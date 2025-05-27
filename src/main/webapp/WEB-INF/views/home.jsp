<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="frm" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <meta charset="UTF-8">
    <title>Home</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">


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
	<div class="button-container">
	    <div class="button-grid">
	        <div class="square-button" onclick="location.href='/ticket';">
	            <div class="button-title">Create Ticket</div>
	            <img class="form-image" src="images/form.png" alt="Create Icon">
	        </div>
			
			<security:authorize access="hasAuthority('ROLE_USER')">
				<div class="view-button" onclick="location.href='/getEmployeeTickets';">
				        <div class="button-title">View Your Tickets</div>
				        <img class="view-image" src="images/view.png" alt="View Icon">
				    </div>
			</security:authorize>
			
			<security:authorize access="hasAuthority('ROLE_MANAGER')">
			    <div class="approve-container">
			        <div class="approve-button" onclick="location.href='/getManagerTickets';">
			            <div class="button-title">Approve Tickets</div>
			            <img class="approve-image" src="images/approve.png" alt="Approve Icon">
			            <span class="notification-badge" id="manager-ticket-count" style="display: none;"></span>
			        </div>
			    </div>
			</security:authorize>
			

			<security:authorize access="hasAuthority('ROLE_ADMIN')">
				<div class="approve-container">
					<div class="resolve-button" onclick="location.href='/getAdminTickets';">
					        <div class="button-title">Resolve Tickets</div>
					        <img class="resolve-image" src="images/resolve.png" alt="Resolve Icon">
							<span class="notification-badge" id="admin-ticket-count" style="display: none;"></span>
					</div>
				</div>
			</security:authorize>
	    </div>

	    <div class="home-section">
            <form action="/home" method="get">
                <button type="submit" class="big-button">Home</button>
            </form>
	    </div>
	</div>
	

</body>
<script>
$(document).ready(function() {
    const userEmail = "${userEmail}";
    
    $.ajax({
        url: 'http://localhost:8485/tickets/getManagerTicketCount?email=' + encodeURIComponent(userEmail),
        method: 'GET',
        success: function(data) {
            if (data.count > 0) {
                $('#manager-ticket-count')
                    .text(data.count)
                    .show();
            }
        },
        error: function(xhr, status, error) {
            console.error("Failed to get manager ticket count:", error);
        }
    });
	$.ajax({
	    url: 'http://localhost:8485/tickets/getAdminTicketCount?email=' + encodeURIComponent(userEmail),
	    method: 'GET',
	    success: function(data) {
	        if (data.count > 0) {
	            $('#admin-ticket-count')
	                .text(data.count)
	                .show();
	        }
	    },
	    error: function(xhr, status, error) {
	        console.error("Failed to get admin ticket count:", error);
	    }
	});
});
</script>
</html>