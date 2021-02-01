package com.sbs.example.jspCommunity.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UsrHomeController extends Controller {
	public String showMain(HttpServletRequest req, HttpServletResponse resp) {

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

		return "usr/home/main";
	}
}
