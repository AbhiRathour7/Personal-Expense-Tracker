package com.dao;

import com.bean.ExpenseBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExpenseDao {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/expense_tracker";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "****";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
    }

    public void addExpense(ExpenseBean expense) throws SQLException {
        String sql = "INSERT INTO expenses(username, amount, category, expense_date, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, expense.getUsername());
            pst.setDouble(2, expense.getAmount());
            pst.setString(3, expense.getCategory());
            pst.setDate(4, new java.sql.Date(expense.getExpenseDate().getTime()));
            pst.setString(5, expense.getDescription());
            pst.executeUpdate();
        }
    }

    public List<ExpenseBean> getExpensesByUsername(String username) throws SQLException {
        List<ExpenseBean> expenses = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE username = ?";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, username);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    ExpenseBean expense = new ExpenseBean();
                    expense.setId(rs.getInt("id"));
                    expense.setUsername(rs.getString("username"));
                    expense.setAmount(rs.getDouble("amount"));
                    expense.setCategory(rs.getString("category"));
                    expense.setExpenseDate(rs.getDate("expense_date"));
                    expense.setDescription(rs.getString("description"));
                    expenses.add(expense);
                }
            }
        }
        return expenses;
    }

    public void deleteExpenseById(int expenseId) throws SQLException {
        String sql = "DELETE FROM expenses WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, expenseId);
            pst.executeUpdate();
        }
    }

    public ExpenseBean getExpenseById(int expenseId) throws SQLException {
        ExpenseBean expense = null;
        String sql = "SELECT * FROM expenses WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, expenseId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    expense = new ExpenseBean();
                    expense.setId(rs.getInt("id"));
                    expense.setUsername(rs.getString("username"));
                    expense.setAmount(rs.getDouble("amount"));
                    expense.setCategory(rs.getString("category"));
                    expense.setExpenseDate(rs.getDate("expense_date"));
                    expense.setDescription(rs.getString("description"));
                }
            }
        }
        return expense;
    }

    public double getTotalExpenseForCurrentMonth(String username) throws SQLException {
        double total = 0;
        String sql = "SELECT SUM(amount) FROM expenses WHERE username = ? AND YEAR(expense_date) = YEAR(CURDATE()) AND MONTH(expense_date) = MONTH(CURDATE())";
        try (Connection con = getConnection(); PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, username);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    total = rs.getDouble(1);
                }
            }
        }
        return total;
    }
}
