package com.paw.ddasoom.animal.domain;

import com.paw.ddasoom.animal.exception.AnimalErrorCode;
import com.paw.ddasoom.animal.exception.AnimalException;

public enum AnimalGender {
  M, F, Q; // M: 남자, F: 여자, Q: 미상

  public static AnimalGender from(String value) {
    return switch(value) {
      case "M" -> M;
      case "F" -> F;
      case "Q" -> Q;
      default -> throw new AnimalException(AnimalErrorCode.ANIMAL_ENUM_VALUE_NOT_FOUND);
    };
  }

  // 쿼리 파라미터 코드(M/F/Q = enum 이름) → enum. 목록 검색 필터 컨버터 전용.
  public static AnimalGender fromCode(String code) {
    try {
      return AnimalGender.valueOf(code.trim().toUpperCase());
    } catch (IllegalArgumentException e) {
      throw new AnimalException(AnimalErrorCode.ANIMAL_ENUM_VALUE_NOT_FOUND);
    }
  }
}
