<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setStatus(302);
    response.setHeader("Location", response.encodeRedirectURL("index.jsp"));
%>