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
	<link href="skins/main.css" rel="stylesheet" type="text/css" />
</head>
<body class="minW">
    <div class="space">
        <!-- 标题 -->
        <div class="title">
            <h1>路桥费缴纳信息</h1>
            <p style="color: red">
				<s:if test="hasFieldErrors()">
					<s:iterator value="fieldErrors">
						<s:iterator value="value">
							<s:property />
						</s:iterator>
					</s:iterator>
				</s:if>
			</p>
        </div>
        <div class="editBlock detail p30">
        <s:form action="tollCharge_%{id == null ? 'save' : 'edit'}" id="pageForm">
        	<s:hidden name="id"></s:hidden>
            <table>
            	<colgroup>
					<col width="80"></col>
					<col></col>
					<col></col>
					<col></col>
					<col></col>
					<col width="120"></col>
				</colgroup>
                <tbody>
                	<tr>
                        <th><s:property value="tr.getText('car.TollCharge.car')" /><span class="required">*</span></th>
						<td>
							<s:textfield id="car_platenumber" cssClass="carSelector inputText inputChoose" onfocus="this.blur();" name="car.plateNumber" type="text"/>
						</td>
                    </tr>
                	<tr>
                        <th><s:property value="tr.getText('car.TollCharge.payDate')" /><span class="required">*</span></th>
                        <td>
                        	<s:textfield cssClass="inputText" name="payDate" id="payDate" class="Wdate half" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                        </td>
                    </tr>
                    <tr>
                        <th><s:property value="tr.getText('car.TollCharge.money')" /><span class="required">*</span></th>
                        <td>
                        	<s:textfield cssClass="inputText" name="money"/>
                        </td>
                    </tr>
                    <tr>
                        <th><s:property value="tr.getText('car.TollCharge.overdueFine')" /></th>
                        <td>
                        	<s:textfield cssClass="inputText" name="overdueFine"/>
                        </td>
                    </tr>
                    <tr>
                        <th><s:property value="tr.getText('car.TollCharge.moneyForCardReplace')" /></th>
                        <td>
                        	<s:textfield cssClass="inputText" name="moneyForCardReplace"/>
                        </td>
                    </tr>
                	<tr>
                        <th><s:property value="tr.getText('car.TollCharge.nextPayDate')" /><span class="required">*</span></th>
                        <td>
                        	<s:textfield cssClass="inputText" name="nextPayDate" id="nextPayDate" class="Wdate half" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                        </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2">
                        	<input class="inputButton" type="submit" value="提交" />
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

	
	    $(function(){	    	
			$("#pageForm").validate({
				submitout: function(element) { $(element).valid(); },
				rules:{
					// 配置具体的验证规则
					'car.plateNumber':{
						required:true,
					},
					payDate:{
						required:true,
					},
					money:{
						required:true,
						number:true,
						min:0
					},
					overdueFine:{
						number:true,
						min:0
					},
					moneyForCardReplace:{
						number:true,
						min:0
					},
					nextPayDate:{
						required:true,
					},
				}
			});
			formatDateField1($("#payDate"));
			formatDateField1($("#nextPayDate"));
		});
    </script>
</body>
</html>
