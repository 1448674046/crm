package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateTimeUtil;
import com.bjpowernode.crm.commons.utils.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping(value = "/workbench/activityRemark")
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 添加市场活动备注
     * @param remark
     * @param session
     * @return returnObject
     */
    @RequestMapping(value = "/saveCreateActivityRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark remark, HttpSession session) {
        User user = (User) session.getAttribute("sessionUser");
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(user.getId());
        remark.setEditFlag("0");
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = activityRemarkService.saveCreateActivityRemark(remark);
            if (num == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据市场活动id查询备注列表
     * @return returnObject
     */
    @RequestMapping(value = "/getRemarkListByAid.do", method = RequestMethod.GET)
    @ResponseBody
    public Object getRemarkListByAid(String activityId) {
        ReturnObject returnObject = new ReturnObject();
        List<ActivityRemark> activityRemarkList = null;
        try {
            activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(activityId);
            if (activityRemarkList != null) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemarkList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙, 请稍后重试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙, 请稍后重试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 id 删除单条备注
     * @return returnObject
     */
    @RequestMapping(value = "/deleteRemarkById.do", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = activityRemarkService.deleteRemarkById(id);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙, 请稍后重试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙, 请稍后重试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 id 查询单条备注
     * @param id
     * @return returnObject
     */
    @RequestMapping(value = "/editRemarkById.do", method = RequestMethod.GET)
    @ResponseBody
    public Object getRemarkById(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            ActivityRemark activityRemark = activityRemarkService.queryActivityRemarkById(id);
            if (activityRemark != null) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙, 请稍后重试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙, 请稍后重试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 id 更新单条备注信息
     * @param remark
     * @return returnObject
     */
    @RequestMapping(value = "/saveEditRemarkById.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveEditActivityRemarkById(ActivityRemark remark, HttpSession session){
        User user = (User) session.getAttribute("sessionUser");
        remark.setEditFlag("1");
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditBy(user.getId());
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = activityRemarkService.saveEditActivityRemarkById(remark);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙, 请稍后重试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙, 请稍后重试 ... ");
        }
        return returnObject;
    }

}
