<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>" />
	<meta charset="UTF-8">

	<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

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
			container:'#dealDate',				// 在指定的容器中生效
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		/**
		 * 为打开市场活动搜索模态框按钮设置单击事件
		 */
		$("#openSearchModalBtn").click(function () {
			// alert("开启模态框");
			$("#searchActivityModal").modal("show");
		});

		/**
		 * 为市场活动模态窗口的搜索框添加键盘键入事件
		 */
		$("#search-activityByName").keydown(function(event) {
			if (event.keyCode == 13) {
				// alert("键盘键入");
				$.ajax({
					url : "workbench/clue/queryActivityListByName.do",
					data : {
						"activityName" : $.trim($("#search-activityByName").val())
					},
					type : 'post',
					dataType : 'json',
					success : function (data) {	// data == activityList{act1, act2, act3, ... }
						var html = "";
						$.each(data, function (i, n) {
							html += '<tr>';
							html += '<td><input type="radio" name="xz" value="' + n.id + '"/></td>';
							html += '<td id="' + n.id + '">' + n.name + '</td>';
							html += '<td>' + n.startDate + '</td>';
							html += '<td>' + n.endDate + '</td>';
							html += '<td>' + n.owner + '</td>';
							html += '</tr>';
						});
						$("#activityBody").html(html);
					}
				});
				// 将模态窗口的默认回车行为禁用
				return false;
			}
		});

		/**
		 * 为提交（市场活动）按钮设置单击事件
		 */
		$("#submitActivityBtn").click(function () {
            var id = $("input[name=xz]:checked").val();
            var name = $("#"+id).html();
		    if (confirm("确定提交所选中吗？")) {
		        // alert(id + "==" +name);
                $("#activityId").val(id);
                $("#activityName").val(name);
                $("#searchActivityModal").modal("hide");
            }
        });

        /**
         * 为转换按钮设置单击事件
         */
        $("#convertBtn").click(function () {
            // alert("线索转换");
			var clueId = '${clue.id}';

			var isCreateTran = $("#isCreateTransaction").prop("checked");		// true or false

			var amountOfMoney = $.trim($("#amountOfMoney").val());
			var tradeName = $.trim($("#tradeName").val());
			var expectedClosingDate = $.trim($("#expectedClosingDate").val());
			var stage = $.trim($("#stage").val());
			var activityId = $.trim($("#activityId").val());

			if (isCreateTran) {

			}

			$.ajax({
				url : "workbench/clue/saveConvertClue.do",
				data : {
					clueId : clueId,
					isCreateTran : isCreateTran,
					amountOfMoney : amountOfMoney,
					tradeName : tradeName,
					expectedClosingDate : expectedClosingDate,
					stage : stage,
					activityId : activityId
				},
				type : "post",
				dataType : "json",
				success : function (data) {		// data == returnObject { code, message, retData }
					if (data.code == "1") {
						window.location.href = "workbench/clue/index.do";
					} else {
						//提示信息
						alert(data.message);
					}
				}
			});
        });
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
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
								<td></td>
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
                    <button id="submitActivityBtn" type="button" class="btn btn-primary">提交</button>
                </div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullName}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullName}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName">
		  </div>
		  <div id="dealDate" class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${dicValueList}" var="dicValue" >
					<option value="${dicValue.text}">${dicValue.text}</option>
				</c:forEach>
		    	<%--
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
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
            <input type="hidden" id="activityId">
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>