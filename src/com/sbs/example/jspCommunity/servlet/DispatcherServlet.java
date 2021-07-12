package com.sbs.example.jspCommunity.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sbs.example.jspCommunity.App;
import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Member;
import com.sbs.example.mysqlutil.MysqlUtil;
import com.sbs.example.util.Util;

// 각 서블릿에 중복되는 코드를 부모클래스인 DispatcherServlet에 몰아두기
// 템플릿 메서드 패턴
public abstract class DispatcherServlet extends HttpServlet {
	
	// html내 form 태그의 method 속성이 get일 경우 호출
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		run(req, resp);
	}

	// html내 form 태그의 method 속성이 post일 경우 호출
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

	public void run(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Map<String, Object> doBeforeActionRs = doBeforeAction(req, resp);

		if (doBeforeActionRs == null) {
			return;
		}

		String jspPath = doAction(req, resp, (String) doBeforeActionRs.get("controllerName"), (String) doBeforeActionRs.get("actionMethodName"));

		if (jspPath == null) {
			resp.getWriter().append("jsp 정보가 없습니다.");
			return;
		}

		doAfterAction(req, resp, jspPath);
	}

	private Map<String, Object> doBeforeAction(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// post 방식으로 보내는 값이 '한글'일 경우 깨지지 않게 전달하기 위해 사용하는 것
		// get 방식으로 보내진 한글은 톰캣이 기본적으로 UTF-8 문자코드가 적용이 되어 있어 자동으로 한글처리
		req.setCharacterEncoding("UTF-8");
		// 브라우저마다 기본적으로 문자코드를 해석하는 defaul가 다르기 때문에 브라우저에게 utf-8을 사용할 것이라는 메세지 전달
		resp.setContentType("text/html; charset=UTF-8");

		String requestUri = req.getRequestURI();
		String[] requestUriBits = requestUri.split("/");

		System.out.println(requestUri);
		
		int minBitsCount = 5;

		if (App.isProductMode()) {
			minBitsCount = 4;
		}

		if (requestUriBits.length < minBitsCount) {
			resp.getWriter().append("올바른 요청이 아닙니다.");
			return null;
		}

		// 운영모드라면 운영DB접속 정보 사용
		if (App.isProductMode()) {
			MysqlUtil.setDBInfo("127.0.0.1", "sbsstLocal", "sbs123414", "jspCommunityReal");
		} else {
			MysqlUtil.setDBInfo("127.0.0.1", "sbsst", "sbs123414", "jspCommunity");
			MysqlUtil.setDevMode(true);
		}

		int controllerTypeNameIndex = 2;
		int controllerNameIndex = 3;
		int actionMethodNameIndex = 4;

		if (App.isProductMode()) {
			controllerTypeNameIndex = 1;
			controllerNameIndex = 2;
			actionMethodNameIndex = 3;
		}

		String controllerTypeName = requestUriBits[controllerTypeNameIndex];
		String controllerName = requestUriBits[controllerNameIndex];
		String actionMethodName = requestUriBits[actionMethodNameIndex];

		String actionUrl = "/" + controllerTypeName + "/" + controllerName + "/" + actionMethodName;

		// 인터셉터위해 로그인 관련 정보를 req에 넣기
		boolean isLogined = false;
		int loginedMemberId = 0;
		Member loginedMember = null;
		Boolean needToChangePw = false;

		HttpSession session = req.getSession();

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
			loginedMember = Container.memberService.getMemberById(loginedMemberId);
			String value = Container.attrService.getValue("member__" + loginedMemberId + "__extra__isUsingTempPassword");
			if (value.equals("1")) {
				needToChangePw = true;
			}
		}

		req.setAttribute("needToChangePw", needToChangePw);
		req.setAttribute("isLogined", isLogined);
		req.setAttribute("loginedMemberId", loginedMemberId);
		req.setAttribute("loginedMember", loginedMember);

		String currentUrl = req.getRequestURI();

		if (req.getQueryString() != null) {
			currentUrl += "?" + req.getQueryString();
		}

		String encodedCurrentUrl = Util.getUrlEncoded(currentUrl);

		req.setAttribute("currentUrl", currentUrl);
		req.setAttribute("encodedCurrentUrl", encodedCurrentUrl);

		Map<String, Object> param = Util.getParamMap(req);
		String paramJson = Util.getJsonText(param);

		req.setAttribute("paramMap", param);
		req.setAttribute("paramJson", paramJson);

		// 데이터 추가 인터셉터 끝

		// 필터링 인터셉터 시작

		// 로그인 필요 필터링 인터셉터 시작
		List<String> needToLoginActionUrls = new ArrayList<>();

		needToLoginActionUrls.add("/usr/member/doLogout");
		needToLoginActionUrls.add("/usr/member/modify");
		needToLoginActionUrls.add("/usr/member/doModify");
		needToLoginActionUrls.add("/usr/article/write");
		needToLoginActionUrls.add("/usr/article/doWrite");
		needToLoginActionUrls.add("/usr/article/modify");
		needToLoginActionUrls.add("/usr/article/doModify");
		needToLoginActionUrls.add("/usr/article/doDelete");

		needToLoginActionUrls.add("/usr/reply/doWrite");
		needToLoginActionUrls.add("/usr/reply/modify");
		needToLoginActionUrls.add("/usr/reply/doModify");
		needToLoginActionUrls.add("/usr/reply/doDelete");
		
		
		if (needToLoginActionUrls.contains(actionUrl)) {
			if ((boolean) req.getAttribute("isLogined") == false) {
				
				req.setAttribute("alertMsg", "로그인 후 이용해주세요.");
				req.setAttribute("replaceUrl", "../member/login?afterLoginUrl=" + encodedCurrentUrl);
				
				// rd라는 객체를 생성해서 forward할 페이지 요청 
				RequestDispatcher rd = req.getRequestDispatcher(getJspDirPath() + "/common/redirect.jsp");
				// 포워드 할 페이지를 부르는 일종의 공식같은 것
				rd.forward(req, resp);
				
			}
		}
		// 로그인 필요 필터링 인터셉터 끝
		
		// 로그인 불필요 필터링 인터셉터 시작
		List<String> needToLogoutActionUrls = new ArrayList<>();

		needToLogoutActionUrls.add("/usr/member/login");
		needToLogoutActionUrls.add("/usr/member/doLogin");
		needToLogoutActionUrls.add("/usr/member/join");
		needToLogoutActionUrls.add("/usr/member/doJoin");
		needToLogoutActionUrls.add("/usr/member/findLoginId");
		needToLogoutActionUrls.add("/usr/member/doFindLoginId");
		needToLogoutActionUrls.add("/usr/member/findLoginPw");
		needToLogoutActionUrls.add("/usr/member/doFindLoginPw");

		if (needToLogoutActionUrls.contains(actionUrl)) {
			if ((boolean) req.getAttribute("isLogined")) {
				req.setAttribute("alertMsg", "로그아웃 후 진행해주세요.");
				req.setAttribute("historyBack", true);

				// rd라는 객체를 생성해서 forward할 페이지 요청 
				RequestDispatcher rd = req.getRequestDispatcher(getJspDirPath() + "/common/redirect.jsp");
				// 포워드 할 페이지를 부르는 일종의 공식같은 것
				rd.forward(req, resp);
			}
		}
		// 로그인 불필요 필터링 인터셉터 끝

		// 필터링 인터셉터 끝

		Map<String, Object> rs = new HashMap<>();
		rs.put("controllerName", controllerName);
		rs.put("actionMethodName", actionMethodName);

		return rs;
	}

	protected abstract String doAction(HttpServletRequest req, HttpServletResponse resp, String controllerName, String actionMethodName);

	private void doAfterAction(HttpServletRequest req, HttpServletResponse resp, String jspPath) throws ServletException, IOException {
		MysqlUtil.closeConnection();

		RequestDispatcher rd = req.getRequestDispatcher(getJspDirPath() + "/" + jspPath + ".jsp");
		rd.forward(req, resp);
	}

	private String getJspDirPath() {
		// WEB-INF파일을 사용해 web에서 바로 jsp 파일에 접근 못하도록 수정
		return "/WEB-INF/jsp";
	}
}
