package com.rmuti.ecp.ask.model.service;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import com.rmuti.ecp.ask.model.table.UserProfile;

import java.util.List;

public interface UserProfileRepository extends JpaRepository<UserProfile, Integer> {

    // Check username in database (Login)
    UserProfile findByUserNameAndPassWord(String userName, String passWord);

    // Check Username for Register
    UserProfile findByUserName(String userName);

    @Transactional
    @Modifying
    @Query(value = "update user_profile u set u.login_status = :status where u.id = :userId",nativeQuery = true)
    void saveStatus(@Param("userId") Integer userId,@Param("status") Integer status);

    @Query(value = "select u.login_status from user_profile u where u.id = ?1",nativeQuery = true)
    int findByloginStatusAndId(Integer userId);
}