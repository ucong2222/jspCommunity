<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세 페이지" />
<%@ include file="../../part/head.jspf"%>

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
					<span>3</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>좋아요수</span>
					<span>${article.extra__likeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>싫어요수</span>
					<span>${article.extra__dislikeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__comment">
					<span>댓글</span>
					<span>4</span>
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
					<span>3</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>좋아요수</span>
					<span>${article.extra__likeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__recommand">
					<span>싫어요수</span>
					<span>${article.extra__dislikeOnlyPoint}</span>
				</div>
				<div class="article-detail-box__comment">
					<span>댓글</span>
					<span>4</span>
				</div>
			</div>
		</div>

		<div class="article-detail-box__body">
			<script type="text/x-template">${article.body}</script>
			<div class="toast-ui-viewer"></div>
		</div>
		<div class="article-detail-box__bottom flex flex-jc-e">
			<c:if test="${article.extra.actorCanLike}">
				<a
					href="../like/doLike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
					onclick="if (!confirm('`좋아요` 처리 하시겠습니까?')) return false">
					<span>
						<i class="fas fa-thumbs-up"></i>
					</span>
					<span>좋아요</span>
				</a>
			</c:if>
			<c:if test="${article.extra.actorCanCancelLike}">
				<a
					href="../like/doCancelLike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
					onclick="if (!confirm('`좋아요` 취소처리 하시겠습니까?')) return false">
					<span>
						<i class="fas fa-slash"></i>
					</span>
					<span>좋아요 취소</span>
				</a>
			</c:if>
			<c:if test="${article.extra.actorCanDislike}">
				<a
					href="../like/doDislike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
					onclick="if (!confirm('`싫어요` 처리 하시겠습니까?')) return false">
					<span>
						<i class="fas fa-thumbs-down"></i>
					</span>
					<span>싫어요</span>
				</a>
			</c:if>
			<c:if test="${article.extra.actorCanCancelDislike}">
				<a
					href="../like/doCancelDislike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
					onclick="if (!confirm('`싫어요` 취소처리 하시겠습니까?')) return false">
					<span>
						<i class="fas fa-slash"></i>
					</span>
					<span>싫어요 취소</span>
				</a>
			</c:if>
			<c:if test="${sessionScope.loginedMemberId eq article.memberId}">
				<a href="modify?id=${article.id}">수정</a>
				<a onclick="if (confirm('정말 삭제 하시겠습니까?') == false){ return false;}"
					href="doDelete?id=${article.id}">삭제</a>
			</c:if>
			<a href="${param.listUrl}">목록</a>
		</div>
	</div>
</div>
<!-- 게시물 리스트 끝-->

<%@ include file="../../part/foot.jspf"%>
