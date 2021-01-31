<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인아이디찾기" />
<%@ include file="../../part/head2.jspf"%>

<!-- js-sha256 암호화 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div>
	<script>
	let DoFindLoginIdForm__submited = false;
	function DoFindLoginIdForm__submit(form) {
		if ( DoFindLoginIdForm__submited ) {
			alert('처리중입니다.');
			return;
		}
	
		form.name.value = form.name.value.trim();
	
		if ( form.name.value.length == 0 ) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			
			return;
		}
		
		form.email.value = form.email.value.trim();
	
		if ( form.email.value.length == 0 ) {
			alert('이메일을 입력해주세요.');
			form.email.focus();
			
			return;
		}
				
		form.submit();
		DoFindLoginIdForm__submited = true;
	}
	</script>
	<div class="con-min-width content">
	  <div class="con flex flex-jc-c find-content">
	   <form action="doFindLoginId" method="POST" onsubmit="DoFindLoginIdForm__submit(this); return false;">
	   <div>
			<div>
				<input name="name" type="text" maxlength="50"
						placeholder="이름을 입력해주세요." />
			</div>
		</div>
		<div>
			<div>
				<input name="email" type="email" maxlength="50"
						placeholder="회원의 이메일을 입력해주세요." />
			</div>
		</div>
	    <div class="find-content__btn-join">
	      <input type="submit" value="아이디찾기" />
	    </div>
	    </form>
	  </div>
	</div>

</div>
<%@ include file="../../part/foot.jspf"%>