package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.utils.DateTimeUtil;
import com.bjpowernode.crm.commons.utils.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    /**
     * 分页条件查询线索列表
     * @param map
     * @return clueList
     */
    @Override
    public List<Clue> queryClueForPageByCondition(Map<String, Object> map) {
        List<Clue> clueList = clueMapper.selectClueForPageByCondition(map);
        return clueList;
    }

    /**
     * 根据条件查询线索记录条数
     * @param map
     * @return count
     */
    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        int count = clueMapper.selectTotalByCondition(map);
        return count;
    }

    /**
     * 创建线索
     * @param clue
     * @return count
     */
    @Override
    public int saveCreateClue(Clue clue) {
        int count = clueMapper.insertClue(clue);
        return count;
    }

    /**
     * 根据 ClueId 删除单个或多个线索
     * @param ids
     * @return count
     */
    @Override
    public int deleteClueByIds(String[] ids) {
        int count = clueMapper.deleteClueByIds(ids);
        return count;
    }

    /**
     * 根据 ClueId 查询单条线索信息
     * @param id
     * @return clue
     */
    @Override
    public Clue queryClueById(String id) {
        Clue clue = clueMapper.selectClueById(id);
        return clue;
    }

    /**
     * 根据 ClueId 更新单条线索信息
     * @param clue
     * @return count
     */
    @Override
    public int saveEditClueById(Clue clue) {
        int count = clueMapper.updateClueById(clue);
        return count;
    }

    /**
     * 根据 ClueId 查询线索详情
     * @param id
     * @return clue
     */
    @Override
    public Clue queryClueForDetailById(String id) {
        Clue clue = clueMapper.selectClueForDetailById(id);
        return clue;
    }

    /**
     * 保存转换线索
     * @param map
     */
    @Override
    public void saveConvert(Map<String, Object> map) {
        // 取出 map 中的数据
        String clueId = (String) map.get("clueId");
        User user = (User) map.get("sessionUser");
        String isCreateTran = (String) map.get("isCreateTran");

        // 根据 clueId 查询当前的 clue 信息
        Clue clue = clueMapper.selectClueById(clueId);

        // 将查询到的 clue 中的公司信息保存到客户表中
        // 将参数封装为 customer 对象
        Customer customer = new Customer();
        customer.setId(UUIDUtil.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        // 调用 mapper 层的方法
        customerMapper.insertCustomer(customer);

        // 将查询到的 clue 中的个人信息加到联系人表中
        // 将参数封装为 contacts 对象
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullName(clue.getFullName());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        // 调用 mapper 层方法
        contactsMapper.insertContacts(contacts);

        // 根据 clueId 查询该线索下的所有备注信息
        // 【其目的单纯是为了将 线索备注表 中的内容备份到 交易备注表 中一份】
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkForSaveTranRemarkByClueId(clueId);

        if (clueRemarkList != null && clueRemarkList.size() > 0) {

            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();

            //遍历clueRemarkList
            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;

            for (ClueRemark cr : clueRemarkList) {
                // 封装CustomerRemark，把该线索下所有的备注转换到客户备注表中一份
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setNoteContent(cr.getNoteContent());
                customerRemark.setCreateBy(cr.getCreateBy());
                customerRemark.setCreateTime(cr.getCreateTime());
                customerRemark.setEditBy(cr.getEditBy());
                customerRemark.setEditTime(cr.getEditTime());
                customerRemark.setEditFlag(cr.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);

                // 封装ContactsRemark，把该线索下所有的备注转换到联系人备注表中一份
                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setNoteContent(cr.getNoteContent());
                contactsRemark.setCreateBy(cr.getCreateBy());
                contactsRemark.setCreateTime(cr.getCreateTime());
                contactsRemark.setEditBy(cr.getEditBy());
                contactsRemark.setEditTime(cr.getEditTime());
                contactsRemark.setEditFlag(cr.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            customerMapper.insertCustomerRemarkByList(customerRemarkList);
            contactsMapper.insertContactsRemarkByList(contactsRemarkList);
        }

        // 根据 clueId 查询线索市场活动关联表中的数据，将其保存到联系人市场活动关系表中
        // 一条 clueId 可能有多条市场活动
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);

        if (clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            // 遍历结果 clueActivityRelationList，将结果保存到联系人市场活动关系表
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            ContactsActivityRelation contactsActivityRelation = null;
            for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);
        }

        // 如果需要创建交易, 就往交易表中添加一条记录
        // ----- 往交易表中添加一条记录 start -----
        if ("true".equals(isCreateTran)) {
            // 封装参数
            Tran tran = new Tran();
            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(user.getId());
            tran.setMoney((String) map.get("amountOfMoney"));
            tran.setName((String) map.get("tradeName"));
            tran.setExpectedDate((String) map.get("expectedClosingDate"));
            tran.setCustomerId(customer.getId());
            tran.setStage((String) map.get("stage"));
            tran.setActivityId((String) map.get("activityId"));
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tranMapper.insertTran(tran);

            // 如果创建交易，还需要将该线索下的所有备注保存到交易备注表中
            if (clueRemarkList != null && clueRemarkList.size() > 0) {

                List<TranRemark> tranRemarkList = new ArrayList<>();

                for (ClueRemark clueRemark : clueRemarkList) {      // 遍历 clueRemarkList
                    TranRemark tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtil.getUUID());
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemark.setCreateBy(clueRemark.getCreateBy());
                    tranRemark.setCreateTime(DateTimeUtil.getSysTime());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditTime(clueRemark.getEditTime());
                    tranRemark.setEditFlag(clueRemark.getEditFlag());
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
            }
        }
        // ----- 往交易表中添加一条记录 end -----

        // 根据 clueId 删除线索备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);

        // 根据 clueId 删除该线索和市场活动的关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);

        // 根据 clueId 删除线索
        clueMapper.deleteClueById(clueId);
    }

}
