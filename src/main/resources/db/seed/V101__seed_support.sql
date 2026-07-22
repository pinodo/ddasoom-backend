-- =============================================================
-- V101__seed_support.sql  [개발용 더미 — 전면 재구성 2026-07]
-- 공지사항 / FAQ / 1:1 문의(QnA) / 신고(회원 대상) — 로컬·테스트 전용. V100 이후 실행 전제.
--
-- 재구성 요점
--   · 공지 작성자 = adminlee@ddasoom.com (관리자 이서진) 고정
--   · FAQ는 스키마상 작성자 컬럼이 없음 — category/question/answer/is_visible 구조 그대로
--   · QnA 작성자 = V100의 실명 회원(user01~user87). 더미회원 참조 없음
--   · 신고(MEMBER 대상) = V100의 HIDDEN 3인이 대상, 신고자는 실명 회원
--   · QnA는 V10 개정 반영 — answered_id/answer 컬럼 없음. 답변 = qna_comment(관리자) + answered_at
--
-- ⚠️ FAQ category는 FaqCategory enum (@Enumerated STRING) — DB에는 "상수명"(영문)이 저장된다.
--    한글 label(회원/계정, 임시보호 등)을 넣으면 조회 시 enum 변환이 실패한다.
--    상수: ACCOUNT / FOSTER / ANIMAL_INFO / COMMUNITY / SERVICE / ETC
-- =============================================================

