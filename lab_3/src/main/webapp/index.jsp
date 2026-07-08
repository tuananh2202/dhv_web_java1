<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    boolean loggedIn = username != null && !username.trim().isEmpty();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Môn Lập Trình Web</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<main>
    <div class="container">
        <h1 style="text-align: center;">Môn Lập Trình Web</h1>
        
            <p class="subtitle">Chào mừng bạn đến với ứng dụng web của Hoàng Tuấn Anh. Vui lòng đăng nhập để tiếp tục.</p>
            <button onclick="location.href='dangnhap.jsp'">Đăng nhập</button>
            <p class="link">Hoặc chưa có tài khoản? <a href="dangky.jsp">Đăng ký</a></p>
       
    </div>
</main>
</body>
</html>
