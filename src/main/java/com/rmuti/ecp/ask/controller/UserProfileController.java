package com.rmuti.ecp.ask.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.web.bind.annotation.*;
import com.rmuti.ecp.ask.model.bean.APIResponse;
import com.rmuti.ecp.ask.model.service.UserProfileRepository;
import com.rmuti.ecp.ask.model.table.UserProfile;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserProfileController {
    @Autowired
    private UserProfileRepository userProfileRepository;

    @PostMapping("/register")
    public Object register(UserProfile userProfile) {
        APIResponse res = new APIResponse();
        UserProfile userProfileDb = userProfileRepository.findByUserName(userProfile.getUserName());
        if (userProfileDb == null) {
            res.setStatus(0);
            res.setMessage("สมัครสมาชิกเรียบร้อยแล้ว");
            userProfileRepository.save(userProfile);
        } else {
            res.setStatus(1);
            res.setMessage("มี Username นี้อยู่แล้ว");
        }
        return res;
    }

    @PostMapping("/login")
    public Object login(@RequestParam String userName, @RequestParam String passWord) {
        APIResponse res = new APIResponse();
        UserProfile userProfile = userProfileRepository.findByUserNameAndPassWord(userName, passWord);
        if (userProfile == null) {
            res.setStatus(1);
            res.setMessage("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง");
        } else {
            res.setStatus(0);
            res.setMessage("เข้าสู่ระบบเรียบร้อยแล้ว");
            res.setData(userProfile.getId());
        }
        return res;
    }

    @PostMapping("/changeStatus")
    public Object changeStatus(@RequestParam int userId, @RequestParam int status) {
        APIResponse res = new APIResponse();
        userProfileRepository.saveStatus(userId, status);
        res.setMessage("OK");
        return res;

    }

    @PostMapping("/checkStatus")
    public Object checkStatus(@RequestParam int userId) {
        APIResponse res = new APIResponse();
        res.setData(userProfileRepository.findByloginStatusAndId(userId));
        res.setMessage("OK");
        return res;
    }
}
