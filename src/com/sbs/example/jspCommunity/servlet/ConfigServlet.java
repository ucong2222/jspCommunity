package com.sbs.example.jspCommunity.servlet;

import java.io.InputStream;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.service.EmailService;
import com.sbs.example.util.Util;

// META-INF/config.json 파일에 메일발송관련 계정정보를 넣고, 설정용 서블릿에서 읽도록 처리

// load-on-startup : 서블릿은 브라우저에서 최초 요청시 init() 메서드를 실행한 후 메모리에 로드되어 기능 수행.
// 최초요청에 대해서는 실행 시간이 길어질수 밖에 없는 단점을 보완하기 위해 이용하는 기능. 구현방법으로 @WebServlet 사용
@WebServlet(name = "loadAppConfig", urlPatterns = { "/loadConfig" }, loadOnStartup = 1)
public class ConfigServlet extends HttpServlet {
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);

		// 웹의 루트 경로
		// 서버의 자원을 읽어오는 예제
		ServletContext context = getServletContext();
		InputStream inStream = context.getResourceAsStream("/META-INF/config.json");
		Map<String, Object> configMap = Util.getJsonMapFromFile(inStream);

		String gmailId = (String) configMap.get("gmailId");
		String gmailPw = (String) configMap.get("gmailPw");

		EmailService emailService = Container.emailService;
		emailService.init(gmailId, gmailPw, "jspCommunity", "jspCommunity");
		
		//emailService.send("dbrudrjf21@gmail.com","메일 테스트입니다.","내용입니다.");
	}

}
