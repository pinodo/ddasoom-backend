-- =============================================================
-- V100__seed_member.sql  [개발용 더미 — 전면 재구성 2026-07]
-- 로컬/테스트 전용. fresh 마이그레이션 전제(기존 로컬 DB는 드롭 후 재기동).
--
-- ⚠️ 재구성 배경: 기존 시드는 대량 회원을 'bulk01~80(더미회원N)'으로 넣고 게시글·문의·임보의
--    작성자로 참조했다. 관리자 페이지에서 회원을 눌러도 의미 없는 더미가 나와 처리 흐름 검증이 불가능했다.
--    → 더미회원을 전부 제거하고 **100명 전원에게 실제 이름·닉네임**을 부여한다.
--      이후 모든 시드(게시판·문의·신고·임보·좋아요)는 이 100명만 작성자로 참조한다.
--
-- 구성 (총 100명)
--   · 오늘 가입    3명  — 대시보드 "오늘 신규 가입자" 카드가 항상 3으로 고정 검증
--   · 활성 일반   87명  — 가입일을 최근 60일에 분산(일별/월별 가입 추이 곡선)
--   · 숨김(HIDDEN) 3명  — 신고 제재 → 로그인 차단 시나리오의 대상
--   · 탈퇴         4명  — 복구 기능·재가입 불가 검증 (작성자로는 사용하지 않음)
--   · GUEST        3명  — 소셜 가입 후 추가정보 미입력. 구조상 name/nickname NULL 유지
--                         (승급 흐름·USER_URIS 403 검증용이라 실명 부여 대상이 아님)
--
-- 작성자 풀 = 오늘가입(3) + 활성(87) + 숨김(3) = 93명. 탈퇴·GUEST는 작성자로 쓰지 않는다.
-- 비밀번호는 전원 동일 해시(평문 Ddasoom1!)
-- =============================================================

SET @pw := '$2b$10$nFgxKiqsJPXAW3uWp5/tqemYRrE1LUkzhftrV4GvrYVJ3r2XF9VN2';

-- ── 1. 오늘 가입 3명 (대시보드 카드 = 항상 3) ────────────────────────────
INSERT INTO `member` (`email`, `password`, `name`, `nickname`, `tel`, `role`, `event_status`, `status`, `created_at`, `updated_at`) VALUES
    ('today01@ddasoom.com', @pw, '민지호', '지호집사',    '01033330001', 'USER', 'NONE', 'ACTIVE', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)),
    ('today02@ddasoom.com', @pw, '서다현', '다현맘',      '01033330002', 'USER', 'NONE', 'ACTIVE', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)),
    ('today03@ddasoom.com', @pw, '이준서', '준서네댕댕',  '01033330003', 'USER', 'NONE', 'ACTIVE', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6));

