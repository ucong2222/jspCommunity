<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세 페이지" />
<%@ include file="../../part/head.jspf"%>

<script>
	$(function(){
		if ( param.focusReplyId ) {
			const $target = $('.reply-list-box .reply-box[data-id="' + param.focusReplyId + '"]');
			$target.addClass('focus');
		
			setTimeout(function() {
				const targetOffset = $target.offset();
				
				$(window).scrollTop(targetOffset.top - 100);
				
				setTimeout(function() {
					$target.removeClass('focus');
				}, 1000);
			}, 1000);
		}
	});
	
	// 좋아요, 싫어요 ajax 구현
	
	function doLike(relTypeCode, id){
		if ( ${loginedMemberId} == 0 ){
			alert('로그인 후 이용해주세요.');
			return;
		}
		
		$.get('../like/doLikeAjax',
				{
				relTypeCode : relTypeCode,
				relId : id
			},
			function(data){
				if (data.resultCode == 'F-1'){
					alert(data.msg);
				} else{
				$('.likeOnlyPoint').text(data.body.likeOnlyPoint);
				}
			},
			'json',
		);
	}
	
	function doDislike(relTypeCode, id){
		if ( ${loginedMemberId} == 0 ){
			alert('로그인 후 이용해주세요.');
			return;
		}
		
		$.get('../like/doDislikeAjax',
				{
				relTypeCode : relTypeCode,
				relId : id
			},
			function(data){
				if (data.resultCode == 'F-1'){
					alert(data.msg);
				} else{
				$('.dislikeOnlyPoint').text(data.body.dislikeOnlyPoint);
				}
			},
			'json',
		);
	}
	
	
	
</script>

<!-- 게시물 상세 시작-->
<div class="title-bar con-min-width">
	<h1 class="con">
		<span>
			<i class="far fa-list-alt"></i>
		</span>
		<span>공지사항 게시물 상세 페이지</span>
	</h1>
</div>

