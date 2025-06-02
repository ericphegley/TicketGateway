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
	    <input type="email" name="username"/><br>
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
	           
	           const name = $('input[name="name"]').val();
	           const email = $('input[name="username"]').val();
	           const department = $('input[name="department"]').val();
			   const password = $('input[name="password"]').val();
	           const project = $('input[name="project"]').val();

			   function isValidEmail(email) {
			     const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			     return regex.test(email);
			   }

			   if (name === '') {
			     alert('Name is required');
			     return;
			   }
			   if (!isValidEmail(email)) {
			     alert('Please enter a valid email address');
			     return;
			   }
			   if (password.length < 6) {
			     alert('Password must be at least 6 characters');
			     return;
			   }
			   if (department === '') {
			     alert('Department is required');
			     return;
			   }
			   if (project === '') {
			     alert('Project is required');
			     return;
			   }
	           $.ajax({
	               url: 'http://localhost:8485/tickets/createEmployee', 
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