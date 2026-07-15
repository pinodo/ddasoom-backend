package com.paw.ddasoom.animal.dto.request;

import com.paw.ddasoom.animal.domain.AnimalGender;
import com.paw.ddasoom.animal.domain.AnimalKind;

import lombok.Builder;

@Builder
public record AnimalListPageRequest(
  AnimalKind kind,
  String location,
  Boolean isFostered,
  AnimalGender gender
) {}