-- ── 2. 활성 회원 87명 (user01~user87) ───────────────────────────────────
-- 가입일은 최근 60일에 분산. 특히 최근 7일 구간(1~6일 전)에 여러 명을 배치해
-- 대시보드의 "일별 신규 가입자 추이" 꺾은선이 평평하지 않게 만든다.
-- user01·user02는 이벤트 참여(PARTICIPATING) — V102 게시판에서 이벤트 기간 글 11건씩 작성.
INSERT INTO `member` (`email`, `password`, `name`, `nickname`, `tel`, `role`, `event_status`, `status`, `created_at`, `updated_at`) VALUES
    ('user01@ddasoom.com', @pw, '박하늘', '하늘이집사',   '01022220001', 'USER', 'PARTICIPATING', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 45 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 45 DAY)),
    ('user02@ddasoom.com', @pw, '최바다', '바다냥집사',   '01022220002', 'USER', 'PARTICIPATING', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 44 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 44 DAY)),
    ('user03@ddasoom.com', @pw, '정온유', '온유멍집사',   '01022220003', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 43 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 43 DAY)),
    ('user04@ddasoom.com', @pw, '한별님', '별님보호소',   '01022220004', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 42 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 42 DAY)),
    ('user05@ddasoom.com', @pw, '오솜이', '솜이누나',     '01022220005', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 41 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 41 DAY)),
    ('user06@ddasoom.com', @pw, '김도담', '도담도담',     '01022220006', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 40 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 40 DAY)),
    ('user07@ddasoom.com', @pw, '이봄날', '봄날의멍멍',   '01022220007', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 39 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 39 DAY)),
    ('user08@ddasoom.com', @pw, '서루비', '루비언니',     '01022220008', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 38 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 38 DAY)),
    ('user09@ddasoom.com', @pw, '문찬비', '찬비네냥이',   '01022220009', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 37 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 37 DAY)),
    ('user10@ddasoom.com', @pw, '강마루', '마루아빠',     '01022220010', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 36 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 36 DAY)),
    ('user11@ddasoom.com', @pw, '윤새롬', '새롬이맘',     '01022220011', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 35 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 35 DAY)),
    ('user12@ddasoom.com', @pw, '장하준', '하준이집사',   '01022220012', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 34 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 34 DAY)),
    ('user13@ddasoom.com', @pw, '임서연', '서연냥집사',   '01022220013', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 33 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 33 DAY)),
    ('user14@ddasoom.com', @pw, '신동우', '동우댕댕',     '01022220014', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 32 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 32 DAY)),
    ('user15@ddasoom.com', @pw, '조미래', '미래보호소',   '01022220015', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 31 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 31 DAY)),
    ('user16@ddasoom.com', @pw, '백지훈', '지훈이네',     '01022220016', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 30 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 30 DAY)),
    ('user17@ddasoom.com', @pw, '남현이', '현이형집사',   '01022220017', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 29 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 29 DAY)),
    ('user18@ddasoom.com', @pw, '표은서', '은서맘',       '01022220018', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 28 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 28 DAY)),
    ('user19@ddasoom.com', @pw, '유가온', '가온이아빠',   '01022220019', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 27 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 27 DAY)),
    ('user20@ddasoom.com', @pw, '배시우', '시우네냥이',   '01022220020', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 26 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 26 DAY)),
    ('user21@ddasoom.com', @pw, '노아린', '아린이집사',   '01022220021', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 25 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 25 DAY)),
    ('user22@ddasoom.com', @pw, '심재윤', '재윤멍멍',     '01022220022', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 24 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 24 DAY)),
    ('user23@ddasoom.com', @pw, '하은결', '은결이맘',     '01022220023', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 23 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 23 DAY)),
    ('user24@ddasoom.com', @pw, '곽태오', '태오네강아지', '01022220024', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 22 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 22 DAY)),
    ('user25@ddasoom.com', @pw, '진소율', '소율냥집사',   '01022220025', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 21 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 21 DAY)),
    ('user26@ddasoom.com', @pw, '차예준', '예준이형',     '01022220026', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY)),
    ('user27@ddasoom.com', @pw, '도하람', '하람보호소',   '01022220027', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 19 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 19 DAY)),
    ('user28@ddasoom.com', @pw, '봉수아', '수아맘',       '01022220028', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 18 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 18 DAY)),
    ('user29@ddasoom.com', @pw, '민가람', '가람이집사',   '01022220029', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 17 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 17 DAY)),
    ('user30@ddasoom.com', @pw, '양지우', '지우네댕댕',   '01022220030', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 16 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 16 DAY)),
    ('user31@ddasoom.com', @pw, '구나윤', '나윤이맘',     '01022220031', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 15 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 15 DAY)),
    ('user32@ddasoom.com', @pw, '탁현서', '현서집사',     '01022220032', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 14 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 14 DAY)),
    ('user33@ddasoom.com', @pw, '방연우', '연우냥이',     '01022220033', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 13 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 13 DAY)),
    ('user34@ddasoom.com', @pw, '석주안', '주안이아빠',   '01022220034', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 12 DAY)),
    ('user35@ddasoom.com', @pw, '우다인', '다인맘',       '01022220035', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 11 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 11 DAY)),
    ('user36@ddasoom.com', @pw, '천이서', '이서네',       '01022220036', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 10 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 10 DAY)),
    ('user37@ddasoom.com', @pw, '편승호', '승호집사',     '01022220037', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 9 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 9 DAY)),
    ('user38@ddasoom.com', @pw, '함라온', '라온이맘',     '01022220038', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 DAY)),
    ('user39@ddasoom.com', @pw, '옥준희', '준희냥집사',   '01022220039', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY)),
    ('user40@ddasoom.com', @pw, '계유진', '유진멍멍',     '01022220040', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY)),
    ('user41@ddasoom.com', @pw, '마동석', '동석이형',     '01022220041', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY)),
    ('user42@ddasoom.com', @pw, '반소민', '소민맘',       '01022220042', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY)),
    ('user43@ddasoom.com', @pw, '설태양', '태양이집사',   '01022220043', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY)),
    ('user44@ddasoom.com', @pw, '성유나', '유나네냥이',   '01022220044', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ('user45@ddasoom.com', @pw, '소하윤', '하윤맘',       '01022220045', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ('user46@ddasoom.com', @pw, '송재하', '재하집사',     '01022220046', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ('user47@ddasoom.com', @pw, '안겨울', '겨울이맘',     '01022220047', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ('user48@ddasoom.com', @pw, '엄시온', '시온네',       '01022220048', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ('user49@ddasoom.com', @pw, '여름이', '여름집사',     '01022220049', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ('user50@ddasoom.com', @pw, '염보라', '보라맘',       '01022220050', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY)),
    ('user51@ddasoom.com', @pw, '예지원', '지원냥집사',   '01022220051', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY),  DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY)),
    ('user52@ddasoom.com', @pw, '옹기종', '기종이형',     '01022220052', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 59 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 59 DAY)),
    ('user53@ddasoom.com', @pw, '원가을', '가을맘',       '01022220053', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 58 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 58 DAY)),
    ('user54@ddasoom.com', @pw, '위서준', '서준집사',     '01022220054', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 57 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 57 DAY)),
    ('user55@ddasoom.com', @pw, '육민준', '민준네댕댕',   '01022220055', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 56 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 56 DAY)),
    ('user56@ddasoom.com', @pw, '은도윤', '도윤이맘',     '01022220056', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 55 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 55 DAY)),
    ('user57@ddasoom.com', @pw, '인채원', '채원냥집사',   '01022220057', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 54 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 54 DAY)),
    ('user58@ddasoom.com', @pw, '주현우', '현우형',       '01022220058', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 53 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 53 DAY)),
    ('user59@ddasoom.com', @pw, '차다온', '다온맘',       '01022220059', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 52 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 52 DAY)),
    ('user60@ddasoom.com', @pw, '전예린', '예린이집사',   '01022220060', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 51 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 51 DAY)),
    ('user61@ddasoom.com', @pw, '정슬기', '슬기네냥이',   '01022220061', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 50 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 50 DAY)),
    ('user62@ddasoom.com', @pw, '제서량', '서량아빠',     '01022220062', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 49 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 49 DAY)),
    ('user63@ddasoom.com', @pw, '주하진', '하진맘',       '01022220063', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 48 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 48 DAY)),
    ('user64@ddasoom.com', @pw, '지새벽', '새벽집사',     '01022220064', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 47 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 47 DAY)),
    ('user65@ddasoom.com', @pw, '진달래', '달래맘',       '01022220065', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 46 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 46 DAY)),
    ('user66@ddasoom.com', @pw, '채송화', '송화냥집사',   '01022220066', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 45 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 45 DAY)),
    ('user67@ddasoom.com', @pw, '최현민', '현민이형',     '01022220067', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 44 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 44 DAY)),
    ('user68@ddasoom.com', @pw, '추가온', '가온맘',       '01022220068', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 43 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 43 DAY)),
    ('user69@ddasoom.com', @pw, '태연서', '연서집사',     '01022220069', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 42 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 42 DAY)),
    ('user70@ddasoom.com', @pw, '판다솜', '다솜맘',       '01022220070', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 41 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 41 DAY)),
    ('user71@ddasoom.com', @pw, '표주원', '주원네댕댕',   '01022220071', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 40 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 40 DAY)),
    ('user72@ddasoom.com', @pw, '하늬별', '늬별집사',     '01022220072', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 39 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 39 DAY)),
    ('user73@ddasoom.com', @pw, '한겨레', '겨레맘',       '01022220073', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 38 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 38 DAY)),
    ('user74@ddasoom.com', @pw, '허사랑', '사랑냥집사',   '01022220074', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 37 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 37 DAY)),
    ('user75@ddasoom.com', @pw, '현빛나', '빛나맘',       '01022220075', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 36 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 36 DAY)),
    ('user76@ddasoom.com', @pw, '형준영', '준영이형',     '01022220076', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 35 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 35 DAY)),
    ('user77@ddasoom.com', @pw, '홍시안', '시안집사',     '01022220077', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 34 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 34 DAY)),
    ('user78@ddasoom.com', @pw, '화사랑', '사랑맘',       '01022220078', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 33 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 33 DAY)),
    ('user79@ddasoom.com', @pw, '황금비', '금비냥집사',   '01022220079', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 32 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 32 DAY)),
    ('user80@ddasoom.com', @pw, '후지영', '지영맘',       '01022220080', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 31 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 31 DAY)),
    ('user81@ddasoom.com', @pw, '강초록', '초록집사',     '01022220081', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 30 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 30 DAY)),
    ('user82@ddasoom.com', @pw, '고은하', '은하맘',       '01022220082', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 28 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 28 DAY)),
    ('user83@ddasoom.com', @pw, '권시월', '시월냥집사',   '01022220083', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 26 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 26 DAY)),
    ('user84@ddasoom.com', @pw, '기다림', '다림이형',     '01022220084', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 24 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 24 DAY)),
    ('user85@ddasoom.com', @pw, '길가온', '가온집사',     '01022220085', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 22 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 22 DAY)),
    ('user86@ddasoom.com', @pw, '김보름', '보름맘',       '01022220086', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 20 DAY)),
    ('user87@ddasoom.com', @pw, '나예솔', '예솔냥집사',   '01022220087', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 18 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 18 DAY));

