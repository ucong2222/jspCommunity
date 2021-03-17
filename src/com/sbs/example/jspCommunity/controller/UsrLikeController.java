package com.sbs.example.jspCommunity.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.dto.ResultData;
import com.sbs.example.jspCommunity.service.ArticleService;
import com.sbs.example.jspCommunity.service.LikeService;
import com.sbs.example.util.Util;

public class UsrLikeController extends Controller {
	private LikeService likeService;
	private ArticleService articleService;

	public UsrLikeController() {
		likeService = Container.likeService;
		articleService = Container.articleService;
	}
	
	public String doLikeAjax(HttpServletRequest req,  HttpServletResponse resp) {

		String relTypeCode = req.getParameter("relTypeCode");
		
		int relId = Util.getAsInt(req.getParameter("relId"), 0);
		
		int actorId = (int) req.getAttribute("loginedMemberId");
		
		String resultCode = null;
		String msg = null;
		
		Boolean aleadyDoDislike = likeService.aleadyDoDislike(relTypeCode, relId, actorId, -1);
		
		if (aleadyDoDislike == true) {
			resultCode ="F-1";
			msg = "이미 투표하셨습니다.";
		} else {
			
			Boolean aleadyDoLike = likeService.aleadyDoLike(relTypeCode, relId, actorId, 1);
			
			if (aleadyDoLike == false){
				resultCode = "S-1";
				msg= "좋아요 처리";
				likeService.setLikePoint(relTypeCode, relId, actorId, 1, 1);
			} else{
				resultCode = "S-2";
				msg= "좋아요 취소";
				likeService.setLikePoint(relTypeCode, relId, actorId, 1, 0);
			} 
		}
		
		
		
		Article article = articleService.getForPrintArticleById(relId);
		
		int likeOnlyPoint = article.getExtra__likeOnlyPoint();
		
		return json(req, new ResultData(resultCode, msg, "likeOnlyPoint",likeOnlyPoint));
	}

	public String doDislikeAjax(HttpServletRequest req,  HttpServletResponse resp) {

		String relTypeCode = req.getParameter("relTypeCode");
		
		int relId = Util.getAsInt(req.getParameter("relId"), 0);
		
		int actorId = (int) req.getAttribute("loginedMemberId");
		
		String resultCode = null;
		String msg = null;
		
		Boolean aleadyDoLike = likeService.aleadyDoLike(relTypeCode, relId, actorId, 1);
		
		if ( aleadyDoLike == true) {
			resultCode = "F-1";
			msg="이미 투표하셨습니다.";
		} else {			
			Boolean aleadyDoDislike = likeService.aleadyDoDislike(relTypeCode, relId, actorId, -1);
			
			if ( aleadyDoDislike == false ) {
				resultCode = "S-1";
				msg= "싫어요 처리";
				likeService.setLikePoint(relTypeCode, relId, actorId, -1, 1);
			} else {
				resultCode = "S-2";
				msg= "싫어요 취소";
				likeService.setLikePoint(relTypeCode, relId, actorId, -1 ,0);
			}
		}
		
		
		
		Article article = articleService.getForPrintArticleById(relId);
		
		int dislikeOnlyPoint = article.getExtra__dislikeOnlyPoint();
		
		return json(req, new ResultData(resultCode, msg, "dislikeOnlyPoint",dislikeOnlyPoint));
	}

}
