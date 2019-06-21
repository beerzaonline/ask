package com.rmuti.ecp.ask.model.table;

import lombok.Data;
import lombok.ToString;
import javax.persistence.*;

@ToString
@Data
@Entity
@Table(name = "user_profile")
public class UserProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @Column(name = "user_name")
    private String userName;

    @Column(name = "pass_word")
    private String passWord;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "login_status")
    private int loginStatus;
}