package com.example.demo.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.common.ticket_common.StatusName;
import com.common.ticket_common.TicketUpdateDTO;
import com.example.demo.domain.RoleName;

import com.example.demo.service.TicketService;
import com.example.demo.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;


import org.springframework.ui.Model;


@Controller
public class HomeController {

    private final SecurityFilterChain apiFilterChain2;


    @Autowired
    private UserService userService;

    @Autowired
    private TicketService ticketService; // NEW

    HomeController(SecurityFilterChain apiFilterChain2) {
        this.apiFilterChain2 = apiFilterChain2;
    }

    @GetMapping("/home")
    public String home(Model model, Principal principal) {
    	model.addAttribute("userEmail", principal.getName());
        return "home";
    }

    @GetMapping("/ticket")
    public String ticket(Model model, Principal principal) {
    	model.addAttribute("userEmail", principal.getName());
        return "ticket";
    }

    
    @GetMapping("/getEmployeeTickets")
    public String getEmployeeTickets(Model model, Principal principal) {
    	model.addAttribute("userEmail", principal.getName());
    	return "viewTickets";
    }
    
    @GetMapping("/getManagerTickets")
    public String getManagerTickets(Model model, Principal principal) {
    	model.addAttribute("userEmail", principal.getName());
    	return "viewManagerTickets2";
    }
    @GetMapping("/getAdminTickets")
    public String getAdminTickets(Model model, Principal principal) {
    	model.addAttribute("userEmail", principal.getName());
    	return "viewAdminTickets2";
    }

    
    @GetMapping("/getTicketHistory")
    public String getTicketHistory(Model model, @RequestParam(name="ticketId") Long ticketId) {
    	model.addAttribute("ticketId", ticketId);
    	return "viewTicketHistory";
    }
    /*
    @GetMapping("/getTicketsUnder")
    public String getAllTickets(Model model, Principal principal, @RequestParam(name = "roleId") int roleId) {
	
        
    	return "home";
    	
    }*/
    
    /*
    @GetMapping("/getTicketHistory/{ticketId}")
    public String getTicketHistory(Model model, @PathVariable Long ticketId) {
    	
        try {
        	System.out.println("Here1:");
        	System.out.println("Here: " + ticketId);
            List<TicketHistoryDTO> th = ticketService.getTicketHistory(ticketId);
            model.addAttribute("tickethistory", th);
            model.addAttribute("ticketId", ticketId);

            return "viewTicketHistory";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
    */

   /* @PostMapping("/submitDecisions")
    public String submitDecisions(@RequestParam Map<String, String> params, Principal p) {
        ticketService.processTicketDecisions(params, p);
        return "home";
    }*/
    
    @GetMapping("/test")
    public String test() {
    	return "login";
    }
    
   
    /*GetMapping("/downloadFile")
    public ResponseEntity<Resource> downloadFile(@RequestParam(name="path") String filePath) throws IOException {
    
    	System.out.println("Here" + filePath);
    	byte[] downloaded = ticketApiClient.downloadFile(filePath);
        ByteArrayResource resource = new ByteArrayResource(downloaded);

        Path path = Paths.get(filePath);
        String fileName = path.getFileName().toString();
        return ResponseEntity.ok()
                .contentLength(downloaded.length)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                .body(resource);
    }*/
}

