<%@ page import="com.dao.ExpenseDao,com.dao.UserDao,com.bean.ExpenseBean" %>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }

    UserDao userDao = new UserDao();
    ExpenseDao expenseDao = new ExpenseDao();

    double monthlyLimit = userDao.getMonthlyLimitByUsername(username);
    if (monthlyLimit <= 0) {
%>
    <p style="color:red; font-weight:bold; text-align:center; margin:2rem;">
        Please <a href="setLimit.jsp">set your monthly limit</a> before adding expenses.
    </p>
<%
        return;
    }

    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                double amount = Double.parseDouble(request.getParameter("amount"));
                String category = request.getParameter("category");
                java.sql.Date expenseDate = java.sql.Date.valueOf(request.getParameter("expense_date"));
                String description = request.getParameter("description");

                ExpenseBean expense = new ExpenseBean();
                expense.setUsername(username);
                expense.setAmount(amount);
                expense.setCategory(category);
                expense.setExpenseDate(expenseDate);
                expense.setDescription(description);

                expenseDao.addExpense(expense);

                // Redirect after POST to avoid double submission on refresh
                response.sendRedirect("expenses.jsp");
                return;
            } else if ("delete".equals(action)) {
                int expenseId = Integer.parseInt(request.getParameter("id"));
                expenseDao.deleteExpenseById(expenseId);

                // Redirect after delete action as well
                response.sendRedirect("expenses.jsp");
                return;
            }
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }
    }

    double totalExpense = expenseDao.getTotalExpenseForCurrentMonth(username);
    double remainingLimit = monthlyLimit - totalExpense;
    List<ExpenseBean> expenses = expenseDao.getExpensesByUsername(username);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Your Expenses</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg,#2a9d8f,#264653);
            margin:0;
            padding:0;
            display:flex;
            justify-content:center;
            align-items:flex-start;
            min-height:100vh;
        }
        .container {
            background:#f1faee;
            color:#264653;
            width:95%;
            max-width:900px;
            border-radius:16px;
            padding:30px;
            margin:40px 0;
            box-shadow:0 12px 24px rgba(0,0,0,0.2);
        }
        .nav-links {
            display:flex;
            justify-content:center;
            gap:20px;
            margin-bottom:20px;
        }
        .nav-links a {
            text-decoration:none;
            padding:10px 20px;
            background:#219ebc;
            color:#fff;
            border-radius:12px;
            font-weight:600;
            transition:0.3s;
        }
        .nav-links a:hover { background:#023047; }
        h2,h3 { text-align:center; margin-bottom:20px; }
        .error { background:#fb6f6f; color:#fff; padding:10px; border-radius:10px; text-align:center; font-weight:bold; margin-bottom:20px; }
        .warning { background:#ffcc00; color:#264653; padding:12px; border-radius:10px; text-align:center; font-weight:bold; margin-bottom:20px; }
        table { width:100%; border-collapse:collapse; margin-bottom:20px; }
        th,td {
            padding:12px;
            text-align:left;
            border-radius:8px;
            background:#e9f5f2;
        }
        th { background:#219ebc; color:#fff; }
        tr:hover td { background:#d0ece7; }
        .delete-btn {
            background:#ff4c4c;
            color:#fff;
            border:none;
            padding:6px 12px;
            border-radius:8px;
            cursor:pointer;
        }
        .delete-btn:hover { background:#d43232; }
        form.add-expense {
            display:grid;
            gap:12px;
        }
        form.add-expense input[type="number"],
        form.add-expense input[type="text"],
        form.add-expense input[type="date"] {
            width:100%;
            padding:8px;
            border-radius:8px;
            border:1px solid #8ecae6;
        }
        .submit-btn {
            background:#219ebc;
            color:#fff;
            border:none;
            padding:10px;
            border-radius:12px;
            cursor:pointer;
            font-weight:600;
        }
        .submit-btn:hover { background:#023047; }
    </style>
</head>
<body>
<div class="container">

    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>Your Expenses</h2>

    <% if (remainingLimit >= 0) { %>
        <div class="warning">
            Remaining Monthly Limit: Rs. <%= String.format("%.2f", remainingLimit) %>
        </div>
    <% } %>

    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>Amount</th>
                    <th>Category</th>
                    <th>Date</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (ExpenseBean e : expenses) { %>
                    <tr>
                        <td>Rs <%= String.format("%.2f", e.getAmount()) %></td>
                        <td><%= e.getCategory() %></td>
                        <td><%= e.getExpenseDate() %></td>
                        <td><%= e.getDescription() %></td>
                        <td>
                            <form method="post" action="expenses.jsp" onsubmit="return confirm('Delete this expense?');">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= e.getId() %>" />
                                <input type="submit" value="Delete" class="delete-btn" />
                            </form>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="card">
        <h3>Add New Expense</h3>
        <form class="add-expense" method="post" action="expenses.jsp">
            <input type="hidden" name="action" value="add" />
            <input type="number" step="0.01" name="amount" placeholder="Amount" required />
            <input type="text" name="category" placeholder="Category" required />
            <input type="date" name="expense_date" required />
            <input type="text" name="description" placeholder="Description (optional)" />
            <input type="submit" value="Add Expense" class="submit-btn" />
        </form>
    </div>

</div>
</body>
</html>
