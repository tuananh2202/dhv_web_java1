<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Record" %>
<%@ page import="dao.RecordDAO" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    response.setCharacterEncoding("UTF-8");
    String message = "";
    String formAction = "action";
    String idValue = "";
    String snameValue = "";
    String courseValue = "";
    String feeValue = "0";

    RecordDAO dao = new RecordDAO();

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("deleteId") != null) {
            try {
            int deleteId = Integer.parseInt(request.getParameter("deleteId"));
            dao.deleteRecord(deleteId);
            out.print("<script>location.href=location.pathname;</script>");
            out.flush();
            return;
        } catch (NumberFormatException ignored) {
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
            }
        } catch (NumberFormatException ignored) {
            message = "ID sửa không hợp lệ.";
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("formAction") != null) {
        String action = request.getParameter("formAction");
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

        if (sname != null && !sname.isBlank() && course != null && !course.isBlank() && feeValid) {
            if ("update".equals(action) && request.getParameter("id") != null) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    boolean updated = dao.updateRecord(new Record(id, sname.trim(), course.trim(), fee));
                    if (updated) {
                        out.print("<script>location.href=location.pathname;</script>");
                        out.flush();
                        return;
                    } else {
                        message = "Cập nhật thất bại.";
                    }
                } catch (NumberFormatException e) {
                    message = "ID cập nhật không hợp lệ.";
                }
                } else {
                int newId = dao.insertRecord(new Record(0, sname.trim(), course.trim(), fee));
                if (newId > 0) {
                    idValue = String.valueOf(newId);
                    formAction = "update";
                    message = "Đã thêm thành công. Bây giờ bạn có thể cập nhật nếu muốn.";
                    messageClass = "success";
                } else {
                    message = "Lưu thất bại. Vui lòng kiểm tra kết nối DB.";
                }
            }
            snameValue = "";
            courseValue = "";
            feeValue = "0";
            idValue = "";
            formAction = "action";
        } else {
            if (!feeValid) {
                message = "Fee phải là số nguyên dương.";
            } else {
                message = "Vui lòng nhập đầy đủ Student name và Course.";
            }
            snameValue = sname != null ? sname : "";
            courseValue = course != null ? course : "";
            feeValue = feeString != null ? feeString : "0";
            if ("update".equals(action) && request.getParameter("id") != null) {
                idValue = request.getParameter("id");
                formAction = "update";
            }
        }
    }

    List<Record> records = dao.getAllRecords();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student register Form</title>
    <style>
        body {
            margin: 0px;
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
        }

        input {
            width: 300px;
            height: 30px;
        }

        label {
            display: block;
        }

        .form_group {
            display: block;
            margin-bottom: 12px;
        }

        .message {
            margin-top: 12px;
            text-align: center;
            color: #006600;
            font-weight: bold;
        }

        .container {
            width: 100%;
            display: flex;
            justify-content: center;
        }

        .panel {
            width: 1000px;
            padding: 20px;
            background-color: #eaf5d7;
            box-sizing: border-box;
        }

        .panel-secondary {
            width: 1000px;
            padding: 20px;
            background-color: #f5f1d7;
            box-sizing: border-box;
            margin-top: 20px;
        }

        .icon-button {
            border: none;
            background: transparent;
            font-size: 1.2rem;
            cursor: pointer;
        }

        input[type="number"] {
            width: 300px;
            height: 30px;
        }

        .delete-button {
            color: #c0392b;
        }

        .icon-button:hover {
            transform: scale(1.1);
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }

        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
    <script>
        function confirmDelete() {
            return confirm("Bạn có chắc muốn xóa bản ghi này?");
        }
    </script>
</head>
<body>
<div class="container">
    <div class="panel">
        <h1>Student Register Form</h1>
        <form id="register_form" method="post" accept-charset="UTF-8">
            <input type="hidden" name="id" value="<%= idValue %>" />
            <input type="hidden" name="formAction" value="<%= formAction %>" />
            <div class="form_group">
                <label for="sname">Student name</label>
                <input id="sname" name="sname" value="<%= snameValue %>" />
            </div>

            <div class="form_group">
                <label for="course">Course</label>
                <input id="course" name="course" value="<%= courseValue %>" />
            </div>

            <div class="form_group">
                <label for="fee">Fee</label>
                <input id="fee" name="fee" type="number" min="1" step="1" value="<%= feeValue %>" />
            </div>

            <div>
                <button type="submit">
                    <%= "update".equals(formAction) ? "Cập nhật" : "Submit" %>
                </button>
            </div>
        </form>
        <% if (!message.isBlank()) { %>
            <div class="message"><%= message %></div>
        <% } %>
    </div>
</div>

<div class="container">
    <div class="panel-secondary">
        <h2>Danh sách đăng ký</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Student name</th>
                <th>Course</th>
                <th>Fee</th>
                <th>Edit</th>
                <th>Delete</th>
            </tr>
            <%
                if (records != null) {
                    for (Record r : records) {
            %>
            <tr>
                <td><%= r.getId() %></td>
                <td><%= r.getStname() %></td>
                <td><%= r.getCourses() %></td>
                <td><%= r.getFee() %></td>
                <td>
                    <form method="get" style="margin:0;">
                        <input type="hidden" name="editId" value="<%= r.getId() %>" />
                        <button type="submit" title="Edit" class="icon-button">✏️</button>
                    </form>
                </td>
                <td>
                    <form method="post" style="margin:0;" onsubmit="return confirmDelete();">
                        <input type="hidden" name="deleteId" value="<%= r.getId() %>" />
                        <button type="submit" title="Delete" class="icon-button delete-button">✖️</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>
</div>
</body>
</html>
