<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Record" %>
<%@ page import="dao.RecordDAO" %>
<%!
    private String h(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String firstHeaderValue(String value) {
        if (value == null) {
            return null;
        }
        int commaIndex = value.indexOf(',');
        if (commaIndex >= 0) {
            value = value.substring(0, commaIndex);
        }
        value = value.trim();
        return value.length() == 0 ? null : value;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    response.setCharacterEncoding("UTF-8");

    String contextPath = request.getContextPath();
    String forwardedProto = firstHeaderValue(request.getHeader("X-Forwarded-Proto"));
    String forwardedHost = firstHeaderValue(request.getHeader("X-Forwarded-Host"));
    String appBaseUrl = contextPath;

    if (forwardedHost != null) {
        if (forwardedProto == null) {
            forwardedProto = "https";
        }
        appBaseUrl = forwardedProto + "://" + forwardedHost + contextPath;
    }

    String pageUrl = appBaseUrl + "/dangkymonhoc.jsp";
    String loginUrl = appBaseUrl + "/dangnhap.jsp";
    String indexUrl = appBaseUrl + "/index.jsp";
    String sanphamUrl = appBaseUrl + "/sanpham.jsp";
    String logoutUrl = appBaseUrl + "/logout.jsp";

    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(loginUrl);
        return;
    }

    String message = "";
    String messageClass = "";
    String formAction = "insert";
    String idValue = "";
    String snameValue = "";
    String courseValue = "";
    String feeValue = "0";

    RecordDAO dao = null;
    List<Record> records = new ArrayList<Record>();

    try {
        dao = new RecordDAO();

        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("deleteId") != null) {
            try {
                int deleteId = Integer.parseInt(request.getParameter("deleteId"));
                dao.deleteRecord(deleteId);
                response.sendRedirect(pageUrl);
                return;
            } catch (NumberFormatException e) {
                message = "ID xóa không hợp lệ.";
                messageClass = "error";
            } catch (Exception e) {
                message = "Lỗi khi xóa dữ liệu: " + e.getMessage();
                messageClass = "error";
            }
        }

        if (request.getParameter("editId") != null) {
            try {
                int editId = Integer.parseInt(request.getParameter("editId"));
                Record record = dao.getRecordById(editId);
                if (record != null) {
                    idValue = String.valueOf(record.getId());
                    snameValue = record.getStname();
                    courseValue = record.getCourses();
                    feeValue = String.valueOf(record.getFee());
                    formAction = "update";
                } else {
                    message = "Không tìm thấy bản ghi cần sửa.";
                    messageClass = "error";
                }
            } catch (NumberFormatException e) {
                message = "ID sửa không hợp lệ.";
                messageClass = "error";
            } catch (Exception e) {
                message = "Lỗi khi lấy dữ liệu sửa: " + e.getMessage();
                messageClass = "error";
            }
        }

        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("formAction") != null) {
            String formActionParam = request.getParameter("formAction");
            String sname = request.getParameter("sname");
            String course = request.getParameter("course");
            String feeString = request.getParameter("fee");
            int fee = 0;
            boolean feeValid = true;

            try {
                fee = Integer.parseInt(feeString != null ? feeString.trim() : "0");
                if (fee <= 0) {
                    feeValid = false;
                }
            } catch (NumberFormatException e) {
                feeValid = false;
            }

            if (sname != null && !sname.trim().isEmpty()
                    && course != null && !course.trim().isEmpty()
                    && feeValid) {

                if ("update".equals(formActionParam) && request.getParameter("id") != null
                        && !request.getParameter("id").trim().isEmpty()) {
                    try {
                        int id = Integer.parseInt(request.getParameter("id"));
                        boolean updated = dao.updateRecord(new Record(id, sname.trim(), course.trim(), fee));
                        if (updated) {
                            response.sendRedirect(pageUrl);
                            return;
                        } else {
                            message = "Cập nhật thất bại.";
                            messageClass = "error";
                        }
                    } catch (NumberFormatException e) {
                        message = "ID cập nhật không hợp lệ.";
                        messageClass = "error";
                    } catch (Exception e) {
                        message = "Lỗi khi cập nhật dữ liệu: " + e.getMessage();
                        messageClass = "error";
                    }
                } else {
                    try {
                        int newId = dao.insertRecord(new Record(0, sname.trim(), course.trim(), fee));
                        if (newId > 0) {
                            response.sendRedirect(pageUrl);
                            return;
                        } else {
                            message = "Lưu thất bại. Vui lòng kiểm tra kết nối DB.";
                            messageClass = "error";
                        }
                    } catch (Exception e) {
                        message = "Lỗi khi thêm dữ liệu: " + e.getMessage();
                        messageClass = "error";
                    }
                }

                snameValue = "";
                courseValue = "";
                feeValue = "0";
                idValue = "";
                formAction = "insert";
            } else {
                if (!feeValid) {
                    message = "Fee phải là số nguyên dương.";
                } else {
                    message = "Vui lòng nhập đầy đủ Student name và Course.";
                }
                messageClass = "error";
                snameValue = sname != null ? sname : "";
                courseValue = course != null ? course : "";
                feeValue = feeString != null ? feeString : "0";
                if ("update".equals(formActionParam) && request.getParameter("id") != null) {
                    idValue = request.getParameter("id");
                    formAction = "update";
                }
            }
        }

        try {
            records = dao.getAllRecords();
        } catch (Exception e) {
            message = "Không tải được danh sách đăng ký: " + e.getMessage();
            messageClass = "error";
        }
    } catch (Exception e) {
        message = "Lỗi khởi tạo trang đăng ký môn học: " + e.getMessage();
        messageClass = "error";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký môn học</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<main>
    <div class="container">
        <h1>Đăng ký môn học</h1>
        <p class="subtitle">
            Xin chào <strong><%= h(username) %></strong>, bạn có thể thêm, sửa hoặc xóa thông tin đăng ký môn học tại đây.
        </p>
        <p class="link">
            <a href="<%= h(sanphamUrl) %>">Xem sản phẩm</a>
            ·
            <a href="<%= h(logoutUrl) %>">Đăng xuất</a>
        </p>

        <% if (message != null && !message.trim().isEmpty()) { %>
            <div class="message <%= h(messageClass) %>"><%= h(message) %></div>
        <% } %>

        <hr />

        <div class="panel-secondary">
            <h2><%= "update".equals(formAction) ? "Cập nhật đăng ký môn học" : "Thêm đăng ký môn học" %></h2>
            <p class="subtitle">
                <%= "update".equals(formAction)
                        ? "Bạn đang sửa bản ghi ID " + h(idValue) + ". Kiểm tra lại thông tin rồi bấm Lưu cập nhật."
                        : "Nhập thông tin sinh viên, môn học và học phí để tạo đăng ký mới." %>
            </p>

            <form id="register_form" action="<%= h(pageUrl) %>" method="post" accept-charset="UTF-8">
                <input type="hidden" name="id" value="<%= h(idValue) %>" />
                <input type="hidden" name="formAction" value="<%= h(formAction) %>" />

                <p>
                    <label for="sname"><strong>Student name</strong></label><br />
                    <input id="sname" name="sname" value="<%= h(snameValue) %>" placeholder="Nhập tên sinh viên" size="45" required />
                </p>

                <p>
                    <label for="course"><strong>Course</strong></label><br />
                    <input id="course" name="course" value="<%= h(courseValue) %>" placeholder="Nhập tên môn học" size="45" required />
                </p>

                <p>
                    <label for="fee"><strong>Fee</strong></label><br />
                    <input id="fee" name="fee" type="number" min="1" step="1" value="<%= h(feeValue) %>" placeholder="Nhập học phí" size="45" required />
                </p>

                <p>
                    <button type="submit"><%= "update".equals(formAction) ? "Lưu cập nhật" : "Thêm đăng ký" %></button>
                    <% if ("update".equals(formAction)) { %>
                        <a href="<%= h(pageUrl) %>">Hủy sửa</a>
                    <% } %>
                </p>
            </form>
        </div>

        <hr />

        <div class="panel-secondary">
            <h2>Danh sách đăng ký môn học</h2>
            <p class="subtitle">Tổng số bản ghi: <strong><%= records != null ? records.size() : 0 %></strong></p>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student name</th>
                        <th>Course</th>
                        <th>Fee</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (records != null && !records.isEmpty()) {
                        for (Record r : records) {
                %>
                    <tr>
                        <td><%= r.getId() %></td>
                        <td><%= h(r.getStname()) %></td>
                        <td><%= h(r.getCourses()) %></td>
                        <td><%= r.getFee() %></td>
                        <td>
                            <form action="<%= h(pageUrl) %>" method="get">
                                <input type="hidden" name="editId" value="<%= r.getId() %>" />
                                <button type="submit" title="Sửa" class="icon-button">✏️</button>
                            </form>
                        </td>
                        <td>
                            <form action="<%= h(pageUrl) %>" method="post" onsubmit="return confirmDelete();">
                                <input type="hidden" name="deleteId" value="<%= r.getId() %>" />
                                <button type="submit" title="Xóa" class="icon-button delete-button">✖️</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6">Chưa có dữ liệu đăng ký môn học.</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</main>
<script>
    function confirmDelete() {
        return confirm("Bạn có chắc muốn xóa bản ghi này?");
    }
</script>
</body>
</html>
