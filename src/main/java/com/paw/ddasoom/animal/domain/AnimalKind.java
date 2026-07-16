package com.paw.ddasoom.animal.domain;

import com.paw.ddasoom.animal.exception.AnimalErrorCode;
import com.paw.ddasoom.animal.exception.AnimalException;

public enum AnimalKind {
  D, C; // D: 개, C: 고양이

  public static AnimalKind from(String value) {
    return switch(value) {
      case "개" -> D;
      case "고양이" -> C;
      default -> throw new AnimalException(AnimalErrorCode.ANIMAL_ENUM_VALUE_NOT_FOUND);
    };
  }

  // 쿼리 파라미터 코드(D/C = enum 이름) → enum. 목록 검색 필터 컨버터 전용.
  // from(공공API 원본값 "개"/"고양이")과 입력 소스가 달라 분리한다.
  public static AnimalKind fromCode(String code) {
    try {
      return AnimalKind.valueOf(code.trim().toUpperCase());
    } catch (IllegalArgumentException e) {
      throw new AnimalException(AnimalErrorCode.ANIMAL_ENUM_VALUE_NOT_FOUND);
    }
  }
}
