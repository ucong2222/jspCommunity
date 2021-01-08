package com.sbs.example.jspCommunity.container;

import com.sbs.example.jspCommunity.dao.ArticleDao;
import com.sbs.example.jspCommunity.dao.MemberDao;
import com.sbs.example.jspCommunity.service.ArticleService;
import com.sbs.example.jspCommunity.service.MemberService;

public class Container {
		public static ArticleService articleService;
		public static ArticleDao articleDao;
		
		public static MemberService memberService;
		public static MemberDao memberDao;

	
	static {
		memberDao = new MemberDao();
		articleDao = new ArticleDao();
				
		memberService = new MemberService();
		articleService = new ArticleService();
	}
}
