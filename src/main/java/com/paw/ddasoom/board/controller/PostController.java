package com.paw.ddasoom.board.controller;

import com.paw.ddasoom.board.dto.request.PostCreateRequest;
import com.paw.ddasoom.board.dto.request.PostUpdateRequest;
import com.paw.ddasoom.board.dto.response.MyCommentResponse;
import com.paw.ddasoom.board.dto.response.MyPostResponse;
import com.paw.ddasoom.board.dto.response.PostDetailResponse;
import com.paw.ddasoom.board.dto.response.PostResponse;
import com.paw.ddasoom.board.service.PostCommentService;
import com.paw.ddasoom.board.service.PostService;
import com.paw.ddasoom.common.dto.ApiResponse;
import com.paw.ddasoom.common.dto.PageResponse;
import com.paw.ddasoom.common.security.CustomUserDetails;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;
    private final PostCommentService postCommentService;

    /**
     * 마이페이지 — 내가 쓴 글 목록. boardType은 선택 필터(미전달 = 전체 보드).
     * ⚠️ /{postId}보다 정확 경로가 우선 매칭되므로 "/my"가 postId로 파싱될 일 없음 (fosters/my와 동일 패턴)
     */
    @GetMapping("/my")
    public ResponseEntity<ApiResponse<PageResponse<MyPostResponse>>> getMyPosts(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(name = "boardType", required = false) String boardType,
            @PageableDefault(size = 10) Pageable pageable) {
        PageResponse<MyPostResponse> response =
                postService.getMyPosts(userDetails.getMemberId(), boardType, pageable);
        return ResponseEntity.ok(ApiResponse.success("내가 쓴 글 목록을 조회했습니다.", response));
    }

    /**
     * 마이페이지 — 내가 쓴 댓글 목록 (전체 게시글 대상).
     * PostCommentController는 /api/posts/{postId}/comments 하위라 postId 없는 이 경로를 가질 수 없어
     * PostController에 위치 (URL 소속: /api/posts 하위 유지).
     */
    @GetMapping("/comments/my")
    public ResponseEntity<ApiResponse<PageResponse<MyCommentResponse>>> getMyComments(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @PageableDefault(size = 10) Pageable pageable) {
        PageResponse<MyCommentResponse> response =
                postCommentService.getMyComments(userDetails.getMemberId(), pageable);
        return ResponseEntity.ok(ApiResponse.success("내가 쓴 댓글 목록을 조회했습니다.", response));
    }

    /** 전체 페이지 조회(기본 페이지네이션: 9), 카테고리, 보드타입 필요. keyword는 제목 부분일치 검색(선택) */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<PostResponse>>> getPostList(
            @RequestParam(name = "boardType") String boardType,
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "keyword", required = false) String keyword,
            @PageableDefault(size = 9) Pageable pageable) {
        PageResponse<PostResponse> response =
                postService.getPostList(boardType, category, keyword, pageable);
        return ResponseEntity.ok(ApiResponse.success("게시글 목록을 조회했습니다.", response));
    }

    /** 게시글 상세 조회 */
    @GetMapping("/{postId}")
    public ResponseEntity<ApiResponse<PostDetailResponse>> getPostDetail(@PathVariable(name = "postId") Long postId) {
        PostDetailResponse response = postService.getPostDetail(postId);
        return ResponseEntity.ok(ApiResponse.success("게시글을 조회했습니다.", response));
    }

    /** 게시글 생성 */
    @PostMapping
    public ResponseEntity<ApiResponse<Long>> createPost(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @Valid @RequestBody PostCreateRequest request) {
        Long postId = postService.createPost(userDetails.getMemberId(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("게시글이 등록되었습니다.", postId));
    }

    /** 게시글 수정 */
    @PatchMapping("/{postId}")
    public ResponseEntity<ApiResponse<Void>> updatePost(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @PathVariable(name = "postId") Long postId,
            @Valid @RequestBody PostUpdateRequest request) {
        postService.updatePost(userDetails.getMemberId(), postId, request);
        return ResponseEntity.ok(ApiResponse.success("게시글이 수정되었습니다."));
    }

    /** 게시글 삭제 (soft delete) - 삭제 시 조회 불가 */
    @DeleteMapping("/{postId}")
    public ResponseEntity<ApiResponse<Void>> deletePost(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @PathVariable(name = "postId") Long postId) {
        postService.deletePost(userDetails.getMemberId(), postId);
        return ResponseEntity.ok(ApiResponse.success("게시글이 삭제되었습니다."));
    }
}