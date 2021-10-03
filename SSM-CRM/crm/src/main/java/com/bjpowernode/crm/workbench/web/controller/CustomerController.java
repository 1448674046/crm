package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @program: SSM-CRM
 * @ClassName: CustomerController
 * @Package: com.bjpowernode.crm.workbench.web.controller
 * @description: 客户控制器
 * @create: 2021-09-20 21:34
 * @author: Mr.Zhao
 **/
@Controller
@RequestMapping(value = "/workbench/customer")
public class CustomerController {

    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String index(Model model){
        return "workbench/customer/index";
    }

}
