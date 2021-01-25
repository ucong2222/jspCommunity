<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인비밀번호찾기" />
<%@ include file="../../part/head.jspf"%>
<h1>${pageTitle}</h1>

<!-- js-sha256 암호화 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div>
	<script>
	let DoFindLoginPwForm__submited = false;
	function DoFindLoginPwForm__submit(form) {
		if ( DoFindLoginPwForm__submited ) {
			alert('처리중입니다.');
			return;
		}
	
		form.loginId.value = form.loginId.value.trim();
	
		if ( form.loginId.value.length == 0 ) {
			alert('로그인아이디를 입력해주세요.');
			form.loginId.focus();
			
			return;
		}
		
		form.email.value = form.email.value.trim();
	
		if ( form.email.value.length == 0 ) {
			alert('이메일을 입력해주세요.');
			form.email.focus();
			
			return;
		}
				
		form.submit();
		DoFindLoginPwForm__submited = true;
	}
	</script>
	<form action="doFindLoginPw" method="POST" onsubmit="DoFindLoginPwForm__submit(this); return false;">
		<hr />
		<div>
			<div>로그인아이디</div>
			<div>
				<input name="loginId" type="text" maxlength="50"
					placeholder="로그인아이디를 입력해주세요." />
			</div>
		</div>

		<hr />

		<div>
			<div>이메일</div>
			<div>
				<input name="email" type="email" maxlength="50"
					placeholder="회원의 이메일을 입력해주세요." />
			</div>
		</div>

		<hr />

		<div>
			<div>로그인비밀번호 찾기</div>
			<div>
				<input type="submit" value="로그인비밀번호 찾기" />
				<button type="button" onclick="history.back();">뒤로가기</button>
			</div>
		</div>
	</form>
</div>
<%@ include file="../../part/foot.jspf"%>