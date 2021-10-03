package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: SSM-CRM
 * @ClassName: TranController
 * @Package: com.bjpowernode.crm.workbench.web.controller
 * @description: 交易控制器
 * @create: 2021-09-22 00:15
 * @author: Mr.Zhao
 **/
@Controller
@RequestMapping(value = "/workbench/transaction")
public class TranController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private TranService tranService;

    /**
     * 跳转到 tran 主页面
     * @param model
     * @return model and view
     */
    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String index(Model model){
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/transaction/index";
    }

    /**
     * 跳转到 创建 tran 页面
     * @return model and view
     */
    @RequestMapping(value = "/createTran.do", method = RequestMethod.GET)
    public String createTran(Model model){
        // 查询用户信息
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("userList", userList);
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/transaction/save";
    }

    /**
     * 跳转到 编辑 tran 页面
     * @return model and view
     */
    @RequestMapping(value = "/editTran.do")
    public String editTran(String id, Model model){
        Tran tran = tranService.queryTranById(id);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("tran", tran);
        model.addAttribute("userList", userList);
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);

        return "workbench/transaction/edit";
    }

    /**
     * 跳转到交易详情页
     * @param id
     * @param model
     * @return model and view
     */
    @RequestMapping(value = "/tranDetail.do", method = RequestMethod.GET)
    public String tranDetail(String id, Model model){
        return "workbench/transaction/detail";
    }

    /**
     * 根据 ContactName 模糊查询联系人列表
     * @param name
     * @return returnObject
     */
    @RequestMapping(value = "/searchContactsListByName.do", method = RequestMethod.GET)
    @ResponseBody
    public Object queryContactsListByName(String name){
        ReturnObject returnObject = new ReturnObject();
        try {
            List<Contacts> contactsList = contactsService.queryContactsListByName(name);
            if (contactsList != null) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(contactsList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙，请稍后再试 ... ");
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 activityName 模糊查询市场活动列表
     * @param name
     * @return returnObject
     */
    @RequestMapping(value = "/searchActivityListByName.do", method = RequestMethod.GET)
    @ResponseBody
    public Object queryActivityListByName(String name){
        ReturnObject returnObject = new ReturnObject();
        try {
            List<Activity> activityList = activityService.queryActivityListByName(name);
            if (activityList != null) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙，请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 分页查询交易列表
     * @param pageNo
     * @param pageSize
     * @param owner
     * @param name
     * @param customerName
     * @param stage
     * @param type
     * @param source
     * @param contactsName
     * @return retMap
     */
    @RequestMapping(value = "/queryTranListForPageByCondition.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> queryTranListForPageByCondition(int pageNo, int pageSize,String id, String owner, String name, String customerName,
                                                               String stage, String type, String source, String contactsName){
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", (pageNo - 1) * pageSize);  // 跳过的记录条数
        map.put("pageSize", pageSize);
        map.put("id", id);
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerName", customerName);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsName", contactsName);

        List<Tran> tranList = this.tranService.queryTranListForPageByCondition(map);
        int total = this.tranService.queryCountOfTranByCondition(map);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("tranList", tranList);
        retMap.put("total", total);

        return retMap;
    }




}
