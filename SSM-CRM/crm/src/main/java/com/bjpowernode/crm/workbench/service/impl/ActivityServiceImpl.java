package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    /**
     * 添加市场活动
     * @param paramActivity
     * @return count
     */
    @Override
    public int saveActivity(Activity paramActivity) {
        int count = activityMapper.insertActivity(paramActivity);
        return count;
    }

    /**
     * 条件分页查询市场活动列表
     * @param map
     * @return activityList
     */
    @Override
    public List<Activity> queryActivityForPageByCondition(Map<String, Object> map) {
        List<Activity> activityList =  activityMapper.selectActivityForPageByCondition(map);
        return activityList;
    }
    // 查询总的记录条数
    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        int count = activityMapper.selectActivityCount(map);
        return count;
    }

    /**
     * 删除市场活动
     * @param id
     * @return count
     */
    @Override
    public int deleteActivityByIds(String[] id) {
        int count = activityMapper.deleteActivityByIds(id);
        return count;
    }

    /**
     * 根据 id 查询市场活动
     * @param id
     * @return activity
     */
    @Override
    public Activity queryActivityById(String id) {
        Activity activity = activityMapper.selectActivityById(id);
        return activity;
    }

    /**
     * 更新市场活动信息
     * @param activity
     * @return count
     */
    @Override
    public int updateActivity(Activity activity) {
        int count = activityMapper.updateByPrimaryKey(activity);
        return count;
    }

    /**
     * 根据 id 查询市场活动详情页
     * @param id
     * @return activity
     */
    @Override
    public Activity queryActivityForDetailById(String id) {
        Activity activity = activityMapper.selectActivityDetailById(id);
        return activity;
    }

    /**
     * 根据 clueId 查询线索详情和市场活动列表
     * @param id
     * @return activityList
     */
    @Override
    public List<Activity> queryActivityForDetailByClueId(String id) {
        List<Activity> activityList = activityMapper.selectActivityForDetailByClueId(id);
        return activityList;
    }

    /**
     * 根据市场活动名搜索市场活动列表
     * @param map
     * @return activityList
     */
    @Override
    public List<Activity> queryActivityForDetailByNameClueId(Map<String, Object> map) {
        List<Activity> activityList = activityMapper.selectActivityForDetailByNameClueId(map);
        return activityList;
    }

    /**
     * 根据 activityId 数组查询市场活动列表
     * @param activityId
     * @return activityList
     */
    @Override
    public List<Activity> queryActivityByIds(String[] activityId) {
        List<Activity> activityList = activityMapper.selectActivityByIds(activityId);
        return activityList;
    }

    /**
     * 根据 activityName 模糊查询市场活动列表
     * @param activityName
     * @return activityList
     */
    @Override
    public List<Activity> queryActivityListByName(String activityName) {
        List<Activity> activityList = activityMapper.selectActivityListByName(activityName);
        return activityList;
    }

}
