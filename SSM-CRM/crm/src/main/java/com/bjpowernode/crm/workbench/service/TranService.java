package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {

    // 分页查询交易列表
    List<Tran> queryTranListForPageByCondition(Map<String, Object> map);
    int queryCountOfTranByCondition(Map<String, Object> map);

    // 根据交易 id 查询单条交易信息
    Tran queryTranById(String id);
}
