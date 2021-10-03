package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    // 分页条件查询线索列表
    List<Clue> queryClueForPageByCondition(Map<String, Object> map);

    // 根据条件查询线索记录条数
    int queryCountOfClueByCondition(Map<String, Object> map);

    // 创建线索
    int saveCreateClue(Clue clue);

    // 根据 ClueId 删除单个或多个 线索
    int deleteClueByIds(String[] ids);

    // 根据 ClueId 查询单条线索信息
    Clue queryClueById(String id);

    // 根据 ClueId 更新单条线索信息
    int saveEditClueById(Clue clue);

    // 根据 ClueId 查询线索详情
    Clue queryClueForDetailById(String id);

    // 保存转换线索
    void saveConvert(Map<String, Object> map);
}
