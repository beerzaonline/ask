package com.rmuti.ecp.ask.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.rmuti.ecp.ask.model.bean.APIResponse;
import com.rmuti.ecp.ask.model.service.TypeRepository;
import com.rmuti.ecp.ask.model.table.Topic;
import com.rmuti.ecp.ask.model.table.Type;

@RestController
@RequestMapping("/type")
public class TypeController {

    @Autowired
    private TypeRepository typeRepository;

    @PostMapping("/add")
    public Object add(Type type) {
        APIResponse res = new APIResponse();
        Type type_db = typeRepository.findByTypeName(type.getTypeName());
        if(type_db == null){
            res.setStatus(0);
            typeRepository.save(type);
        }else{
            res.setStatus(1);
        }
        return res;
    }

    @PostMapping("/list")
    public Object list() {
        APIResponse res = new APIResponse();
        res.setStatus(0);
        res.setData(typeRepository.findAll());
        return res;
    }
}
