<%@ page import="java.sql.*, javax.servlet.http.*" session="true" %>
<%
    // Check session and username
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");

    Connection con = null;
    PreparedStatement pst = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Replace password with your actual DB password
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/expense_tracker", "root", "9835");
        String sql = "DELETE FROM users WHERE username = ?";
        pst = con.prepareStatement(sql);
        pst.setString(1, username);
        int result = pst.executeUpdate();

        if (result > 0) {
            // Delete successful - invalidate session and redirect to login
            session.invalidate();
            response.sendRedirect("index.jsp");
            return;
        } else {
            out.println("<h3 style='color:red;'>Error: Unable to delete account.</h3>");
        }
    } catch (Exception e) {
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    } finally {
        if (pst != null) try { pst.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
