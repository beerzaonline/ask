package com.rmuti.ecp.ask.model.service;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.rmuti.ecp.ask.model.table.Type;

public interface TypeRepository extends JpaRepository<Type, Integer> {
    Type findByTypeName(String name);
}
