<%@ page import="java.sql.*, javax.servlet.http.*" session="true" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");

    Connection con = null;
    PreparedStatement pst = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/expense_tracker", "root", "9835");
        String sql = "DELETE FROM users WHERE username = ?";
        pst = con.prepareStatement(sql);
        pst.setString(1, username);
        int result = pst.executeUpdate();

        if (result > 0) {
            session.invalidate();
            response.sendRedirect("index.jsp");
            return;
        } else {
            out.println("Error: Unable to delete account.");
        }
    } catch (Exception e) {
        java.io.StringWriter sw = new java.io.StringWriter();
        e.printStackTrace(new java.io.PrintWriter(sw));
        String stackTrace = sw.toString();
        out.println("<pre>" + stackTrace + "</pre>"); // For debugging, remove in production
    } finally {
        if (pst != null) try { pst.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
