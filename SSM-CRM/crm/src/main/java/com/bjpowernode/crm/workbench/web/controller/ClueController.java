package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateTimeUtil;
import com.bjpowernode.crm.commons.utils.UUIDUtil;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench/clue")
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    /**
     * 跳转到Clue主页，并将数据字典中的数据值查出
     * @param model
     * @return model
     */
    @RequestMapping(value = "/index.do", method = RequestMethod.GET)
    public String index(Model model) {
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = this.dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = this.dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = this.dicValueService.queryDicValueByTypeCode("source");
        model.addAttribute("userList", userList);
        model.addAttribute("appellationList", appellationList);
        model.addAttribute("clueStateList", clueStateList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/clue/index";
    }

    /**
     * 分页条件查询线索列表
     * @param pageNo
     * @param pageSize
     * @return returnMap
     */
    @RequestMapping(value = "/queryClueForPageByCondition.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> queryClueForPageByCondition(int pageNo, int pageSize, Clue clue){
        System.out.println("pageNo" + pageNo);
        System.out.println("pageSize" + pageSize);

        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", ((pageNo-1)*pageSize));
        map.put("pageSize", pageSize);
        map.put("id", clue.getId());
        map.put("fullName", clue.getFullName());
        map.put("company", clue.getCompany());
        map.put("phone", clue.getPhone());
        map.put("source", clue.getSource());
        map.put("owner", clue.getOwner());
        map.put("mphone", clue.getMphone());
        map.put("state", clue.getState());

        List<Clue> clueList = clueService.queryClueForPageByCondition(map);
        int total = clueService.queryCountOfClueByCondition(map);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("clueList", clueList);
        returnMap.put("total", total);
        return returnMap;
    }

    /**
     * 创建线索
     * @param clue
     * @return returnObject
     */
    @RequestMapping(value = "/saveCreateClue.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute("sessionUser");
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        try {
            int num = clueService.saveCreateClue(clue);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 ClueId 删除单个或多个线索
     * @param ids
     * @return returnObject
     */
    @RequestMapping(value = "/deleteClueByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteClueByIds(@RequestParam(value = "id") String[] ids){
        ReturnObject returnObject = new ReturnObject();
        System.out.println(ids);
        try {
            int num = clueService.deleteClueByIds(ids);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 根据 ClueId 查询单条线索信息
     * @param id
     * @return clue
     */
    @RequestMapping(value = "/editClueById", method = RequestMethod.GET)
    @ResponseBody
    public Clue editClueBtnById(String id){
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    /**
     * 根据 ClueId 更新单条线索信息
     * @param clue
     * @param session
     * @return returnObject
     */
    @RequestMapping(value = "/saveEditClueById", method = RequestMethod.POST)
    @ResponseBody
    public Object saveEditClueById(Clue clue, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute("sessionUser");
        clue.setEditBy(user.getId());
        clue.setEditTime(DateTimeUtil.getSysTime());
        try {
            int num = clueService.saveEditClueById(clue);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clue);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试 ... ");
        }
        return  returnObject;
    }

    /**
     * 根据 clueId 查询线索详情和市场活动列表
     * @param id 市场活动id
     * @return String
     */
    @RequestMapping(value = "/detailClue.do", method = RequestMethod.GET)
    public String detailClue(String id, Model model){
        System.out.println(id);
        Clue clue = this.clueService.queryClueForDetailById(id);
        // 根据 clueId 查询已关联的市场活动列表
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
        model.addAttribute("clue", clue);
        model.addAttribute("activityList", activityList);
        return "workbench/clue/detail";
    }

    /**
     * 根据 市场活动名 搜索 市场活动列表
     * @param activityName
     * @param clueId
     * @return activityList
     */
    @RequestMapping(value = "/searchActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public List<Activity> searchActivity(String activityName, String clueId){
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);
        List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);
        return activityList;
    }

    /**
     * 保存关联
     * @param activityId
     * @param clueId
     * @return returnObject
     */
    @RequestMapping(value = "/saveBundActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveBundActivity(String[] activityId, String clueId){
        List<ClueActivityRelation> relationList = new ArrayList<>();
        ClueActivityRelation car = null;
        for (String aid : activityId) {
            car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);
            car.setActivityId(aid);
            relationList.add(car);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = clueActivityRelationService.saveCreateClueActivityRelation(relationList);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                List<Activity> activityList = activityService.queryActivityByIds(activityId);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 解除关联
     * @param clueId
     * @param activityId
     * @return returnObject
     */
    @RequestMapping(value = "/saveUnbundActivity.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveUnbundActivity(String clueId, String activityId){
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = clueActivityRelationService.saveUnbundActivity(clueId, activityId);
            if (num > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试 ... ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

    /**
     * 跳转到线索转换页面
     * @param id 市场活动id
     * @return String
     */
    @RequestMapping(value = "/convertClue.do", method = RequestMethod.GET)
    public String doConvert(String id, Model model){
        System.out.println(id);
        try {
            // 根据 clueId 查询线索信息
            Clue clue = clueService.queryClueForDetailById(id);
            // 查询阶段列表
            List<DicValue> dicValueList = dicValueService.queryDicValueByTypeCode("stage");
            model.addAttribute("clue", clue);
            model.addAttribute("dicValueList", dicValueList);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "workbench/clue/convert";
    }

    /**
     * 根据 activityName 模糊查询市场活动列表
     * @param activityName
     * @return activityList
     */
    @RequestMapping(value = "/queryActivityListByName.do", method = RequestMethod.POST)
    @ResponseBody
    public List<Activity> queryActivityListByName(String activityName){
        List<Activity> activityList = null;
        try {
            activityList = activityService.queryActivityListByName(activityName);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return activityList;
    }

    /**
     * 保存转换线索
     * @param clueId
     * @param isCreateTran
     * @param amountOfMoney
     * @param tradeName
     * @param expectedClosingDate
     * @param stage
     * @param activityId
     * @return returnObject
     */
    @RequestMapping(value = "/saveConvertClue.do", method = RequestMethod.POST)
    @ResponseBody
    public Object saveConvertClue(String clueId, String isCreateTran, String amountOfMoney, String tradeName,
                                  String expectedClosingDate, String stage, String activityId, HttpSession session){
        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("clueId", clueId);
        map.put("isCreateTran", isCreateTran);
        map.put("amountOfMoney", amountOfMoney);
        map.put("tradeName", tradeName);
        map.put("expectedClosingDate", expectedClosingDate);
        map.put("stage", stage);
        map.put("activityId", activityId);
        map.put("sessionUser", session.getAttribute(Contants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try {
            // 如果该条语句执行完成，则表明事务执行都成功
            clueService.saveConvert(map);

            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试 ... ");
        }
        return returnObject;
    }

}
