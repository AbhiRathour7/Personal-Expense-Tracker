<%@ page import="com.dao.UserDao,com.bean.UserBean"%>
<%@ page session="true" %>
<%
    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email    = request.getParameter("email");

        UserDao dao = new UserDao();
        UserBean user = new UserBean();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);

        try {
            boolean registered = dao.registerUser(user); // should enforce unique username & email
            if (registered) {
                response.sendRedirect("index.jsp?message=registered");
                return;
            } else {
                error = "Username or Email already exists";
            }
        } catch (Exception e) {
            error = "Registration failed: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body { font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:linear-gradient(135deg,#2a9d8f,#264653); display:flex; justify-content:center; align-items:center; height:100vh; margin:0; color:#f1faee; }
        .register-container{ background:#f1faee; width:380px; padding:45px 40px; border-radius:16px; box-shadow:0 12px 24px rgba(22,160,133,.3); color:#264653; animation:fadeInUp .9s ease forwards; text-align:center; }
        @keyframes fadeInUp { from {opacity:0; transform:translateY(40px);} to {opacity:1; transform:translateY(0);} }
        h2{ margin-bottom:30px; font-weight:700; letter-spacing:.1em; }
        input[type=text], input[type=email], input[type=password]{ width:90%; padding:14px 12px; margin:12px 0 24px; border:2px solid #8ecae6; border-radius:12px; font-size:16px; color:#073b4c; transition:border-color .4s, box-shadow .4s; }
        input:focus{ border-color:#219ebc; box-shadow:0 0 8px #219ebcaa; outline:none; }
        input[type=submit]{ width:90%; background:linear-gradient(135deg,#219ebc,#023047); border:none; border-radius:12px; padding:14px 0; font-size:18px; font-weight:700; color:#faf9f9; cursor:pointer; box-shadow:0 5px 10px #1b758aaa; transition:background .3s, transform .2s; }
        input[type=submit]:hover{ background:linear-gradient(135deg,#023047,#219ebc); transform:translateY(-2px); box-shadow:0 8px 15px #1b758acc; }
        p.error{ background:#fb6f6f; color:#fff; padding:12px 15px; border-radius:12px; font-weight:700; margin-bottom:24px; box-shadow:0 0 10px #fb6f6faa; }
        a{ color:#219ebc; font-weight:600; text-decoration:none; }
        a:hover{ color:#023047; text-decoration:underline; }
    </style>
</head>
<body>
  <div class="register-container">
    <h2>Register</h2>
    <% if (error != null) { %><p class="error"><%= error %></p><% } %>
    <form method="post" action="register.jsp">
      <input type="text"   name="username" placeholder="Username" required value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" />
      <input type="email"  name="email"    placeholder="Email"    required value="<%= request.getParameter("email")    != null ? request.getParameter("email")    : "" %>" />
      <input type="password" name="password" placeholder="Password" required />
      <input type="submit" value="Register" />
    </form>
    <p>Already registered? <a href="index.jsp">Login here</a></p>
  </div>
</body>
</html>
