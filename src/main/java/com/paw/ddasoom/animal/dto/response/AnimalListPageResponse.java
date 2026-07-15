package com.paw.ddasoom.animal.dto.response;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.domain.AnimalGender;
import com.paw.ddasoom.animal.domain.AnimalKind;

import lombok.Builder;

@Builder
public record AnimalListPageResponse(
  Long animalId,
  AnimalKind kind,
  String nickname,
  AnimalGender gender,
  String typeName,
  String age,
  String imageUrl,
  boolean isFostered,
  int likeCount
) {
  public static AnimalListPageResponse from(Animal animal) {
    return AnimalListPageResponse.builder()
      .animalId(animal.getId())
      .kind(animal.getKind())
      .nickname(animal.getNickname())
      .gender(animal.getGender())
      .typeName(animal.getTypeName())
      .age(animal.getAge())
      .imageUrl(animal.getImageUrl())
      .isFostered(animal.isFostered())
      .likeCount(animal.getLikeCount())
      .build();
  }
}
