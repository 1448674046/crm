package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateTimeUtil;
import com.bjpowernode.crm.commons.utils.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @program: SSM-CRM
 * @ClassName: ClueRemarkController
 * @Package: com.bjpowernode.crm.workbench.web.controller
 * @description: 线索备注控制器
 * @create: 2021-09-23 08:54
 * @author: Mr.Zhao
 **/
@Controller
@RequestMapping(value = "/workbench/clueRemark")
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    /**
     * 添加线索备注
     * @param clueRemark
     * @param session
     * @return returnObject
     */
    @RequestMapping(value = "/saveCreateClueRemark.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);     // 从 session 正获取当前用户
        ReturnObject returnObject = new ReturnObject();

        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("0");

        try {
            int num = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 clueId 查询备注列表
     * @param clueId
     * @return clueRemarkList
     */
    @RequestMapping(value = "/getClueRemarkListByClueId.do", method = RequestMethod.GET)
    @ResponseBody
    public Object getClueRemarkList(String clueId){
        ReturnObject returnObject = new ReturnObject();

        List<ClueRemark> clueRemarkList = null;
        try {
            clueRemarkList = clueRemarkService.queryClueRemarkList(clueId);
            if (clueRemarkList != null) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemarkList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 id 删除单条线索备注
     * @param id
     * @return returnObject
     */
    @RequestMapping(value = "/deleteClueRemarkById.do")
    @ResponseBody
    public Object deleteClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = clueRemarkService.deleteClueRemarkById(id);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 id 查询单条线索备注
     * @param id
     * @return returnObject
     */
    @RequestMapping(value = "/editClueRemarkById.do", method = RequestMethod.GET)
    @ResponseBody
    public Object editClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            ClueRemark clueRemark = clueRemarkService.queryClueRemarkById(id);
            if (clueRemark != null) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 id 更新单条线索备注
     * @param clueRemark
     * @return returnObject
     */
    @RequestMapping(value = "/saveEditClueRemarkById.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveEditClueRemarkById(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clueRemark.setEditFlag("1");
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateTimeUtil.getSysTime());

        try {
            int num = clueRemarkService.saveEditClueRemarkById(clueRemark);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(" 系统忙, 请稍后再试 ... ");
        }

        return returnObject;
    }
}
