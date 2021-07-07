<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세 페이지" />
<%@ include file="../../part/head.jspf"%>

<c:set var="loginedMemberId" value="${loginedMemberId}" />

<style>
.reply-list-box .loading-delete-inline {
	display:none;
	font-weit:bold;
	color:red;
}
.reply-list-box .permission-mode-block{
	display:none;
}
.reply-list-box .reply-list[data-loading="Y"] .loading-none {
	display:none;
}
.reply-list-box .reply-list[data-loading="Y"][data-loading-delete="Y"] .loading-delete-inline {
	display:inline;
}
.reply-list-box .reply-list[data-modify-mode="Y"] .modify-mode-none {
	display: none;
}

.reply-list-box .reply-list .modify-mode-inline {
	display: none;
}
.reply-list-box .reply-list .modify-mode-block {
	display: none;
}
.reply-list-box .reply-list[data-modify-mode="Y"] .modify-mode-block {
	display: block;
}
.reply-list-box .reply-list[data-modify-mode="Y"] .modify-mode-inline {
	display: inline;
}

.reply-list-box .reply-list[data-permission-mode="Y"] .permission-mode-block {
	display: block;
}

</style>

<script>

var ArticleReply__loadListDelay = 1000;
// 임시
ArticleReply__loadListDelay = 5000;

