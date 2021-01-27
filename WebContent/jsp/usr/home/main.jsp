<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="메인화면" />
<%@ include file="../../part/head.jspf"%>

<!-- 
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/UsrHomeMain.css" />
<script src="${pageContext.request.contextPath}/static/UsrHomeMain.js" defer></script>
 -->

<!-- 로고바 시작 -->
<div class="logo-bar con-min-width visible-md-up">
  <div class="con height-100p flex flex-jc-sb flex-ai-c">
    <div class="header__logo height-100p">
      <a href="../home/main" class="logo"><img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FpcVUI%2FbtqUzu8suTk%2F3T7owEJ5tUaHKQTMKzDrtk%2Fimg.jpg" alt=""></a>
    </div>
    <div class="header__search-box flex">
      <input type="text">
      <button type="button"><i class="fas fa-search"></i></button>
    </div>
  </div>
</div>
<!-- 로고바 끝 -->

<!-- 메뉴바 시작 -->
<div class="menu-bar con-min-width visible-md-up">
  <div class="con height-100p">
    <nav class="menu-bar__menu-box-1 height-100p">
      <ul class="flex height-100p">
        <li><a href="../home/main" class="flex flex-jc-c flex-ai-c height-100p">HOME</a></li>
        <li><a href="../article/list?boardId=1" class="flex flex-jc-c flex-ai-c height-100p">NOTICE</a></li>
        <li><a href="../article/list?boardId=3" class="flex flex-jc-c flex-ai-c height-100p">FREE</a></li>
        <li><a href="../article/list?boardId=2" class="flex flex-jc-c flex-ai-c height-100p">GUESTBOOK</a></li>
      </ul>
    </nav>
  </div>
</div>
<!-- 메뉴바 끝 -->

<!--content 시작 -->
<main class="con-min-width visible-md-up">
  <div class="con main-content flex flex-jc-sb height-100vh">
    <div class="left-content"></div>
    <div class="right-content">
      <div class="login-box">
        <c:if test="${isLogined == false}">
	        <div class="login-box__login flex flex-ai-c  flex-jc-c">
	          <a href="../member/login">로 그 인</a>
	        </div>
	        <div class="flex flex-jc-sb login-box__option">
	          <div>
	            <a href="../member/findLoginId">아이디찾기</a>
	            <a href="../member/findLoginPw">비밀번호찾기</a>
	          </div>
	          <div>
	            <a href="../member/join">회원가입</a>  
	          </div>
	        </div>
        </c:if>
      </div>
    </div>
  </div>
</main>
<!--content 끝 -->

<!-- 모바일 탑바 시작-->
<header class="mobile-top-bar visible-md-down flex">
  <div class="flex-1-0-0 flex">
    <div class="mobile-top-bar__btn-toggle-side-bar flex-as-c">
      <div></div>
      <div></div>
      <div></div>
    </div>
  </div>
  <div>
    <a href="../home/main" class="mobile-logo"><img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbJFCp5%2FbtqUODbWKTd%2F9sKe9tTCE3taxUxWAcbW11%2Fimg.jpg" alt=""></a>
  </div>
  <div class="flex-1-0-0"></div>
</header>
<!-- 모바일 탑바 끝-->

<!-- 모바일 사이드 바 시작-->
<aside class="mobile-side-bar visible-md-down">
  <nav class="mobile-side-bar__menu-box-1">
    <ul>
      <li><a href="../home/main" class="block">HOME</a></li>
      <li><a href="../article/list?boardId=1" class="block">NOTICE</a></li>
      <li><a href="../article/list?boardId=3" class="block">FREE</a></li>
      <li><a href="../article/list?boardId=2" class="block">GUESTBOOK</a></li>
    </ul>
  </nav>
</aside>
<!-- 모바일 사이드 바 끝-->

<%@ include file="../../part/foot.jspf"%>