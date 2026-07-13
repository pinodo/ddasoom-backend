package com.paw.ddasoom.animal.batch;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.paw.ddasoom.animal.exception.AnimalException;
import com.paw.ddasoom.animal.repository.AnimalLikeJdbcRepository;
import com.paw.ddasoom.animal.service.AnimalLikeSyncItem;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class AnimalLikeSyncBatch {
  /**
   * 토글 최종 상태만 해시에 남김
   * flush 주기 안에서 여러번 눌러도 마지막 상태 하나만 반영됨
   * 주기적으로 dirty를 읽어 RDB에 반영
   */

  private final StringRedisTemplate redisTemplate;
  private final AnimalLikeJdbcRepository jdbcRepository;
  private static final String DIRTY_KEY = "animal:like:dirty";

  @Scheduled(fixedDelay = 10_000) // 10초 주기 (조정 가능)
  public void flush() {
    Map<Object, Object> dirty = redisTemplate.opsForHash().entries(DIRTY_KEY);
    if (dirty.isEmpty()) return;

    List<AnimalLikeSyncItem> toInsert = new ArrayList<>();
    List<AnimalLikeSyncItem> toDelete = new ArrayList<>();
    Set<Long> affectedAnimalIds = new HashSet<>();

    /**
     * 키 값에 있는 "animalId:memberId"를 ":"를 분기로 파싱하고,
     * 좋아요나 좋아요 취소가 눌리면 각각의 ArrayList에 담음
     */ 
    for (Map.Entry<Object, Object> e : dirty.entrySet()) {
      String[] parts = ((String) e.getKey()).split(":");
      Long animalId = Long.valueOf(parts[0]);
      Long memberId = Long.valueOf(parts[1]);
      boolean liked = "1".equals(e.getValue());

      // 좋아요 누른 동물의 아이디 값 저장
      affectedAnimalIds.add(animalId);

      if (liked) toInsert.add(new AnimalLikeSyncItem(animalId, memberId, true));
      else       toDelete.add(new AnimalLikeSyncItem(animalId, memberId, false));
    }

    try {
      doFlush(toInsert, toDelete, affectedAnimalIds);

      // 처리한 필드만 제거 (처리 중 새로 들어온 것 보존)
      redisTemplate.opsForHash().delete(DIRTY_KEY,
      dirty.keySet().toArray());
    } catch (AnimalException e) {
      log.error("좋아요 배치 반영 실패, 다음 주기에 재시도합니다.", e);
    }
  }

  @Transactional
  public void doFlush(
    List<AnimalLikeSyncItem> toInsert,
    List<AnimalLikeSyncItem> toDelete,
    Set<Long> affectedAnimalIds) {
      
      if (toInsert.isEmpty() == false) jdbcRepository.bulkInsertIgnore(toInsert);
      if (toDelete.isEmpty() == false) jdbcRepository.bulkDelete(toDelete);

      // 좋아요 누른 동물의 좋아요 수를 animal 테이블에 저장
      jdbcRepository.updateLikedAnimalCounts(affectedAnimalIds);
  }
}
