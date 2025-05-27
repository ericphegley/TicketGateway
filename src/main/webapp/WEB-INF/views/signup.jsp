<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Signup</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css" />
</head>
<body>

	<form id="signupForm" action="createUser" method="post">
		<h2>Create Account</h2>
		<c:if test="${not empty Message}">
		    <p style="color: red;">${Message}</p>
		</c:if>
	    <label>Name: </label>
	    <input type="text" name="name"/><br>
	    <label>Email: </label>
	    <input type="text" name="username"/><br>
	    <label>Password: </label>
	    <input type="password" name="password"/><br>
	    <label>Department: </label>
	    <input type="text" name="department"/><br>
	    <label>Project: </label>
	    <input type="text" name="project"/><br>

	    <input type="submit" value="Create"/>
	    <sec:csrfInput/>
	</form>
	
	<script>
	       $('#signupForm').on('submit', function(e) {
	           // Step 1: grab form values
	           const name = $('input[name="name"]').val();
	           const email = $('input[name="username"]').val();
	           const department = $('input[name="department"]').val();
	           const project = $('input[name="project"]').val();

	           // Step 2: do the normal form submission (User creation)
	           // We don't preventDefault so this proceeds normally

	           // Step 3: call Ticket Microservice via AJAX (Employee creation)
	           $.ajax({
	               url: 'http://localhost:8485/tickets/createEmployee', // <-- Adjust this to your ticket microservice endpoint
	               method: 'POST',
	               contentType: 'application/json',
	               data: JSON.stringify({
	                   name: name,
	                   email: email,
	                   department: department,
	                   project: project
	               }),
	               success: function(response) {
	                   console.log("Employee created in ticket service:", response);
	               },
	               error: function(xhr, status, error) {
	                   console.error("Failed to create Employee in ticket service:", error);
	               }
	           });
	       });
	   </script>
</body>
</html>