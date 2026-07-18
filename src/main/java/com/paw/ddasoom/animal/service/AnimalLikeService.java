package com.paw.ddasoom.animal.service;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import com.paw.ddasoom.animal.exception.AnimalException;
import com.paw.ddasoom.animal.repository.AnimalRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnimalLikeService {
  /**
   * 좋아요/취소 시점에 Redis에 dirty 기록 (즉시 RDB 안씀)
   */

  private final AnimalRepository animalRepository;
  private final StringRedisTemplate redisTemplate;
  /** DIRTY_KEY의 목적: 무엇이 바뀌었는지만 표기하는 변경 추적 목록 */
  private static final String DIRTY_KEY = "animal:like:dirty";

  // 좋아요
  public void like(Long animalId, Long memberId) {
    try {
      if (animalRepository.existsById(animalId)) {
        redisTemplate.opsForHash().put(DIRTY_KEY, field(animalId, memberId), "1");
      }
    } catch (AnimalException e) {
      log.error("Animal iD({})는 없는 동물입니다.", animalId);
    }
  }

  // 좋아요 취소
  public void unlike(Long animalId, Long memberId) {
    try {
      if (animalRepository.existsById(animalId)) {
        redisTemplate.opsForHash().put(DIRTY_KEY, field(animalId, memberId), "0");
      }
    } catch (AnimalException e) {
      log.error("Animal iD({})는 없는 동물입니다.", animalId);
    }
  }

  // 키 생성 메서드
  private String field(Long animalId, Long memberId) {
    return animalId + ":" + memberId;
  }
}
