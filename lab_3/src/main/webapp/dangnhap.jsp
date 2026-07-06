<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>
<%@ page import="context.DBContext" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String message = null;
    String messageClass = "";

    Object attemptsObj = session.getAttribute("loginAttempts");
    Integer loginAttempts = null;
    if (attemptsObj instanceof Integer) {
        loginAttempts = (Integer) attemptsObj;
    }
    if (loginAttempts == null) {
        loginAttempts = 0;
    }
    Long lockUntil = (Long) session.getAttribute("lockUntil");
    long now = new java.util.Date().getTime();

    if (lockUntil != null && now < lockUntil) {
        long remaining = (lockUntil - now) / 1000;
        message = "Bạn đã thử đăng nhập quá 5 lần. Vui lòng đợi " + remaining + " giây.";
        messageClass = "error";
    } else if ("POST".equalsIgnoreCase(request.getMethod())) {
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            message = "Vui lòng nhập Username/Email và Password.";
            messageClass = "error";
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = new DBContext().getConnection();
                String sql = "SELECT id FROM tbl_user WHERE (username = ? OR email = ?) AND password = SHA2(?, 256)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, usernameOrEmail);
                ps.setString(2, usernameOrEmail);
                ps.setString(3, password);
                rs = ps.executeQuery();
                if (rs.next()) {
                    session.setAttribute("loginAttempts", 0);
                    session.removeAttribute("lockUntil");
                    session.setAttribute("username", usernameOrEmail);
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    return;
                } else {
                    loginAttempts++;
                    session.setAttribute("loginAttempts", loginAttempts);
                    if (loginAttempts >= 5) {
                        long blockTime = now + 2 * 60 * 1000;
                        session.setAttribute("lockUntil", blockTime);
                        message = "Sai tài khoản hoặc mật khẩu. Bạn đã bị khoá trong 2 phút.";
                    } else {
                        message = "Sai tài khoản hoặc mật khẩu. Lần thử thứ " + loginAttempts + "/5.";
                    }
                    messageClass = "error";
                }
            } catch (Exception e) {
                message = "Lỗi máy chủ: " + e.getMessage();
                messageClass = "error";
            } finally {
                if (rs != null) {
                    try { rs.close(); } catch (Exception ignore) { }
                }
                if (ps != null) {
                    try { ps.close(); } catch (Exception ignore) { }
                }
                if (conn != null) {
                    try { conn.close(); } catch (Exception ignore) { }
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<main>
    <div class="container">
        <h1>Đăng nhập</h1>
        <p class="subtitle">Nhập Username hoặc Email để đăng nhập vào hệ thống.</p>
        <% if (message != null) { %>
            <div class="message <%= messageClass %>"><%= message %></div>
        <% } %>

        <form action="dangnhap.jsp" method="post">
            <label for="username">Username hoặc Email</label>
            <input type="text" id="username" name="username" required />

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required />

            <button type="submit">Đăng nhập</button>
        </form>

        <p class="link">Chưa có tài khoản? <a href="dangky.jsp">Đăng ký ngay</a></p>
        <div class="note">Lưu ý: Sai quá 5 lần sẽ bị khoá đăng nhập trong 2 phút.</div>
    </div>
</main>
</body>
</html>
