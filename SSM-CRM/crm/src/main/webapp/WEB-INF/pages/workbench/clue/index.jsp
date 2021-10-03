<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
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
			pickerPosition: "top-left",			// 文本框出现的位置
		});

		// 页面加载完成时，加载分页查询方法
		queryClueForPageByCondition(1, 2);

		/**
		 * 为查询按钮绑定单击事件
		 */
		$("#searchBtn").click(function () {
			// alert("searchBtn");
			queryClueForPageByCondition(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
		});

		/**
		 * 为 “创建按钮” 绑定单击事件
		 */
		$("#createClueBtn").click(function () {
			// alert("#createClueBtn");
			$("#createClueModal").modal("show");
		});

		/**
		 * 为 “保存按钮” 绑定单击事件
		 */
		$("#saveCreateClueBtn").click(function () {
			// alert("saveCreateClueBtn");
			var owner=$("#create-clueOwner").val();
			var company=$.trim($("#create-company").val());
			var appellation=$("#create-appellation").val();
			var fullName=$.trim($("#create-fullName").val());
			var job=$.trim($("#create-job").val());
			var email=$.trim($("#create-email").val());
			var phone=$.trim($("#create-phone").val());
			var website=$.trim($("#create-website").val());
			var mphone=$.trim($("#create-mphone").val());
			var state=$("#create-state").val();
			var source=$("#create-source").val();
			var description=$.trim($("#create-description").val());
			var contactSummary=$.trim($("#create-contactSummary").val());
			var nextContactTime=$("#create-nextContactTime").val();
			var address=$.trim($("#create-address").val());

			$.ajax({
				url : 'workbench/clue/saveCreateClue.do',
				data : {
					owner : owner,
					company : company,
					appellation : appellation,
					fullName : fullName,
					job : job,
					email : email,
					phone : phone,
					website : website,
					mphone : mphone,
					state : state,
					source : source,
					description : description,
					contactSummary : contactSummary,
					nextContactTime : nextContactTime,
					address : address
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {		// data = returnObject { code, message }
					if (data.code == "0") {
						alert(data.message);
					} else if (data.code == "1"){
						// 再查一遍，跳转到第一页，保存每页显示的记录条数
						queryClueForPageByCondition(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createClueModal").modal("hide");
					}
				}
			});
			// 清空保存线索表单中的数据
			$("#saveCreateClueForm")[0].reset();
		});

		/**
		 * 为 “删除按钮” 设置 单击事件
		 */
		$("#removeClueBtn").click(function () {
			// alert("removeClueBtn");
			// 获取选中框的 id 值
			var $xz = $("input[name='xz']:checked");
			if ($xz.length == 0) {
				alert("请选择一条记录进行删除!");
				return;
			}
			var ids="";
			for (var i=0; i<$xz.length; i++) {		// removeClueById?id=1$id=2$id=3...
				ids += "id=" + $($xz[i]).val();
				if (i<$xz.length-1) {
					ids += "&";
				}
			}
			// alert(ids);
			if (confirm("确定要删除选中的线索吗？")) {
				$.ajax({
					url : 'workbench/clue/deleteClueByIds',
					data : ids,
					type : 'post',
					dataType : 'json',
					success : function (data) {		// data == returnObject {code, message }
						if (data.code == "0") {
							alert(data.message);
						} else {
							queryClueForPageByCondition(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						}
					}
				});
			}
		});

		/**
		 * 为 “修改按钮” 绑定单击事件
		 */
		$("#editClueBtn").click(function () {
			// alert("editClueBtn");
			var $xz = $("input[name=xz]:checked");
			if ($xz.length != 1) {
				alert("请选择单条记录修改！！！");
				return;
			}
			var checkId = $xz.val();
			// alert(checkId);
			$.ajax({
				url : 'workbench/clue/editClueById',
				data : {
					id : checkId
				},
				type : 'get',
				dataType : 'json',
				success : function (data) {		// data == Clue { 属性 }
					$("#edit-id").val(data.id);
					$("#edit-fullName").val(data.fullName);
					$("#edit-appellation").val(data.appellation);
					$("#edit-clueOwner").val(data.owner);
					$("#edit-company").val(data.company);
					$("#edit-job").val(data.job);
					$("#edit-email").val(data.email);
					$("#edit-phone").val(data.phone);
					$("#edit-website").val(data.website);
					$("#edit-mphone").val(data.mphone);
					$("#edit-state").val(data.state);
					$("#edit-source").val(data.source);
					$("#edit-editBy").val(data.editBy);
					$("#edit-editTime").val(data.editTime);
					$("#edit-description").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);
				}
			});
			// 处理完成后打开模态框
			$("#editClueModal").modal("show");
		});

		/**
		 * 为 “更新按钮” 绑定单击事件
		 */
		$("#saveEditClueBtn").click(function () {
			// alert("saveEditClueBtn");
			// alert(checkId);
			var id = $.trim($("#edit-id").val());
			var fullName = $.trim($("#edit-fullName").val());
			var appellation = $.trim($("#edit-appellation").val());
			var clueOwner = $.trim($("#edit-clueOwner").val());
			var company = $.trim($("#edit-company").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var mphone = $.trim($("#edit-mphone").val());
			var state = $.trim($("#edit-state").val());
			var source = $.trim($("#edit-source").val());
			var editBy = $.trim($("#edit-editBy").val());
			var editTime = $.trim($("#edit-editTime").val());
			var description = $.trim($("#edit-description").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $.trim($("#edit-nextContactTime").val());
			var address = $.trim($("#edit-address").val());

			$.ajax({
				url : 'workbench/clue/saveEditClueById',
				data : {
					id 				: id,
					fullName		: fullName,
					appellation		: appellation,
					owner			: clueOwner,
					company			: company,
					job				: job,
					email			: email,
					phone			: phone,
					website			: website,
					mphone			: mphone,
					state			: state,
					source			: source,
					editBy			: editBy,
					editTime		: editTime,
					description		: description,
					contactSummary	: contactSummary,
					nextContactTime	: nextContactTime,
					address			: address
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {		// data == returnObject {code, message, retData}
					if (data.code == "1") {
						// 1.保存更新之前将 clueId 存放到隐藏域中
						$("#search-clueId").val(id);

						// 2.查询之间将所有输入框中的数据清空
						$("#search-fullName").val("");
						$("#search-company").val("");
						$("#search-phone").val("");
						$("#search-source").val("");
						$("#search-owner").val("");
						$("#search-mphone").val("");
						$("#search-state").val("");

						// 3.根据线索 id 再查询一遍
						queryClueForPageByCondition(1,
													$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));

						// 4.根据 id 查询完成后，将之前存放到隐藏域中的 clueId 清空
						$("#search-clueId").val("");

						// 5.关闭模态框
						$("#editClueModal").modal("hide");
					} else {
						alert(data.message);
					}
				}
			});
		});

		/**
		 * 为 “全选按钮” 设置 单击事件
		 */
		$("#check_all").click(function () {
			// alert("全部选中");
			$("#clueBody input[type='checkbox']").prop("checked",this.checked);
		});
		$("#clueBody").on("click", "input[type='checkbox']", function () {
			if ($("#clueBody input[type='checkbox']").size() == $("#clueBody input[type='checkbox']:checked").size()) {
				$("#check_all").prop("checked", true);
			} else {
				$("#check_all").prop("checked", false);
			}
		});

	});

	/**
	 * 分页查询函数[ 条件分页查询线索列表 ]
	 */
	function queryClueForPageByCondition(pageNo, pageSize) {
		// 清空的全选框
		$("#check_all").prop("checked", false);
		// alert($.trim($("#search-clueId").val()));
		$.ajax({
			url:'workbench/clue/queryClueForPageByCondition.do',
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"id":$.trim($("#search-clueId").val()),
				"fullName":$.trim($("#search-fullName").val()),
				"company":$.trim($("#search-company").val()),
				"phone":$.trim($("#search-phone").val()),
				"source":$.trim($("#search-source").val()),
				"owner":$.trim($("#search-owner").val()),
				"mphone":$.trim($("#search-mphone").val()),
				"state":$.trim($("#search-state").val())
			},
			type:'get',
			dataType:'json',
			success:function (data) {	// data == returnMap{ clueList:{ {clue1}, {clue2},... }, total : 总记录条数}
				var html = "";
				$.each(data.clueList, function (i, n) {
					html += '<tr>'
					html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detailClue.do?id='+ n.id +'\'">'+ n.fullName + n.appellation +'</a></td>'
					// html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.jsp\'">'+ n.fullname + n.appellation +'</a></td>'
					html += '<td>'+ n.company +'</td>'
					html += '<td>'+ n.phone +'</td>'
					html += '<td>'+ n.mphone +'</td>'
					html += '<td>'+ n.source +'</td>'
					html += '<td>'+ n.owner +'</td>'
					html += '<td>'+ n.state +'</td>'
					html += '</tr>'
				});
				$("#clueBody").html(html);

				// 查询总页数
				var totalPages = data.total%pageSize==0? data.total/pageSize: parseInt(data.total/pageSize)+1;

				// 数据处理完成后, 结合分页查询, 对前端展现分页信息
				$("#cluePage").bs_pagination({
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
						queryClueForPageByCondition(data.currentPage , data.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="saveCreateClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="appellation">
								  	<option value="${appellation.value}">${appellation.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  	<option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  	<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateClueBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input id="edit-id" hidden>
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								 	<option></option>
								 	<c:forEach items="${appellationList}" var="appellation">
								 		<option value="${appellation.value}">${appellation.text}</option>
								 	</c:forEach>
								</select>
							</div>
							<label for="edit-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditClueBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
						<input id="search-clueId" type="hidden">
						<input id="search-fullName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="search-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="search-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="search-source" class="form-control">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="search-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="search-state" class="form-control">
						  <option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.value}">${clueState.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createClueBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editClueBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="removeClueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="check_all" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
						<%--
						<tr>
                    	    <td><input type="checkbox" /></td>
                    	    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                    	    <td>动力节点</td>
                    	    <td>010-84846003</td>
                    	    <td>12345678901</td>
                    	    <td>广告</td>
                    	    <td>zhangsan</td>
                    	    <td>已联系</td>
                    	</tr>
                    	<tr class="active">
                    	    <td><input type="checkbox" /></td>
                    	    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                    	    <td>动力节点</td>
                    	    <td>010-84846003</td>
                    	    <td>12345678901</td>
                    	    <td>广告</td>
                    	    <td>zhangsan</td>
                    	    <td>已联系</td>
                    	</tr>
                    	--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage" >

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>