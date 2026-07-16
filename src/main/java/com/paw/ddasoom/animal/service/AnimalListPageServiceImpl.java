package com.paw.ddasoom.animal.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;
import com.paw.ddasoom.animal.dto.response.AnimalListPageResponse;
import com.paw.ddasoom.animal.repository.AnimalRepository;
import com.paw.ddasoom.common.dto.PageResponse;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class AnimalListPageServiceImpl implements AnimalListPageService {

  private final AnimalRepository animalRepository;

  @Override
    @Transactional(readOnly = true)
    public PageResponse<AnimalListPageResponse> search(
      AnimalListPageRequest request,
      Pageable pageable) {
        Page<Animal> page = animalRepository.search(request, pageable);
        return PageResponse.of(page, AnimalListPageResponse::from);
    }
  
}
