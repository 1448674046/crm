package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    //【线索转换】根据 clueId 查询该线索下的所有备注信息【其目的是为了保存到线索备注表中】
    List<ClueRemark> selectClueRemarkForSaveTranRemarkByClueId(String clueId);

    //【线索转换】根据 clueId 删除线索备注
    void deleteClueRemarkByClueId(String clueId);

    //【线索转换】添加线索备注
    int insertClueRemark(ClueRemark clueRemark);

    // 根据 clueId 查询该线索下的所有备注信息
    List<ClueRemark> selectClueRemarkByClueId(String clueId);

    // 根据 id 删除单条线索备注
    int deleteClueRemarkById(String id);

    // 根据 id 查询单条线索备注
    ClueRemark selectClueRemarkById(String id);

    // 根据 id 更新单条线索备注
    int updateClueRemarkById(ClueRemark clueRemark);
}
