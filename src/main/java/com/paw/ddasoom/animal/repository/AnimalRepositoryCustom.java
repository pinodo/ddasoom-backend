package com.paw.ddasoom.animal.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;

public interface AnimalRepositoryCustom {
  // memberId: "내가 좋아요한 동물만" 필터(isLiked=true)를 적용하기 위한 회원 PK. 비로그인이면 null.
  Page<Animal> search(AnimalListPageRequest request, Long memberId, Pageable pageable);
}
