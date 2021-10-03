package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateTimeUtil;
import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 *  用户控制器
 */
@Controller
@RequestMapping(value = "/settings/qx/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 跳转到登录页
     * @return string
     */
    @RequestMapping({"/toLogin.do"})
    public String toLogin() {
        return "settings/qx/user/login";
    }
    /**
     * 用户登录
     * @param loginAct
     * @param loginPwd
     * @param isRemPwd
     * @param request
     * @param response
     * @param session
     * @return returnObject
     */
    @RequestMapping(value = "/login.do", method = RequestMethod.POST)
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", MD5Util.getMD5(loginPwd));      // 将密码转换成 MD5 密文
        User user = userService.queryUserByLoginActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();
        if (user == null) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或者密码不正确");
        } else if (user.getExpireTime().compareTo(DateTimeUtil.getSysTime()) > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("账号已过期");
        } else if ("0".equals(user.getLockState())){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("账号已冻结");
        } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("ip受限");
        } else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            session.setAttribute("sessionUser", user);
            if ("true".equals(isRemPwd)) {
                Cookie c1 = new Cookie("loginAct", loginAct);
                c1.setMaxAge(10 * 24 * 60 * 60);    // 设置 cookie 的有效期为 10 天
                response.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", loginPwd);
                c2.setMaxAge(10 * 24 * 60 * 60);
                response.addCookie(c2);
            } else {
                Cookie c1 = new Cookie("loginAct", Contants.RETURN_OBJECT_CODE_SUCCESS);
                c1.setMaxAge(0);
                response.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", Contants.RETURN_OBJECT_CODE_SUCCESS);
                c2.setMaxAge(0);
                response.addCookie(c2);
            }
        }
        return returnObject;
    }

    /**
     * 根据 id 查询用户密码
     * @return
     */
    @RequestMapping(value = "/queryUserById.do", method = RequestMethod.POST)
    @ResponseBody
    public User changePwd(String id){
        User user = userService.queryUserById(id);
        return user;
    }

    /**
     * 根据 id 更新用户密码
     * @return
     */
    @RequestMapping(value = "/updatePwd.do", method = RequestMethod.POST)
    @ResponseBody
    public Object updatePwdById(String id, String newPwd){
        int num = userService.updatePwdById(id, MD5Util.getMD5(newPwd));
        ReturnObject returnObject = new ReturnObject();
        if (num == 1) { // 更新成功
            returnObject.setMessage("密码更新成功！");
        } else {
            returnObject.setMessage("密码更新失败！");
        }
        return returnObject;
    }

    /**
     * 用户登出
     * @param response
     * @param session
     * @return
     */
    @RequestMapping({"/logout.do"})
    public String logout(HttpServletResponse response, HttpSession session) {
        Cookie c1 = new Cookie("loginAct", Contants.RETURN_OBJECT_CODE_SUCCESS);
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", Contants.RETURN_OBJECT_CODE_SUCCESS);
        c2.setMaxAge(0);
        response.addCookie(c2);

        // 销毁 session
        session.invalidate();

        // 重定向到 http://localhost:8080/crm; 会自动转成 response.sendRedirect("/crm"); 然后执行
        return "redirect:/";
    }

}
