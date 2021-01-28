<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인" />
<%@ include file="../../part/head.jspf"%>
<!-- js-sha256 암호화 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div>
	<script>
		let DoLoginForm__submited = false;
		function DoLoginForm__submit(form) {
			if (DoLoginForm__submited) {
				alert('처리중입니다.');
				return;
			}

			form.loginId.value = form.loginId.value.trim();

			if (form.loginId.value.length == 0) {
				alert('로그인 아이디를 입력해주세요.');
				form.loginId.focus();

				return;
			}

			form.loginPw.value = form.loginPw.value.trim();

			if (form.loginPw.value.length == 0) {
				alert('로그인 비밀번호를 입력해주세요.');
				form.loginPw.focus();

				return;
			}

			form.loginPwReal.value= sha256(form.loginPw.value);
			form.loginPw.value="";
			form.loginPwConfirm.value="";

			form.submit();
			DoLoginForm__submited=true;
		}
	</script>
	<header class="con-min-width">
	  <div class="con flex flex-jc-c">
	    <div>
	      <a href="../home/main" class="simple-logo">
	        <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbJFCp5%2FbtqUODbWKTd%2F9sKe9tTCE3taxUxWAcbW11%2Fimg.jpg" alt="">
	      </a>
	    </div>
	  </div>
	</header>
	<div class="con-min-width content">
  		<div class="con flex flex-jc-c login-content">
			<form action="doLogin" method="POST" onsubmit="DoLoginForm__submit(this); return false;">
				<input type="hidden" name="loginPwReal" />
				<div>
					<div>
						<input name="loginId" type="text" maxlength="50"
							placeholder="아이디 입력" />
					</div>
				</div>
				<div>
					<div>
						<input name="loginPw" type="password" maxlength="50"
							placeholder="비밀번호 입력" />
					</div>
				</div>
				<div>
					<div  class="login-content__btn-login">
						<input type="submit" value="로그인" />
					</div>
				</div>
				<div>
			        <div class="login-content__check-auto-login">
			          <input type="checkbox" />
			          <span>자동로그인</span>
			        </div>
			      </div>
			      <div>
			        <div class="login-content__option flex flex-jc-c flex-ai-c">
			          <a href="#">아이디찾기</a>
			          <span class="txt-bar">|</span>
			          <a href="#">비밀번호찾기</a>
			          <span class="txt-bar">|</span>
			          <a href="#">회원가입</a>
			        </div>
			      </div>
			</form>
		</div>
	</div>
</div>
<%@ include file="../../part/foot.jspf"%>