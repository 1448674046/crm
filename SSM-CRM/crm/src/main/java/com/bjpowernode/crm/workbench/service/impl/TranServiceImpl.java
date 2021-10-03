package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.mapper.TranMapper;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @program: SSM-CRM
 * @ClassName: TranServiceImpl
 * @Package: com.bjpowernode.crm.workbench.service.impl
 * @description:
 * @create: 2021-09-25 15:30
 * @author: Mr.Zhao
 **/
@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;

    /**
     * 分页查询交易列表
     * @param map
     * @return tranList
     */
    @Override
    public List<Tran> queryTranListForPageByCondition(Map<String, Object> map) {
        List<Tran> tranList = tranMapper.selectTranListForPageByCondition(map);
        return tranList;
    }

    /**
     * 分页查询交易记录条数
     * @param map
     * @return count
     */
    @Override
    public int queryCountOfTranByCondition(Map<String, Object> map) {
        int count = tranMapper.selectTranCount(map);
        return count;
    }

    /**
     * 根据交易 id 查询单条交易信息
     * @param id
     * @return tran
     */
    @Override
    public Tran queryTranById(String id) {
        Tran tran = tranMapper.selectTranById(id);
        return tran;
    }
}
