package com.sbs.example.jspCommunity.service;

import java.util.List;
import java.util.Map;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dao.ArticleDao;
import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.dto.Board;

public class ArticleService {
	private ArticleDao articleDao;

	public ArticleService() {
		articleDao = Container.articleDao;
	}

	public Article getForPrintArticleById(int id) {
		return articleDao.getForPrintArticleById(id);
	}
	
	public Board getBoardById(int id) {
		return articleDao.getBoardById(id);
	}

	public int write(Map<String, Object> args) {
		return articleDao.write(args);
	}

	public int modify(Map<String, Object> args) {
		return articleDao.modify(args);
	}

	public int delete(int id) {
		return articleDao.delete(id);
	}

	public int getArticlesCountByBoardId(int boardId, String searchKeyword, String searchKeywordType) {
		return articleDao.getArticlesCountByBoardId(boardId, searchKeyword, searchKeywordType);
	}

	public List<Article> getForPrintArticlesByBoardId(int boardId, int limitStart, int limitCount, String searchKeyword, String searchKeywordType) {
		return articleDao.getForPrintArticlesByBoardId(boardId, limitStart, limitCount, searchKeyword, searchKeywordType);
	}

	public Article getArticleById(int id) {
		return articleDao.getArticleByid(id);
	}

	public void increaseHit(int id) {
		articleDao.increaseHit(id);
	}

	public List<Article> getArticlesTitleByBoardId(int boardId) {
		List<Article> articles= articleDao.getArticlesTitleByBoardId(boardId);
		
		return articles;
	}

}
