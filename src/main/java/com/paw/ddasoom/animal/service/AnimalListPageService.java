package com.paw.ddasoom.animal.service;

import org.springframework.data.domain.Pageable;

import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;
import com.paw.ddasoom.animal.dto.response.AnimalListPageResponse;
import com.paw.ddasoom.common.dto.PageResponse;

public interface AnimalListPageService {

  PageResponse<AnimalListPageResponse> search(AnimalListPageRequest request, Pageable pageable);

}
