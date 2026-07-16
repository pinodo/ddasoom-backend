package com.paw.ddasoom.animal.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.paw.ddasoom.animal.dto.response.AnimalMainPageResponse;
import com.paw.ddasoom.animal.repository.AnimalRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AnimalMainPageService {

  private final AnimalRepository animalRepository;

  // 메인페이지 미리보기 — 최근 등록 4건. 공개(비로그인) 노출이라 isLiked는 계산하지 않는다.
  @Transactional(readOnly = true)
  public List<AnimalMainPageResponse> getMainPreview() {
    return animalRepository.findTop4ByOrderByIdDesc().stream()
      .map(AnimalMainPageResponse::from)
      .toList();
  }
}
