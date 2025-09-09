<%@ page import="com.dao.ExpenseDao,com.bean.ExpenseBean" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    
    // If session is invalid or user logged out, redirect to login page
    if (username == null) {
        session.invalidate(); // Optional: explicitly invalidate session here for safety
        response.sendRedirect("index.jsp");
        return;
    }

    String error = null;
    ExpenseDao expenseDao = new ExpenseDao();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                double amount = Double.parseDouble(request.getParameter("amount"));
                String category = request.getParameter("category");
                java.sql.Date expenseDate = java.sql.Date.valueOf(request.getParameter("expense_date"));
                String description = request.getParameter("description");

                ExpenseBean expense = new ExpenseBean(username, amount, category, expenseDate, description);
                expenseDao.addExpense(expense);
            } else if ("delete".equals(action)) {
                int expenseId = Integer.parseInt(request.getParameter("id"));
                expenseDao.deleteExpenseById(expenseId);
            }
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }
    }

    List<ExpenseBean> expenses = expenseDao.getExpensesByUsername(username);
%>


<!DOCTYPE html>
<html>
<head>
    <title>Your Expenses</title>
    <style>
        /* Original Color Palette in CSS Variables */
        :root {
            --bg-color-1: #2a9d8f;
            --bg-color-2: #264653;
            --card-bg-color: #f1faee;
            --text-color-dark: #264653;
            --link-color: #219ebc;
            --link-hover-color: #023047;
            --error-bg: #fb6f6f;
            --table-bg: #e9f5f2;
            --table-header-bg: #219ebc;
            --table-row-hover: #d0ece7;
            --delete-btn-bg: #ff4c4c;
            --delete-btn-hover: #d43232;
            --input-border: #8ecae6;
            --input-focus: #219ebc;
        }
    
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--bg-color-1), var(--bg-color-2));
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: var(--text-color-dark);
            padding: 2rem;
        }

        .container {
            max-width: 900px;
            width: 100%;
            background: rgba(255, 255, 255, 0.2); /* Glass effect background */
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.1);
            color: #fff;
            position: relative;
        }

        .card {
            background: var(--card-bg-color);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            color: var(--text-color-dark);
            margin-bottom: 2rem;
        }

        h2, h3 {
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-align: center;
            letter-spacing: 0.05em;
        }

        h2 {
            color: #fff;
            border-bottom: 2px solid rgba(255, 255, 255, 0.5);
            padding-bottom: 10px;
            display: inline-block;
        }
        
        h3 {
            color: var(--text-color-dark);
        }

        .nav-links {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .nav-links a {
            color: #fff;
            font-weight: 600;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.4);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
            background: rgba(255, 255, 255, 0.1);
        }

        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        .error {
            background: var(--error-bg);
            color: var(--error-text);
            padding: 1rem;
            border-radius: 12px;
            font-weight: 700;
            margin-bottom: 2rem;
            box-shadow: 0 0 12px rgba(251, 111, 111, 0.5);
        }
        
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 1rem;
            margin-top: 1.5rem;
        }
        
        th, td {
            padding: 1rem 1.5rem;
            text-align: left;
            background: var(--table-bg);
            border-radius: 12px;
            font-size: 0.875rem;
        }

        th {
            background: var(--table-header-bg);
            color: #fff;
            font-weight: 600;
        }

        tr:hover td {
            background: var(--table-row-hover);
        }

        td form {
            margin: 0;
        }

        .delete-btn {
            background: var(--delete-btn-bg);
            color: #fff;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
        }

        .delete-btn:hover {
            background: var(--delete-btn-hover);
            transform: scale(0.98);
        }

        form.add-expense {
            display: grid;
            gap: 1.5rem;
        }

        form.add-expense input[type="number"],
        form.add-expense input[type="text"],
        form.add-expense input[type="date"] {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--input-border);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-color-dark);
            box-sizing: border-box;
            background-color: #fff;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        form.add-expense input::placeholder {
            color: #999;
        }

        form.add-expense input:focus {
            border-color: var(--input-focus);
            box-shadow: 0 0 8px rgba(33, 158, 188, 0.4);
            outline: none;
        }
        
        .submit-btn {
            width: 100%;
            background: linear-gradient(135deg, var(--link-color), var(--link-hover-color));
            color: #fff;
            border: none;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.25);
        }

    </style>
</head>
<body>
<div class="container">
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>Your Expenses</h2>
    <div class="card">
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>

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