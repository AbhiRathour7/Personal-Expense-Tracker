package com.dao;

import com.bean.UserBean;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DAO class for User management.
 */
public class UserDao {

    private static String JDBC_URL;
    private static String JDBC_USERNAME;
    private static String JDBC_PASSWORD;

    static {
        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Load DB credentials from config.properties
            Properties props = new Properties();
            FileInputStream fis = new FileInputStream("config.properties"); // file in project root
            props.load(fis);

            JDBC_URL = props.getProperty("DB_URL");
            JDBC_USERNAME = props.getProperty("DB_USER");
            JDBC_PASSWORD = props.getProperty("DB_PASS");

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            System.err.println("⚠️ Could not load config.properties. Please make sure it exists.");
            e.printStackTrace();
        }
    }

    public UserDao() {}

    /**
     * Returns a new database connection.
     */
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
    }

    /**
     * Registers a new user if the username and email are not already taken.
     */
    public boolean registerUser(UserBean user) throws SQLException {
        String checkSql = "SELECT username FROM users WHERE username = ? OR email = ?";
        String insertSql = "INSERT INTO users(username, password, email) VALUES (?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement checkStmt = con.prepareStatement(checkSql)) {

            checkStmt.setString(1, user.getUsername());
            checkStmt.setString(2, user.getEmail());

            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // User or email already exists
                    return false;
                }
            }

            try (PreparedStatement insertStmt = con.prepareStatement(insertSql)) {
                insertStmt.setString(1, user.getUsername());
                insertStmt.setString(2, user.getPassword());
                insertStmt.setString(3, user.getEmail());
                insertStmt.executeUpdate();
                return true;
            }
        }
    }

    /**
     * Attempts user login and returns UserBean if successful, otherwise null.
     */
    public UserBean loginUser(String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection con = getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, username);
            pst.setString(2, password);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    UserBean user = new UserBean();
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    // For security, avoid returning password
                    return user;
                }
            }
        }
        return null;
    }

    /**
     * Deletes a user by username.
     */
    public void deleteUserByUsername(String username) throws SQLException {
        String sql = "DELETE FROM users WHERE username = ?";

        try (Connection con = getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, username);
            pst.executeUpdate();
        }
    }
}
