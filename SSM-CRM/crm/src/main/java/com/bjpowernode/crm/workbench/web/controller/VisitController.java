package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @program: SSM-CRM
 * @ClassName: VisitController
 * @Package: com.bjpowernode.crm.workbench.web.controller
 * @description: 回访控制器
 * @create: 2021-09-22 00:25
 * @author: Mr.Zhao
 **/
@Controller
@RequestMapping(value = "/workbench/visit")
public class VisitController {

    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String index(Model model){
        return "workbench/visit/index";
    }

}
