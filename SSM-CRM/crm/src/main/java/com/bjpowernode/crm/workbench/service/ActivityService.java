package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import java.util.List;
import java.util.Map;

public interface ActivityService {
    // 添加市场活动
    int saveActivity(Activity activity);

    // 条件分页查询市场活动列表
    List<Activity> queryActivityForPageByCondition(Map<String, Object> map);
    int queryCountOfActivityByCondition(Map<String, Object> map);

    // 删除市场活动
    int deleteActivityByIds(String[] id);

    // 根据 id 查询市场活动
    Activity queryActivityById(String id);

    // 更新市场活动信息
    int updateActivity(Activity activity);

    // 根据 id 查询市场活动详情页
    Activity queryActivityForDetailById(String id);

    // 根据 clueId 查询线索详情和市场活动列表
    List<Activity> queryActivityForDetailByClueId(String id);

    // 根据市场活动名搜索市场活动列表
    List<Activity> queryActivityForDetailByNameClueId(Map<String, Object> map);

    // 根据 activityId 数组查询市场活动列表
    List<Activity> queryActivityByIds(String[] activityId);

    // 根据 activityName 模糊查询市场活动列表
    List<Activity> queryActivityListByName(String activityName);
}
