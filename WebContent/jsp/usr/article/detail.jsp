<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="${board.name} 게시물 상세 페이지"/>
<%@ include file="../../part/head.jspf" %>
	<h1>${pageTitle}</h1>
	<div>
		번호 : 
		${article.id}
		<br />
		작성날짜 : 
		${article.regDate}
		<br />
		갱신날짜 : 
		${article.updateDate}
		<br />
		작성자 : 
		${article.extra__writer}
		<br />
		제목 : 
		${article.title}
		<br />
		내용 : 
		${article.body}
	</div>
	
	<hr />
	
	<div>
		<a href="list?boardId=${article.boardId}">리스트로 이동</a>
		<c:if test="${sessionScope.loginedMemberId eq article.memberId}">
		<a href="modify?id=${article.id}">수정</a>
		<a onclick="if (confirm('정말 삭제 하시겠습니까?') == false){ return false;}" href="doDelete?id=${article.id}">삭제</a>
		</c:if>
	</div>
<%@ include file="../../part/foot.jspf" %>
