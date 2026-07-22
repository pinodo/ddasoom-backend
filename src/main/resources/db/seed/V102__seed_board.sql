-- =============================================================
-- V102__seed_board.sql  [개발용 더미 — 전면 재구성 2026-07]
-- 게시판(post / post_comment) + 게시글·댓글 대상 신고 — 로컬·테스트 전용. V100·V101 이후 실행 전제.
--
-- 재구성 요점
--   · 작성자·댓글 작성자 전원 V100의 실명 회원(user01~user87, hidden01~03). 더미회원 참조 없음
--   · **이미지 없음** — image 테이블 연결을 하지 않는다(사진은 실제 업로드로 확인)
--   · board_type은 BoardType enum 실제 값: ADOPTION_REVIEW / DOG_INFO / CAT_INFO
--   · category는 게시판별 의미가 다름 (프론트 규칙)
--       - DOG_INFO / CAT_INFO  → '예방접종' (정보 게시판의 세부 주제)
--       - ADOPTION_REVIEW      → '강아지' / '고양이' (펫 종류)
--   · HIDDEN 3인의 도배·비방 글이 신고 → 승인 → 회원 숨김으로 이어지는 스토리를 완결시킨다
-- =============================================================

-- ── 1. 입양후기 6건 (category = 펫 종류) ───────────────────────────────────
INSERT INTO `post` (`member_id`, `board_type`, `category`, `title`, `content`, `view_count`, `comment_count`, `created_at`, `updated_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'user03@ddasoom.com'), 'ADOPTION_REVIEW', '강아지',
     '임보로 시작해서 가족이 되기까지, 한 달의 기록',
     '임시보호로 시작했는데 이제는 가족이 되었습니다. 처음엔 경계가 심해 손도 못 대게 하던 아이가 지금은 제 무릎에서 잠들어요.\n\n임보를 고민하시는 분들께 꼭 말씀드리고 싶어요 — 완벽한 환경이 아니어도 괜찮습니다. 용기 내시길.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user04@ddasoom.com'), 'ADOPTION_REVIEW', '강아지',
     '대형견 임보 후기 (준비물과 산책 팁 포함)',
     '대형견 임보가 처음이라 걱정이 많았는데, 산책 루틴만 잡히니 순한 양이 됩니다.\n\n팁 세 가지 —\n1. 첫 주는 짧게 여러 번 산책\n2. 급여량은 보호소 기준을 그대로 유지\n3. 하네스는 몸통 조절이 되는 걸로',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 15 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 15 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user05@ddasoom.com'), 'ADOPTION_REVIEW', '고양이',
     '검은 고양이 편견을 버리세요',
     '검은 고양이는 입양이 잘 안 된다고 하죠. 저희 아이는 제가 만난 가장 다정한 생명입니다. 매일 아침 이마 박치기로 저를 깨워요.\n\n색으로 판단하지 말아 주세요.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user06@ddasoom.com'), 'ADOPTION_REVIEW', '강아지',
     '임보 3주차 근황 — 아이들과도 잘 지냅니다',
     '24kg 대형견과의 동거는 체력전이지만 그만큼 행복도 큽니다. 아이들과도 조심스럽게 잘 지내요.\n\n이번 주말 입양 상담이 잡혔습니다. 좋은 소식 전할 수 있길.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user07@ddasoom.com'), 'ADOPTION_REVIEW', '고양이',
     '겁쟁이가 개냥이 되기까지 — 임보 일기',
     '첫 일주일은 침대 밑에서 나오지 않았어요. 밥그릇만 조용히 채워두고 기다렸습니다.\n\n3주차인 지금은 제 어깨에 올라옵니다. 시간이 약이라는 말, 임보에서 배웁니다.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user08@ddasoom.com'), 'ADOPTION_REVIEW', '강아지',
     '임보 준비물 체크리스트 공유합니다',
     '임보 3회차가 되니 준비물이 정리되네요.\n\n· 켄넬(숨을 공간이 꼭 필요합니다)\n· 배변패드, 이동장\n· 기존에 먹던 사료 소량\n· 그리고 가장 중요한 것 — 인내심',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY));

-- ── 2. 강아지·고양이 정보 게시판 명시 5건 + 신고 대상 도배 3건 ──────────────
INSERT INTO `post` (`member_id`, `board_type`, `category`, `title`, `content`, `view_count`, `comment_count`, `created_at`, `updated_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'user01@ddasoom.com'), 'DOG_INFO', '예방접종',
     '여름철 산책 시간대 다들 어떻게 하시나요?',
     '한낮 아스팔트가 너무 뜨거워서 새벽/저녁으로 옮겼는데, 다들 몇 시쯤 나가시나요? 손등 5초 테스트는 하고 있습니다.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user10@ddasoom.com'), 'DOG_INFO', '예방접종',
     '야간 진료 가능한 동물병원 정리 중입니다',
     '응급상황 대비해 야간 진료 병원을 지역별로 모으고 있습니다. 댓글로 제보해 주시면 정리해서 올릴게요.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user02@ddasoom.com'), 'CAT_INFO', '예방접종',
     '입 짧은 냥이 습식 사료 추천 부탁드려요',
     '브랜드 몇 개 돌려봤는데 잘 안 먹네요. 기호성 좋은 제품 추천 부탁드립니다. 알러지는 없는 아이입니다.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user09@ddasoom.com'), 'CAT_INFO', '예방접종',
     '장모종 여름 미용, 하시나요 마시나요?',
     '임보 중인 아이가 장모종인데 여름 미용 의견이 갈리더라고요. 털이 단열 역할도 한다고 해서 고민입니다. 경험담 들려주세요.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user11@ddasoom.com'), 'CAT_INFO', '예방접종',
     '중성화 수술 후 회복 기간 얼마나 걸리나요?',
     '어제 수술받고 왔는데 계속 자려고만 합니다. 정상 범위인지 궁금해요. 넥카라는 며칠 정도 씌우셨나요?',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY)),
    -- 신고 대상 (HIDDEN 회원 작성 — "왜 이 회원이 숨김됐는가"의 증거물)
    ((SELECT member_id FROM member WHERE email = 'hidden01@ddasoom.com'), 'DOG_INFO', '예방접종',
     '■■최저가 사료 공동구매 링크■■ 지금 클릭!!',
     '지금 바로 클릭하세요!! 최저가 보장!! 선착순 마감!! (외부 링크 반복 게시)',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY)),
    ((SELECT member_id FROM member WHERE email = 'hidden02@ddasoom.com'), 'CAT_INFO', '예방접종',
     '품종묘 분양합니다 (문의 주세요)',
     '커뮤니티 취지와 맞지 않는 상업적 분양 홍보 글입니다. 유기동물 플랫폼에서 금지된 게시물 유형입니다.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ((SELECT member_id FROM member WHERE email = 'hidden03@ddasoom.com'), 'DOG_INFO', '예방접종',
     '(비방성 게시글) 여기 사람들 수준이',
     '다른 회원들을 싸잡아 비방하는 내용의 게시글입니다. 신고 처리 시연용 데이터입니다.',
     0, 0, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY));

