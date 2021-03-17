package com.sbs.example.jspCommunity.dto;

import java.util.Map;

import lombok.Data;

@Data
public class Like {
	private int id;
	private String regDate;
	private String updateDate;
	private String relTypeCode;
	private int relId;
	private int memberId;
	private int point;
	
	public Like(Map<String, Object> map) {
		this.id = (int) map.get("id");
		this.regDate = (String) map.get("regDate");
		this.updateDate = (String) map.get("updateDate");
		this.relTypeCode = (String) map.get("relTypeCode");
		this.relId = (int) map.get("relId");
		this.memberId = (int) map.get("memberId");
		this.point = (int) map.get("point");
	}

}