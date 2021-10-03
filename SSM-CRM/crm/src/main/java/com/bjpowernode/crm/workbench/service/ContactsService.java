package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {

    // 根据 ContactName 模糊查询联系人列表
    List<Contacts> queryContactsListByName(String name);
}