<div class="con-min-width article-detail-box">
	<div class="con">
		<h2 class="article-detail-box__title">${article.title}</h2>
		<div class="article-detail-box__info flex flex-jc-sb visible-md-up">
			<div class="flex">
				<div class="article-detail-box__writer">
					${article.extra__writer}</div>
				<div class="article-detail-box__reg-data">${article.regDate}</div>
			</div>
			<div class="flex">
				<div class="article-detail-box__likeCount">
					<span>조회</span>
					<span>${article.hit}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>좋아요수</span>
					<span class="likeOnlyPoint">${article.extra__likeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>싫어요수</span>
					<span class="dislikeOnlyPoint">${article.extra__dislikeOnlyPoint}</span>
				</div>
			</div>
		</div>

		<div class="article-detail-box__info visible-md-down">
			<div class="flex">
				<div class="article-detail-box__writer">
					${article.extra__writer}</div>
				<div class="article-detail-box__reg-data">${article.regDate}</div>
			</div>
			<div class="flex">
				<div class="article-detail-box__likeCount">
					<span>조회</span>
					<span>${article.hit}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>좋아요수</span>
					<span class="likeOnlyPoint">${article.extra__likeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>싫어요수</span>
					<span class="dislikeOnlyPoint">${article.extra__dislikeOnlyPoint}</span>
				</div>
			</div>
		</div>

		<div class="article-detail-box__body">
			<script type="text/x-template">${article.body}</script>
			<div class="toast-ui-viewer"></div>
		</div>
		<div class="article-detail-box__bottom flex flex-jc-e">
			<a onclick="doLike('article', '${article.id}');">
				<span><i id="like" class="far fa-thumbs-up"></i></span>
				<span>좋아요</span>
				<span class="likeOnlyPoint">${article.extra__likeOnlyPoint}</span>
			</a>
			<a onclick="doDislike('article', '${article.id}');">
				<span><i id="disLike" class="far fa-thumbs-down"></i></span>
				<span>싫어요</span>
				<span class="dislikeOnlyPoint">${article.extra__dislikeOnlyPoint}</span>
			</a>	
			<c:if test="${sessionScope.loginedMemberId eq article.memberId}">
				<a href="modify?id=${article.id}">수정</a>
				<a onclick="if (confirm('정말 삭제 하시겠습니까?') == false){ return false;}"
					href="doDelete?id=${article.id}">삭제</a>
			</c:if>
			<a href="${param.listUrl}">목록</a>
		</div>
	</div>
</div>
<!-- 게시물 상세페이지 끝-->

<!-- 게시물 댓글 시작-->
<div class="title-bar con-min-width">
	<h1 class="con">
		<span>
			<i class="fas fa-newspaper"></i>
		</span>
		<span>댓글작성</span>
	</h1>
</div>
<c:if test="${isLogined == false}">
	<div
		class="article-reply-write-form-box form-box con-min-width">
		<div class="con">
			<a class="udl hover-link" href="../member/login?afterLoginUrl=${encodedCurrentUrl}">로그인</a> 후 이용해주세요.
		</div>
	</div>
</c:if>

<c:if test="${isLogined}">
	<div class="article-reply-write-form-box form-box con-min-width">
		<script>
	let Reply__DoWriteForm__submited = false;
	let Reply__DoWriteForm__checkedLoginId = "";
	
	// 폼 발송전 체크
	function Reply__DoWriteForm__submit(form) {
		if ( Reply__DoWriteForm__submited ) {
			alert('처리중입니다.');
			return;
		}
			
		form.body.value = form.body.value.trim()
		
		if ( form.body.value.length == 0 ) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			
			return;
		}
		
		form.submit();
		Reply__DoWriteForm__submited = true;
	}
	</script>

		<div class="con form-box">
		<form action="../reply/doWrite" method="POST" onsubmit="Reply__DoWriteForm__submit(this); return false;">
			<input type="hidden" name="redirectUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId','[NEW_REPLY_ID]')}" />
			<input type="hidden" name="relTypeCode" value="article" />
			<input type="hidden" name="relId" value="${article.id}" />
			
          <div class="article-reply-write-box__body flex">
		    <textarea name="body"></textarea>
		    <input type="submit" onclick="if ( confirm('작성하시겠습니까?') == false ) { return false; }" value="작성" />
		  </div>
        </form>
      </div>
	</div>
</c:if>
<!-- 게시물 댓글 끝-->

<!-- 게시물 댓글리스트 시작-->
<div class="title-bar con-min-width">
	<h1 class="con">
		<span>
			<i class="fas fa-list"></i>
		</span>
		<span>댓글 리스트</span>
	</h1>
</div>

<div class="reply-list-total-count-box con-min-width">
	<div class="con">
		<div>
			<span>
				<i class="fas fa-clipboard-list"></i>
			</span>
			<span>총 게시물 수 : </span>
			<span class="color-red"> ${replies.size()} </span>
		</div>
	</div>
</div>

<div class="reply-list-box con-min-width">
  <div class="con">
 	 <c:forEach items="${replies}" var="reply">
	    <div class="reply-box" data-id="${reply.id}">
	    	<div class="reply-box-top flex">
		      <div class="reply-name" style="font-weight:bold; margin-right:5px;">${reply.extra__writer}</div>
		      <div class="reply-reg-date">${reply.regDate}</div>
		      <div class="flex-grow-1"></div>
		      <div class="reply-like-box flex">
		        <div class="reply-like">
		          <span><i id="like" class="far fa-thumbs-up"></i></span>
		          <span>${reply.extra__likeOnlyPoint}</span>
		        </div>
		        <div class="reply-dislike">
		          <span><i id="dislike" class="far fa-thumbs-down"></i></span>
		          <span>${reply.extra__dislikeOnlyPoint}</span>
		        </div>
		      </div>
		    </div>
		    
		    <div class="reply-box-body"">
		    ${reply.body}
		    </div>
		    
		    <div class="reply-box-bottom flex"">
		        <a href="#">댓글달기</a>
		        <div class="flex-grow-1"></div>
		        <c:if test="${isLogined}">
		        <a href="../reply/modify?id=${reply.id}&redirectUrl=${encodedCurrentUrl}" style="margin-right:5px;">수정</a>
			    <a onclick="if (confirm('정말 삭제 하시겠습니까?') == false){ return false;}"
							href="../reply/doDelete?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">삭제</a>
			    </c:if>
		    </div>
	    </div>
    </c:forEach>
  </div>
</div>


<!-- 게시물 댓글리스트 끝-->

<%@ include file="../../part/foot.jspf"%>
