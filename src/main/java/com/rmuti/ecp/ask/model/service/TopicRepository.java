package com.rmuti.ecp.ask.model.service;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.rmuti.ecp.ask.model.table.Topic;

import java.util.List;

public interface TopicRepository extends JpaRepository<Topic, Integer> {

    @Query(value = "select  a.id , a.name , b.user_name , a.create_date , a.description , c.type_name" +
            " from topic a, user_profile b, type c " +
            " where a.user_id = b.id and a.type_id = ?1 and c.id = ?1", nativeQuery = true)
    List<Object[]> findListView(int typeId);

    @Query(value = "select a.name,a.description,b.user_name from topic a, user_profile b where a.id = ?1 and b.id = ?2",nativeQuery = true)
    List<Object[]> findTopic(String topicId, String userId);
}
