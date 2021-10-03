package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    // 登录验证
    User queryUserByLoginActAndPwd(Map<String, Object> paramMap);

    // 修改密码
    // 1.根据 id 查询用户信息
    User queryUserById(String id);
    // 2.根据 id 更新用户密码
    int updatePwdById(String id, String newPwd);

    // 查询所有用户信息
    List<User> queryAllUsers();
}
