<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" +
			request.getServerName() + ":" + request.getServerPort() +
			request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>"/>
	<meta charset="UTF-8">

	<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript">

		//默认情况下取消和保存按钮是隐藏的
		var cancelAndSaveBtnDefault = true;

		$(function(){
			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
			});

			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});

			$(".remarkDiv").mouseover(function(){
				$(this).children("div").children("div").show();
			});

			$(".remarkDiv").mouseout(function(){
				$(this).children("div").children("div").hide();
			});

			$(".myHref").mouseover(function(){
				$(this).children("span").css("color","red");
			});

			$(".myHref").mouseout(function(){
				$(this).children("span").css("color","#E6E6E6");
			});

			// 页面加载完成后, 展现关联市场活动的备注信息列表
			showRemarkList();

			// 添加备注
			// 为保存按钮添加鼠标单击事件
			$("#saveRemarkBtn").click(function () {
				if ($.trim($("#remark").val()) == "") {
					alert("添加的备注不能为空！！！");
				} else {
					$.ajax({
						url : "workbench/activityRemark/saveCreateActivityRemark.do",
						data : {
							"noteContent" : $.trim($("#remark").val()),
							"activityId" : "${activity.id}"
						},
						type : "post",
						dataType : "json",
						success : function (data) {		// data == returnObject{ code, message, retData }
							if (data.code == "1"){
								// 在后台根据id查单条 ActivityRemark 信息
								// 赋值
								var html = "";

								html += '<div class="remarkDiv" id="'+data.retData.id+'" style="height: 60px;">';
								html += '<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">';
								html += '<div style="position: relative; top: -40px; left: 40px;" >';
								html += '<h5 id="nc'+data.retData.id+'">' + data.retData.noteContent + '</h5>';
								html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;">'+(data.retData.editFlag==0? data.retData.createTime: data.retData.editTime)+' 由 '+ "${sessionScope.sessionUser.name}" +' 创建 </small>';
								html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
								html += '<a class="myHref" href="javascript:void(0);" onclick="editRemarkById(\''+ data.retData.id +'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
								html += '&nbsp;&nbsp;&nbsp;&nbsp;';
								html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.retData.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
								html += '</div>';
								html += '</div>';
								html += '</div>';

								// 再将该记录追加至对行文本域上方
								$("#remarkDiv").before(html);
								// 之后将输入框中的信息清空
								$("#remark").val("");

							} else {
								alert(data.message);
							}
						}
					});
				}
			});
		});

		// 根据 activityId 查询备注列表
		function showRemarkList() {
			$.ajax({
				url : "workbench/activityRemark/getRemarkListByAid.do",
				data : {
					"activityId" : "${activity.id}"
				},
				type : "get",
				dataType : "json",
				success : function (data) {		// data == returnObject { code, message, retData == remarkList{ {remark1}, {remark2}, ...  } }
					if (data.code == "0") {
						alert(data.message);
					} else if (data.code == "1"){	// 查询成功，遍历列表

						var html = "";

						$.each(data.retData, function (i, n) {
							html += '<div class="remarkDiv" id="' + n.id + '" style="height: 60px;">';
							html += '<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">';
							html += '<div style="position: relative; top: -40px; left: 40px;" >';
							// html += '<h5>' + n.noteContent + '</h5>';
							html += '<h5 id="nc'+n.id+'">' + n.noteContent + '</h5>';
							// html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;">'+(n.editFlag==0? n.createTime: n.editTime)+' 由 '+(n.editFlag==0? n.createBy: n.editBy)+'</small>';
							html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="etb'+n.id+'">' + (n.editFlag==0? n.createTime: n.editTime) + ' 由 ' + (n.editFlag==0? n.createBy: n.editBy) + ' ' + (n.editFlag==0? '创建': '更新') +'</small>';
							html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
							html += '<a class="myHref" href="javascript:void(0);" onclick="editRemarkById(\'' + n.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
							html += '&nbsp;&nbsp;&nbsp;&nbsp;';
							html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
							html += '</div>';
							html += '</div>';
							html += '</div>';
						});

						$("#remarkDiv").before(html);
					}

					$("#remarkBody").on("mouseover",".remarkDiv",function(){
						$(this).children("div").children("div").show();
					});
					$("#remarkBody").on("mouseout",".remarkDiv",function(){
						$(this).children("div").children("div").hide();
					});

				}
			});
		}

		// 根据 id 删除单条备注
		function deleteRemark(id){
			// alert(id);
			if (window.confirm("是否确定删除该线索下的此条备注？")){
				$.ajax({
					url : "workbench/activityRemark/deleteRemarkById.do",
					data : {
						"id" : id
					},
					type : "post",
					dataType : "json",
					success : function (data) {		// data = returnObject { code, message }

						if (data.code == "1"){
							// 这种方法使用 before()方法在上面添加的，所以不行
							// showRemarkList();

							// 找到需要删除记录的 div ，将其移除
							$("#"+id).remove();
						} else {
							alert(data.message);
						}
					}
				});
			}
		}

		// 根据 id 修改单条备注
		function editRemarkById(id) {
			//alert(id);
			// 根据 id 查询出备注信息
			$.ajax({
				url : "workbench/activityRemark/editRemarkById.do",
				data : {
					"id" : id
				},
				type : "get",
				dataType : "json",
				success : function (data) {		// data == returnObject { code, message, retData == {remark} }
					$("#remarkId").val(data.retData.id);
					$("#noteContent").val(data.retData.noteContent);
				}
			});
			// 打开模态框
			$("#editRemarkModal").modal("show");

			// 给 "更新按钮" 设置单击事件
			$("#editRemarkBtn").click(function () {
				// alert(id);
				var id = $("#remarkId").val();
				$.ajax({
					url : "workbench/activityRemark/saveEditRemarkById.do",
					data : {
						"id" : id,
						"noteContent" : $.trim($("#noteContent").val())
					},
					type : "post",

					dataType : "json",
					success : function (data) {		// data = returnObject { code, message, retData }
						if (data.code == "1"){
							// alert("更新成功");
							$("#nc"+id).html(data.retData.noteContent);
							$("#etb"+id).html(data.retData.editTime + ' 由 ' + "${sessionScope.sessionUser.name}" + ' 更新 ');
							// 关闭模态框
							$("#editRemarkModal").modal("hide");
						} else {
							alert(data.message);
						}
					}
				});
			});
		}

	</script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改市场活动备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="editRemarkBtn">更新</button>
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
				<h4 class="modal-title" id="myModalLabel1">修改市场活动</h4>
			</div>
			<div class="modal-body">

				<form class="form-horizontal" role="form">

					<div class="form-group">
						<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-marketActivityOwner">
								<option>zhangsan</option>
								<option>lisi</option>
								<option>wangwu</option>
							</select>
						</div>
						<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
						</div>
						<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-cost" class="col-sm-2 control-label">成本</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-cost" value="5,000">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
						</div>
					</div>

				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
			</div>
		</div>
	</div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
	<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
	<div class="page-header">
		<h3>市场活动-${activity.name}<small> ${activity.startDate} ~ ${activity.endDate}</small></h3>
	</div>
	<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
		<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
	</div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
	<div style="position: relative; left: 40px; height: 30px;">
		<div style="width: 300px; color: gray;">所有者</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>

	<div style="position: relative; left: 40px; height: 30px; top: 10px;">
		<div style="width: 300px; color: gray;">开始日期</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 20px;">
		<div style="width: 300px; color: gray;">成本</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 30px;">
		<div style="width: 300px; color: gray;">创建者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 40px;">
		<div style="width: 300px; color: gray;">修改者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 50px;">
		<div style="width: 300px; color: gray;">描述</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>${activity.description}</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
	<div class="page-header">
		<h4>备注</h4>
	</div>

	<!-- 备注1 -->
	<%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>哎呦！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

	<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
		<form role="form" style="position: relative;top: 10px; left: 10px;">
			<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
			<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
				<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
				<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
			</p>
		</form>
	</div>
</div>
<div style="height: 200px;"></div>
</body>
</html>