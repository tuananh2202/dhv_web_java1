<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="dao.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("dangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<main>
    <div class="container">
        <h1>Danh sách sản phẩm</h1>
        <p class="subtitle">Chào mừng <strong><%= username %></strong>. Bạn đang xem dữ liệu sản phẩm từ cơ sở dữ liệu appdb.</p>
        <p class="link"><a href="dangkymonhoc.jsp">Đăng ký môn học</a> · <a href="logout.jsp">Đăng xuất</a></p>
        <table class="data-table">
            <tr>
                <th>ID</th>
                <th>Tên sản phẩm</th>
                <th>Supplier ID</th>
                <th>Category ID</th>
                <th>Quantity Per Unit</th>
                <th>Unit Price</th>
                <th>Units In Stock</th>
            </tr>

            <%
                ProductDAO dao = new ProductDAO();
                List<Product> list = dao.getAllProducts();

                if (list != null) {
                    for (Product p : list) {
            %>

            <tr>
                <td><%= p.getProductID() %></td>
                <td><%= p.getProductName() %></td>
                <td><%= p.getSupplierID() %></td>
                <td><%= p.getCategoryID() %></td>
                <td><%= p.getQuantityPerUnit() %></td>
                <td><%= p.getUnitPrice() %></td>
                <td><%= p.getUnitsInStock() %></td>
            </tr>

            <%
                    }
                }
            %>
        </table>
    </div>
</main>
</body>
</html>