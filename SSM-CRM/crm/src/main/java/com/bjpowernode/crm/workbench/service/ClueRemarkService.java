package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    // 添加线索备注
    int saveCreateClueRemark(ClueRemark clueRemark);

    // 根据 clueId 查询线索备注列表
    List<ClueRemark> queryClueRemarkList(String clueId);

    // 根据 id 删除单条线索备注
    int deleteClueRemarkById(String id);

    // 根据 id 查询单条线索备注
    ClueRemark queryClueRemarkById(String id);

    // 根据 id 更新单条线索备注
    int saveEditClueRemarkById(ClueRemark clueRemark);
}
