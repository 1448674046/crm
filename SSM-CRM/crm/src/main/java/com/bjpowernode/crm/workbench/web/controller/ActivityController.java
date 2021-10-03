package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateTimeUtil;
import com.bjpowernode.crm.commons.utils.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench/activity")
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    /**
     * 跳转到 activity 主页
     * @param model
     * @return String
     */
    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String toWorkbench(Model model){
        // 将 查询的全部用户信息 装载到 请求作用域
        List<User> userList = userService.queryAllUsers();
        model.addAttribute("userList", userList);
        return "workbench/activity/index";
    }

    /**
     * 添加市场活动
     * @param activity
     * @param session
     * @return returnObject
     */
    @RequestMapping(value = "/saveActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveActivity(Activity activity, HttpSession session){
        User user = (User) session.getAttribute("sessionUser");
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy(user.getId());
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = activityService.saveActivity(activity);
            if (num == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("添加成功！！！");
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试...");
        }
        return returnObject;
    }

    /**
     * 条件分页查询市场活动列表
     * @return Map<Activity>
     */
    @RequestMapping(value = "/queryActivityForPageByCondition.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> queryActivityForPageByCondition(int pageNo, int pageSize,String id, String name, String owner, String startDate, String endDate){
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", Integer.valueOf((pageNo - 1)*pageSize));
        map.put("pageSize", Integer.valueOf(pageSize));
        map.put("id", id);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        // 条件分页查询activity列表
        List<Activity> activityList = this.activityService.queryActivityForPageByCondition(map);
        // 查询记录条数
        int total = this.activityService.queryCountOfActivityByCondition(map);
        System.out.println("=================================" + total + "========================================");
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("activityList", activityList);
        returnMap.put("total", total);
        return returnMap;
    }

    /**
     * 删除市场活动
     * @param id
     * @return returnObject
     */
    @RequestMapping(value = "/deleteActivityByIds.do", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = this.activityService.deleteActivityByIds(id);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    /**
     * 修改市场活动列表【第一步: 根据 id 查询市场活动信息】
     * @param id
     * @return activity
     */
    @RequestMapping(value = "/editActivity.do", method = RequestMethod.GET)
    @ResponseBody
    public Activity editActivity(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    /**
     * 修改市场活动列表【第二步: 更新市场活动信息】
     * @param activity
     * @return returnObject
     */
    @RequestMapping(value = "/saveEditActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveEditActivity(Activity activity, HttpSession session){
        User user = (User) session.getAttribute("sessionUser");
        ReturnObject returnObject = new ReturnObject();
        activity.setEditBy(user.getId());
        activity.setEditTime(DateTimeUtil.getSysTime());
        try {
            int num = activityService.updateActivity(activity);
            if (num == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    /**
     * 根据 id 查询市场活动详情
     * @param id 市场活动id
     * @return String
     */
    @RequestMapping(value = "/detailActivity.do", method = RequestMethod.GET)
    public String detailActivity(String id, Model model){
        System.out.println(id);
        Activity activity = this.activityService.queryActivityForDetailById(id);
        model.addAttribute("activity", activity);
        return "workbench/activity/detail";
    }

}
