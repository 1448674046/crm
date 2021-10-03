package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Clue;
import java.util.List;
import java.util.Map;

public interface ClueMapper {

    // 分页条件查询线索列表
    List<Clue> selectClueForPageByCondition(Map<String, Object> paramMap);

    // 根据条件查询线索记录条数
    int selectTotalByCondition(Map<String, Object> paramMap);

    // 创建线索
    int insertClue(Clue clue);

    // 根据 ClueId 删除单个或多个 线索
    int deleteClueByIds(String[] ids);

    //【线索转换】根据 ClueId 查询单条线索信息
    Clue selectClueById(String paramId);

    // 根据 ClueId 更新单条线索信息
    int updateClueById(Clue clue);

    // 根据 ClueId 查询线索详情
    Clue selectClueForDetailById(String id);

    //【线索转换】根据 clueId 删除线索
    void deleteClueById(String clueId);
}