-- ── 3. 이벤트 참여 게시글 — user01·user02 각 11건 (7월, 10건+ 판정 충족) ────
-- V100에서 두 회원의 event_status = PARTICIPATING과 정합. 배치 집계 시연 대상.
INSERT INTO `post` (`member_id`, `board_type`, `category`, `title`, `content`, `view_count`, `comment_count`, `created_at`, `updated_at`)
WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 22
)
SELECT
    IF(n <= 11,
       (SELECT member_id FROM member WHERE email = 'user01@ddasoom.com'),
       (SELECT member_id FROM member WHERE email = 'user02@ddasoom.com')),
    IF(n MOD 2 = 0, 'DOG_INFO', 'CAT_INFO'),
    '예방접종',
    CONCAT('오늘의 반려 일상 기록 ', n),
    CONCAT('이벤트 기간에 작성한 일상 기록 ', n, '번입니다. 오늘도 무사히 하루가 지나갔네요.'),
    0, 0,
    DATE_ADD(MAKEDATE(YEAR(CURDATE()), 1), INTERVAL (181 + (n MOD 14)) DAY),   -- 7월 1일 + 0~13일
    DATE_ADD(MAKEDATE(YEAR(CURDATE()), 1), INTERVAL (181 + (n MOD 14)) DAY)
FROM seq;

