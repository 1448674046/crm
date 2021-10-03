package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Tran;
import java.util.List;
import java.util.Map;

public interface TranMapper {

    //【线索转换】添加交易
    void insertTran(Tran tran);

    // 分页查询交易列表
    List<Tran> selectTranListForPageByCondition(Map<String, Object> map);
    // 分页查询交易记录条数
    int selectTranCount(Map<String, Object> map);

    // 根据交易 id 查询单条交易信息
    Tran selectTranById(String id);
}
