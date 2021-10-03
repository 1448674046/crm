package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @program: SSM-CRM
 * @ClassName: ContactsController
 * @Package: com.bjpowernode.crm.workbench.web.controller
 * @description: 联系人控制器
 * @create: 2021-09-22 00:03
 * @author: Mr.Zhao
 **/
@Controller
@RequestMapping(value = "/workbench/contacts")
public class ContactsController {

    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String index(Model model){
        return "workbench/contacts/index";
    }

}