-- ── 4. 대량 게시글 66건 — 3종 게시판 순환 (목록 페이징·필터·정렬 검증) ──────
-- 작성자는 user01~user87 순환 참조.
-- n MOD 3: 0=입양후기(category 강아지/고양이), 1=강아지정보, 2=고양이정보(category 예방접종)
INSERT INTO `post` (`member_id`, `board_type`, `category`, `title`, `content`, `view_count`, `comment_count`, `created_at`, `updated_at`)
WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 66
),
authors AS (
    SELECT member_id, ROW_NUMBER() OVER (ORDER BY member_id) AS rn
    FROM member WHERE email LIKE 'user%' AND deleted_at IS NULL
)
SELECT
    a.member_id,
    ELT((seq.n MOD 3) + 1, 'ADOPTION_REVIEW', 'DOG_INFO', 'CAT_INFO'),
    CASE WHEN seq.n MOD 3 = 0 THEN IF(seq.n MOD 2 = 0, '강아지', '고양이')
                              ELSE '예방접종' END,
    CONCAT(ELT((seq.n MOD 3) + 1, '[후기] ', '[강아지] ', '[고양이] '),
           ELT((seq.n MOD 6) + 1,
               '오늘의 산책 기록',
               '병원 다녀온 이야기',
               '사료 바꾼 후기',
               '함께 지낸 지 한 달',
               '궁금한 점이 있어요',
               '소소한 일상 공유'),
           ' ', seq.n),
    CONCAT('본문 ', seq.n, '번입니다. 목록 페이징과 검색·정렬 필터 검증용 데이터입니다.'),
    (seq.n * 13) MOD 300,                                        -- 조회수 0~299 (인기순 정렬 검증)
    0,
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (seq.n MOD 45) DAY),
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (seq.n MOD 45) DAY)
FROM seq
JOIN authors a ON a.rn = ((seq.n - 1) MOD 87) + 1;

-- ── 5. 댓글 — 명시 6건 (실명 회원) ──────────────────────────────────────
INSERT INTO `post_comment` (`post_id`, `member_id`, `parent_comment_id`, `content`, `created_at`, `updated_at`) VALUES
    ((SELECT post_id FROM post WHERE title = '임보로 시작해서 가족이 되기까지, 한 달의 기록'),
     (SELECT member_id FROM member WHERE email = 'user01@ddasoom.com'), NULL,
     '읽다가 눈물이… 좋은 가족 되어 주셔서 감사해요.', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 19 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 19 DAY)),
    ((SELECT post_id FROM post WHERE title = '임보로 시작해서 가족이 되기까지, 한 달의 기록'),
     (SELECT member_id FROM member WHERE email = 'user02@ddasoom.com'), NULL,
     '저도 임보 고민 중이었는데 용기 얻고 갑니다!', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 18 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 18 DAY)),
    ((SELECT post_id FROM post WHERE title = '검은 고양이 편견을 버리세요'),
     (SELECT member_id FROM member WHERE email = 'user09@ddasoom.com'), NULL,
     '검은 고양이 최고죠. 오래오래 행복하시길!', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 11 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 11 DAY)),
    ((SELECT post_id FROM post WHERE title = '여름철 산책 시간대 다들 어떻게 하시나요?'),
     (SELECT member_id FROM member WHERE email = 'user03@ddasoom.com'), NULL,
     '저는 아침 6시요. 손등으로 아스팔트 5초 체크하고 나갑니다.', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY)),
    ((SELECT post_id FROM post WHERE title = '입 짧은 냥이 습식 사료 추천 부탁드려요'),
     (SELECT member_id FROM member WHERE email = 'user07@ddasoom.com'), NULL,
     '토핑용 츄르를 살짝 섞는 게 저희 집 해법이었어요.', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    -- 신고 대상 댓글 (HIDDEN 회원의 비방성 댓글)
    ((SELECT post_id FROM post WHERE title = '여름철 산책 시간대 다들 어떻게 하시나요?'),
     (SELECT member_id FROM member WHERE email = 'hidden03@ddasoom.com'), NULL,
     '(비방성 댓글) 그것도 모르면서 개를 왜 키우시나요?', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY));

-- 대댓글 1건 (계층 구조 검증)
-- ⚠️ MySQL은 INSERT 대상 테이블(post_comment)을 같은 문장의 서브쿼리에서 직접 참조할 수 없다(에러 1093).
--    부모 댓글 조회를 파생 테이블(SELECT ... FROM (...) AS x)로 한 겹 감싸 우회한다.
INSERT INTO `post_comment` (`post_id`, `member_id`, `parent_comment_id`, `content`, `created_at`, `updated_at`)
SELECT
    (SELECT post_id FROM post WHERE title = '임보로 시작해서 가족이 되기까지, 한 달의 기록'),
    (SELECT member_id FROM member WHERE email = 'user03@ddasoom.com'),
    parent.id,
    '감사합니다! 궁금한 점 있으면 편하게 물어보세요.',
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 17 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 17 DAY)
FROM (SELECT post_comment_id AS id FROM post_comment
      WHERE content = '저도 임보 고민 중이었는데 용기 얻고 갑니다!' LIMIT 1) AS parent;

