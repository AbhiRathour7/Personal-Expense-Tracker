<%@ page import="com.dao.UserDao,com.bean.UserBean"%>
<%@ page session="true" %>
<%
    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDao dao = new UserDao();
        UserBean user = null;
        try {
            user = dao.loginUser(username, password); // should return UserBean with id, username, email
        } catch (Exception e) {
            error = "Login failed: " + e.getMessage();
        }

        if (user != null) {
            session.setAttribute("username", user.getUsername());
           // session.setAttribute("userId", user.getId());  // make sure UserBean has getId()
            response.sendRedirect("dashboard.jsp");
            return;
        } else if (error == null) {
            error = "Invalid username or password";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #2a9d8f, #264653); display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; color: #f0f0f0; }
        .login-container { background: #f1faee; width: 370px; padding: 50px 30px; border-radius: 12px; box-shadow: 0 12px 24px rgba(22,160,133,.3); color: #264653; text-align: center; animation: fadeInUp .8s ease forwards; }
        @keyframes fadeInUp { from {opacity:0; transform: translateY(40px);} to {opacity:1; transform: translateY(0);} }
        h2 { font-weight:700; margin-bottom:24px; letter-spacing:.1em; }
        input[type=text], input[type=password]{ width:90%; padding:14px 16px; margin:12px 0 24px; border:2px solid #8ecae6; border-radius:55px; font-size:16px; color:#073b4c; transition: border-color .4s, box-shadow .4s; }
        input[type=text]:focus, input[type=password]:focus { border-color:#219ebc; box-shadow:0 0 8px #219ebcaa; outline:none; }
        input[type=submit]{ width:90%; background:linear-gradient(135deg,#219ebc,#023047); border:none; border-radius:12px; padding:14px 0; font-size:18px; font-weight:700; color:#faf9f9; cursor:pointer; box-shadow:0 5px 10px #1b758aaa; transition: background .3s, transform .2s; }
        input[type=submit]:hover{ background:linear-gradient(135deg,#023047,#219ebc); transform: translateY(-2px); box-shadow:0 8px 15px #1b758acc; }
        p.error{ background:#fb6f6f; color:#fff; padding:12px 15px; border-radius:12px; font-weight:700; margin-bottom:24px; box-shadow:0 0 10px #fb6f6faa; }
        a{ color:#219ebc; font-weight:600; text-decoration:none; transition:color .25s; }
        a:hover{ color:#023047; text-decoration:underline; }
    </style>
</head>
<body>
  <div class="login-container">
    <h2>Login</h2>
    <% if (error != null) { %><p class="error"><%= error %></p><% } %>
    <form method="post" action="index.jsp">
      <input type="text" name="username" placeholder="Username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required />
      <input type="password" name="password" placeholder="Password" required />
      <input type="submit" value="Login" />
    </form>
    <p>Don't have an account? <a href="register.jsp">Register here</a></p>
  </div>
</body>
</html>
