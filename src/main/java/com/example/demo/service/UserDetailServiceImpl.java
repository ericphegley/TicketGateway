package com.example.demo.service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.demo.domain.Role;
import com.example.demo.domain.User;

@Service
public class UserDetailServiceImpl implements UserDetailsService {

	@Autowired
	UserService userService;

	@Override
	public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
		System.out.println("Finding user");
		User user = userService.findByEmail(email);
		if(user == null) {
			System.out.println("Email not found");
			throw new UsernameNotFoundException(email);
		}
		
		//System.out.println("Email found for: " + user.getName());
		Set<GrantedAuthority> ga = new HashSet<>();
		List<Role> roles = user.getRoles();
		for (Role role : roles) {
			System.out.println("role.getRoleName()" + role.getName().name());
			ga.add(new SimpleGrantedAuthority("ROLE_" + role.getName().name()));
		}
		System.out.println("done");

		return new org.springframework.security.core.userdetails.User(user.getEmail(), user.getPassword(), ga);
	}

}
