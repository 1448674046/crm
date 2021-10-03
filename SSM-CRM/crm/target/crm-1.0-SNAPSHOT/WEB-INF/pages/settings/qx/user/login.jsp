<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" +
			request.getServerName() + ":" + request.getServerPort() +
			request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>"/>
    <meta charset="UTF-8">
	<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            // 页面加载完毕时，给键盘绑定键入事件
            $(window).keydown(function (e) {
                if (e.keyCode == 13){
                    $("#loginBtn").click();
                }
            });
            $("#loginBtn").click(function () {
                var loginAct = $.trim($("#loginAct").val());
                var loginPwd = $.trim($("#loginPwd").val());
                var isRemPwd = $.trim($("#isRemPwd").val());
                if (loginAct == "") {
                    alert("用户名不能为空!");
                    return;
                }
                if (loginPwd == "") {
                    alert("密码不能为空");
                    return;
                }
                $.ajax({
                    url:'settings/qx/user/login.do',
                    data:{
                        loginAct:loginAct,
                        loginPwd:loginPwd,
                        isRemPwd:isRemPwd
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        /*  data = returnObject{
                                code: 0/1
                                message: "msg"
                            }                       */
                        if (data.code == "1"){  // 验证通过，跳转到主页
                            window.location.href="workbench/index.do";
                        } else {
                            $("#msg").text(data.message);
                        }
                    },
					beforeSend:function(){	//在ajax发送异步请求之前执行本函数，函数返回值是true或者false；当返回true时，ajax会真正向后台发请求，否则，则ajax放弃向后台发请求。
						//显示提示信息
						$("#msg").text("正在验证....");
						return true;
					}
                });
            });
        });
    </script>
</head>

<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="static/images/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
                        <label>
                            <c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
                                <input type="checkbox" id="isRemPwd" checked="true">
                            </c:if>
                            <c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
                                <input type="checkbox" id="isRemPwd">
                            </c:if>
							十天内免登录
                        </label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>