<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
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

	<script type="text/javascript" >
		$(function () {		// 页面加载完成

			// 加载时间控件
			$(".time").datetimepicker({
				language:'zh-CN',					// 汉化
				format:'yyyy-mm-dd',				// 选择日期后，文本框显示的日期格式
				minView:'month',					// 选择日期后，不会再跳转去选择时分秒
				initialDate:new Date(),
				autoclose:true,						// 选择日期后自动关闭
				todayBtn:true,
				clearBtn:true,
				pickerPosition: "top-right",		// 文本框出现的位置
				container:'#nextContactTimeDiv'		// 文本框在指定的 div 中生效
			});

			/**
			 * 为查询联系人按钮绑定单击事件
			 */
			$("#findContactsBtn").click(function () {
				// 打开模态框之前，清空表格中的数据
				$("#contactsBody").html("");
				// 清空搜索框的内容
				$("#search-contactsByName").val("");
				// 打开模态框
				$("#findContacts").modal("show");
			});

			/**
			 * 为查找联系人输入框绑定获得焦点事件
			 */
			$("#search-contactsByName").focus(function () {
				$("#contactsBody").html("");
			});

			/**
			 * 为查找联系人输入框绑定键盘键入事件
			 */
			$("#search-contactsByName").keydown(function (event) {
				if (event.keyCode == 13) {
					// alert("search-contactsByName");
					$.ajax({
						url : 'workbench/transaction/searchContactsListByName.do',
						data : {
							'name' : $.trim($("#search-contactsByName").val())
						},
						type : 'get',
						dataType : 'json',
						success : function (data) {	// data == returnObject { code, message, retData == contactsList {cont1, cont2, cont3, ...} }
							if (data.code == "1") {
								var html = '';
								$.each(data.retData, function (i, n) {
									html += '<tr>';
									html += '<td><input type="radio" name="contacts" value="'+ n.id +'"/></td>';
									html += '<td id="'+ n.id +'">'+ n.fullName +'</td>';
									html += '<td>'+ n.email +'</td>';
									html += '<td>'+ n.mphone +'</td>';
									html += '</tr>';
								});
								$("#contactsBody").html(html);
							} else {
								alert(data.message);
							}
						}
					});
					// 关闭模态框默认关闭行为
					return false;
				}
			});

			/**
			 * 为选择联系人按钮绑定单击事件
			 */
			$("#selectContactBtn").click(function () {
				// alert("确认选中联系人");
				var id = $("input[name=contacts]:checked").val();
				var fullName = $("#"+id).html();
				// alert(id + " == " + fullName);
				$("#create-contactsId").val(id);
				$("#create-contactsName").val(fullName);
				$("#findContacts").modal("hide");
			});

			/**
			 * 为查找市场活动源图标绑定单击事件
			 */
			$("#findActivityBtn").click(function () {
				// 将市场活动表格主体中的内容清空
				$("#activityBody").html("");
				// 清空搜索框的内容
				$("#search-activityByName").val("");
				// 打开模态框
				$("#findMarketActivity").modal("show");
			});

			/**
			 * 为查找市场活动输入框绑定键盘键事件
			 */
			$("#search-activityByName").keydown(function (event) {
				if (event.keyCode == "13") {
					// alert("查询市场活动");
					// alert($("#search-activityByName").val());
					$.ajax({
						url : 'workbench/transaction/searchActivityListByName.do',
						data : {
							'name' : $.trim($("#search-activityByName").val())
						},
						type : 'get',
						dataType : 'json',
						success : function (data) {	//	data == returnObject {code, message, retData == activityList{ act1, act2, act3, ... } }
							if (data.code == "1") {
								var html = "";
								$.each(data.retData, function (i, n) {
									html += '<tr>';
									html += '<td><input type="radio" name="activity" value="' + n.id + '"/></td>';
									html += '<td id="' + n.id + '">' + n.name + '</td>';
									html += '<td>' + n.startDate + '</td>';
									html += '<td>' + n.endDate + '</td>';
									html += '<td>' + n.owner + '</td>';
									html += '</tr>';
								});
								$("#activityBody").html(html);
							} else {
								alert(data.message);
							}
						}
					});
					return false;	// 关闭模态框自动关闭行为
				}
			});

			/**
			 * 为选择市场活动按钮绑定单击事件
			 */
			$("#selectActivityBtn").click(function () {
				var id = $("input[name=activity]:checked").val();
				var name = $("#"+id).html();
				// alert(id + " == " +name);
				$("#create-activityId").val(id);
				$("#create-activitySrc").val(name);
				$("#findMarketActivity").modal("hide");
			});

			/**
			 * 为保存交易按钮创建单击事件
			 */
			$("#saveCreateTranBtn").click(function () {
				alert("create Tran");
			});

		});
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-activityByName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityBody">
							<%--
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="selectActivityBtn" type="button" class="btn btn-primary">选择</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="search-contactsByName" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="contactsTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">
							<%--
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="selectContactBtn" type="button" class="btn btn-primary">选择</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateTranBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				  <option></option>
				  <c:forEach items="${userList}" var="user">
				  	<option value="${user.id}">${user.name}</option>
				  </c:forEach>
				  <%--
				  <option>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>
				  --%>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
				<option></option>
				<c:forEach items="${stageList}" var="stage">
					  <option value="${stage.value}">${stage.text}</option>
				</c:forEach>
			  	<%--
			  	<option></option>
			  	<option>资质审查</option>
			  	<option>需求分析</option>
			  	<option>价值建议</option>
			  	<option>确定决策者</option>
			  	<option>提案/报价</option>
			  	<option>谈判/复审</option>
			  	<option>成交</option>
			  	<option>丢失的线索</option>
			  	<option>因竞争丢失关闭</option>
			  	--%>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
					<option></option>
					<c:forEach items="${transactionTypeList}" var="transactionType">
						<option value="${transactionType.value}">${transactionType.text}</option>
					</c:forEach>
				  <%--
				  <option></option>
				  <option>已有业务</option>
				  <option>新业务</option>
				  --%>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
					<option></option>
					<c:forEach items="${sourceList}" var="source">
						<option value="${source.value}">${source.text}</option>
					</c:forEach>
				  <%--
				  <option></option>
				  <option>广告</option>
				  <option>推销电话</option>
				  <option>员工介绍</option>
				  <option>外部介绍</option>
				  <option>在线商场</option>
				  <option>合作伙伴</option>
				  <option>公开媒介</option>
				  <option>销售邮件</option>
				  <option>合作伙伴研讨会</option>
				  <option>内部研讨会</option>
				  <option>交易会</option>
				  <option>web下载</option>
				  <option>web调研</option>
				  <option>聊天</option>
				  --%>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="findActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-activityId">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="findContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId">
				<input type="text" class="form-control" id="create-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div id="nextContactTimeDiv" class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>