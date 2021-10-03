package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {

    // 添加市场信息
    int insertActivity(Activity paramActivity);

    // 条件分页查询市场活动列表
    List<Activity> selectActivityForPageByCondition(Map<String, Object> paramMap);
    // 查询总的记录条数
    int selectActivityCount(Map<String, Object> paramMap);

    // 删除市场活动
    int deleteActivityByIds(String[] paramId);

    // 根据 id 查询市场活动
    Activity selectActivityById(String paramId);
    // 更新市场活动信息
    int updateByPrimaryKey(Activity paramActivity);

    // 根据 id 查询市场活动详情页
    Activity selectActivityDetailById(String paramId);

    // 根据 clueId 查询线索详情和市场活动列表
    List<Activity> selectActivityForDetailByClueId(String paramId);

    // 根据 activityName 搜索市场活动列表
    List<Activity> selectActivityForDetailByNameClueId(Map<String, Object> map);

    // 根据 activityId 查询市场活动列表
    List<Activity> selectActivityByIds(String[] activityId);

    // 根据 activityName 模糊查询市场活动列表
    List<Activity> selectActivityListByName(String paramActivityName);
}
