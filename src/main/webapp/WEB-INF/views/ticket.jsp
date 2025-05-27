<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="frm" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
	<meta name="userEmail" content="${userEmail}" />
    <title>Ticket</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/createTicket.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


</head>

<body>
	<nav>
	    <div class="nav-title">Ticket Creation Service</div>
	    <div class="nav-logout">
	        <form action="/login?logout='yes'" method="get">
	            <button type="submit" class="logout-button">Logout</button>
	        </form>
	    </div>
	</nav>

	<div class="logout-buttons">
		<h2>Create Ticket</h2>
	      <security:authorize access="hasAuthority('ROLE_USER')">
	          <form id="createTicketForm" enctype="multipart/form-data">
	              <label>Title: </label>
	              <input type="text" id="title" name="title"/><br>

	              <label>Description: </label>
	              <input type="text" id="description" name="description"/><br>

	              <label>Priority: </label>
	              <select id="priority" name="priority">
	                  <option value="LOW">Low</option>
	                  <option value="MEDIUM">Medium</option>
	                  <option value="HIGH">High</option>
	              </select><br>

	              <label>Category: </label>
	              <input type="text" id="category" name="category"/><br>

	              <label>Attachment: </label>
	              <input type="file" id="fileInput" name="files" multiple/><br>
				  
				  <input type="hidden" id="userEmail" value="${userEmail}" />


	              <security:csrfInput/>
	              <button type="submit">Submit</button>
	          </form>

	      </security:authorize>
	  </div>
	  <div class="button-container">
	  	<div class="home-section">
	  	    <form action="/home" method="get">
	  	        <button type="submit" class="big-button">Home</button>
	  	    </form>
	  	</div>
	  </div>

	<script>
		$('#createTicketForm').on('submit', function(e) {
		      e.preventDefault(); 

		      const formData = new FormData();

		      const ticketData = {
		          title: $('#title').val(),
		          description: $('#description').val(),
		          priority: $('#priority').val(), 
		          email: $('#userEmail').val(),
				  category: $('#category').val()
		      };

		     
		      formData.append('ticket', new Blob(
		          [JSON.stringify(ticketData)],
		          { type: 'application/json' }
		      ));

		      
		      const fileInput = $('#fileInput')[0]; 
		      if (fileInput && fileInput.files.length > 0) {
		          for (let i = 0; i < fileInput.files.length; i++) {
		              formData.append('files', fileInput.files[i]); 
		          }
		      }

		      // CSRF token
		      const csrfToken = $('input[name="_csrf"]').val();
		      const csrfHeader = $('meta[name="_csrf_header"]').attr('content') || 'X-CSRF-TOKEN';

		      $.ajax({
		          url: 'http://localhost:8485/tickets/createTicket',
		          method: 'POST',
		          data: formData,
		          processData: false,
		          contentType: false,
		          beforeSend: function(xhr) {
		              xhr.setRequestHeader(csrfHeader, csrfToken);
		          },
		          success: function(response) {
		              alert("Ticket created successfully!");
		              $('#createTicketForm')[0].reset(); // reset form
		          },
		          error: function(xhr, status, error) {
		              alert("Error creating ticket: " + error);
		              console.error(xhr.responseText);
		          }
		      });
		  });
	</script>
</body>
</html>