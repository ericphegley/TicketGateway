<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="frm" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tickets</title>
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
			<security:authorize access="hasAuthority('ROLE_USER')">
		        <h2>Your Proposed Tickets</h2>
		        <table border="1">
		            <thead>
		                <tr>
		                    <th>Date</th><th>Title</th><th>Created By</th><th>Assignee</th>
		                    <th>Description</th><th>Priority</th><th>Status</th><th>Category</th><th>Comments</th><th>Decision</th>
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
	        url: 'http://localhost:8485/tickets/getEmployeeTickets?email=' + encodeURIComponent(userEmail),  
	        method: 'GET',
	        dataType: 'json',
	        success: function(tickets) {
				tickets.forEach(function(ticket) {
					console.log(ticket)
				    var decisionControls = "";
					if (ticket.status === 'RESOLVED') {
					    decisionControls += "<div class='decision-option'><label><input type='radio' name='decision_" + ticket.id + "' value='Reopen'> Reopen</label></div>";
					    decisionControls += "<div class='decision-option'><label><input type='radio' name='decision_" + ticket.id + "' value='Close'> Close</label></div>";
					    decisionControls += "<div class='decision-option'><button type='button' class='cancel-btn' data-ticket-id='" + ticket.id + "'>Cancel</button></div>";
					}

				    var row = "<tr>" +
				        "<td>" + (ticket.creationDate || '').split('T')[0] + "</td>" +
				        "<td>" + ticket.title + "</td>" +
				        "<td>" + ticket.actionerEmail + "</td>" +
				        "<td>" + ticket.assigneeEmail + "</td>" +
				        "<td>" + ticket.description + "</td>" +
				        "<td>" + ticket.priority + "</td>" +
				        "<td>" + ticket.status + "</td>" +
				        "<td>" + ticket.category + "</td>" +
				        "<td>" +
							"<a href='/getTicketHistory?ticketId=" + ticket.id + "'>History</a>" +
				        "</td>" +
				        "<td>" + decisionControls + "</td>" +
				    "</tr>";

				    $('#ticketsBody').append(row);
				});

	            // re-bind your cancel button event handler for new buttons
	            $('.cancel-btn').on('click', function () {
	                $(this).parent().find('label input').prop('checked', false);
	                const anySelected = $('input[type="radio"]:checked').length > 0;
	                $('#submitBtn').toggle(anySelected);
	            });
	        },
	        error: function(xhr, status, error) {
	            alert('Failed to load tickets: ' + error);
	        }
	    });

	    // Radio button change event for dynamically added inputs
	    $(document).on('change', 'input[type="radio"]', function () {
	        const anySelected = $('input[type="radio"]:checked').length > 0;
	        $('#submitBtn').toggle(anySelected);
	    });
		
		$('#decisionform').on('submit', function(e) {
			e.preventDefault(); // prevent default form submission

			let decisions = [];

			$('input[type="radio"]:checked').each(function() {
				let ticketId = $(this).attr('name').split('_')[1];
				let decision = $(this).val();
				decisions.push({ id: ticketId, status: decision, actionerEmail: userEmail });
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