$(function(){
	if ( param.focusReplyId ) {
		const $target = $('.reply-list-box .reply-list[data-article-reply-id="' + param.focusReplyId + '"]');
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
	$.ajax({
		url : '../like/doLikeAjax', // 요청 url
		type : 'GET', // 데이터 전송 방식
		dataType : "json", // 서버에서 받아올 데이터를 어떤 형태로 해석할 것인가
		data : {"relTypeCode" : relTypeCode, "relId" : id} , // 서버로 전송할 데이터
		success : function(data) { // ajax 통신에 성공했을때 실행되는 이벤트
			if (data.resultCode == 'F-1'){
				alert(data.msg);
			}else if (data.body.relTypeCode == 'article'){
			$('.likeOnlyPoint').text(data.body.likeOnlyPoint);
			}else if (data.body.relTypeCode == 'reply'){
				$('.reply-likeOnlyPoint-' + data.body.relId ).text(data.body.likeOnlyPoint);
			}
		},
	});
	
}

function doDislike(relTypeCode, id){
	if ( ${loginedMemberId} == 0 ){
		alert('로그인 후 이용해주세요.');
		return;
	}
	
	$.ajax({
		url : '../like/doDislikeAjax', // 요청 url
		type : 'GET', // 데이터 전송 방식
		dataType : "json", // 서버에서 받아올 데이터를 어떤 형태로 해석할 것인가
		data : {"relTypeCode" : relTypeCode, "relId" : id} , // 서버로 전송할 데이터
		success : function(data) { // ajax 통신에 성공했을때 실행되는 이벤트
			if (data.resultCode == 'F-1'){
				alert(data.msg);
			} else if (data.body.relTypeCode == 'article'){
			$('.dislikeOnlyPoint').text(data.body.dislikeOnlyPoint);
			} else if (data.body.relTypeCode == 'reply'){
				$('.reply-dislikeOnlyPoint-' + data.body.relId ).text(data.body.dislikeOnlyPoint);
			}
		},
	});
	
}

// 댓글 작성 ajax
function ArticleReply__submitWriteForm(form) {
		form.body.value = form.body.value.trim();
		
		
		if (form.body.value.length == 0) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}
		
		$.post('../reply/doWriteReplyAjax', {
			relTypeCode : form.relTypeCode.value,
			relId : form.relId.value,
			body : form.body.value
		}, function(data) {
			if (data.resultCode.substr(0,2) == 'F-') {
				alert(data.msg);
			}
		},
		'json',
	);
	form.body.value = '';
}

// 댓글리스트 ajax
var ArticleReply__lastLoadedArticleReplyId = 0;

function ArticleReply__loadList() {
	$.get('../reply/getForPrintArticleRepliesRs', {
		id : param.id,
		from : ArticleReply__lastLoadedArticleReplyId + 1
	}, function(data) {
		
		if (data.resultCode.substr(0,2) == 'F-') {
			alert(data.msg);
		}
		
		data.body.articleReplies = data.body.articleReplies.reverse();
		
		var articleReplies = data.body.articleReplies;
		
		$('.reply-total-cnt').text(data.body.articleReplyCnt);
		
		var loginedMemberId = ${loginedMemberId};
		
		for (var i = 0; i < articleReplies.length; i++) {
			var articleReply = articleReplies[i];
			
			
			ArticleReply__drawReply(articleReply);
			
			if (loginedMemberId == articleReply.memberId){
			var $list = $('.reply-list[data-article-reply-id='+ articleReply.id + ']');
				$list.attr('data-permission-mode', 'Y');
			}
			
			ArticleReply__lastLoadedArticleReplyId = articleReply.id;
		}
		
		setTimeout(ArticleReply__loadList, ArticleReply__loadListDelay);
		
	},
	'json'
	);
}
	
var ArticleReply__$list;
function ArticleReply__drawReply(articleReply) {
	var html = $('.template-box-1').html();
	
	html = replaceAll(html, "{$번호}", articleReply.id);
	html = replaceAll(html, "{$날짜}", articleReply.regDate);
	html = replaceAll(html, "{$작성자}", articleReply.extra__writer);
	html = replaceAll(html, "{$내용}", articleReply.body);
	html = replaceAll(html, "{$좋아요}", articleReply.extra__likeOnlyPoint);
	html = replaceAll(html, "{$싫어요}", articleReply.extra__dislikeOnlyPoint);
	
	
	ArticleReply__$list.prepend(html);
}

$(function() {
	ArticleReply__$list = $('.reply-list-box > div');
	
	ArticleReply__loadList();
});


// 댓글삭제 ajax
function ArticleReply__delete(obj) {
	var $clickedBtn = $(obj);
	var $list = $clickedBtn.closest('.reply-list');
	var replyId = parseInt($list.attr('data-article-reply-id'));
	$list.attr('data-loading', 'Y');
	$list.attr('data-loading-delete', 'Y');
	$.post(
		'../reply/doDeleteReplyAjax',
		{
			id: replyId
		},
		function(data) {
			$list.attr('data-loading', 'N');
			$list.attr('data-loading-delete', 'N');
			
			if (data.resultCode.substr(0,2) == 'F-') {
				alert(data.msg);
				return;
			}
			
			$list.remove();
		},
		'json'
	);
}
		

// 댓글 수정
function ArticleReply__enableModifyMode(obj) {
	var $clickedBtn = $(obj);
	var $list = $clickedBtn.closest('.reply-list');
	var replyId = parseInt($list.attr('data-article-reply-id'));
	
	var $replyBodyText = $list.find('.reply-list-body');
	var $textarea = $list.find('form textarea');
	
	$textarea.val($replyBodyText.text().trim());
	$list.attr('data-modify-mode', 'Y');
}

function ArticleReply__disableModifyMode(obj) {
	var $clickedBtn = $(obj);
	var $list = $clickedBtn.closest('.reply-list');
	$list.attr('data-modify-mode', 'N');
}

function ArticleReply__submitModifyReplyForm(form) {
	var $list = $(form).closest('.reply-list');
	form.body.value = form.body.value.trim();
	
	if (form.body.value.length == 0) {
		alert('댓글내용을 입력 해주세요.');
		form.body.focus();
		return false;
	}
	
	var replyId = parseInt($list.attr('data-article-reply-id'));
	var body = form.body.value;
	
	$list.attr('data-loading', 'Y');
	$list.attr('data-loading-modify', 'Y');
	
	$.post('../reply/doModifyReplyAjax', {
		id : replyId,
		body : body
	}, function(data) {
		$list.attr('data-loading', 'N');
		$list.attr('data-loading-modify', 'N');
		ArticleReply__disableModifyMode(form);
		if (data.resultCode.substr(0, 2) == 'S-') {
			var $replyBodyText = $list.find('.reply-list-body');
			var $textarea = $list.find('form textarea');
			$replyBodyText.text($textarea.val());
		} else {
			if (data.msg) {
				alert(data.msg)
			}
		}
	},
	'json'
	);

}
</script>

<!-- 게시물 상세 시작-->
<div class="title-bar con-min-width">
	<h1 class="con">
		<span> <i class="far fa-list-alt"></i>
		</span> <span>${board.name} 게시물 상세 페이지</span>
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
					<span>조회</span> <span>${article.hit}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>좋아요수</span> <span class="likeOnlyPoint">${article.extra__likeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>싫어요수</span> <span class="dislikeOnlyPoint">${article.extra__dislikeOnlyPoint}</span>
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
					<span>조회</span> <span>${article.hit}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>좋아요수</span> <span class="likeOnlyPoint">${article.extra__likeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>싫어요수</span> <span class="dislikeOnlyPoint">${article.extra__dislikeOnlyPoint}</span>
				</div>
			</div>
		</div>

		<div class="article-detail-box__body">
			<script type="text/x-template">${article.body}</script>
			<div class="toast-ui-viewer"></div>
		</div>
		
		<div class="article-detail-box__bottom flex flex-jc-e">
			<a onclick="doLike('article', '${article.id}');"> <span><i
					id="like" class="far fa-thumbs-up"></i></span> <span
				style="cursor: pointer;">좋아요</span> <span class="likeOnlyPoint">${article.extra__likeOnlyPoint}</span>
			</a> <a onclick="doDislike('article', '${article.id}');"> <span><i
					id="disLike" class="far fa-thumbs-down"></i></span> <span
				style="cursor: pointer;">싫어요</span> <span class="dislikeOnlyPoint">${article.extra__dislikeOnlyPoint}</span>
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
		<span> <i class="fas fa-newspaper"></i>
		</span> <span>댓글작성</span>
	</h1>
</div>
<c:if test="${isLogined == false}">
	<div class="article-reply-write-form-box form-box con-min-width">
		<div class="con">
			<a class="udl hover-link"
				href="../member/login?afterLoginUrl=${encodedCurrentUrl}">로그인</a> 후
			이용해주세요.
		</div>
	</div>
</c:if>

<c:if test="${isLogined}">
	<div class="article-reply-write-form-box form-box con-min-width">

		<div class="con form-box">
			<form action=""
				onsubmit="ArticleReply__submitWriteForm(this); return false;">
				<input type="hidden" name="redirectUrl"
					value="${Util.getNewUrl(currentUrl, 'focusReplyId','[NEW_REPLY_ID]')}" />
				<input type="hidden" name="relTypeCode" value="article" /> <input
					type="hidden" name="relId" value="${article.id}" />

				<div class="article-reply-write-box__body flex">
					<textarea name="body"></textarea>
					<input type="submit"
						onclick="if ( confirm('작성하시겠습니까?') == false ) { return false; }"
						value="작성" />
				</div>
			</form>
		</div>
	</div>
</c:if>
<!-- 게시물 댓글 끝-->

<!-- 게시물 댓글리스트 시작-->

<div class="template-box template-box-1">
	<div class="reply-list" data-article-reply-id="{$번호}">
		<div class="reply-list-top flex">
			<div class="reply-name" style="font-weight: bold; margin-right: 5px;">{$작성자}</div>
			<div class="reply-reg-date">{$날짜}</div>
			<div class="flex-grow-1"></div>
			<div class="reply-like-box flex">
				<a onclick="doLike('reply', '{$번호}');">
					<span style="cursor: pointer;"><i id="like" class="far fa-thumbs-up"></i></span>
					<span class="reply-likeOnlyPoint-{$번호}">{$좋아요}</span>
				</a>
				<a onclick="doDislike('reply', '{$번호}');">
					<span style="cursor: pointer;"><i id="dislike" class="far fa-thumbs-down"></i></span>
					<span class="reply-dislikeOnlyPoint-{$번호}">{$싫어요}</span>
				</a>
			</div>
		</div>

		<div class="reply-list-body modify-mode-none">{$내용}</div>
		
		<div class="reply-modify modify-mode-block">
			<form onsubmit="ArticleReply__submitModifyReplyForm(this); return false;">
				<div class="reply-body">
					<textarea name="body">{$내용}</textarea>
				</div>
				<div class="reply-list-bottom flex">
					<div class="flex-grow-1"></div>
					<input class="loading-none" type="submit" value="수정" />
					<a class="loading-none" href="#" onclick="ArticleReply__disableModifyMode(this); return false;" style="margin-left: 5px;">취소</a>
				</div>
			</form>
		</div>

		<div class="reply-list-bottom modify-mode-none flex">
			<a href="#">댓글달기</a>
			<div class="flex-grow-1"></div>
			<c:if test="${isLogined}">
				<div class="permission-mode-block">
				<a class="loading-none modify-mode-none" href="#" onclick="ArticleReply__enableModifyMode(this); return false;" style="margin-right: 5px;">수정</a>
				
				<span class="loading-delete-inline">삭제중입니다...</span>
				<a class="loading-none" onclick="if ( confirm('정말 삭제하시겠습니까?') ) { ArticleReply__delete(this); } return false;" href="#">삭제</a>
				</div>
			</c:if>
		</div>
		
	</div>
</div>

<div class="title-bar con-min-width">
	<h1 class="con">
		<span> <i class="fas fa-list"></i>
		</span> <span>댓글 리스트</span>
	</h1>
</div>

<div class="reply-list-total-count-box con-min-width">
	<div class="con">
		<div>
			<span> <i class="fas fa-clipboard-list"></i></span>
			<span>총 게시물 수 : </span>
			<span></span>
			<span class="reply-total-cnt">${replies.size()} </span>
		</div>
	</div>
</div>

<div class="reply-list-box con-min-width">
	<div class="con">
	<%--
		<c:forEach items="${replies}" var="reply">
			<div class="reply-box" data-id="${reply.id}">
				<div class="reply-box-top flex">
					<div class="reply-name" style="font-weight: bold; margin-right: 5px;">${reply.extra__writer}</div>
					<div class="reply-reg-date">${reply.regDate}</div>
					<div class="flex-grow-1"></div>
					<div class="reply-like-box flex">
						<a onclick="doLike('reply', '${reply.id}');">
							<span style="cursor: pointer;"><i id="like" class="far fa-thumbs-up"></i></span>
							<span class="reply-likeOnlyPoint-${reply.id}">${reply.extra__likeOnlyPoint}</span>
						</a>
						<a onclick="doDislike('reply', '${reply.id}');">
							<span style="cursor: pointer;"><i id="dislike" class="far fa-thumbs-down"></i></span>
							<span class="reply-dislikeOnlyPoint-${reply.id}">${reply.extra__dislikeOnlyPoint}</span>
						</a>
					</div>
				</div>

				<div class="reply-box-body"">${reply.body}</div>

				<div class="reply-box-bottom flex">
					<a href="#">댓글달기</a>
					<div class="flex-grow-1"></div>
					<c:if test="${isLogined}">
						<a
							href="../reply/modify?id=${reply.id}&redirectUrl=${encodedCurrentUrl}"
							style="margin-right: 5px;">수정</a>
						<a
							onclick="if (confirm('정말 삭제 하시겠습니까?') == false){ return false;}"
							href="../reply/doDelete?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">삭제</a>
					</c:if>
				</div>
			</div>
		</c:forEach>
	--%>	
	</div>
</div>


<!-- 게시물 댓글리스트 끝-->

<%@ include file="../../part/foot.jspf"%>
