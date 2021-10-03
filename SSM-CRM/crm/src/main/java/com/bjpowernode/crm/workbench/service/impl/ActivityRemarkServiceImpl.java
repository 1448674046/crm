package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    /**
     * 根据市场活动id查询备注列表
     * @param id
     * @return List<ActivityRemark>
     */
    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String id) {
        List<ActivityRemark> activityRemarkList = activityRemarkMapper.selectActivityRemarkForDetailByActivityId(id);
        return activityRemarkList;
    }

    /**
     * 创建市场活动备注信息
     * @param remark
     * @return int
     */
    @Override
    public int saveCreateActivityRemark(ActivityRemark remark) {
        int count = activityRemarkMapper.insertActivityRemark(remark);
        return count;
    }

    /**
     * 根据 id 删除单条备注
     * @param id
     * @return count
     */
    @Override
    public int deleteRemarkById(String id) {
        int count = activityRemarkMapper.deleteRemarkById(id);
        return count;
    }

    /**
     * 根据 id 查询单条备注
     * @param id
     * @return ActivityRemark
     */
    @Override
    public ActivityRemark queryActivityRemarkById(String id) {
        ActivityRemark activityRemark = activityRemarkMapper.selectActivityRemarkById(id);
        return activityRemark;
    }

    /**
     * 根据 id 更新单条备注信息
     * @param remark
     * @return count
     */
    @Override
    public int saveEditActivityRemarkById(ActivityRemark remark) {
        int count = activityRemarkMapper.updateActivityRemarkById(remark);
        return count;
    }


}
