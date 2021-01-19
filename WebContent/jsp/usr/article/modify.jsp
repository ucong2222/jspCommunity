<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="${board.name} 게시물 수정"/>
<%@ include file="../../part/head.jspf" %>
	<h1>${pageTitle}</h1>
	<div>
		<form action="doModify" method="POST">
			<input type="hidden" name="id" value="${article.id}"/>
			<hr />
			<div>
				<div>제목</div>
				<div><input name="title" type="text" maxlength="50" placeholder="제목을 입력해주세요." value = "${article.title}"/></div>
			</div>
				<hr />
			<div>
				<div>내용</div>
				<div><textarea name="body" maxlength="5000" placeholder="내용을 입력해주세요.">${article.body}</textarea></div>
			</div>
				<hr />
			<div>
				<div>수정</div>
				<div>
					<input type="submit" value="수정"/>
					<button type="button" onclick="history.back()">뒤로가기</button>
				</div>
			</div>

		</form>
	</div>
<%@ include file="../../part/foot.jspf" %>