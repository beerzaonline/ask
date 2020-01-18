package com.rmuti.ecp.ask.model.service;

import javax.transaction.Transactional;

import com.rmuti.ecp.ask.model.table.ImageTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface ImageTopicRepository extends JpaRepository<ImageTopic,Integer>{

    ImageTopic findByImageId(int imageId);

    ImageTopic findByTopicId(int topicId);

    @Transactional
    @Modifying
    @Query(value = "INSERT INTO image_topic(`image_name`, `topic_id`) VALUES (?1,?2)",nativeQuery = true)
    void insertName(String name,int topicId);

    @Transactional
    @Modifying
    @Query(value = "UPDATE image_topic a SET a.image_name = ?2 WHERE a.image_id = ?1",nativeQuery = true)
    void updateNameImage(int imageId, String name);
    
}