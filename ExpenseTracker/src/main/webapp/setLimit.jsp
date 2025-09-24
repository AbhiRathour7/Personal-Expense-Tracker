<%@ page import="com.dao.UserDao" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String limitParam = request.getParameter("monthly_limit");
            if(limitParam == null || limitParam.trim().isEmpty()) {
                message = "Please enter a valid monthly limit.";
            } else {
                double limit = Double.parseDouble(limitParam);
                UserDao userDao = new UserDao();
                boolean updated = userDao.updateMonthlyLimit(username, limit);
                message = updated ? "Monthly limit updated successfully." : "Failed to update monthly limit.";
            }
        } catch (NumberFormatException e) {
            message = "Invalid input for monthly limit.";
        } catch (Exception e) {
            message = "Error updating limit: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Set Monthly Limit</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #2a9d8f, #264653);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #264653;
            padding: 2rem;
        }
        .container {
            background: #f1faee;
            padding: 3rem 2rem;
            border-radius: 20px;
            box-shadow: 0 12px 24px rgba(0,0,0,0.2);
            max-width: 500px;
            width: 100%;
            text-align: center;
        }
        h2 {
            margin-bottom: 2rem;
            font-weight: 700;
            color: #264653;
            letter-spacing: 0.05em;
        }
        form input[type="number"] {
            width: 80%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border: 2px solid #8ecae6;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            box-sizing: border-box;
        }
        form input[type="number"]:focus {
            border-color: #219ebc;
            outline: none;
            box-shadow: 0 0 8px rgba(33, 158, 188, 0.4);
        }
        form input[type="submit"] {
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 12px;
            border: none;
            background: linear-gradient(135deg,#219ebc,#023047);
            color: #fff;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        form input[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.25);
        }
        p.message {
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #264653;
        }
        a {
            display: inline-block;
            margin-top: 1rem;
            color: #fff;
            text-decoration: none;
            background: #219ebc;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-weight: 600;
            transition: background 0.3s;
        }
        a:hover {
            background: #023047;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Set Your Monthly Expense Limit</h2>
        <% if (message != null) { %>
            <p class="message"><%= message %></p>
        <% } %>
        <form method="post" action="setLimit.jsp">
            <input type="number" step="0.01" name="monthly_limit" placeholder="Enter monthly limit" required />
            <input type="submit" value="Set Limit" />
        </form>
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
