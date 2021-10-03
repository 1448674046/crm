package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    // 根据市场活动id查询备注列表
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String id);

    // 创建市场活动备注信息
    int saveCreateActivityRemark(ActivityRemark remark);

    // 根据 id 删除单条备注
    int deleteRemarkById(String id);

    // 根据 id 查询单条备注
    ActivityRemark queryActivityRemarkById(String id);

    // 根据 id 更新单条备注信息
    int saveEditActivityRemarkById(ActivityRemark remark);
}
