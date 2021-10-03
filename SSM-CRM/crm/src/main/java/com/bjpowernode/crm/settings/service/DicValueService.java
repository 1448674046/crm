package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {

    // 查询全部的数据字典值
    List<DicValue> queryAllDicValues();

    // 根据字典类型的 typeCode 查询字典值
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
