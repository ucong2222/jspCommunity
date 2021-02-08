<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세 페이지" />
<%@ include file="../../part/head.jspf"%>

<script>
	$(function(){
		if ( param.focusReplyId ) {
			const $target = $('.reply-list-box tr[data-id="' + param.focusReplyId + '"]');
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
			
		const editor = $(form).find('.toast-ui-editor').data('data-toast-editor');
		const body = editor.getMarkdown().trim();
		
		if ( body.length == 0 ) {
			alert('내용을 입력해주세요.');
			editor.focus();
			
			return;
		}
		
		form.body.value = body;
		
		form.submit();
		Reply__DoWriteForm__submited = true;
	}
	</script>

		<div class="con form-box">
		<form action="../reply/doWrite" method="POST" onsubmit="Reply__DoWriteForm__submit(this); return false;">
			<input type="hidden" name="redirectUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId','[NEW_REPLY_ID]')}" />
			<input type="hidden" name="relTypeCode" value="article" />
			<input type="hidden" name="relId" value="${article.id}" />
			<input type="hidden" name="body" />
			
          <div class="article-reply-write-box__body">
            <div>내용</div>
            <script type="text/x-template"></script>
            <div class="toast-ui-editor" data-height="200"></div>
          </div>
          <div>
            <div class="article-reply-write-box__bottom flex flex-jc-e">
              <input type="submit" value="작성" />
              <button type="button" onclick="history.back()">취소</button>
            </div>
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

<div class="reply-list-box response-list-box con-min-width">
	<div class="con">
		<table>
			<colgroup>
				<col width="50">
				<col width="150">
				<col width="100">
				<col width="100">
				<col width="200">
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>작성자</th>
					<th>좋아요</th>
					<th>비고</th>
					<th>내용</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${replies}" var="reply">
					<tr data-id="${reply.id}">
						<td>
							<span class="response-list-box__id">${reply.id}</span>
						</td>
						<td>
							<span class="response-list-box__reg-date">${reply.regDate}</span>
						</td>
						<td>
							<span class="response-list-box__writer">${reply.extra__writer}</span>
						</td>
						<td>
							<span class="response-list-box__likeOnlyPoint">
								<span>
									<i class="far fa-thumbs-up"></i>
								</span>
								<span> ${reply.extra__likeOnlyPoint} </span>
							</span>
							<span class="response-list-box__dislikeOnlyPoint">
								<span>
									<i class="far fa-thumbs-down"></i>
								</span>
								<span> ${reply.extra__dislikeOnlyPoint} </span>
							</span>
						</td>
						<td>
							<div class="btn-wrap">
								<a class="btn btn-info" href="../reply/modify?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">수정</a>
								<a class="btn btn-danger"
									onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
									href="../reply/doDelete?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">삭제</a>
							</div>
						</td>
						<td>
							<script type="text/x-template">${reply.body}</script>
							<div class="toast-ui-viewer"></div>
						</td>
						<td class="visible-md-down">
							<div class="flex">
								<span class="response-list-box__id response-list-box__id--mobile">${reply.id}</span>
							</div>

							<div class="flex">
								<span class="response-list-box__likeOnlyPoint">
									<span>
										<i class="far fa-thumbs-up"></i>
									</span>
									<span> ${reply.extra__likeOnlyPoint} </span>
								</span>
								<span class="response-list-box__dislikeOnlyPoint">
									<span>
										<i class="far fa-thumbs-down"></i>
									</span>
									<span> ${reply.extra__dislikeOnlyPoint} </span>
								</span>
							</div>

							<div class="flex">
								<span
									class="response-list-box__writer response-list-box__writer--mobile">${reply.extra__writer}</span>
								<span>&nbsp;|&nbsp;</span>
								<span
									class="response-list-box__reg-date response-list-box__reg-date--mobile">${reply.regDate}</span>
							</div>

							<div>
								<script type="text/x-template">${reply.body}</script>
								<div class="toast-ui-viewer"></div>
							</div>
							<div class="btn-wrap">
								<a class="btn btn-info" href="../reply/modify?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">수정</a>
								<a class="btn btn-danger"
									onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
									href="../reply/doDelete?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">삭제</a>
							</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>


<!-- 게시물 댓글리스트 끝-->

<%@ include file="../../part/foot.jspf"%>
