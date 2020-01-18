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
@Entity(name = "imageComment")
public class ImageComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int imageId;

    @Column
    private int commentId;

    @Column(name = "image_name")
    private String imageName;

    
}