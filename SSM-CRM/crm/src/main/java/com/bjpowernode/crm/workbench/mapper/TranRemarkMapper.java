package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkMapper {

    //【线索转换】添加交易备注【 交易备注可能有一条或者多条 】
    void insertTranRemarkByList(List<TranRemark> tranRemarkList);

}
