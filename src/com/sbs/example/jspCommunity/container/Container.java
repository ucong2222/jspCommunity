package com.sbs.example.jspCommunity.container;

import com.sbs.example.jspCommunity.controller.AdmMemberController;
import com.sbs.example.jspCommunity.controller.UsrArticleController;
import com.sbs.example.jspCommunity.controller.UsrHomeController;
import com.sbs.example.jspCommunity.controller.UsrLikeController;
import com.sbs.example.jspCommunity.controller.UsrMemberController;
import com.sbs.example.jspCommunity.dao.ArticleDao;
import com.sbs.example.jspCommunity.dao.AttrDao;
import com.sbs.example.jspCommunity.dao.LikeDao;
import com.sbs.example.jspCommunity.dao.MemberDao;
import com.sbs.example.jspCommunity.service.ArticleService;
import com.sbs.example.jspCommunity.service.AttrService;
import com.sbs.example.jspCommunity.service.EmailService;
import com.sbs.example.jspCommunity.service.LikeService;
import com.sbs.example.jspCommunity.service.MemberService;

public class Container {
	public static LikeDao LikeDao;
	public static AttrDao attrDao;
	public static MemberDao memberDao;
	public static ArticleDao articleDao;

	public static EmailService emailService;
	public static AttrService attrService;
	public static LikeService likeService;
	public static ArticleService articleService;
	public static MemberService memberService;

	public static UsrLikeController usrLikeController;
	public static AdmMemberController admMemberController;
	public static UsrMemberController usrMemberController;
	public static UsrArticleController articleController;
	public static UsrHomeController usrHomeController;

	static {
		attrDao = new AttrDao();
		LikeDao = new LikeDao();
		memberDao = new MemberDao();
		articleDao = new ArticleDao();

		attrService = new AttrService();
		likeService = new LikeService();
		emailService = new EmailService();
		memberService = new MemberService();
		articleService = new ArticleService();

		usrLikeController = new UsrLikeController();
		admMemberController = new AdmMemberController();
		usrMemberController = new UsrMemberController();
		articleController = new UsrArticleController();
		usrHomeController = new UsrHomeController();
	}
}
