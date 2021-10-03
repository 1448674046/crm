package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerMapper {

    //【线索转换】添加新客户
    Integer insertCustomer(Customer customer);

    //【线索转换】添加客户备注列表
    void insertCustomerRemarkByList(List<CustomerRemark> customerRemarkList);
}
