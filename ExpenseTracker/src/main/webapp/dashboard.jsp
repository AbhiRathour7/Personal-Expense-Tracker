<%@ page import="com.dao.UserDao,com.dao.ExpenseDao" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    UserDao userDao = new UserDao();
    ExpenseDao expenseDao = new ExpenseDao();

    double monthlyLimit = userDao.getMonthlyLimitByUsername(username);
    double totalExpenses = expenseDao.getTotalExpenseForCurrentMonth(username);
    double remaining = monthlyLimit - totalExpenses;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background:linear-gradient(135deg,#2a9d8f,#264653); 
            color:#f1faee; 
            min-height:100vh; 
            display:flex; 
            justify-content:center; 
            align-items:flex-start; 
            padding:40px 20px; 
            margin:0; 
        }
        .container {
            background:#f1faee; 
            color:#264653; 
            width:100%; 
            max-width:700px; 
            border-radius:16px; 
            box-shadow:0 12px 24px rgba(22,160,133,.3); 
            padding:40px 40px 50px; 
            text-align:center; 
            animation:fadeInZoom .8s ease forwards; 
        }
        @keyframes fadeInZoom { 
            from {opacity:0; transform:scale(.85);} 
            to {opacity:1; transform:scale(1);} 
        }
        h2 { 
            margin-bottom:36px; 
            font-weight:700; 
            letter-spacing:.1em; 
        }
        a, form input[type=submit] { 
            font-weight:700; 
            border-radius:12px; 
            padding:14px 28px; 
            font-size:18px; 
            text-decoration:none; 
            cursor:pointer; 
            margin:10px 15px; 
            transition:background-color .3s, color .3s; 
            display:inline-block; 
        }
        a { 
            background-color:#219ebc; 
            color:#faf9f9; 
            border:none; 
        }
        a:hover { 
            background-color:#023047; 
        }
        form input[type=submit] { 
            background-color:#e63946; 
            color:#faf9f9; 
            border:none; 
        }
        form input[type=submit]:hover { 
            background-color:#9e1c27; 
        }
        p.remaining-limit {
            background-color: #f7c948;
            color: #264653;
            font-weight: bold;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        p{ 
            margin-top:30px; 
            color:#444; 
            font-weight:500; 
            font-size:14px; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= username %>!</h2>

        <% if (remaining <= 1000) { %>
            <p class="remaining-limit">Remaining Monthly Limit: Rs. <%= String.format("%.2f", remaining) %></p>
        <% } %>

        <a href="expenses.jsp">Manage Expenses</a>
        <a href="setLimit.jsp">Set Monthly Limit</a>
        <form action="delete_account.jsp" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete your account?');">
            <input type="submit" value="Delete My Account" />
        </form>
        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>
