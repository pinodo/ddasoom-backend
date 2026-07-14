package com.paw.ddasoom.foster.repository;

import java.util.Collection;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.paw.ddasoom.foster.domain.Foster;
import com.paw.ddasoom.foster.domain.FosterStatus;

public interface FosterRepository extends JpaRepository<Foster, Long> {

  // 유저 수정 조회(유저 본인 + fosterId 조회)
  Optional<Foster> findByFosterIdAndUser_IdAndDeletedAtIsNull(Long fosterId, Long userId);

  // 유저 리스트 조회 (유저의 신청 + 삭제되지않은 신청 + 최신 신청 정렬)
  Page<Foster> findAllByUser_IdAndDeletedAtIsNullOrderByCreatedAtDesc(Long userId, Pageable pageable);
  
  // 관리자 리스트 조회(작성일순 정렬)
  Page<Foster> findAllByOrderByCreatedAtDesc(Pageable pageable);

  // 관리자 수정 - 해당 동물이 임시보호 상태(FOSTERING/EXTENDED)가 있는지 확인(삭제된 데이터 제외)
  boolean existsByAnimal_IdAndStatusInAndDeletedAtIsNull(
    Long animalId,
    Collection<FosterStatus> statuses //여러 임시보호 상태를 한번에 IN 조회하기위해 Collection사용
  );

}
