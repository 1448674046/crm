package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ClueRemarkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @program: SSM-CRM
 * @ClassName: ClueRemarkServiceImpl
 * @Package: com.bjpowernode.crm.settings.service.impl
 * @description:
 * @create: 2021-09-23 21:56
 * @author: Mr.Zhao
 **/
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    /**
     * 添加线索备注
     * @param clueRemark
     * @return count
     */
    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        int count = clueRemarkMapper.insertClueRemark(clueRemark);
        return count;
    }

    /**
     * 根据 clueId 查询线索备注列表
     * @param clueId
     * @return clueRemarkList
     */
    @Override
    public List<ClueRemark> queryClueRemarkList(String clueId) {
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        return clueRemarkList;
    }

    /**
     * 根据 id 删除单条线索备注
     * @param id
     * @return count
     */
    @Override
    public int deleteClueRemarkById(String id) {
        int count = clueRemarkMapper.deleteClueRemarkById(id);
        return count;
    }

    /**
     * 根据 id 查询单条线索备注
     * @param id
     * @return clueRemark
     */
    @Override
    public ClueRemark queryClueRemarkById(String id) {
        ClueRemark clueRemark = clueRemarkMapper.selectClueRemarkById(id);
        return clueRemark;
    }

    /**
     * 根据 id 更新单条线索备注
     * @param clueRemark
     * @return count
     */
    @Override
    public int saveEditClueRemarkById(ClueRemark clueRemark) {
        int count = clueRemarkMapper.updateClueRemarkById(clueRemark);
        return count;
    }


}
