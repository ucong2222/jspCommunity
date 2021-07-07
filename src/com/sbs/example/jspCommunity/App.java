package com.sbs.example.jspCommunity;

public class App {
	
	// 운영모드일때 컨텍스트 패스 제거
	// 컨텍스트 패스 : WAS에서 웹어플리케이션을 구분하기 위한 path
	public static boolean isProductMode() {
		// 환경변수 spring.profiles.active의 값을 체크해서 운영모드인지 확인
		String profilesActive = System.getProperty("spring.profiles.active");

		if (profilesActive == null) {
			return false;
		}

		if (profilesActive.equals("production") == false) {
			return false;
		}

		return true;
	}

	// 운영모드 : https://walwal.heycong.com/usr/home/main
	// 개발모드 : http://localhost:8083/jspCommunity/usr/home/main
	
	public static String getSiteName() {
		return "Walwal";
	}

	public static String getMainUrl() {
		return getAppUrl();
	}

	public static String getLoginUrl() {
		return getAppUrl() + "/usr/member/login";
	}

	public static String getAppUrl() {
		String appUrl = getSiteProtocol() + "://" + getSiteDomain();

		if (getSitePort() != 80 && getSitePort() != 443) {
			appUrl += ":" + getSitePort();
		}

		if (getContextName().length() > 0) {
			appUrl += "/" + getContextName();
		}
		
		return appUrl;
	}

	private static String getSiteProtocol() {
		if (isProductMode()) {
			return "https";
		}

		return "http";
	}

	public static String getContextName() {
		if (isProductMode()) {
			return "";
		}
		
		return "jspCommunity";
	}
	
	private static int getSitePort() {
		if (isProductMode()) {
			return 443;
		}
		
		return 8083;
	}

	private static String getSiteDomain() {
		if (isProductMode()) {
			return "walwal.heycong.com";
		}

		return "localhost";
	}
}