-- ── 1. 공지사항 (작성자: adminlee = 관리자 이서진) ─────────────────────────
INSERT INTO `notice` (`member_id`, `title`, `content`, `is_visible`, `pin_order`, `created_at`, `updated_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '[필독] 따숨 서비스 정식 오픈 안내',
     '안녕하세요, 따숨입니다.\n\n유기동물 임시보호 및 커뮤니티 플랫폼 따숨이 정식 오픈했습니다. 서비스 이용 중 불편사항은 1:1 문의를 이용해 주세요.\n\n감사합니다.',
     TRUE, 1, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 60 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 60 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '[안내] 커뮤니티 이용 수칙 및 신고 제도 안내',
     '건강한 커뮤니티를 위해 이용 수칙을 안내드립니다.\n\n1. 광고/도배 게시물은 제재 대상입니다.\n2. 욕설·비방 게시물은 신고 기능을 이용해 주세요.\n3. 신고 접수 시 관리자가 확인 후 조치하며, 반복 위반 시 계정 이용이 제한될 수 있습니다.',
     TRUE, 2, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 30 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 30 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '유기동물 정보 갱신 주기 안내',
     '따숨의 유기동물 정보는 공공데이터포털의 유기동물 공고 데이터를 기반으로 제공됩니다.\n\n정보는 주기적으로 동기화되며, 보호소 사정에 따라 실제 상태와 차이가 있을 수 있습니다. 방문 전 보호소에 연락해 확인해 주세요.',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 25 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 25 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '임시보호 신청 절차 개편 안내',
     '임시보호 신청 심사 기준이 개편되었습니다.\n\n· 신청서에 반려 경험과 주거 형태를 상세히 작성해 주세요.\n· 심사는 접수 후 2~3일 내 완료됩니다.\n\n자세한 내용은 임시보호 페이지를 확인해 주세요.',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '[이벤트] 7월 임시보호 후기 작성 이벤트',
     '7월 한 달간 커뮤니티에 게시글을 10건 이상 작성해 주신 분께 소정의 사료 기프티콘을 드립니다.\n\n· 기간: 7월 1일 ~ 7월 31일\n· 대상: 이벤트 기간 내 게시글 10건 이상 작성 회원\n· 발표: 8월 첫째 주 개별 안내',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 15 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 15 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '여름철 반려동물 건강관리 안내',
     '무더위가 시작되었습니다. 임시보호 중이신 분들께 안내드립니다.\n\n· 한낮 아스팔트 산책은 화상 위험이 있습니다(손등 5초 테스트 권장).\n· 차량 내 단독 방치는 짧은 시간도 위험합니다.\n· 식수는 자주 갈아 주세요.',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '입양후기 게시판 오픈!',
     '임보/입양 경험을 나눌 수 있는 입양후기 게시판이 열렸습니다. 따뜻한 이야기를 들려주세요.',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 10 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 10 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '개인정보처리방침 개정 안내 (시행일 안내 포함)',
     '개인정보처리방침이 일부 개정되어 안내드립니다.\n\n· 주요 변경: 보관 기간 명확화, 위탁 업체 현황 갱신\n· 시행일: 공지일로부터 7일 후\n\n변경 내용에 동의하지 않으실 경우 회원 탈퇴를 요청하실 수 있습니다.',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '시스템 점검 안내 (새벽 2시~4시)',
     '서비스 안정화를 위한 정기 점검이 예정되어 있습니다.\n\n· 일시: 이번 주 목요일 새벽 2시 ~ 4시\n· 영향: 점검 중 로그인 및 신청 기능 이용 불가\n\n이용에 불편을 드려 죄송합니다.',
     TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ((SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
     '(비공개 테스트) 내부 공지 초안',
     '이 공지는 is_visible=FALSE로 사용자 목록에 노출되지 않아야 합니다. 관리자 목록에서만 보여야 정상입니다.',
     FALSE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY));

-- ── 2. FAQ (작성자 컬럼 없음 — 스키마 그대로) ──────────────────────────────
INSERT INTO `faq` (`category`, `question`, `answer`, `is_visible`, `created_at`, `updated_at`) VALUES
    -- 회원/계정
    ('ACCOUNT', '회원 탈퇴 후 같은 이메일로 재가입할 수 있나요?',
     '탈퇴한 이메일로는 재가입이 불가능합니다. 계정 복구가 필요하시면 1:1 문의로 요청해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 50 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 50 DAY)),
    ('ACCOUNT', '소셜 계정으로 가입했는데 비밀번호 변경이 안 돼요.',
     '소셜 로그인 전용 회원은 비밀번호가 없어 비밀번호 변경 기능을 이용할 수 없습니다. 소셜 계정 제공사에서 관리해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 49 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 49 DAY)),
    ('ACCOUNT', '비밀번호를 잊어버렸어요.',
     '로그인 화면의 "비밀번호 찾기"에서 가입하신 이메일을 입력하시면 재설정 링크를 보내드립니다. 링크는 30분간 유효하며 한 번만 사용할 수 있습니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 48 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 48 DAY)),
    ('ACCOUNT', '닉네임을 변경할 수 있나요?',
     '마이페이지 > 내 정보 수정에서 변경할 수 있습니다. 다만 이미 사용 중인 닉네임으로는 변경할 수 없습니다. 이메일은 계정 식별값이라 변경이 불가능합니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 47 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 47 DAY)),
    ('ACCOUNT', '계정이 이용 제한되었다고 나와요.',
     '커뮤니티 이용 수칙 위반으로 신고가 접수되어 관리자가 제재한 경우입니다. 제재 사유 확인 및 이의 제기는 1:1 문의를 이용해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 46 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 46 DAY)),
    -- 임시보호
    ('FOSTER', '임시보호 기간은 얼마나 되나요?',
     '기본 30일이며, 상황에 따라 연장 신청이 가능합니다. 연장은 관리자 승인 후 반영됩니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 45 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 45 DAY)),
    ('FOSTER', '임시보호 신청 후 결과는 언제 알 수 있나요?',
     '관리자 심사 후 보통 2~3일 내 답변드립니다. 마이페이지 > 임시보호 신청 내역에서 진행 상태를 확인할 수 있습니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 44 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 44 DAY)),
    ('FOSTER', '임시보호 중 병원비는 누가 부담하나요?',
     '기본 예방접종과 중대한 질병 치료비는 보호소 또는 협약 병원에서 지원합니다. 사료·용품 등 일상 관리 비용은 임시보호자가 부담하는 것이 일반적입니다. 상세 조건은 보호소마다 다르니 신청 전 확인해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 43 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 43 DAY)),
    ('FOSTER', '임시보호 연장은 어떻게 신청하나요?',
     '마이페이지 > 임시보호 신청 내역에서 진행 중인 건에 연장 요청을 할 수 있습니다. 종료 예정일 7일 전부터 신청 가능하며, 관리자 승인 시 기간이 연장됩니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 42 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 42 DAY)),
    ('FOSTER', '임시보호 중인 아이를 그대로 입양할 수 있나요?',
     '가능합니다. 임시보호 기간 중 입양을 원하시면 1:1 문의로 알려 주세요. 보호소와 연결해 정식 입양 절차를 안내드립니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 41 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 41 DAY)),
    -- 유기동물 정보
    ('ANIMAL_INFO', '동물 정보는 어디서 가져오나요?',
     '농림축산검역본부가 제공하는 공공데이터포털의 유기동물 공고 정보를 기반으로 제공합니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 40 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 40 DAY)),
    ('ANIMAL_INFO', '동물 정보가 실제와 달라요.',
     '공고 정보는 보호소가 등록한 내용을 그대로 제공하며, 보호소 사정에 따라 변경될 수 있습니다. 방문 전 반드시 해당 보호소에 연락해 확인해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 39 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 39 DAY)),
    ('ANIMAL_INFO', '공고 기간이 끝난 아이는 어떻게 되나요?',
     '공고 종료 후에는 보호소 정책에 따라 처리됩니다. 관심 있는 아이가 있다면 공고 기간 내에 임시보호 또는 입양을 문의해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 38 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 38 DAY)),
    -- 커뮤니티
    ('COMMUNITY', '게시글을 신고하면 어떻게 처리되나요?',
     '신고가 접수되면 관리자가 내용을 직접 확인한 뒤 게시글 숨김 또는 작성자 제재 등의 조치를 합니다. 처리 결과는 별도로 안내되지 않습니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 37 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 37 DAY)),
    ('COMMUNITY', '작성한 글을 수정하거나 삭제하려면 어떻게 하나요?',
     '게시글 상세 화면에서 본인이 작성한 글에 한해 수정·삭제 버튼이 표시됩니다. 삭제한 글은 복구할 수 없습니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 36 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 36 DAY)),
    ('COMMUNITY', '게시판 종류가 어떻게 나뉘나요?',
     '강아지 정보, 고양이 정보, 입양 후기 게시판으로 운영됩니다. 입양·임보 경험담은 입양 후기 게시판을 이용해 주세요.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 35 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 35 DAY)),
    -- 서비스 이용
    ('SERVICE', '1:1 문의는 답변까지 얼마나 걸리나요?',
     '영업일 기준 1~2일 내 답변드립니다. 문의 내역과 답변은 마이페이지 > 1:1 문의에서 확인할 수 있습니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 34 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 34 DAY)),
    ('SERVICE', '모바일에서도 이용할 수 있나요?',
     '별도 앱 없이 모바일 브라우저에서 이용하실 수 있습니다.',
     TRUE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 33 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 33 DAY)),
    -- 기타 (비노출 검증용)
    ('ETC', '(비공개 테스트) 노출 제외 FAQ',
     'is_visible=FALSE — 사용자 목록에 나오면 안 됩니다. 관리자 목록에서만 보여야 정상입니다.',
     FALSE, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 32 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 32 DAY));

-- ── 3. 1:1 문의(QnA) — 명시 6건 (답변 대기, 관리자 처리 시연 대상) ──────────
INSERT INTO `qna` (`questioner_id`, `title`, `content`, `status`, `is_visible`, `answered_at`, `created_at`, `updated_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'user01@ddasoom.com'),
     '임보 신청서를 수정하고 싶어요',
     '어제 제출한 임시보호 신청서에 전화번호를 잘못 적었습니다. 수정할 방법이 있을까요?',
     'PENDING', TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user05@ddasoom.com'),
     '임시보호 중인데 아이가 밥을 안 먹어요',
     '임보 3일차인데 사료를 거의 안 먹습니다. 보호소에서 먹던 사료와 달라서 그런 걸까요? 어떻게 해야 할지 조언 부탁드립니다.',
     'PENDING', TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user12@ddasoom.com'),
     '탈퇴한 계정을 복구하고 싶습니다',
     '실수로 탈퇴 버튼을 눌렀습니다. 임보 이력이 남아있으면 좋겠는데 복구가 가능할까요?',
     'PENDING', FALSE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 HOUR), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 HOUR)),
    ((SELECT member_id FROM member WHERE email = 'user23@ddasoom.com'),
     '게시글 신고가 처리되었는지 확인하고 싶어요',
     '어제 광고성 게시글을 신고했는데 아직 그대로 보입니다. 처리 중인지 확인 부탁드립니다.',
     'PENDING', TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 HOUR), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 HOUR)),
    ((SELECT member_id FROM member WHERE email = 'user44@ddasoom.com'),
     '보호소 연락처를 알 수 있을까요?',
     '관심 있는 아이가 있는데 방문 전에 상태를 확인하고 싶습니다. 보호소에 직접 연락할 수 있는 방법이 있나요?',
     'PENDING', TRUE, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 HOUR), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 HOUR)),
    ((SELECT member_id FROM member WHERE email = 'today01@ddasoom.com'),
     '가입 인사 겸 질문드려요',
     '오늘 가입했습니다! 임시보호 신청에 필요한 서류가 따로 있나요? 처음이라 준비할 게 궁금합니다.',
     'PENDING', TRUE, NULL, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6));

