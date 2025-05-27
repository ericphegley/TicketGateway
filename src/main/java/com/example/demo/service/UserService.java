package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.domain.Role;
import com.example.demo.domain.RoleName;
import com.example.demo.domain.User;

@Service
public interface UserService {
	
	public User save(User e);

	public User findByEmail(String email);

	public User findById(Long id);
	
	public List<User> findByRolesName(RoleName rn);
	
	
}
