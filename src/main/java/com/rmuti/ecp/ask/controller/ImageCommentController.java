package com.rmuti.ecp.ask.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.rmuti.ecp.ask.model.bean.APIResponse;
import com.rmuti.ecp.ask.model.service.ImageCommentRepository;
import com.rmuti.ecp.ask.model.table.ImageComment;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * ImageCommentController
 */
@RestController
@RequestMapping("/imageComment")
public class ImageCommentController {

    @Autowired
    private ImageCommentRepository imageCommentRepository;

    @PostMapping("/saveImage")
    public Object saveImage(@RequestParam(name = "file", required = false) MultipartFile file,
            @RequestParam int commentId) throws IOException {
        APIResponse res = new APIResponse();
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("dd-MM-yyyy_HHmmss");
        String formattedDate = myDateObj.format(myFormatObj);

        ImageComment imageComment = imageCommentRepository.findByCommentId(commentId);

        String fileName = file.getOriginalFilename();
        String typeName = file.getOriginalFilename().substring(fileName.length() - 3);
        String newName = formattedDate + "." + typeName;
        // File fileContent = new File(fileName);
        // BufferedOutputStream buf = new BufferedOutputStream(new
        // FileOutputStream(fileContent));

        if (imageComment == null) {
            Path path = Paths.get(FlodersUpload.floder_gcp_comment.toString() + newName);
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            imageCommentRepository.insertName(commentId, newName);
            res.setStatus(0);
            res.setMessage("อัพรูปเรียบร้อยแล้ว");
            //res.setData(imageComment.getImageId());
        } else if (imageComment != null) {
            Path path = Paths.get(FlodersUpload.floder_gcp_comment.toString() + newName);
            byte[] bytes = file.getBytes();
            Files.write(path, bytes);
            imageCommentRepository.updateNameImage(imageComment.getImageId(), newName);
            res.setStatus(1);
            res.setMessage("แก้ไขรูปเรียบร้อยแล้ว");
            //res.setData(imageComment.getImageId());
        }
        return res;
    }

    @ResponseBody
    @RequestMapping(value = "/image", method = RequestMethod.GET, produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] getResource(@RequestParam String nameImage) throws Exception {
        try {
            String path = FlodersUpload.floder_gcp_comment.toString() + nameImage; /// home/nicapa_sr/spdorm/images/dorm/
            InputStream in = new FileInputStream(path);
            return IOUtils.toByteArray(in);
        } catch (Exception e) {
        }
        return null;
    }

    @PostMapping("/getNameImages")
    public Object getName(@RequestParam("commentId") int commentId) {
        APIResponse res = new APIResponse();
        ImageComment imageComment = imageCommentRepository.findByCommentId(commentId);

        if (imageComment != null) {
            res.setStatus(0);
            res.setMessage("พบข้อมูล");
            res.setData(imageComment);
        } else {
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }

}