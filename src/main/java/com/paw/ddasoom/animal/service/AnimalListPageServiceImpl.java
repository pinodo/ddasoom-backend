package com.paw.ddasoom.animal.service;

import java.util.List;
import java.util.Set;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;
import com.paw.ddasoom.animal.dto.response.AnimalListPageResponse;
import com.paw.ddasoom.animal.repository.AnimalLikeRepository;
import com.paw.ddasoom.animal.repository.AnimalRepository;
import com.paw.ddasoom.common.dto.PageResponse;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class AnimalListPageServiceImpl implements AnimalListPageService {

  private final AnimalRepository animalRepository;
  private final AnimalLikeRepository animalLikeRepository;

  @Override
  @Transactional(readOnly = true)
  public PageResponse<AnimalListPageResponse> search(
      AnimalListPageRequest request, Long memberId, Pageable pageable) {

    Page<Animal> page = animalRepository.search(request, memberId, pageable);

    // 이번 페이지 동물들 중 내가 좋아요한 id 집합을 한 번에 조회(비로그인이면 빈 집합)
    Set<Long> likedIds = resolveLikedIds(page.getContent(), memberId);

    return PageResponse.of(page,
        animal -> AnimalListPageResponse.from(animal, likedIds.contains(animal.getId())));
  }

  private Set<Long> resolveLikedIds(List<Animal> animals, Long memberId) {
    if (memberId == null || animals.isEmpty()) {
      return Set.of();
    }
    List<Long> animalIds = animals.stream().map(Animal::getId).toList();
    return Set.copyOf(animalLikeRepository.findLikedAnimalIds(memberId, animalIds));
  }
}
