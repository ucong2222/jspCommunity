package com.sbs.example.mysqlutil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

// SQL 인젝션 방지
// SQL 인젝션 : 악의적인 사용자가 보안상의 취약점을 이용하여, 임의의 SQL 문을 주입하고 실행되게 하여 데이터베이스가 비정상적으로 동작하도록 조작하는 행위
public class SecSql {
	private StringBuilder sqlBuilder;
	private List<Object> datas;

	// SQL 오류시 화면에 출력되던 sql 원문이 안나오던 버그 수정
	@Override
	public String toString() {
		return "rawSql=" + getRawSql() + ", data=" + datas;
	}

	public SecSql() {
		sqlBuilder = new StringBuilder();
		datas = new ArrayList<>();
	}

	public boolean isInsert() {
		return getFormat().startsWith("INSERT");
	}

	public SecSql append(Object... args) {
		if (args.length > 0) {
			String sqlBit = (String) args[0];
			sqlBuilder.append(sqlBit + " ");
		}

		for (int i = 1; i < args.length; i++) {
			datas.add(args[i]);
		}

		return this;
	}

	public PreparedStatement getPreparedStatement(Connection connection) throws SQLException {
		PreparedStatement stmt = null;

		if (isInsert()) {
			stmt = connection.prepareStatement(getFormat(), Statement.RETURN_GENERATED_KEYS);
		} else {
			stmt = connection.prepareStatement(getFormat());
		}

		for (int i = 0; i < datas.size(); i++) {
			Object data = datas.get(i);
			int parameterIndex = i + 1;

			if (data instanceof Integer) {
				stmt.setInt(parameterIndex, (int) data);
			} else if (data instanceof String) {
				stmt.setString(parameterIndex, (String) data);
			}
		}

		if (MysqlUtil.isDevMode()) {
			System.out.println("rawSql : " + getRawSql());
		}

		return stmt;
	}

	public String getFormat() {
		return sqlBuilder.toString().trim();
	}

	public String getRawSql() {
		String rawSql = getFormat();

		for (int i = 0; i < datas.size(); i++) {
			Object data = datas.get(i);

			rawSql = rawSql.replaceFirst("\\?", "'" + data + "'");
		}

		return rawSql;
	}

	public static SecSql from(String sql) {
		return new SecSql().append(sql);
	}
}