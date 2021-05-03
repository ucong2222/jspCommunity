DROP DATABASE IF EXISTS jspCommunity;
CREATE DATABASE jspCommunity;
USE jspCommunity;

# 회원 테이블 생성
CREATE TABLE `member`(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    loginId CHAR(50) NOT NULL UNIQUE,
    loginPw VARCHAR(200) NOT NULL,
    `name` CHAR(50) NOT NULL,
    `nickname` CHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    cellphoneNo CHAR(20) NOT NULL,
    authLevel TINYINT(1) UNSIGNED NOT NULL DEFAULT 2 COMMENT '0=탈퇴/1=로그인정지/2=일반/3=인증된/4=관리자'
);

# 회원1 생성
INSERT INTO `member`
SET regDate = NOW(),
    updateDate = NOW(),
    `name` = "김민수",
    `nickname` = "강바람",
    `email` = "dnjdn21@naver.com",
    cellphoneNo=01012341234,
    loginId = "user1",
    loginPw = "user1";
    
# 회원2 생성
INSERT INTO `member`
SET regDate = NOW(),
    updateDate = NOW(),
    `name` = "김수연",
    `nickname` = "콧노래",
    `email` = "dnjdn21@naver.com",
    cellphoneNo=01012341234,
    loginId = "user2",
    loginPw = "user2";

# 게시판 테이블 생성
CREATE TABLE board(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `code` CHAR(10) NOT NULL UNIQUE,
    `name` CHAR(10) NOT NULL UNIQUE
);

# 자유토크 생성
INSERT INTO board
SET regDate = NOW(),
    updateDate = NOW(),
    `code` = "freeTalk",
    `name` = "자유토크";
    
# 갤러리게시판  생성
INSERT INTO board
SET regDate = NOW(),
    updateDate = NOW(),
    `code` = "gallery",
    `name` = "갤러리";
    
# 정보공유게시판  생성
INSERT INTO board
SET regDate = NOW(),
    updateDate = NOW(),
    `code` = "info",
    `name` = "정보공유";

# 게시물 테이블 생성  
CREATE TABLE article(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    boardId INT(10) UNSIGNED NOT NULL,
    title CHAR(100) NOT NULL,
    `body` LONGTEXT NOT NULL,
    hit INT(10) UNSIGNED NOT NULL DEFAULT 0
);


# 테스트 게시물 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 1,
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 1,
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 1,
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 1,
title = '제목4',
`body` = '내용4';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 1,
title = '제목5',
`body` = '내용5'; 


INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 2,
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 2,
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 2,
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 2,
title = '제목4',
`body` = '내용4';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 2,
title = '제목5',
`body` = '내용5'; 

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 3,
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 3,
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 3,
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 3,
title = '제목4',
`body` = '내용4';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 3,
title = '제목5',
`body` = '내용5'; 

# 칼럼 순서 재정렬
ALTER TABLE `member` CHANGE loginId loginId CHAR(50) NOT NULL AFTER updateDate,
                     CHANGE loginPw loginPw VARCHAR(200) NOT NULL AFTER loginId;

# 기존회원의 비번을 암호화
UPDATE `member`
SET loginPw = SHA2(loginPw, 256);

# 부가정보 테이블
# 댓글 테이블 추가

CREATE TABLE attr(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `relTypeCode` CHAR(20) NOT NULL, # 관련타입코드, member
    `relId` INT(10) UNSIGNED NOT NULL, # 관련데이터번호, 5
    `typeCode` CHAR(30) NOT NULL, # extra
    `type2Code` CHAR(30) NOT NULL, # isTempPasswordUsing
    `value` TEXT NOT NULL # 1
);

# attr 유니크 인데스 걸기
## 중복변수 생성금지
## 변수찾는 속도 최적화
ALTER TABLE `attr` ADD UNIQUE INDEX (`relTypeCode`, `relId`, `typeCode`,`type2Code`);

## 특정 조건을 만족하는 회원 또는 게시물(기타 데이터)를 빠르게 찾기 위해서
ALTER TABLE `attr` ADD INDEX (`relTypeCode`,`typeCode`,`type2Code`);

# attr에 만료날짜 추가
ALTER TABLE `attr` ADD COLUMN `expireDate` DATETIME NULL AFTER `value`;

# 좋아요 테이블 추가
CREATE TABLE `like` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    relTypeCode CHAR(30) NOT NULL,
    relId INT(10) UNSIGNED NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    `point` SMALLINT(1) NOT NULL
);

# 좋아요 인덱스
ALTER TABLE `like` ADD INDEX (`relTypeCode`, `relId`, `memberId`);

# 댓글 테이블 추가
CREATE TABLE `reply` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    relTypeCode CHAR(30) NOT NULL,
    relId INT(10) UNSIGNED NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    `body` TEXT NOT NULL
);

# 댓글에 인덱스 걸기
ALTER TABLE `reply` ADD INDEX (`relTypeCode`, `relId`);

# 댓글에 테스트 데이터 추가
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`body` = '댓글1';

INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글2';

INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글3';

