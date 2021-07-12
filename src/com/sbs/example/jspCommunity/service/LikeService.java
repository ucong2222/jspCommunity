package com.sbs.example.jspCommunity.service;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dao.LikeDao;
import com.sbs.example.jspCommunity.dto.Like;

public class LikeService {
	private LikeDao likeDao;

	public LikeService() {
		likeDao = Container.LikeDao;
	}

	public void setLikePoint(String relTypeCode, int relId, int actorId, int point, int set) {
		if (set == 0) {
			likeDao.removePoint(relTypeCode, relId, actorId, point);
		} else {
			likeDao.setPoint(relTypeCode, relId, actorId, point);
		}
	}

	public Boolean alreadyDoLike(String relTypeCode, int relId, int actorId, int point) {
		Like like = likeDao.getLike(relTypeCode, relId, actorId, point);

		if (like != null) {
			return true;
		} else {
			return false;
		}

	}

	public Boolean alreadyDoDislike(String relTypeCode, int relId, int actorId, int point) {
		return alreadyDoLike(relTypeCode, relId, actorId, point);
	}

}
