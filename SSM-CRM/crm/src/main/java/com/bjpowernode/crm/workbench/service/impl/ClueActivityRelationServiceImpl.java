package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.mapper.ClueActivityRelationMapper;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    /**
     * 保存 Clue and Activity 关联
     * @param relationList
     * @return count
     */
    @Override
    public int saveCreateClueActivityRelation(List<ClueActivityRelation> relationList) {
        int count = clueActivityRelationMapper.insertClueActivityRelation(relationList);
        return count;
    }

    /**
     * 解除关联
     * @param clueId
     * @param activityId
     * @return count
     */
    @Override
    public int saveUnbundActivity(String clueId, String activityId) {
        int count = clueActivityRelationMapper.deleteClueActivityRelation(clueId, activityId);
        return count;
    }

}
