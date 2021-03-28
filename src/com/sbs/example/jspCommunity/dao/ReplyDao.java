package com.sbs.example.jspCommunity.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.sbs.example.jspCommunity.dto.Reply;
import com.sbs.example.mysqlutil.MysqlUtil;
import com.sbs.example.mysqlutil.SecSql;

public class ReplyDao {

	public int write(Map<String, Object> args) {
		SecSql sql = new SecSql();
		sql.append("INSERT INTO reply");
		sql.append("SET regDate = NOW()");
		sql.append(", updateDate = NOW()");
		sql.append(", relTypeCode = ?", args.get("relTypeCode"));
		sql.append(", relId = ?", args.get("relId"));
		sql.append(", memberId = ?", args.get("memberId"));
		sql.append(", `body` = ?", args.get("body"));

		return MysqlUtil.insert(sql);
	}

	public List<Reply> getForPrintReplies(String relTypeCode, int relId) {
		List<Reply> replies = new ArrayList<>();

		SecSql sql = new SecSql();
		sql.append("SELECT R.*");
		sql.append(", M.name AS extra__writer");
		sql.append(", IFNULL(SUM(L.point), 0) AS extra__likePoint");
		sql.append(", IFNULL(SUM(IF(L.point > 0, L.point, 0)), 0) AS extra__likeOnlyPoint");
		sql.append(", IFNULL(SUM(IF(L.point < 0, L.point * -1, 0)), 0) extra__dislikeOnlyPoint");
		sql.append("FROM reply AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON L.relTypeCode = 'reply'");
		sql.append("AND R.id = L.relId");
		sql.append("WHERE 1");
		sql.append("AND R.relTypeCode = ?", relTypeCode);
		sql.append("AND R.relId = ?", relId);
		sql.append("GROUP BY R.id");
		sql.append("ORDER BY R.id DESC");

		List<Map<String, Object>> mapList = MysqlUtil.selectRows(sql);

		for (Map<String, Object> map : mapList) {
			replies.add(new Reply(map));
		}

		return replies;
	}

	public Reply getReplyById(int id) {
		SecSql sql = new SecSql();
		sql.append("SELECT *");
		sql.append("FROM reply AS R");
		sql.append("WHERE 1");
		sql.append("AND R.id = ?", id);

		Map<String, Object> map = MysqlUtil.selectRow(sql);

		if (map.isEmpty()) {
			return null;
		}

		return new Reply(map);
	}

	public int delete(int id) {
		SecSql sql = new SecSql();
		sql.append("DELETE FROM reply");
		sql.append("WHERE 1");
		sql.append("AND id = ?", id);

		return MysqlUtil.delete(sql);
	}

	public Reply getForPrintReplyById(int relId) {
		SecSql sql = new SecSql();
		sql.append("SELECT R.*");
		sql.append(", M.name AS extra__writer");
		sql.append(", IFNULL(SUM(L.point), 0) AS extra__likePoint");
		sql.append(", IFNULL(SUM(IF(L.point > 0, L.point, 0)), 0) AS extra__likeOnlyPoint");
		sql.append(", IFNULL(SUM(IF(L.point < 0, L.point * -1, 0)), 0) extra__dislikeOnlyPoint");
		sql.append("FROM reply AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON L.relTypeCode = 'reply'");
		sql.append("AND R.id = L.relId");
		sql.append("WHERE 1");
		sql.append("AND R.id = ?", relId);

		Map<String, Object> replyMap = MysqlUtil.selectRow(sql);

		if (replyMap.isEmpty()) {
			return null;
		}

		return new Reply(replyMap);
	}

	public List<Reply> getForPrintArticleRepliesFrom(int id, int from) {
		List<Reply> replies = new ArrayList<>();

		SecSql sql = new SecSql();
		sql.append("SELECT R.*");
		sql.append(", M.name AS extra__writer");
		sql.append(", IFNULL(SUM(L.point), 0) AS extra__likePoint");
		sql.append(", IFNULL(SUM(IF(L.point > 0, L.point, 0)), 0) AS extra__likeOnlyPoint");
		sql.append(", IFNULL(SUM(IF(L.point < 0, L.point * -1, 0)), 0) extra__dislikeOnlyPoint");
		sql.append("FROM reply AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON L.relTypeCode = 'reply'");
		sql.append("AND R.id = L.relId");
		sql.append("WHERE 1");
		sql.append("AND R.relId = ?", id);
		sql.append("AND R.id >= ?", from);
		sql.append("GROUP BY R.id");
		sql.append("ORDER BY R.id DESC");

		List<Map<String, Object>> mapList = MysqlUtil.selectRows(sql);

		for (Map<String, Object> map : mapList) {
			replies.add(new Reply(map));
		}

		return replies;
	}

	public int modify(Map<String, Object> args) {
		SecSql sql = new SecSql();
		sql.append("UPDATE reply");
		sql.append("SET updateDate = NOW()");

			sql.append(",body = ?", args.get("body"));

		sql.append("WHERE id = ?", args.get("id"));

		return MysqlUtil.update(sql);
	}

}
