package com.rmuti.ecp.ask.model.service;

import javax.transaction.Transactional;

import com.rmuti.ecp.ask.model.table.ImageComment;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * ImageComment
 */
public interface ImageCommentRepository extends JpaRepository<ImageComment, Integer> {
    
    ImageComment findByImageId(int imageId);

    ImageComment findByCommentId(int commentId);

    @Transactional
    @Modifying
    @Query(value = "INSERT INTO image_comment(`comment_id`, `image_name`) VALUES (?1,?2)",nativeQuery = true)
    void insertName(int commentId,String name);

    @Query(value = "UPDATE image_comment a SET a.image_name = ?2 WHERE a.image_id = ?1",nativeQuery = true)
    void updateNameImage(int imageId, String name);
    
}