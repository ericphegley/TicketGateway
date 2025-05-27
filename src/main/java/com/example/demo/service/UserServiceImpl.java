package com.example.demo.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.domain.Role;
import com.example.demo.domain.RoleName;
import com.example.demo.domain.User;
import com.example.demo.repository.RoleRepository;
import com.example.demo.repository.UserRepository;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	UserRepository userRepository;
	
	@Autowired
	RoleRepository roleRepository;
	
	@Override
	public User findByEmail(String email) {
		return userRepository.findByEmail(email);
	}
	
	@Override
	public User save(User e) {
		List<Role> roles = new ArrayList<>();
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		String hashedPassword = passwordEncoder.encode(e.getPassword());
		e.setPassword(hashedPassword);
		Role role = roleRepository.findById(1); //1=USER 2=MANAGER 3=ADMIN
		roles.add(role);
		e.setRoles(roles);
		User user = userRepository.save(e);
		//System.out.println(user.getUserPassword());
		return user;
	}
	
	
	
	@Override
	public User findById(Long id) {
		return userRepository.findById(id).orElse(null);
	}
	
	
	@Override
	public List<User> findByRolesName(RoleName rn){
		return userRepository.findByRoles_Name(rn);
	}
	

}
