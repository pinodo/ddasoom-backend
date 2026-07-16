package com.paw.ddasoom.animal.dto.response;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.domain.AnimalGender;
import com.paw.ddasoom.animal.domain.AnimalKind;

// DTO 확인용
public record AnimalMainPageResponse(
  Long id,
  String abandonmentId,
  AnimalKind kind,
  String nickname,
  AnimalGender gender,
  String typeName,
  String age,
  String location,
  String weight,
  String color,
  String specialMark,
  String vaccinationChk,
  String imageUrl,
  long likeCount
) {
  public static AnimalMainPageResponse from(Animal animal) {
    return new AnimalMainPageResponse(
      animal.getId(),
      animal.getAbandonmentId(), 
      animal.getKind(), 
      animal.getNickname(), 
      animal.getGender(), 
      animal.getTypeName(), 
      animal.getAge(), 
      animal.getLocation(), 
      animal.getWeight(), 
      animal.getColor(), 
      animal.getSpecialMark(), 
      animal.getVaccinationChk(), 
      animal.getImageUrl(), 
      animal.getLikeCount());
  }
}
