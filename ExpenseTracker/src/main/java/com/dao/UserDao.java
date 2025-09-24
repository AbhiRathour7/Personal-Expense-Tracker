package com.dao;

import com.bean.UserBean;
import java.sql.*;

public class UserDao {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/expense_tracker";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "password";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
    }

    public UserBean loginUser(String username, String password) throws SQLException {
        String sql = "SELECT username, password, email, monthly_limit FROM users WHERE username = ? AND password = ?";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, username);
            pst.setString(2, password);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    UserBean user = new UserBean();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setMonthlyLimit(rs.getDouble("monthly_limit"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean updateMonthlyLimit(String username, double limit) throws SQLException {
        String sql = "UPDATE users SET monthly_limit = ? WHERE username = ?";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setDouble(1, limit);
            pst.setString(2, username);
            int rowsUpdated = pst.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    public double getMonthlyLimitByUsername(String username) throws SQLException {
        double monthlyLimit = 0.0;
        String sql = "SELECT monthly_limit FROM users WHERE username = ?";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, username);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    monthlyLimit = rs.getDouble("monthly_limit");
                }
            }
        }
        return monthlyLimit;
    }

    public boolean registerUser(UserBean user) throws SQLException {
        // Check if username or email already exists
        String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        try (Connection con = getConnection(); PreparedStatement pstCheck = con.prepareStatement(checkSql)) {
            pstCheck.setString(1, user.getUsername());
            pstCheck.setString(2, user.getEmail());
            try (ResultSet rs = pstCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Username or email already exists
                    return false;
                }
            }
        }

        // Insert new user
        String insertSql = "INSERT INTO users (username, password, email, monthly_limit) VALUES (?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement pstInsert = con.prepareStatement(insertSql)) {
            pstInsert.setString(1, user.getUsername());
            pstInsert.setString(2, user.getPassword());
            pstInsert.setString(3, user.getEmail());
            pstInsert.setDouble(4, user.getMonthlyLimit());
            int inserted = pstInsert.executeUpdate();
            return inserted > 0;
        }
    }
}