-- ── 3. 숨김(HIDDEN) 3명 — 신고 제재 대상 ────────────────────────────────
-- V102 게시판에서 이들이 쓴 도배·비방 글이 신고되고, 관리자가 승인해 숨김 처리된 상태.
-- "신고 큐 확인 → 회원 상세 → 숨김 해제" 및 "숨김 회원 로그인 차단(AUTH_110)" 시연 대상.
INSERT INTO `member` (`email`, `password`, `name`, `nickname`, `tel`, `role`, `event_status`, `status`, `created_at`, `updated_at`) VALUES
    ('hidden01@ddasoom.com', @pw, '차민석', '최저가공구',   '01044440001', 'USER', 'NONE', 'HIDDEN', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 50 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ('hidden02@ddasoom.com', @pw, '남경호', '분양전문',     '01044440002', 'USER', 'NONE', 'HIDDEN', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 48 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ('hidden03@ddasoom.com', @pw, '구태식', '팩트폭격기',   '01044440003', 'USER', 'NONE', 'HIDDEN', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 46 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY));

-- ── 4. 탈퇴 회원 4명 — 복구 기능·재가입 불가 검증 (작성자로 사용하지 않음) ──
INSERT INTO `member` (`email`, `password`, `name`, `nickname`, `tel`, `role`, `event_status`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
    ('left01@ddasoom.com', @pw, '송민아', '민아맘',       '01055550001', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 55 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 7 DAY)),
    ('left02@ddasoom.com', @pw, '유태경', '태경집사',     '01055550002', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 54 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 6 DAY)),
    ('left03@ddasoom.com', @pw, '임하늘', '하늘맘',       '01055550003', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 53 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 5 DAY)),
    ('left04@ddasoom.com', @pw, '조은수', '은수냥집사',   '01055550004', 'USER', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 52 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY));

