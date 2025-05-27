<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="frm" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/tickets.css">
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
	<div class="page-container">
		<frm:form id="decisionform" method="post" action="/submitDecisions">
			<!-- Employee Table-->
			<security:authorize access="hasAuthority('ROLE_MANAGER')">
		        <h2>Manage Your Employees' Tickets</h2>
		        <table border="1">
		            <thead>
		                <tr>
		                    <th>Date</th><th>Title</th><th>Created By</th><th>Assignee</th>
		                    <th>Description</th><th>Priority</th><th>Status</th><th>Category</th><th>Files</th><th>History</th><th>Decision</th>
		                </tr>
		            </thead>
		            <tbody id=ticketsBody>
		 				
		            </tbody>
		        </table>
			</security:authorize>
			
		    <!-- One shared submit button -->
		    <button type="submit" id="submitBtn" style="display:none;">Submit All</button>
		</frm:form>
	</div>
	<div class="button-container">
		<div class="home-section">
		    <form action="/home" method="get">
		        <button type="submit" class="big-button">Home</button>
		    </form>
		</div>
	</div>

	
</body>

<script>
	const userEmail = "${userEmail}";
	$(document).ready(function() {
		console.log(userEmail);
	    $.ajax({
	        url: 'http://localhost:8485/tickets/getManagerTickets?email=' + encodeURIComponent(userEmail),  
	        method: 'GET',
	        dataType: 'json',
	        success: function(tickets) {
				tickets.forEach(function(ticket) {
					console.log(ticket)
				    var decisionControls = "";
			        decisionControls += "<label><input type='radio' name='decision_" + ticket.id + "' value='Approve'> Approve</label>";
			        decisionControls += "<label><input type='radio' name='decision_" + ticket.id + "' value='Reject'> Reject</label>";
			        decisionControls += "<button type='button' class='cancel-btn' data-ticket-id='" + ticket.id + "'> Cancel</button>";
					decisionControls += "<br><textarea class='reject-comment' data-ticket-id='" + ticket.id + "' placeholder='Reason for rejection...' style='display:none;'></textarea>";

					var filesColumn = ticket.filePath
					    ? "<button type='button' class='file-download-btn' data-file-path='" + ticket.filePath + "' data-ticket-id='" + ticket.id + "'>Download Files</button>"
					    : "No files";
				    var row = "<tr>" +
				        "<td>" + (ticket.creationDate || '').split('T')[0] + "</td>" +
				        "<td>" + ticket.title + "</td>" +
				        "<td>" + ticket.actionerEmail + "</td>" +
				        "<td>" + ticket.assigneeEmail + "</td>" +
				        "<td>" + ticket.description + "</td>" +
				        "<td>" + ticket.priority + "</td>" +
				        "<td>" + ticket.status + "</td>" +
				        "<td>" + ticket.category + "</td>" +
						"<td>" + filesColumn + "</td>" +
				        "<td>" +
							"<a href='/getTicketHistory?ticketId=" + ticket.id + "'>History</a>" +
				        "</td>" +
				        "<td>" + decisionControls + "</td>" +
				    "</tr>";

				    $('#ticketsBody').append(row);
				});

	           
				$('.cancel-btn').on('click', function () {
				    $(this).parent().find('label input').prop('checked', false);
				    
				    const ticketId = $(this).data('ticket-id');
				    const commentBox = $('textarea.reject-comment[data-ticket-id="' + ticketId + '"]');
				    commentBox.hide().val(''); // hide and clear the comment box

				    const anySelected = $('input[type="radio"]:checked').length > 0;
				    $('#submitBtn').toggle(anySelected);
				});
				
				$(document).on('click', '.file-download-btn', function () {
				    const filePath = $(this).data('file-path');
					const ticketId = $(this).data('ticket-id');
				    $.ajax({
				        url: 'http://localhost:8485/tickets/downloadFiles?filePath=' + encodeURIComponent(filePath),
				        method: 'GET',
				        xhrFields: {
				            responseType: 'blob'  
				        },
				        success: function(blob) {
				            const link = document.createElement('a');
				            link.href = window.URL.createObjectURL(blob);
				            link.download = "ticket_" + ticketId + ".zip"; 
				            link.click();
							link.remove();
				        },
				        error: function(xhr, status, error) {
				            alert("File download failed: " + error);
				        }
				    });
				});
	        },
	        error: function(xhr, status, error) {
	            alert('Failed to load tickets: ' + error);
	        }
	    });

	    // Radio button change event for dynamically added inputs
		$(document).on('change', 'input[type="radio"]', function () {
		    const name = $(this).attr('name'); 5
		    const ticketId = name.split('_')[1];
		    const value = $(this).val();

		    const commentBox = $('textarea.reject-comment[data-ticket-id="' + ticketId + '"]');

		    if (value === 'Reject') {
		        commentBox.show();
		    } else {
		        commentBox.hide().val(''); // hide and clear
		    }

		    const anySelected = $('input[type="radio"]:checked').length > 0;
		    $('#submitBtn').toggle(anySelected);
		});
		
		$('#decisionform').on('submit', function(e) {
			e.preventDefault(); // prevent default form submission

			let decisions = [];

			$('input[type="radio"]:checked').each(function() {
				let ticketId = $(this).attr('name').split('_')[1];
				let decision = $(this).val();
				let comment = $('textarea.reject-comment[data-ticket-id="' + ticketId + '"]').val();
				decisions.push({ id: ticketId, status: decision, actionerEmail: userEmail, comments: (decision === 'Reject') ? comment : null });
			});

			console.log("Submitting decisions:", decisions);

			$.ajax({
				url: 'http://localhost:8485/tickets/updateTickets',
				method: 'POST',
				contentType: 'application/json',
				data: JSON.stringify(decisions),
				success: function(response) {
					alert("Tickets updated successfully.");
					location.reload();
				},
				error: function(xhr, status, error) {
					alert("Error updating tickets: " + error);
				}
			});
		});
		
	});

</script>

</html>