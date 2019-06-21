package com.rmuti.ecp.ask.model.table;

import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;

@ToString
@Data
@Entity(name = "topic")
public class Topic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_id")
    private int userId;

    @Column
    private String name;

    @Column
    private String description;

    @Column(name = "type_id")
    private int typeId;

    @Column(name = "create_date")
    private Date dateTime = new Date();
}