package com.sbs.example.jspCommunity;

public class App {
	public static String getSite() {
		return "Walwal";
	}

	public static String getContextName() {
		return "jspCommunity";
	}

	public static String getLoginUrl() {
		return "http://" + getSiteDomain() + ":" + getSitePort() + "/" + getContextName() + "/usr/member/login";
	}

	public static String getMailUrl() {
		return "http://" + getSiteDomain() + ":" + getSitePort() + "/" + getContextName() + "/usr/home/mail";
	}

	private static int getSitePort() {
		return 8083;
	}

	private static String getSiteDomain() {
		return "localhost";
	}
}
