package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {

    // 查询全部数据组字典值
    List<DicValue> selectAllDicValues();

    // 根据字典类型的 typeCode 查询字典值
    List<DicValue> selectDicValuesByTypeCode(String paramTypeCode);
}
