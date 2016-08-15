<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="skins/main.css" rel="stylesheet" type="text/css" />
<style>
    	
    </style>
</head>
<body class="minW">
	<div class="space">
		<!-- 标题 -->
		<div class="title">
			<h1>详细查询</h1>
		</div>
		<div class="editBlock detail p30">
			<s:form action="order_moreQuery" id="pageForm">
			<table style="width:90%"> 
				<tbody>
				<tr>
					<th><s:property value="tr.getText('order.Order.sn')" /></th>
					<td><s:textfield class="inputText" name="sn" /></td>
					<th><s:property value="tr.getText('order.Order.customerOrganization')" /></th>
					<td><s:textfield id="customer_organization_name" name="customerOrganizationName" cssClass="inputText" type="text"/>
					       <input id="customer_organization_id" type="hidden">
					</td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.customer')" /></th>
					<td><s:textfield class="inputText" name="customerName" /></td>
					<th><s:property value="tr.getText('order.Order.phone')" /></th>
					<td><s:textfield class="inputText" name="phone" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.chargeMode')" /></th>
					<td><s:select name="chargeMode" list="{'所有方式','按里程计费','按天计费','协议计费','接送机'}" /></td>
					<th><s:property value="tr.getText('order.Order.planBeginDate')" />（时间段）</th>
					<td>
						<s:textfield name="planBeginDate1" id="planBeginDate1" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						<s:textfield name="planBeginDate2" id="planBeginDate2" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.planEndDate')" />（时间段）</th>
					<td>
						<s:textfield name="planEndDate1" id="planEndDate1" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						<s:textfield name="planEndDate2" id="planEndDate2" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
					<th><s:property value="tr.getText('order.Order.actualBeginDate')" />（时间段）</th>
					<td>
						<s:textfield name="actualBeginDate1" id="actualBeginDate1" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						<s:textfield name="actualBeginDate2" id="actualBeginDate2" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.actualEndDate')" />（时间段）</th>
					<td>
						<s:textfield name="actualEndDate1" id="actualEndDate1" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						<s:textfield name="actualEndDate2" id="actualEndDate2" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
					<th><s:property value="tr.getText('car.CarServiceType.title')" /></th>
					<td><s:select name="serviceType" cssClass="SelectStyle"
                        		list="carServiceTypeList" listKey="title" listValue="title"
                        		headerKey="" headerValue="所有类型"
                        		/>
                     </td>
                </tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.fromAddress')" /></th>
					<td><s:textfield class="inputText" name="fromAddress" /></td>
					<th><s:property value="tr.getText('order.Order.toAddress')" /></th>
					<td><s:textfield class="inputText" name="toAddress" /></td>
			    </tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.orderMoney')" />（区间）</th>
					<td><s:textfield id="orderMoney1" class="inputText half" name="orderMoney1" />&nbsp;<s:textfield id="orderMoney2" class="inputText half" name="orderMoney2" /></td>
					<th><s:property value="tr.getText('order.Order.actualMoney')" />（区间）</th>
					<td><s:textfield id="actualMoney1" class="inputText half" name="actualMoney1" />&nbsp;<s:textfield id="actualMoney2" class="inputText half" name="actualMoney2" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.queueTime')" />（时间段）</th>
					<td>
						<s:textfield name="queueTime1" id="queueTime1" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						<s:textfield name="queueTime2" id="queueTime2" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
					<th><s:property value="tr.getText('order.Order.scheduleTime')" />（时间段）</th>
					<td>
						<s:textfield name="scheduleTime1" id="scheduleTime1" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						<s:textfield name="scheduleTime2" id="scheduleTime2" class="Wdate half" type="text" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.car')" /></th>
					<td><s:textfield id="car_platenumber" name="plateNumber" class="carSelector inputText inputChoose" onfocus="this.blur();" type="text" /></td>
					<th><s:property value="tr.getText('order.Order.driver')" /></th>
					<td><s:textfield class="userSelector inputText" id="driver" type="text" name="driver.name" driverOnly="true"/>
							<s:textfield id="driverId" name="driverId" type="hidden"/>
					</td>
				</tr>
				<tr>	
					<th><s:property value="tr.getText('order.Order.status')" /></th>
					<td><s:select name="status" list="{'所有状态','在队列','已调度','已接受','已开始','已上车','已下车','已结束','已付费','已取消'}"></s:select></td>
					<th><s:property value="tr.getText('order.Order.memo')" /></th>
					<td><s:textfield class="inputText" name="memo" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.scheduler')" /></th>
					<td>
							<s:textfield class="userSelector inputText inputChoose" id="schedulerName" type="text"/>
				 			<s:textfield id="schedulerId" name="schedulerId" type="hidden"/>
					</td>
					<th><s:property value="tr.getText('order.Order.orderSource')" /></th>
					<td><s:select name="orderSource" list="{'所有来源','调度员','客户端','网站'}"  /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.callForOther')" /></th>
					<td><s:select name="callForOtherLabel" list="{'','否','是'}" /></td>
					<th><s:property value="tr.getText('order.Order.otherPassengerName')" /></th>
					<td><s:textfield class="inputText" name="otherPassengerName"/></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.otherPhoneNumber')" /></th>
					<td><s:textfield class="inputText" name="otherPhoneNumber"/></td>
					<th><s:property value="tr.getText('order.Order.callForOtherSendSMS')" /></th>
					<td><s:select name="callForOtherSendSMSLabel" list="#{0:'否',1:'是'}" cssClass="SelectStyle"  listKey="value" listValue="value"  headerKey="" headerValue="" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.grade')" /></th>
					<td><s:select name="grade" list="{'','1','2','3','4','5'}"  /></td>
					<th><s:property value="tr.getText('order.Order.refuelMoney')" />（区间）</th>
					<td><s:textfield id="refuelMoney1" class="inputText half" name="refuelMoney1" />&nbsp;<s:textfield id="refuelMoney2" class="inputText half" name="refuelMoney2" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.washingFee')" />（区间）</th>
					<td><s:textfield id="washingFee1" class="inputText half" name="washingFee1" />&nbsp;<s:textfield id="washingFee2" class="inputText half" name="washingFee2" /></td>
					<th><s:property value="tr.getText('order.Order.parkingFee')" />（区间）</th>
					<td><s:textfield id="parkingFee1" class="inputText half" name="parkingFee1" />&nbsp;<s:textfield id="parkingFee2" class="inputText half" name="parkingFee2" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.toll')" />（区间）</th>
					<td><s:textfield id="toll1" class="inputText half" name="toll1" />&nbsp;<s:textfield id="toll2" class="inputText half" name="toll2" /></td>
					<th><s:property value="tr.getText('order.Order.roomAndBoardFee')" />（区间）</th>
					<td><s:textfield id="roomAndBoardFee1" class="inputText half" name="roomAndBoardFee1" />&nbsp;<s:textfield id="roomAndBoardFee2" class="inputText half" name="roomAndBoardFee2" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.otherFee')" />（区间）</th>
					<td><s:textfield id="otherFee1" class="inputText half" name="otherFee1" />&nbsp;<s:textfield id="otherFee2" class="inputText half" name="otherFee2" /></td>
					<th><s:property value="tr.getText('order.Order.options')" /></th>
					<td><s:textfield class="inputText" name="options" /></td>
				</tr>
				<tr>
					<th><s:property value="tr.getText('order.Order.saler')" /></th>
					<td>
							<s:textfield class="userSelector inputText inputChoose" id="salerName" type="text"/>
				 			<s:textfield id="salerId" name="salerId" type="hidden"/>
					</td>
				</tr>
				</tbody>
				<tfoot>
					<tr>
						<td>
							<input type="submit" id="btn" class="inputButton" value="确定"/>
		                	<a class="p15" href="javascript:history.go(-1);">返回</a>
	                	</td>
		            </tr>
				</tfoot>
			</table>
			</s:form>
		</div>
		
	</div>
	<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>	
	<script type="text/javascript" src="js/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="js/common.js"></script>	
	<script src="js/artDialog4.1.7/artDialog.source.js?skin=blue"></script>
	<script src="js/artDialog4.1.7/plugins/iframeTools.source.js"></script>
    <script type="text/javascript" src="js/validate/jquery.validate.js"></script>
    <script type="text/javascript" src="js/validate/messages_cn.js"></script>
	<script type="text/javascript">
		
		if($("#mileage1").val() == 0){
			$("#mileage1").val("");
		}
		if($("#mileage2").val() == 0){
			$("#mileage2").val("");
		}
		if($("#seatNumber1").val() == 0){
			$("#seatNumber1").val("");
		}
		if($("#seatNumber2").val() == 0){
			$("#seatNumber2").val("");
		}
		formatDateField2($("#registDate1"));
		formatDateField2($("#registDate2"));
		formatDateField2($("#enrollDate1"));
		formatDateField2($("#enrollDate2"));
	</script>
</body>
</html>