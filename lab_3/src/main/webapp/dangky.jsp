<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>
<%@ page import="context.DBContext" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String checkUsername = request.getParameter("checkUsername");
    if (checkUsername != null) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean exists = false;
        try {
            conn = new DBContext().getConnection("school");
            String query = "SELECT id FROM tbl_user WHERE username = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, checkUsername);
            rs = ps.executeQuery();
            exists = rs.next();
        } catch (Exception ignore) {
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
        response.setContentType("text/plain; charset=UTF-8");
        out.print(exists ? "taken" : "ok");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Đăng ký</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<main>
    <div class="container">
        <h1>Đăng ký tài khoản</h1>
        <p class="subtitle">Tạo tài khoản mới để đăng nhập vào hệ thống.</p>
        <p class="link"><a href="index.jsp">Trang chủ</a></p>
        <%
            String message = null;
            String messageClass = "";

            if ("POST".equalsIgnoreCase(request.getMethod())) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            if (username == null || username.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()
                    || email == null || email.trim().isEmpty()) {
                message = "Vui lòng nhập đầy đủ username, password, confirm password và email.";
                messageClass = "error";
            } else if (!password.equals(confirmPassword)) {
                message = "Password và Confirm Password phải giống nhau.";
                messageClass = "error";
            } else {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = new DBContext().getConnection("school");
                    String checkSql = "SELECT id FROM tbl_user WHERE username = ? OR email = ?";
                    ps = conn.prepareStatement(checkSql);
                    ps.setString(1, username);
                    ps.setString(2, email);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        message = "Username hoặc Email đã tồn tại. Vui lòng chọn tên khác hoặc email khác.";
                        messageClass = "error";
                    } else {
                        if (rs != null) {
                            try { rs.close(); } catch (Exception ignore) { }
                        }
                        if (ps != null) {
                            try { ps.close(); } catch (Exception ignore) { }
                        }

                        String sql = "INSERT INTO tbl_user (username, password, email, address) VALUES (?, SHA2(?, 256), ?, ?)";
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, username);
                        ps.setString(2, password);
                        ps.setString(3, email);
                        ps.setString(4, address == null ? "" : address);
                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            message = "Đăng ký thành công. Bạn có thể đăng nhập ngay.";
                            messageClass = "success";
                        } else {
                            message = "Đăng ký thất bại. Vui lòng thử lại.";
                            messageClass = "error";
                        }
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

    <% if (message != null) { %>
        <div class="message <%= messageClass %>"><%= message %></div>
    <% } %>

    <form action="dangky.jsp" method="post" novalidate>
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required />
        <div id="usernameFeedback" class="message error" style="display:none;"></div>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required />

        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required />
        <div id="confirmPasswordFeedback" class="message error" style="display:none;"></div>

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required />
        <div id="emailFeedback" class="message error" style="display:none;"></div>

        <label for="address">Address</label>
        <input type="text" id="address" name="address" />

        <button type="submit">Đăng ký</button>
    </form>

    <p class="link">Đã có tài khoản? <a href="dangnhap.jsp">Đăng nhập ngay</a></p>
    <script>
        const usernameField = document.getElementById('username');
        const passwordField = document.getElementById('password');
        const confirmField = document.getElementById('confirmPassword');
        const emailField = document.getElementById('email');
        const usernameFeedback = document.getElementById('usernameFeedback');
        const confirmFeedback = document.getElementById('confirmPasswordFeedback');
        const emailFeedback = document.getElementById('emailFeedback');

        function showFeedback(element, text) {
            element.textContent = text;
            element.style.display = text ? 'block' : 'none';
        }

        function validatePasswords() {
            if (passwordField.value && confirmField.value && passwordField.value !== confirmField.value) {
                showFeedback(confirmFeedback, 'Password và Confirm Password phải giống nhau.');
            } else {
                showFeedback(confirmFeedback, '');
            }
        }

        function validateEmail() {
            if (emailField.value && !emailField.validity.valid) {
                showFeedback(emailFeedback, 'Email không đúng định dạng.');
            } else {
                showFeedback(emailFeedback, '');
            }
        }

        usernameField.addEventListener('blur', function () {
            const username = usernameField.value.trim();
            if (!username) {
                showFeedback(usernameFeedback, 'Username không được để trống.');
                return;
            }
            fetch('dangky.jsp?checkUsername=' + encodeURIComponent(username))
                .then(response => response.text())
                .then(text => {
                    if (text === 'taken') {
                        showFeedback(usernameFeedback, 'Username đã tồn tại. Vui lòng chọn username khác.');
                    } else {
                        showFeedback(usernameFeedback, '');
                    }
                })
                .catch(() => showFeedback(usernameFeedback, 'Không thể kiểm tra username ngay bây giờ.'));
        });

        passwordField.addEventListener('input', validatePasswords);
        confirmField.addEventListener('input', validatePasswords);
        emailField.addEventListener('input', validateEmail);
    </script>
    </div>
</main>
</body>
</html>
