<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 리스트" />
<%@ include file="../../part/head.jspf"%>
<h1>${pageTitle}</h1>
<hr />
<div>
	<c:if test="${sessionScope.loginedMemberId > 0}">
	<a href="write?boardId=${param.boardId}">게시물 작성</a>
	<hr />
	</c:if>
</div>

<div>
	<script>
		let DoSearchForm__submited = false;
		function DoSearchForm__submit(form){
			if( DoSearchForm__submited ){
					alert('처리중입니다.');
					return;
				}
			form.searchKeyword.value = form.searchKeyword.value.trim();
			
			if ( form.searchKeyword.value.length == 0){
				alert('검색어를 입력해주세요.');
				form.searchKEyword.focus();
				return;
			}
			
			form.submit();
			DoSearchForm__submited = true;
		}
	</script>
	<form action="" onsubmit="DoSearchForm__submit(this); return false;">
		<input type="hidden" name="boardId" value="${param.boardId}" />
		
		<select name="searchKeywordType">
			<option value="title">제목</option>
			<option value="body">본문</option>
		</select>
		<script>
			const param__searchKeywordType = '${param.searchKeywordType}';
		
			if ( param__searchKeywordType ) {
				$('select[name="searchKeywordType"]').val(param__searchKeywordType);
			}
		</script>
		<input value="${param.searchKeyword}" type="text" name="searchKeyword" placeholder="검색어를 입력해주세요."/>
		<input type="submit" value="검색" />
	</form>
</div>

<hr />

<div>
	총 게시물 수 : ${totalCount}
</div>

<hr />

<c:forEach var="article" items="${articles}">
	<div>
		번호 :
		${article.id}
		<br /> 작성날짜 :
		${article.regDate}
		<br /> 갱신날짜 :
		${article.updateDate}
		<br /> 작성자 :
		${article.extra__writer}
		<br /> 제목 : <a href="detail?id=${article.id}">${article.title}</a>
		<hr />
	</div>
</c:forEach>
<%@ include file="../../part/foot.jspf"%>