-- ── 4. 1:1 문의(QnA) — 대량 40건 (답변 완료 위주, 목록 페이징·필터 검증) ────
-- 작성자는 user01~user87을 순환 참조 (더미회원 없음).
-- n MOD 10 = 0 이면 PENDING(4건) — 명시 6건과 합쳐 답변 대기 총 10건이 되도록.
INSERT INTO `qna` (`questioner_id`, `title`, `content`, `status`, `is_visible`, `answered_at`, `created_at`, `updated_at`)
WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 40
),
authors AS (
    SELECT member_id, ROW_NUMBER() OVER (ORDER BY member_id) AS rn
    FROM member WHERE email LIKE 'user%' AND deleted_at IS NULL
)
SELECT
    a.member_id,
    ELT((seq.n MOD 5) + 1,
        '계정 설정 관련 문의드립니다',
        '임시보호 신청 절차가 궁금합니다',
        '커뮤니티 이용 중 문의드려요',
        '동물 공고 정보 관련 질문입니다',
        '서비스 이용 중 오류가 있어요'),
    CONCAT('문의 내용 ', seq.n, '번입니다. 확인 후 답변 부탁드립니다.'),
    IF(seq.n MOD 10 = 0, 'PENDING', 'ANSWERED'),
    IF(seq.n MOD 9 = 0, FALSE, TRUE),                                            -- 일부 비공개 문의
    IF(seq.n MOD 10 = 0, NULL, DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (seq.n MOD 40) DAY)),
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL ((seq.n MOD 40) + 2) DAY),
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (seq.n MOD 40) DAY)
FROM seq
JOIN authors a ON a.rn = ((seq.n - 1) MOD 87) + 1;

