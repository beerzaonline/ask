package com.rmuti.ecp.ask.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.rmuti.ecp.ask.model.bean.APIResponse;
import com.rmuti.ecp.ask.model.service.CommentRepository;
import com.rmuti.ecp.ask.model.table.Comment;

import java.util.List;

@RestController
@RequestMapping("/comment")
public class CommentController {
    @Autowired
    private CommentRepository commentRepository;

    @PostMapping("/save")
    public Object save(Comment comment) {
        APIResponse res = new APIResponse();
        commentRepository.save(comment);
        res.setData(comment.getId());
        return res;
    }

    @PostMapping("/list")
    public Object List() {
        APIResponse res = new APIResponse();
        res.setData(commentRepository.findAll());
        return res;
    }

    @PostMapping("/findAllComment")
    public Object FindAllComment(@RequestParam String topicId) {
        APIResponse res = new APIResponse();
        List a = commentRepository.findAllComment(topicId);
        if (a.isEmpty()) {
            res.setStatus(1);
            res.setMessage("ไม่มีข้อมูล");
        }else {
            res.setStatus(0);
            res.setData(a);
        }
        return res;
    }
}
