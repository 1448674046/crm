package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsMapper {

    //【线索转换】添加联系人
    void insertContacts(Contacts contacts);

    //【线索转换】添加联系人列表
    void insertContactsRemarkByList(List<ContactsRemark> contactsRemarkList);

    // 根据 ContactName 模糊查询联系人列表
    List<Contacts> selectContactsListByName(String name);
}