-- ── 5. GUEST 3명 — 소셜 가입 후 추가정보 미입력 ──────────────────────────
-- ⚠️ name/nickname이 NULL인 것은 오류가 아니라 설계다. GUEST는 추가정보 입력(승급) 전 상태이며,
--    소셜 닉네임을 쓰지 않는 팀 정책상 승급 시점에 비로소 값이 채워진다.
INSERT INTO `member` (`email`, `password`, `name`, `nickname`, `tel`, `role`, `event_status`, `status`, `created_at`, `updated_at`) VALUES
    ('guest01@ddasoom.com', NULL, NULL, NULL, NULL, 'GUEST', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 8 DAY)),
    ('guest02@ddasoom.com', NULL, NULL, NULL, NULL, 'GUEST', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ('guest03@ddasoom.com', NULL, NULL, NULL, NULL, 'GUEST', 'NONE', 'ACTIVE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY), DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY));

-- GUEST의 소셜 연동 레코드 (신원은 provider+provider_id — 이메일이 아님)
INSERT INTO `member_social` (`member_id`, `provider`, `provider_id`, `created_at`, `updated_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'guest01@ddasoom.com'), 'KAKAO',  'kakao-dummy-0001',  CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)),
    ((SELECT member_id FROM member WHERE email = 'guest02@ddasoom.com'), 'NAVER',  'naver-dummy-0001',  CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)),
    ((SELECT member_id FROM member WHERE email = 'guest03@ddasoom.com'), 'GOOGLE', 'google-dummy-0001', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6));

-- ── 6. 로그인 이력 ──────────────────────────────────────────────────────
-- user01: 23건 — 관리자 상세의 로그인 이력 페이징(20건/페이지)이 2페이지가 되도록
INSERT INTO `login_log` (`member_id`, `login_type`, `created_at`)
WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 23
)
SELECT
    (SELECT member_id FROM member WHERE email = 'user01@ddasoom.com'),
    ELT((n MOD 4) + 1, 'LOCAL', 'KAKAO', 'NAVER', 'GOOGLE'),
    DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL n DAY)
FROM seq;

-- 명시 회원 몇 명에 최근 이력 (마이페이지 "최근 5건" 미리보기 검증)
INSERT INTO `login_log` (`member_id`, `login_type`, `created_at`) VALUES
    ((SELECT member_id FROM member WHERE email = 'user02@ddasoom.com'), 'LOCAL', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 1 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user02@ddasoom.com'), 'KAKAO', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 3 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user03@ddasoom.com'), 'LOCAL', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ((SELECT member_id FROM member WHERE email = 'user05@ddasoom.com'), 'GOOGLE', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 2 DAY)),
    ((SELECT member_id FROM member WHERE email = 'hidden01@ddasoom.com'), 'LOCAL', DATE_SUB(CURRENT_TIMESTAMP(6), INTERVAL 4 DAY)),
    ((SELECT member_id FROM member WHERE email = 'today01@ddasoom.com'), 'LOCAL', CURRENT_TIMESTAMP(6));
