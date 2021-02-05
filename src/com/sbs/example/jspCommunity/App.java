package com.sbs.example.jspCommunity;

public class App {
	public static boolean isProductMode() {
		String profilesActive = System.getProperty("spring.profiles.active");

		if (profilesActive == null) {
			return false;
		}

		if (profilesActive.equals("production") == false) {
			return false;
		}

		return true;
	}

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
