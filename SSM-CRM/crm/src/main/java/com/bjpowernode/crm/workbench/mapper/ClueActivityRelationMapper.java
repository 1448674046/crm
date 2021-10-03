package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueActivityRelationMapper {

    // 保存 Clue and Activity 关联
    int insertClueActivityRelation(List<ClueActivityRelation> relationList);

    // 解除关联
    int deleteClueActivityRelation(@Param("clueId") String clueId, @Param("activityId") String activityId);

    // 【线索转换】根据 clueId 查询线索市场活动关系表
    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    // 【线索转换】根据 clueId 删除线索市场活动关系表的数据
    void deleteClueActivityRelationByClueId(String clueId);
}
