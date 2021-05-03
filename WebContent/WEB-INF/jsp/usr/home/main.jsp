<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="메인화면" />
<%@ include file="../../part/head.jspf"%>

<!-- 
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/UsrHomeMain.css" />
<script src="${pageContext.request.contextPath}/static/UsrHomeMain.js" defer></script>
 -->
	<!--content 시작 -->
	<main class="con-min-width visible-md-up">
	  <div class="con main-content flex flex-jc-sb">
	    <div class="left-content">
	        <div class="flex flex-wrap">
	          <div class="freetalk-box">
	            <div class="flex flex-jc-sb title-box">
	              <div class="title">자유토크</div>
	              <a href="../article/list?boardId=1" class="flex-as-c">더보기+</a>
	            </div>
	            <div class="freetalk-title">
	              <c:forEach var="freeTalkArticle" items="${freeTalkArticles}">
	              	<a href="../article/detail?id=${freeTalkArticle.id}">${freeTalkArticle.title}</a>
	              </c:forEach>
	            </div>
	          </div>
	          <div class="infoshare-box">
	            <div class="flex flex-jc-sb title-box">
	              <div class="title">정보공유</div>
	              <a href="../article/list?boardId=3" class="flex-as-c">더보기+</a>
	            </div>
	            <div class="infoshare-title">
	              <c:forEach var="infoShareArticle" items="${infoShareArticles}">
	              	<a href="../article/detail?id=${infoShareArticle.id}">${infoShareArticle.title}</a>
	              </c:forEach>
	            </div>
	          </div>
	          <div class="gallery-box">
	            <div class="flex flex-jc-sb title-box">
	              <div class="title">갤러리</div>
	              <a href="../article/list?boardId=2" class="flex-as-c">더보기+</a>
	            </div>
	            <div class="gallery-title">
	              <c:forEach var="galleryArticle" items="${galleryArticles}">
	              	<a href="../article/detail?id=${galleryArticle.id}">${galleryArticle.title}</a>
	              </c:forEach>
	            </div>
	          </div>
	        </div>
	    </div>
	    <div class="right-content flex flex-jc-c">
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
	        <c:if test="${isLogined}">
		        <div class="login-box__info flex flex-jc-sb flex-ai-c">
		            <div class="login-box__info-nickname"><span>${loginedMember.name}</span>님</div>
		            <div class="login-box__info-btn-logout">
		              <a href="../member/doLogout">로그아웃</a>
		            </div>
		          </div>
		          <div class="login-box__info-detail">
		            <span>쪽지 0</span>
		            <span>알림 0</span>
		          </div>
		          <div class="flex flex-jc-c login-box__info-option">
		            <a href="#">내 게시물</a>
		            <span>|</span>
		            <a href="#">내 댓글</a>
		            <span>|</span>
		            <a href="../member/modify">회원정보</a>
		          </div>
	        </c:if>
	      </div>
	    </div>
	  </div>
	</main>
	<!--content 끝 -->
	


<%@ include file="../../part/foot.jspf"%>