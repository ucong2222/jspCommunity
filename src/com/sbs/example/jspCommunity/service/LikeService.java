package com.sbs.example.jspCommunity.service;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dao.LikeDao;
import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.dto.Member;

public class LikeService {
	private LikeDao likeDao;

	public LikeService() {
		likeDao = Container.LikeDao;
	}

	public boolean actorCanLike(Article article, Member actor) {
		return likeDao.getPoint("article", article.getId(), actor.getId()) == 0;
	}

	public boolean actorCanCancleLike(Article article, Member actor) {
		return likeDao.getPoint("article", article.getId(), actor.getId()) > 0;
	}

	public boolean actorCanDislike(Article article, Member actor) {
		return likeDao.getPoint("article", article.getId(), actor.getId()) == 0;
	}

	public boolean actorCanCancleDislike(Article article, Member actor) {
		return likeDao.getPoint("article", article.getId(), actor.getId()) < 0;
	}

}
