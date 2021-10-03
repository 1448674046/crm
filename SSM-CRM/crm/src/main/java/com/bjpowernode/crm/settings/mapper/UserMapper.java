package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;


import java.util.List;
import java.util.Map;

public interface UserMapper {

    // 登录验证
    User selectUserByLoginActAndPwd(Map<String, Object> paramMap);

    // 修改密码
    // 1.根据 id 查询用户信息
    User selectUserById(@Param("userId") String id);
    // 2.根据 id 更新用户密码
    int updateUserPwdById(@Param("userId") String id, @Param("newPwd") String newPwd);

    // 查询所有用户信息
    List<User> selectAllUsers();
}
