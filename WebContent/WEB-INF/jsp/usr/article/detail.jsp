<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세 페이지" />
<%@ include file="../../part/head.jspf"%>

<script>
$(function(){
	if ( param.focusReplyId ) {
		const $target = $('.reply-list-box .reply-box[data-article-reply-id="' + param.focusReplyId + '"]');
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
			}else if (data.body.relTypeCode == 'article'){
			$('.likeOnlyPoint').text(data.body.likeOnlyPoint);
			}else if (data.body.relTypeCode == 'reply'){
				$('.reply-likeOnlyPoint-' + data.body.relId ).text(data.body.likeOnlyPoint);
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
			} else if (data.body.relTypeCode == 'article'){
			$('.dislikeOnlyPoint').text(data.body.dislikeOnlyPoint);
			} else if (data.body.relTypeCode == 'reply'){
				$('.reply-dislikeOnlyPoint-' + data.body.relId ).text(data.body.dislikeOnlyPoint);
			}
		},
		'json',
	);
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
		
		data.body.articleReplies = data.body.articleReplies.reverse();
		
		var articleReplies = data.body.articleReplies;
		
		$('.reply-total-cnt').text(data.body.articleReplyCnt);
		
		for (var i = 0; i < articleReplies.length; i++) {
			var articleReply = articleReplies[i];
			ArticleReply__drawReply(articleReply);
			
			ArticleReply__lastLoadedArticleReplyId = articleReply.id;
		}
	},
	'json'
	);
}
	
var ArticleReply__$list;
function ArticleReply__drawReply(articleReply) {
	html = '';
	html = '<div  class="reply-box" data-article-reply-id="' + articleReply.id + '">';
	html += '<div class="reply-box-top flex">';
	html += '<div class="reply-name" style="font-weight: bold; margin-right: 5px;">' + articleReply.extra__writer + '</div>';
	html += '<div class="reply-reg-date">' + articleReply.regDate + '</div>';
	html += '<div class="flex-grow-1"></div>';
	html += '<div class="reply-like-box flex">';
	html +=	'<a onclick="doLike("reply", "'+ articleReply.id+'");">';
	html += '<span style="cursor: pointer;"><i id="like" class="far fa-thumbs-up"></i></span>';
	html += '<span class="reply-likeOnlyPoint-' + articleReply.id+ '">'+ articleReply.extra__likeOnlyPoint+ '</span>';
	html +=	'</a>';
	html += '<a onclick="doDislike("reply", "' + articleReply.id + '");">';
	html += '<span style="cursor: pointer;"><i id="dislike" class="far fa-thumbs-down"></i></span>';
	html += '<span class="reply-dislikeOnlyPoint-' + articleReply.id + '">' + articleReply.extra__dislikeOnlyPoint + '</span>';
	html +=	'</a>';
	html += '</div>';
    html += '</div>';

	html += '<div class="reply-box-body"">' + articleReply.body+ '</div>';

	html += '<div class="reply-box-bottom flex">';
	html += '<a href="#">댓글달기</a>';
	html += '<div class="flex-grow-1"></div>';
	html += '<c:if test="${isLogined}">';
	html += '<a href="#" style="margin-right: 5px;">수정</a>';
	html += '<a onclick="#">삭제</a>';
	html += '</c:if>';
	html += '</div>';
    html += '</div>';
	ArticleReply__$list.prepend(html);
}

$(function() {
	ArticleReply__$list = $('.reply-list-box > div');
	
	setInterval(ArticleReply__loadList, 1000);
});
		
</script>

<!-- 게시물 상세 시작-->
<div class="title-bar con-min-width">
	<h1 class="con">
		<span> <i class="far fa-list-alt"></i>
		</span> <span>공지사항 게시물 상세 페이지</span>
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
