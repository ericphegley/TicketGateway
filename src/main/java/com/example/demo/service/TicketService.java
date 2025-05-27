package com.example.demo.service;

import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.common.ticket_common.EmployeeDTO;
import com.common.ticket_common.StatusName;
import com.common.ticket_common.TicketUpdateDTO;
import com.example.demo.domain.Role;
import com.example.demo.domain.RoleName;
import com.fasterxml.jackson.core.JsonProcessingException;

@Service
public class TicketService {
	/*
	
	private int currentIndex = 0;

    @Autowired
    private UserService userService;

    @Autowired
    private TicketApiClient ticketApiClient;

    public void createTicket(String userEmail, String title, String description, String priority,
        String category, List<MultipartFile> files) throws IOException {
    	
		Employee creator = userService.findByEmail(userEmail);
		Employee manager = userService.findById(creator.getManagerId());
		
		Ticket ticket = new Ticket();
		ticket.setTitle(title);
		ticket.setDescription(description);
		ticket.setPriority(priority);
		ticket.setCategory(category);
		ticket.setCreatedBy(creator);
		ticket.setAssignee(manager);
		
		ticketApiClient.createAndSendTicket(ticket, files); 
		
    }
    
    public List<TicketHistoryDTO> getTicketHistory(Long id) {
    	List<TicketHistoryDTO> thList = ticketApiClient.getTicketHistory(id);
    	thList.sort(Comparator.comparing(TicketHistoryDTO::getActionDate));
    	return thList;
    }
    

    public void getSortedTicketsUnder(String email) throws JsonProcessingException {
        Employee loggedInEmployee = userService.findByEmail(email);
        List<Role> roles = loggedInEmployee.getRoles();
        List<RoleName> roleNames = new ArrayList<>();
        List<Ticket> assignedTickets = new ArrayList<>();
        List<Ticket> underlingsTickets = new ArrayList<>();
        for(Role role : roles) {
        	roleNames.add(role.getName());
        }
        if(roleNames.contains(RoleName.ADMIN)) {
        	assignedTickets = ticketApiClient.getTicketsAssignedTo(loggedInEmployee.getId());
            assignedTickets.sort(Comparator.comparing(Ticket::getCreationDate));
        }

        if(roleNames.contains(RoleName.MANAGER)) {
            List<Employee> subordinates = userService.findByManagerId(loggedInEmployee.getId());
            if(!subordinates.isEmpty()) {
                underlingsTickets = ticketApiClient.getTicketsUnder(subordinates, false);
                underlingsTickets.sort(Comparator.comparing(Ticket::getCreationDate));
            }
        }
        
        List<Employee> singleEmployee = List.of(loggedInEmployee);
        List<Ticket> employeeTickets = ticketApiClient.getTicketsUnder(singleEmployee, true);
        
		CHANGE RETURN TYPE TO LIST<LIST<TICKET>>
        return List.of(assignedTickets, underlingsTickets, employeeTickets);
        
    	
    }

    public void processTicketDecisions(Map<String, String> params, Principal p) {
    	
        List<TicketUpdateDTO> updates = new ArrayList<>();
        List<Employee> admins = userService.findByRolesName(RoleName.ADMIN);
        
        for (Map.Entry<String, String> entry : params.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();

            if (key.startsWith("decision_")) {
                Long ticketId = Long.parseLong(key.substring("decision_".length()));
                TicketUpdateDTO dto = new TicketUpdateDTO();
                dto.setTicketId(ticketId);
                
                //common logic for setting the person who performed the action
                String actionerEmail = p.getName();
                Employee actioner = userService.findByEmail(actionerEmail);
                EmployeeDTO actionerDTO = new EmployeeDTO();
                actionerDTO.setId(actioner.getId());
                actionerDTO.setName(actioner.getName());
                actionerDTO.setEmail(actioner.getEmail());
                dto.setActioner(actionerDTO);

                if ("Approve".equalsIgnoreCase(value)) {
                	//need to change the assignee
                    dto.setStatus(StatusName.APPROVED);
                    Employee selectedAdmin = admins.get(currentIndex);
                    //round-robin admin selection for who it's assigned to
                    currentIndex = (currentIndex + 1) % admins.size();
                    EmployeeDTO adminDTO = new EmployeeDTO();
                    adminDTO.setId(selectedAdmin.getId());
                    adminDTO.setName(selectedAdmin.getName());
                    adminDTO.setEmail(selectedAdmin.getEmail());
                    dto.setAssignee(adminDTO);
                } 
                else if ("Reject".equalsIgnoreCase(value)) {
                    dto.setStatus(StatusName.REJECTED);
                }
                else if("Resolve".equalsIgnoreCase(value)) {
                	dto.setStatus(StatusName.RESOLVED);
                }
                else if("Reopen".equalsIgnoreCase(value)) {
                	dto.setStatus(StatusName.REOPENED);
                }
                else if("Close".equalsIgnoreCase(value)) {
                	dto.setStatus(StatusName.CLOSED);
                }

                updates.add(dto);
            }
        }

        ticketApiClient.updateTickets(updates);
        
    }
    */
}
