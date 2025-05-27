package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.domain.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class LoginController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	UserRepository userRepository;
	
	
	@GetMapping(value = "/login")
	public String login(@RequestParam(required = false) String logout, @RequestParam(required = false) String error,
			HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Model model) {
		String message = "";
		if (error != null) {
			message = "Invalid Credentials";
		}
		if (logout != null) {
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			if (auth != null) {
				new SecurityContextLogoutHandler().logout(httpServletRequest, httpServletResponse, auth);
			}
			message = "Logout";
			return "login";
		}
		model.addAttribute("Message", message);
		return "login";

	}
	
	@GetMapping(value= "/signup")
	public String signup() {
		return "signup";
	}
	
	@PostMapping(value= "/createUser")
	public String createUser(@RequestParam String name, @RequestParam String username, @RequestParam String password, @RequestParam String department, @RequestParam String project, Model model) {
		if(name.isEmpty() || username.isEmpty() || password.isEmpty() || department.isEmpty() || project.isEmpty()) {
			model.addAttribute("Message", "Fields must contain values!");
			return "signup";
		}
		User u = new User();

        if (!name.matches("[a-zA-Z\\s]*")) {
            model.addAttribute("Message", "Name contains invalid characters!");
            return "signup";
        }
        User existing = userRepository.findByEmail(username);
        if(existing != null) {
        	model.addAttribute("Message", "Email already exists!");
        	return "signup";
        }
        u.setEmail(username);
        u.setPassword(password);
		userService.save(u);
		
		return "login";
	}

}
