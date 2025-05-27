package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.domain.RoleName;
import com.example.demo.domain.User;

public interface UserRepository extends JpaRepository<User, Long>{

	User findByEmail(String email);
	List<User> findByRoles_Name(RoleName rn);
}
