package com.paw.ddasoom.animal.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.paw.ddasoom.animal.domain.Animal;
import com.paw.ddasoom.animal.domain.AnimalGender;
import com.paw.ddasoom.animal.domain.AnimalKind;
import com.paw.ddasoom.animal.domain.QAnimal;
import com.paw.ddasoom.animal.domain.QAnimalLike;
import com.paw.ddasoom.animal.dto.request.AnimalListPageRequest;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AnimalQueryRepository {

  private final JPAQueryFactory queryFactory;

  private static final QAnimal animal = QAnimal.animal;
  private static final QAnimalLike animalLike = QAnimalLike.animalLike;

  public Page<Animal> search(AnimalListPageRequest request, Long memberId, Pageable pageable) {
    // memberId: "내가 좋아요한 동물만" 필터(isLiked=true)를 적용하기 위한 회원 PK. 비로그인이면 null.
    
    // WHERE 조건 — null 반환 메서드는 where절에서 자동 제거됨
    BooleanExpression[] conditions = {
      kindEq(request.kind()),
      locationEq(request.location()),
      isFosteredEq(request.isFostered()),
      genderEq(request.gender()),
      isLikedEq(request.isLiked(), memberId)
    };

    List<Animal> animals = queryFactory
      .selectFrom(animal)
      .where(conditions)
      .orderBy(animal.likeCount.desc(), animal.id.desc())
      .offset(pageable.getOffset())
      .limit(pageable.getPageSize())
      .fetch();

    // count 쿼리는 정렬이 의미 없으므로 orderBy 제거
    Long total = queryFactory
      .select(animal.count())
      .from(animal)
      .where(conditions)
      .fetchOne();

    return new PageImpl<>(animals, pageable, total == null ? 0 : total);
  }

  // 조건 메서드 — null 반환 시 where절에서 자동 제거
  private BooleanExpression kindEq(AnimalKind kind) {
    return kind != null ? animal.kind.eq(kind) : null;
  }

  private BooleanExpression locationEq(String location) {
    return location != null ? animal.location.contains(location) : null;
  }

  private BooleanExpression isFosteredEq(Boolean isFostered) {
    return isFostered != null ? animal.isFostered.eq(isFostered) : null;
  }

  private BooleanExpression genderEq(AnimalGender gender) {
    return gender != null ? animal.gender.eq(gender) : null;
  }

  // "내가 좋아요한 동물만" 필터 — animal_like에 (해당 동물, 나) 행이 존재하는 동물로 제한.
  // isLiked가 true가 아니거나 비로그인(memberId=null)이면 필터 미적용(null 반환).
  private BooleanExpression isLikedEq(Boolean isLiked, Long memberId) {
    if (isLiked == null || !isLiked || memberId == null) {
      return null;
    }
    return JPAExpressions
      .selectOne()
      .from(animalLike)
      .where(
        animalLike.animal.eq(animal),
        animalLike.member.id.eq(memberId))
      .exists();
  }
}
