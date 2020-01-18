package com.rmuti.ecp.ask.model.service;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.rmuti.ecp.ask.model.table.Comment;
import com.rmuti.ecp.ask.model.table.Topic;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Integer> {

    @Query(value = "select a.id,a.message,b.user_name from comment a, user_profile b where a.topic_id = :topicId and a.user_id = b.id order by a.id",nativeQuery = true)
    List<Object[]> findAllComment(@Param("topicId") String topicId);
}
