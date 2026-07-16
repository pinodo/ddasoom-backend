package com.paw.ddasoom.animal.dto.response;

import com.paw.ddasoom.animal.domain.Animal;

import lombok.Builder;

@Builder
public record AnimalDetailPageResponse(
  Long detailId,
  String nickname,
  String weight,
  boolean isFostered,
  String imageUrl,
  String color,
  String specialMark,
  String vaccinationChk
) {
  public static AnimalDetailPageResponse from(Animal animal) {
    return AnimalDetailPageResponse.builder()
      .detailId(animal.getId())
      .nickname(animal.getNickname())
      .weight(animal.getWeight())
      .isFostered(animal.isFostered())
      .imageUrl(animal.getImageUrl())
      .color(animal.getColor())
      .specialMark(animal.getSpecialMark())
      .vaccinationChk(animal.getVaccinationChk())
      .build();
    }
}
