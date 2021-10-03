package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {

    //【线索转换】添加联系人市场活动关系
    void insertContactsActivityRelationByList(List<ContactsActivityRelation> contactsActivityRelationList);
}
