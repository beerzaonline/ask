package com.rmuti.ecp.ask.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.rmuti.ecp.ask.model.bean.APIResponse;
import com.rmuti.ecp.ask.model.service.TopicRepository;
import com.rmuti.ecp.ask.model.service.UserProfileRepository;
import com.rmuti.ecp.ask.model.table.Topic;
import com.rmuti.ecp.ask.model.table.UserProfile;

import java.util.Optional;

@RestController
@RequestMapping("/topic")
public class TopicController {
    @Autowired
    private TopicRepository topicRepository;
    private UserProfileRepository userProfileRepository;

    @PostMapping("/save")
    public Object save(Topic topic) {
        APIResponse res = new APIResponse();
        topicRepository.save(topic);
        return res;
    }

    @PostMapping("/list")
    public Object List(@RequestParam int typeId) {
        APIResponse res = new APIResponse();
        res.setData(topicRepository.findListView(typeId));
        // res.setData(topicRepository.findAll());
        return res;
    }

    @PostMapping("/findTopic")
    public Object FindTopic(@RequestParam String topicId, @RequestParam String userId) {
        APIResponse res = new APIResponse();
        res.setData(topicRepository.findTopic(topicId, userId));
        return res;
    }

    @PostMapping("/delete")
    public Object Delete(@RequestParam int topicId) {
        APIResponse res = new APIResponse();
        Optional<Topic> topic_db = topicRepository.findById(topicId);
        if (topic_db.isPresent()) {
            topicRepository.deleteById(topicId);
            res.setStatus(0);
            res.setMessage("ลบหัวข้อเรียบร้อยแล้ว");
        } else {
            res.setStatus(1);
            res.setMessage("ผิดพลาด");
        }
        return res;
    }
}
