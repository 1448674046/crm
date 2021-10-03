package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    /**
     * 登录验证
     * @param paramMap
     * @return user
     */
    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> paramMap) {
        User user = userMapper.selectUserByLoginActAndPwd(paramMap);
        return user;
    }

    // 修改用户密码
    /**
     * 1.根据 id 查询用户信息
     * @param id
     * @return
     */
    @Override
    public User queryUserById(String id) {
        User user = userMapper.selectUserById(id);
        return user;
    }
    /**
     * 2.根据 id 更新用户密码
     * @param id
     * @param newPwd
     * @return
     */
    @Override
    public int updatePwdById(String id, String newPwd) {
        int count = userMapper.updateUserPwdById(id, newPwd);
        return count;
    }

    /**
     * 查询所有用户信息
     * @return userList
     */
    @Override
    public List<User> queryAllUsers() {
        List<User> userList = userMapper.selectAllUsers();
        return userList;
    }
}
