package com.paw.ddasoom.animal.service;

import org.springframework.data.domain.Pageable;

import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;
import com.paw.ddasoom.animal.dto.response.AnimalListPageResponse;
import com.paw.ddasoom.common.dto.PageResponse;

public interface AnimalListPageService {

  // memberId: isLiked 필드/필터 계산용 회원 PK. 비로그인이면 null.
  PageResponse<AnimalListPageResponse> search(AnimalListPageRequest request, Long memberId, Pageable pageable);

}
