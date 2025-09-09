package com.dao;

import com.bean.ExpenseBean;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Expense management.
 */
public class ExpenseDao {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/expense_tracker";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "9835";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }
    }

    public ExpenseDao() {}

    /**
     * Returns a new database connection.
     */
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
    }

    /**
     * Adds a new expense to the database.
     */
    public void addExpense(ExpenseBean expense) throws SQLException {
        String sql = "INSERT INTO expenses(username, amount, category, expense_date, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, expense.getUsername());
            pst.setDouble(2, expense.getAmount());
            pst.setString(3, expense.getCategory());
            pst.setDate(4, new Date(expense.getExpenseDate().getTime()));
            pst.setString(5, expense.getDescription());
            pst.executeUpdate();
        }
    }

    /**
     * Retrieves all expenses for a specific username.
     */
    public List<ExpenseBean> getExpensesByUsername(String username) throws SQLException {
        List<ExpenseBean> expenses = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE username = ?";
        try (Connection con = getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
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

    /**
     * Deletes an expense by its ID.
     */
    public void deleteExpenseById(int expenseId) throws SQLException {
        String sql = "DELETE FROM expenses WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, expenseId);
            pst.executeUpdate();
        }
    }
}
