package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    /**
     * 查询全部的数据字典值
     * @return dicValueList
     */
    @Override
    public List<DicValue> queryAllDicValues() {
        List<DicValue> dicValueList =  dicValueMapper.selectAllDicValues();
        return dicValueList;
    }

    /**
     * 根据字典类型的 typeCode 查询字典值
     * @param typeCode
     * @return dicValueList
     */
    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        List<DicValue> dicValueList = dicValueMapper.selectDicValuesByTypeCode(typeCode);
        return dicValueList;
    }
}
