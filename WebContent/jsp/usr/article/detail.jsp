<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.sbs.example.jspCommunity.dto.Article"%>
<%@ page import="com.sbs.example.jspCommunity.dto.Board"%>
<%
Board board = (Board) request.getAttribute("board");
String pageTitle = "게시물 상세페이지";
%>
<%@ include file="../../part/head.jspf" %>

	<h1><%=pageTitle%></h1>
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
		<a href="modify?id=${article.id}">수정</a>
		<a onclick="if (confirm('정말 삭제 하시겠습니까?') == false){ return false;}" href="doDelete?id=${article.id}">삭제</a>
	</div>
<%@ include file="../../part/foot.jspf" %>
