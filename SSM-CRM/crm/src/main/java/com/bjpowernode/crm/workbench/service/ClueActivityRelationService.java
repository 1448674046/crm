package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    // 保存 Clue and Activity 关联
    int saveCreateClueActivityRelation(List<ClueActivityRelation> relationList);

    // 解除关联
    int saveUnbundActivity(String clueId, String activityId);
}
