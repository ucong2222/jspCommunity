package com.sbs.example.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Util {
	public static Map getJsonMapFromFile(InputStream is) {
		ObjectMapper mapper = new ObjectMapper();

		try {
			return mapper.readValue(is, Map.class);
		} catch (IOException e) {
			e.printStackTrace();
		}

		return null;
	}

	public static String getJsonText(Object obj) {
		ObjectMapper mapper = new ObjectMapper();
		String rs = "";
		try {
			rs = mapper.writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		return rs;
	}

	// Gmail SMTP를 이용한 메일 보내기
	public static int send(String smtpServerId, String smtpServerPw, String from, String fromName, String to, String title, String body) {
		
		// Properties 클래스는 시스템의 속성을 객체로 생성하는 클래스
		Properties prop = System.getProperties();
		
		// 로그인 시 TLS를 사용할 것인지 설정
		prop.put("mail.smtp.starttls.enable", "true");
		
		// 이메일 발송을 처리해줄 SMTP 서버
		prop.put("mail.smtp.host", "smtp.gmail.com");
		
		prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		
		// SMTP 서버의 인증을 사용한다는 의미
		prop.put("mail.smtp.auth", "true");
		
		// TLS의 포트번호는 587이며 SSL의 포트번호는 456
		prop.put("mail.smtp.port", "587");

		// MailAuth.java에서 Authenticator를 상속받아 MailAuth 클래스를 받아 세션 생성
		Authenticator auth = new MailAuth(smtpServerId, smtpServerPw);

		Session session = Session.getDefaultInstance(prop, auth);

		// MimeMessage는 Message 클래스를 상속받은 인터넷 메일을 위한 클래스
		// 위에서 생성한 세션을 담아 msg 객체를 생성
		MimeMessage msg = new MimeMessage(session);

		try {
			// 보내는 날짜 지정
			msg.setSentDate(new Date());

			// 발송자를 지정, 발송자의 메일과 발송자명
			msg.setFrom(new InternetAddress(from, fromName));
			
			// 수신자를 설정
			msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
			
			// 메일의 제목 지정
			msg.setSubject(title, "UTF-8");
			
			// 메일의 내용
			msg.setContent(body, "text/html; charset=UTF-8");

			// 메일을 최종적으로 보내는 클래스로 메일을 보내는 부분
			Transport.send(msg);

		} catch (AddressException ae) {
			System.out.println("AddressException : " + ae.getMessage()); // 문자열의 잘못된 주소
			return -1;
		} catch (MessagingException me) {
			System.out.println("MessagingException : " + me.getMessage()); // 메일 계정인증 관련 예외처리
			return -2;
		} catch (UnsupportedEncodingException e) {
			System.out.println("UnsupportedEncodingException : " + e.getMessage()); // 지원되지 않는 인코딩 사용할 경우 예외처리
			return -3;
		}

		return 1;
	}

	public static String getTempPassword(int length) {
		int index = 0;
		char[] charArr = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };

		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < length; i++) {
			index = (int) (charArr.length * Math.random());
			sb.append(charArr[index]);
		}

		return sb.toString();
	}

	public static String sha256(String base) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(base.getBytes("UTF-8"));
			StringBuffer hexString = new StringBuffer();

			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if (hex.length() == 1)
					hexString.append('0');
				hexString.append(hex);
			}

			return hexString.toString();

		} catch (Exception ex) {
			return "";
		}
	}

	public static int getAsInt(Object value, int defaultValue) {
		if (value instanceof Integer) {
			return (int) value;
		} else if (value instanceof Long) {
			return Long.valueOf((long) value).intValue();
		} else if (value instanceof Float) {
			return Float.valueOf((float) value).intValue();
		} else if (value instanceof Double) {
			return Double.valueOf((double) value).intValue();
		} else if (value instanceof String) {
			try {
				return Integer.parseInt((String) value);
			} catch (NumberFormatException e) {
			}
		}

		return defaultValue;
	}

	public static boolean isEmpty(Object obj) {
		if (obj == null) {
			return true;
		}

		if (obj instanceof String) {
			if (((String) obj).trim().length() == 0) {
				return true;
			}
		}
		return false;
	}

	public static String getUrlEncoded(String url) {
		try {
			return URLEncoder.encode(url, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			return url;
		}
	}

	public static String getNowDateStr() {
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String dateStr = format1.format(System.currentTimeMillis());

		return dateStr;
	}

	public static int getPassedSecondsFrom(String from) {
		SimpleDateFormat fDate = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		Date n;
		try {
			n = fDate.parse(from);
		} catch (ParseException e) {
			return -1;
		}

		return (int) ((new Date().getTime() - n.getTime()) / 1000);
	}
	
	public static String getNewUriRemoved(String url, String paramName) {
		String deleteStrStarts = paramName + "=";
		int delStartPos = url.indexOf(deleteStrStarts);

		if (delStartPos != -1) {
			int delEndPos = url.indexOf("&", delStartPos);

			if (delEndPos != -1) {
				delEndPos++;
				url = url.substring(0, delStartPos) + url.substring(delEndPos, url.length());
			} else {
				url = url.substring(0, delStartPos);
			}
		}

		if (url.charAt(url.length() - 1) == '?') {
			url = url.substring(0, url.length() - 1);
		}

		if (url.charAt(url.length() - 1) == '&') {
			url = url.substring(0, url.length() - 1);
		}

		return url;
	}

	public static String getNewUrl(String url, String paramName, String paramValue) {
		url = getNewUriRemoved(url, paramName);

		if (url.contains("?")) {
			url += "&" + paramName + "=" + paramValue;
		} else {
			url += "?" + paramName + "=" + paramValue;
		}

		url = url.replace("?&", "?");

		return url;
	}

	public static String getNewUrlAndEncoded(String url, String paramName, String pramValue) {
		return getUrlEncoded(getNewUrl(url, paramName, pramValue));
	}

	public static Map<String, Object> getParamMap(HttpServletRequest request) {
		Map<String, Object> param = new HashMap<>();

		Enumeration<String> parameterNames = request.getParameterNames();

		while (parameterNames.hasMoreElements()) {
			String paramName = parameterNames.nextElement();
			Object paramValue = request.getParameter(paramName);

			param.put(paramName, paramValue);
		}

		return param;
	}

}
