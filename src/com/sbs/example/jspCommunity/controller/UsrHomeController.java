package com.sbs.example.jspCommunity.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.service.ArticleService;

public class UsrHomeController extends Controller {
	private ArticleService articleService;

	public UsrHomeController() {
		articleService = Container.articleService;
	}
	
	public String showMain(HttpServletRequest req, HttpServletResponse resp) {
		
		List<Article> freeTalkArticles = articleService.getArticlesTitleByBoardId(1);
		List<Article> galleryArticles = articleService.getArticlesTitleByBoardId(2);
		List<Article> infoShareArticles = articleService.getArticlesTitleByBoardId(3);

		/*
		 * Container.attrService.setValue("member__1__extra__isUsingTempPassword", "18",
		 * null); Container.attrService.remove("member__1__extra__isUsingTempPassword");
		 * String value =
		 * Container.attrService.getValue("member__1__extra__isUsingTempPassword");
		 * 
		 * req.setAttribute("data", value);
		 * 
		 * return "common/pure";
		 */

		req.setAttribute("freeTalkArticles", freeTalkArticles);
		req.setAttribute("galleryArticles", galleryArticles);
		req.setAttribute("infoShareArticles", infoShareArticles);
		
		return "usr/home/main";
	}
}
