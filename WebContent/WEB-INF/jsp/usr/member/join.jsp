<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="회원가입" />
<%@ include file="../../part/head2.jspf"%>

<!-- js-sha256 암호화 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div>
	<script>
		let DoJoinForm__submited = false;
		let DoJoinForm__checkedLoginId="";

		// 로그인 아이디 중복체크
		function DoJoinForm__checkLoginIdDup(el){
			const form = $(el).closest('form').get(0);
			const loginId = form.loginId.value;

			$.get(
				"getLoginIdDup",
				{	
					// loginId : loginId
					loginId
				},
				function(data){
					if ( data.msg ){
						alert(data.msg);
					}
					if ( data.success ){
						DoJoinForm__checkedLoginId = data.body.loginId;
					}
				},
				"json"
			);
		}

		// 폼 발송전 체크
		function DoJoinForm__submit(form) {
			if (DoJoinForm__submited) {
				alert('처리중입니다.');
				return;
			}

			form.loginId.value = form.loginId.value.trim();

			if (form.loginId.value.length == 0) {
				alert('로그인 아이디를 입력해주세요.');
				form.loginId.focus();

				return;
			}

			if( form.loginId.value != DoJoinForm__checkedLoginId ){
				alert('로그인 아이디 중복검사를 해주세요.');
				form.btnLoginIdDupCheck.focus();
				return;
			}

			form.loginPw.value = form.loginPw.value.trim();

			if (form.loginPw.value.length == 0) {
				alert('로그인 비밀번호를 입력해주세요.');
				form.loginPw.focus();

				return;
			}

			form.loginPwConfirm.value = form.loginPwConfirm.value.trim();

			if (form.loginPwConfirm.value.length == 0) {
				alert('로그인 비밀번호확인을 입력해주세요.');
				form.loginPwConfirm.focus();

				return;
			}

			if (form.loginPw.value != form.loginPwConfirm.value) {
				alert('로그인 비밀번호가 일치하지 않습니다.');
				form.loginPwConfirm.focus();

				return;
			}

			form.name.value = form.name.value.trim();

			if (form.name.value.length == 0) {
				alert('이름을 입력해주세요.');
				form.name.focus();

				return;
			}
			form.nickname.value = form.nickname.value.trim();

			if (form.nickname.value.length == 0) {
				alert('별명을 입력해주세요.');
				form.nickname.focus();

				return;
			}
			form.email.value = form.email.value.trim();

			if (form.email.value.length == 0) {
				alert('이메일을 입력해주세요.');
				form.email.focus();

				return;
			}

			form.cellphoneNo.value = form.cellphoneNo.value.trim();

			if (form.cellphoneNo.value.length == 0) {
				alert('전화번호를 입력해주세요.');
				form.cellphoneNo.focus();

				return;
			}

			form.loginPwReal.value= sha256(form.loginPw.value);
			form.loginPw.value="";
			form.loginPwConfirm.value="";

			form.submit();
			DoJoinForm__submited=true;
		}
	</script>

	<div class="con-min-width content">
  		<div class="con flex flex-jc-c join-content">
			<form action="doJoin" method="POST" onsubmit="DoJoinForm__submit(this); return false;">
				<input type="hidden" name="loginPwReal" />
				<div>
					<div>로그인 아이디</div>
					<div class="flex flex-jc-sb flex-ai-c">
						<input name="loginId" type="text" maxlength="50"
								placeholder="아이디 입력" />
						<button name="btnLoginIdDupCheck" type="button" onclick="DoJoinForm__checkLoginIdDup(this);">중복체크</button>						
					</div>
				</div>
				<div>
					<div>
						<div>로그인 비밀번호</div>
						<input name="loginPw" type="password" maxlength="50"
							placeholder="비밀번호 입력" />
					</div>
				</div>
				<div>
					<div>
						<div>로그인 비밀번호 확인</div>
						<input name="loginPwConfirm" type="password" maxlength="50"
							placeholder="비밀번호 확인 입력" />
					</div>
				</div>
				<div>
					<div>
						<div>이름</div>
						<input name="name" type="text" maxlength="50"
							placeholder="이름 입력" />
					</div>
				</div>
				<div>
					<div>
						<div>별명</div>
						<input name="nickname" type="text" maxlength="50"
							placeholder="별명 입력" />
					</div>
				</div>
				<div>
					<div>
						<div>이메일</div>
						<input name="email" type="email" maxlength="100"
							placeholder="이메일 입력" />
					</div>
				</div>
				<div>
					<div>
						<div>전화번호</div>
						<input name="cellphoneNo" type="tel" maxlength="100"
							placeholder="전화번호 입력" />
					</div>
				</div>
				<div>
					<div class="join-content__btn-join">
						<input type="submit" value="가입" />
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<%@ include file="../../part/foot.jspf"%>