<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>" />
	<meta charset="UTF-8">
		<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
		<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

		<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
		<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
		<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

		<link rel="stylesheet" type="text/css" href="static/jquery/bs_pagination/jquery.bs_pagination.min.css">
		<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
		<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>

	<script type="text/javascript">
		// 页面加载完成
		$(function(){
			// 加载时间控件
			$(".time").datetimepicker({
				language:'zh-CN',					// 汉化
				format:'yyyy-mm-dd',				// 选择日期后，文本框显示的日期格式
				minView:'month',					// 选择日期后，不会再跳转去选择时分秒
				initialDate:new Date(),
				autoclose:true,						// 选择日期后自动关闭
				todayBtn:true,
				clearBtn:true,
				container:'#createActivityModal',	// 在指定的容器中生效
				container:'#searchActivityForm',
			});

			// 页面加载完成时，加载分页查询方法
			queryActivityForPageByCondition(1, 2);

            /**
			 * 为 “查询按钮” 绑定 单击事件
			 */
            $("#searchBtn").click(function () {
				queryActivityForPageByCondition(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            });

            /**
			 * 为【市场活动名】搜索栏添加键盘键入事件
			 */
			$("#search-name").bind("keyup", function (event) {
				if (event.keyCode == 13) {
					// alert("回车键按下");
					queryActivityForPageByCondition(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
				}
			});

			/**
			 * 为【市场活动所有者】搜索栏添加键盘键入事件
			 */
			$("#search-owner").bind("keyup", function (event) {
				if (event.keyCode == 13) {
					// alert("回车键按下");
					queryActivityForPageByCondition(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
				}
			});

			/**
			 * 为 “创建按钮” 添加 单击事件
			 */
			$("#createActivityBtn").click(function () {
				// alert("saveActivityBtn");
				// 打开模态框
				$("#createActivityModal").modal("show");
			});

			/**
			 * 为 “保存按钮” 添加 单击事件
			 */
			$("#saveActivityBtn").click(function () {
				// alert("saveActivityBtn");
				// 每次保存之前，将隐藏域中的 id 清空
				// 将 id 存放到隐藏域中
				$("#search-activityId").val("");
				$.ajax({
					url:'workbench/activity/saveActivity.do',
					data:{
						owner:$.trim($("#create-activityOwner").val()),
						name:$.trim($("#create-activityName").val()),
						startDate:$.trim($("#create-startTime").val()),
						endDate:$.trim($("#create-endTime").val()),
						cost:$.trim($("#create-cost").val()),
						description:$.trim($("#create-describe").val())
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						/*
						 	data == ReturnObject { code, message }
						 */
						if (data.code == "1") {
							// 刷新列表
							// 添加之后返回第一页，保留用户设置的当前页的记录条数
							queryActivityForPageByCondition(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							$("#createActivityModal").modal("hide");
							// alert(data.message);
						} else {
							alert(data.message);
						}
					}
				});
				// 请求处理完成后 清空表单中的数据
				$("#saveActivityForm")[0].reset();
			});

			/**
			 * 为 “修改按钮” 创建 单击事件
			 */
            $("#editActivityBtn").click(function () {
                // alert("编辑市场活动");
                // 取得当前选中的活动
                // alert(checkedId);
                if ($("input[name=xz]:checked").size() != 1){
                    alert("请选择一条记录修改");
                    return;
                }
                var checkedId = $("#activityBody input[name=xz]:checked").val();
                // 1.根据id查询市场活动信息
                $.ajax({
                    url:'workbench/activity/editActivity.do',
                    data:{
                        id : checkedId
                    },
                    type:'get',
                    datatype:'json',
                    success:function (data) {   // data == activity{ 属性 }
                        $("#edit-id").val(data.id);
                        $("#edit-activityOwner").val(data.owner);
                        $("#edit-activityName").val(data.name);
                        $("#edit-startDate").val(data.startDate);
                        $("#edit-endDate").val(data.endDate);
                        $("#edit-cost").val(data.cost);
                        $("#edit-describe").val(data.description);
                    }
                });
                // 打开模态框
                $("#editActivityModal").modal("show");
            });

            /**
			 * 为 “更新按钮” 添加 单击事件
			 */
			$("#saveEditActivityBtn").click(function () {
				var id = $.trim($("#edit-id").val());
				var owner = $.trim($("#edit-activityOwner").val());
				var name = $.trim($("#edit-activityName").val());
				var startDate = $.trim($("#edit-startDate").val());
				var endDate = $.trim($("#edit-endDate").val());
				var cost = $.trim($("#edit-cost").val());
				var description = $.trim($("#edit-describe").val());

				// alert("保存更新");
				// 如果选择下拉框中的 value 值为 null
				if ($("#edit-activityOwner").val() == null) {
					alert("所有者不能为空！！！！！");
					return;
				}

				$.ajax({
					url:'workbench/activity/saveEditActivity.do',
					data:{
						         id : id,
						      owner : owner,
						       name : name,
						  startDate : startDate,
						    endDate : endDate,
						       cost : cost,
						description : description
					},
					type:'post',
					dataType:'json',
					success:function (data) {	// data == ReturnObject{code, message}
						if (data.code == "1") {
							// 1.更新成功后，将市场活动 id 存放到隐藏域中
							$("#search-activityId").val(id);

							// 2.再次查询前将所有的搜索框中的数据清空
							$("#search-name").val("");
							$("#search-owner").val("");
							$("#search-startDate").val("");
							$("#search-endDate").val("");

							// 3.根据市场活动 id 再查询一次
							queryActivityForPageByCondition(1,
															$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

							// 4.查询成功后，将存放到隐藏域中的市场活动 id 清空
							$("#search-activityId").val("");

							// 5.关闭模态框
							$("#editActivityModal").modal("hide");
						} else {
							alert(data.message);
							$("#editActivityModal").modal("hide");
						}
					}
				});
			});

			/**
			 * 为 “删除按钮” 添加单击事件
			 */
			$("#deleteActivityBtn").click(function () {
				// alert("删除按钮");
				var $xz = $("input[name='xz']:checked");	// deleteActivityById.do?id=1&id=2&id=3...
				if ($xz.length == 0) {
					alert("请选择一条记录要删除的记录！");
					return false;
				}
				var ids = "";
				for(var i=0; i<$xz.length; i++){
					ids += "id="+$($xz[i]).val();
					if(i<$xz.length-1){
						ids += "&";
					}
				}
				// alert(ids);
				if(confirm("确定要删除所选中的记录吗？")){
					$.ajax({
						url:'workbench/activity/deleteActivityByIds.do',
						data:ids,
						type:'post',
						dataType:'json',
						success:function (data) {	// data == ReturnObject
							if(data.code == "1"){
								queryActivityForPageByCondition(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								alert(data.message);
							}
						}
					});
				}
			});

			/**
			 * 为 “全选按钮” 设置 单击事件
			 */
			$("#check_all").click(function () {
				// alert("全部选中");
				$("#activityBody input[type='checkbox']").prop("checked",this.checked);
			});
			$("#activityBody").on("click", "input[type='checkbox']", function () {
				if ($("#activityBody input[type='checkbox']").size() == $("#activityBody input[type='checkbox']:checked").size()) {
					$("#check_all").prop("checked", true);
				} else {
					$("#check_all").prop("checked", false);
				}
			});
		});

		/**
		 * 分页查询函数
		 */
		function queryActivityForPageByCondition(pageNo, pageSize) {
            // 清空的全选框
            $("#check_all").prop("checked", false);

			// alert("加载市场活动列表！！！")
			$.ajax({
				url:'workbench/activity/queryActivityForPageByCondition.do',
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"id":$.trim($("#search-activityId").val()),
					"name":$.trim($("#search-name").val()),
					"owner":$.trim($("#search-owner").val()),
					"startDate":$.trim($("#search-startDate").val()),
					"endDate":$.trim($("#search-endDate").val())
				},
				type:'get',
				dataType:'json',
				success:function (data) {	// data == map{ activityList:{ {act1}, {act2},... }, total : 总记录条数}
					var html = "";
					$.each(data.activityList, function (i, n) {
						html += '<tr class="active">';
						html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detailActivity.do?id='+ n.id +'\';">'+ n.name +'</a></td>';
						html += '<td>' + n.owner + '</td>';
						html += '<td>' + n.startDate + '</td>';
						html += '<td>' + n.endDate + '</td>';
						html += '</tr>';
					});
					$("#activityBody").html(html);

					// 查询总页数
					var totalPages = data.total%pageSize==0? data.total/pageSize: parseInt(data.total/pageSize)+1;

					// 数据处理完成后, 结合分页查询, 对前端展现分页信息
					$("#activityPage").bs_pagination({
						currentPage : pageNo,        	// 页码
						rowsPerPage : pageSize,      	// 每页显示的记录条数
						maxRowsPerPage : 20,         	// 每页最多显示的记录条数
						totalPages : totalPages,     	// 总页数
						totalRows : data.total,  		// 总记录条数

						visiblePageLinks : 3,        	// 显示几个卡片

						showGoToPage : true,
						showRowsPerPage : true,
						showRowsInfo : true,
						showRowsDefaultInfo : true,

						onChangePage : function(event, data){
							queryActivityForPageByCondition(data.currentPage , data.rowsPerPage);
						}
					});
				}
			});
		}


	</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="saveActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-activityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-activityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-activityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-activityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveActivityBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
                        <input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-activityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-activityOwner">
									<option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-activityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-activityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditActivityBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form id="searchActivityForm" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
						<input type="hidden" id="search-activityId">
				      	<input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" readonly />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate" readonly />
				    </div>
				  </div>
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				</form>
			</div>

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="createActivityBtn" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editActivityBtn" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteActivityBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="check_all"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--
						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>
                        --%>
					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage" >

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>