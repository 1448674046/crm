package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {

    // 根据市场活动id查询备注列表
    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String paramActivityId);

    // 创建市场活动备注信息
    int insertActivityRemark(ActivityRemark paramRemark);

    // 根据 id 删除单条备注
    int deleteRemarkById(String paramId);

    // 根据 id 查询单条备注
    ActivityRemark selectActivityRemarkById(String paramId);

    // 根据 id 更新单条备注信息
    int updateActivityRemarkById(ActivityRemark paramRemark);
}
