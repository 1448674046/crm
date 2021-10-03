package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @program: SSM-CRM
 * @ClassName: ContactsServiceImpl
 * @Package: com.bjpowernode.crm.workbench.service.impl
 * @description:
 * @create: 2021-09-26 12:49
 * @author: Mr.Zhao
 **/
@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    /**
     * 根据 ContactName 模糊查询联系人列表
     * @param name
     * @return contactsList
     */
    @Override
    public List<Contacts> queryContactsListByName(String name) {
        List<Contacts> contactsList = contactsMapper.selectContactsListByName(name);
        return contactsList;
    }
}
