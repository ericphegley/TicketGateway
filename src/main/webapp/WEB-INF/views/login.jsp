<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="frm" %>

<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <title>Login</title>
	    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css" />
	</head>
<body>


	<frm:form action="login" method="post">
		<h2>Login</h2>
		<c:if test="${not empty Message}">
		    <p style="color: red;">${Message}</p>
		</c:if>
		<label>Email: </label>
		<input type="text" name="email"/>
		
		<label>Password: </label>
		<input type="password" name="password"/>
		
		<input type="submit" value="Login"/>
		<sec:csrfInput/>
		
		<a href="/signup">Create Account</a>
	</frm:form>
</body>
</html>