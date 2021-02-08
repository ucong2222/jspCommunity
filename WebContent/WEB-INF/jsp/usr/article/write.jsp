<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="${board.name} 게시물 작성"/>
<%@ include file="../../part/head.jspf" %>
	<div>
			<script>
			let DoWriteForm__submited = false;
			let DoWriteForm__checkedLoginId = "";
			
			// 폼 발송전 체크
			function DoWriteForm__submit(form) {
				if ( DoWriteForm__submited ) {
					alert('처리중입니다.');
					return;
				}
			
				form.title.value = form.title.value.trim();
			
				if ( form.title.value.length == 0 ) {
					alert('제목을 입력해주세요.');
					form.title.focus();
					
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
				DoWriteForm__submited = true;
			}
			</script>
			<!-- 게시물 작성 시작-->
    <div class="title-bar con-min-width">
      <h1 class="con">
        <span><i class="fas fa-edit"></i></span>
        <span>글쓰기</span>
      </h1>
    </div>

    <div class="con-min-width article-write-box">
      <div class="con form-box">
		<form action="doWrite" method="POST" onsubmit="DoWriteForm__submit(this); return false;">
			<input type="hidden" name="boardId" value="${board.id}"/>
			<input type="hidden" name="body" />
          <div class="article-write-box__title flex flex-ai-c">
            <div>제목</div>
            <div><input name="title" type="text" maxlength="50" placeholder="제목을 입력해주세요."/></div>
          </div>
          <div class="article-write-box__body">
            <div>내용</div>
            <script type="text/x-template"></script>
            <div class="toast-ui-editor"></div>
          </div>
          <div>
            <div class="article-write-box__bottom flex flex-jc-e">
              <input type="submit" value="작성" />
              <button type="button" onclick="history.back()">취소</button>
            </div>
          </div>
        </form>
      </div>
    </div>
    <!-- 게시물 작성 끝-->
		
	</div>
<%@ include file="../../part/foot.jspf" %>