-- ── 6. 대량 댓글 60건 — 대량 게시글에 순환 배분 (작성자도 실명 회원) ────────
INSERT INTO `post_comment` (`post_id`, `member_id`, `parent_comment_id`, `content`, `created_at`, `updated_at`)
WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 60
),
authors AS (
    SELECT member_id, ROW_NUMBER() OVER (ORDER BY member_id) AS rn
    FROM member WHERE email LIKE 'user%' AND deleted_at IS NULL
),
targets AS (
    SELECT post_id, ROW_NUMBER() OVER (ORDER BY post_id) AS rn
    FROM post WHERE content LIKE '본문%번입니다%'
)
SELECT
    t.post_id,
    a.member_id,
    NULL,
    ELT((seq.n MOD 5) + 1,
        '좋은 정보 감사합니다!',
        '저도 비슷한 경험이 있어요.',
        '도움이 많이 됐습니다 :)',
        '공감하고 갑니다.',
        '혹시 더 자세히 알 수 있을까요?'),
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (seq.n MOD 40) DAY),
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (seq.n MOD 40) DAY)
FROM seq
JOIN authors a ON a.rn = ((seq.n * 3 - 1) MOD 87) + 1
JOIN targets t ON t.rn = (seq.n MOD 65) + 1;

-- ── 7. 신고 — 게시글(POST) 3건 + 댓글(POST_COMMENT) 3건 ────────────────
INSERT INTO `report` (`reporter_id`, `target_type`, `target_id`, `reason`, `content`, `status`, `processed_id`, `processed_at`, `created_at`, `updated_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'user01@ddasoom.com'), 'POST',
     (SELECT post_id FROM post WHERE title = '■■최저가 사료 공동구매 링크■■ 지금 클릭!!'),
     'SPAM', '외부 링크 도배 광고 게시글입니다.', 'PENDING', NULL, NULL,
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user04@ddasoom.com'), 'POST',
     (SELECT post_id FROM post WHERE title = '품종묘 분양합니다 (문의 주세요)'),
     'INAPPROPRIATE', '상업적 분양 홍보 — 커뮤니티 취지 위반입니다.', 'PENDING', NULL, NULL,
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user05@ddasoom.com'), 'POST',
     (SELECT post_id FROM post WHERE title = '(비방성 게시글) 여기 사람들 수준이'),
     'ABUSE', '다른 회원을 싸잡아 비방하는 게시글입니다.', 'APPROVED',
     (SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY),
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user03@ddasoom.com'), 'POST_COMMENT',
     (SELECT post_comment_id FROM (SELECT post_comment_id FROM post_comment
        WHERE content = '(비방성 댓글) 그것도 모르면서 개를 왜 키우시나요?' LIMIT 1) AS c1),
     'ABUSE', '다른 회원을 비방하는 댓글입니다.', 'PENDING', NULL, NULL,
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user07@ddasoom.com'), 'POST_COMMENT',
     (SELECT post_comment_id FROM (SELECT post_comment_id FROM post_comment
        WHERE content = '(비방성 댓글) 그것도 모르면서 개를 왜 키우시나요?' LIMIT 1) AS c2),
     'ABUSE', '동일 댓글 중복 신고 (다른 신고자 — 유니크 제약 검증용).', 'PENDING', NULL, NULL,
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user08@ddasoom.com'), 'POST',
     (SELECT post_id FROM post WHERE title = '■■최저가 사료 공동구매 링크■■ 지금 클릭!!'),
     'ETC', '같은 글이 다른 게시판에도 반복 게시되고 있습니다.', 'REJECTED',
     (SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY),
     DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY));

-- ── 8. comment_count 캐시 동기화 (활성 댓글 수와 일치 보장) ─────────────────
UPDATE `post` p
SET p.comment_count = (SELECT COUNT(*) FROM post_comment c
                       WHERE c.post_id = p.post_id AND c.deleted_at IS NULL);
