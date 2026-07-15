package com.paw.ddasoom.animal.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;

public interface AnimalRepositoryCustom {
  Page<Animal> search(AnimalListPageRequest request, Pageable pageable);
}
