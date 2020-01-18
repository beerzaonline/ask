package com.rmuti.ecp.ask.model.table;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import lombok.Data;
import lombok.ToString;

@ToString
@Data
@Entity(name = "imageTopic")
public class ImageTopic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int imageId;

    @Column
    private int topicId;

    @Column(name = "image_name")
    private String imageName;

    
}