package com.sbs.example.jspCommunity.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.dto.Reply;
import com.sbs.example.jspCommunity.dto.ResultData;
import com.sbs.example.jspCommunity.service.ArticleService;
import com.sbs.example.jspCommunity.service.ReplyService;
import com.sbs.example.util.Util;

public class UsrReplyController extends Controller {
	private ReplyService replyService;
	private ArticleService articleService;

	public UsrReplyController() {
		replyService = Container.replyService;
		articleService = Container.articleService;
	}

	public String doWrite(HttpServletRequest req, HttpServletResponse resp) {
		String redirectUrl = req.getParameter("redirectUrl");

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		String relTypeCode = req.getParameter("relTypeCode");

		if (relTypeCode == null) {
			return msgAndBack(req, "관련데이터타입코드를 입력해주세요.");
		}

		int relId = Util.getAsInt(req.getParameter("relId"), 0);

		if (relId == 0) {
			return msgAndBack(req, "관련데이터번호를 입력해주세요.");
		}

		if (relTypeCode.equals("article")) {
			Article article = articleService.getArticleById(relId);

			if (article == null) {
				return msgAndBack(req, relId + "번 게시물은 존재하지 않습니다.");
			}
		}

		String body = req.getParameter("body");

		if (Util.isEmpty(body)) {
			return msgAndBack(req, "내용을 입력해주세요.");
		}

		Map<String, Object> writeArgs = new HashMap<>();
		writeArgs.put("memberId", loginedMemberId);
		writeArgs.put("relId", relId);
		writeArgs.put("relTypeCode", relTypeCode);
		writeArgs.put("body", body);

		int newArticleId = replyService.write(writeArgs);

		redirectUrl = redirectUrl.replace("[NEW_REPLY_ID]", newArticleId + "");

		return msgAndReplace(req, newArticleId + "번 댓글이 생성되었습니다.", redirectUrl);
	}

	public String doDelete(HttpServletRequest req, HttpServletResponse resp) {
		String redirectUrl = req.getParameter("redirectUrl");

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		int id = Util.getAsInt(req.getParameter("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "번호를 입력해주세요.");
		}

		Reply reply = replyService.getReplyById(id);

		if (reply == null) {
			return msgAndBack(req, id + "번 댓글은 존재하지 않습니다.");
		}

		if (replyService.actorCanDelete(reply, loginedMemberId) == false) {
			return msgAndBack(req, "삭제권한이 없습니다.");
		}

		replyService.delete(id);

		return msgAndReplace(req, id + "번 댓글이 삭제되었습니다.", redirectUrl);
	}

	public String doModify(HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		return null;
	}

	public String doWriteReplyAjax(HttpServletRequest req, HttpServletResponse resp) {

		String resultCode = null;
		String msg = null;

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		String relTypeCode = req.getParameter("relTypeCode");

		if (relTypeCode == null) {
			return msgAndBack(req, "관련데이터타입코드를 입력해주세요.");
		}

		int relId = Util.getAsInt(req.getParameter("relId"), 0);

		if (relId == 0) {
			resultCode = "F-1";
			msg = "관련데이터번호를 입력해주세요.";
		}

		if (relTypeCode.equals("article")) {
			Article article = articleService.getArticleById(relId);

			if (article == null) {
				resultCode = "F-2";
				msg = "게시물이 존재하지 않습니다.";
			}
		}

		String body = req.getParameter("body");

		if (Util.isEmpty(body)) {
			resultCode = "F-2";
			msg = "내용을 입력해주세요.";
		}

		Map<String, Object> writeArgs = new HashMap<>();
		writeArgs.put("memberId", loginedMemberId);
		writeArgs.put("relId", relId);
		writeArgs.put("relTypeCode", relTypeCode);
		writeArgs.put("body", body);

		int newArticleId = replyService.write(writeArgs);

		resultCode = "S-1";
		msg = "성공";

		return json(req, new ResultData(resultCode, msg, "articleId", newArticleId));
	}

}
