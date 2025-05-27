<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="frm" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ticket History</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/history.css">
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
	<h2>Ticket History for ticket #<span id="ticketIdText">${ticketId}</span></h2>
	<table border="1">
	    <thead>
	        <tr>
	            <th>Action</th>
	            <th>Action By</th>
	            <th>Date</th>
	            <th>Comments</th>
	        </tr>
	    </thead>
	    <tbody id="historyTableBody">

	    </tbody>
	</table>
</div>
<div class="button-container">
	<div class="home-section">
	    <form action="/home" method="get">
	        <button type="submit" class="big-button">Home</button>
	    </form>
	</div>
</div>


<script>
    $(document).ready(function () {
        const ticketId = '${ticketId}';

        $.ajax({
            url: 'http://localhost:8485/tickets/getTicketHistory',
            method: 'GET',
            data: { ticketId: ticketId },
            success: function (historyData) {
				console.log(historyData)
                if (Array.isArray(historyData)) {
                    let historyRows = "";
                    historyData.forEach(entry => {
                        historyRows += "<tr>" +
                            "<td>" + entry.action + "</td>" +
                            "<td>" + (entry.actionBy || '') + "</td>" +
                            "<td>" + (entry.date || '').split('T')[0] + "</td>" +
                            "<td>" + (entry.comments || '') + "</td>" +
                            "</tr>";
                    });
                    $('#historyTableBody').html(historyRows);
                } else {
                    $('#historyTableBody').html("<tr><td colspan='4'>No history found.</td></tr>");
                }
            },
            error: function (xhr, status, error) {
                alert('Failed to fetch ticket history: ' + error);
            }
        });
    });
</script>

</body>
</html>