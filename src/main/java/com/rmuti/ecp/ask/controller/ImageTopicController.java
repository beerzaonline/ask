package com.rmuti.ecp.ask.controller;

import com.rmuti.ecp.ask.model.bean.APIResponse;
import com.rmuti.ecp.ask.model.service.ImageTopicRepository;
import com.rmuti.ecp.ask.model.service.TopicRepository;
import com.rmuti.ecp.ask.model.table.ImageTopic;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ImageTopicController
 */
@RestController
@RequestMapping("imageTopic")
public class ImageTopicController {

    @Autowired
    private ImageTopicRepository imageTopicRepository;

    @Autowired
    private TopicRepository topicRepository;

    @PostMapping("/saveImage")
    public Object saveImage(@RequestParam(name = "file", required = false) MultipartFile file,
            @RequestParam int topicId) throws IOException {
        APIResponse res = new APIResponse();
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy_HHmmss");
        String formattedDate = myDateObj.format(myFormatObj);

        ImageTopic imageTopic = imageTopicRepository.findByTopicId(topicId);

        String fileName = file.getOriginalFilename();
        String typeName = file.getOriginalFilename().substring(fileName.length() - 3);
        String newName = formattedDate + "." + typeName;
        // File fileContent = new File(fileName);
        // BufferedOutputStream buf = new BufferedOutputStream(new
        // FileOutputStream(fileContent));

        if (imageTopic == null) {
            Path path = Paths.get(FlodersUpload.floder_gcp_topic.toString() + newName);
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            imageTopicRepository.insertName(newName, topicId);
            res.setStatus(0);
            res.setMessage("อัพรูปเรียบร้อยแล้ว");
            //res.setData(imageTopic.getImageId());
        } else if (imageTopic != null) {
            Path path = Paths.get(FlodersUpload.floder_gcp_topic.toString() + newName);
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            imageTopicRepository.updateNameImage(imageTopic.getImageId(), newName);
            res.setStatus(1);
            res.setMessage("อัพเดทรูปเรียบร้อยแล้ว");
            //res.setData(imageTopic.getImageId());
        }
        return res;
    }

    @ResponseBody
    @RequestMapping(value = "/image", method = RequestMethod.GET, produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] getResource(@RequestParam String nameImage) throws Exception {
        try {
            String path = FlodersUpload.floder_gcp_topic.toString() + nameImage; /// home/nicapa_sr/spdorm/images/dorm/
            InputStream in = new FileInputStream(path);
            return IOUtils.toByteArray(in);
        } catch (Exception e) {
        }
        return null;
    }

    @PostMapping("/getNameImages")
    public Object getName(@RequestParam("topicId") int topicId) {
        APIResponse res = new APIResponse();
        ImageTopic imageTopic = imageTopicRepository.findByTopicId(topicId);

        if (imageTopic != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(imageTopic);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }
}