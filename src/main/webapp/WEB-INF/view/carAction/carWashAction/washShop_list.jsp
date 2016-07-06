<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title></title>
	<link rel="stylesheet" type="text/css" href="skins/main.css">
</head>
<body class="minW">
	<div class="space">
		<!-- 标题 -->
		<div class="title">
			<h1>洗车点管理</h1>
		</div>
		<div class="editBlock search">
			<table>
				<tr>
					<td>
						<input id="register" class="inputButton" type="button" value="洗车点登记" name="button" />
						<input id="back" class="inputButton" type="button" value="返回" name="back" />
					</td>										
				</tr>
			</table>
		</div>
		<div class="dataGrid">
			<div class="tableWrap">
				<table>
					<thead>
						<tr>
							<th class="alignCenter">洗车点</th>
							<th class="alignCenter">操作</th>
						</tr>
					</thead>
					<tbody class="tableHover">
						<s:iterator value="carWashshop">
						<tr>
							<td class="alignCenter">${name}</td>
							<td class="alignCenter">								
								<s:a action="carWashShop_editUI?id=%{id}" ><i class="icon-operate-edit" title="修改"></i></s:a>	
							<s:if test="canDeleteCarWashShop">
								<s:a action="carWashShop_delete?id=%{id}" onclick="return confirm('确认要删除吗？');"><i class="icon-operate-delete" title="删除"></i></s:a>
							</s:if>
							<s:else>
							</s:else>
							</td>
						</tr>
						</s:iterator> 
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>	
	<script type="text/javascript" src="js/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="js/common.js"></script>	
	<script type="text/javascript">
		$(function(){
			$("#register").click(function(){
				location.href='carWashShop_savaUI.action';
			});
			
			$("#back").click(function(){
				location.href='carWash_list.action';
			});
			
		})
	</script>
</body>
</html>