-- 답변 완료(ANSWERED) 건에 관리자 답변 댓글 1개씩 (V10 대화형 구조)
INSERT INTO `qna_comment` (`qna_id`, `member_id`, `content`, `created_at`, `updated_at`)
SELECT q.qna_id,
       (SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com'),
       '안녕하세요, 따숨입니다. 문의하신 내용 확인했습니다. 추가로 궁금하신 점은 이 문의에 이어서 남겨 주세요.',
       q.answered_at, q.answered_at
FROM qna q
WHERE q.status = 'ANSWERED';

-- ── 5. 신고 — 회원(MEMBER) 대상 9건 ────────────────────────────────────
-- V100의 HIDDEN 3인이 대상. 신고자는 실명 회원 3인.
-- hidden01: 전건 승인 처리 완료 / hidden02: 1건 허위(반려) + 승인 / hidden03: 미처리(관리자 큐 시연 대상)
INSERT INTO `report` (`reporter_id`, `target_type`, `target_id`, `reason`, `content`, `status`, `processed_id`, `processed_at`, `created_at`, `updated_at`)
SELECT r.member_id, 'MEMBER', t.member_id,
       ELT((r.rn + t.rn) MOD 3 + 1, 'SPAM', 'ABUSE', 'INAPPROPRIATE'),
       CONCAT(t.nickname, ' 회원이 반복적으로 문제 행동을 하고 있습니다. 확인 부탁드립니다.'),
       CASE WHEN t.rn = 1 THEN 'APPROVED'
            WHEN t.rn = 2 AND r.rn = 1 THEN 'REJECTED'
            WHEN t.rn = 2 THEN 'APPROVED'
            ELSE 'PENDING' END,
       CASE WHEN t.rn = 3 THEN NULL ELSE (SELECT member_id FROM member WHERE email = 'adminlee@ddasoom.com') END,
       CASE WHEN t.rn = 3 THEN NULL ELSE DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL t.rn DAY) END,
       DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL (t.rn + r.rn + 2) DAY),
       DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL t.rn DAY)
FROM (SELECT member_id, ROW_NUMBER() OVER (ORDER BY member_id) AS rn
      FROM member WHERE email IN ('user01@ddasoom.com', 'user02@ddasoom.com', 'user03@ddasoom.com')) r
CROSS JOIN (SELECT member_id, nickname, ROW_NUMBER() OVER (ORDER BY member_id) AS rn
            FROM member WHERE email IN ('hidden01@ddasoom.com', 'hidden02@ddasoom.com', 'hidden03@ddasoom.com')) t;
