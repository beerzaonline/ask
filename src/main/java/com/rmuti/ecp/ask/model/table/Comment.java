package com.rmuti.ecp.ask.model.table;

import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;

@ToString
@Data
@Entity(name = "comment")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_id")
    private int userId;

    @Column(name = "topic_id")
    private int topicId;

    @Column
    private String message;

    @Column(name = "create_date")
    private Date dateTime = new Date();
}