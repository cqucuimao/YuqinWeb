<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/common/common.jsp" %>
<cqu:border>
	<div class="space">
		<!-- 标题 -->
		<div class="title">
			<h1>扩充常备车库申请</h1>
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
			<s:form action="reserveCarApplyOrder_%{id == null ? 'add' : 'edit'}" id="pageForm">
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
					<!-- 新建时填写的内容 -->
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.proposer')" /><span class="required">*</span></th>
						<td>${proposer.name}</td>
					</tr>
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.carCount')" /><span class="required">*</span></th>
						<td>

								<s:textfield cssClass="inputText" id="carCount" name="carCount"/>
						
						</td>
					</tr>
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.fromDate')" /><span class="required">*</span></th>
						<td>
								<s:textfield class="Wdate half" id="fromDate" name="fromDate" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</td>
					</tr>
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.toDate')" /><span class="required">*</span></th>
						<td>
								<s:textfield class="Wdate half" id="toDate" name="toDate" onfocus="new WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</td>
					</tr>
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.reason')" /><span class="required">*</span></th>
						<td>
								<s:textarea class="inputText" style="height:100px" id="reason" name="reason"></s:textarea>
						</td>
					</tr>										
					<tr>
						<td colspan="2">		
							<div class="title">
             					<br/>
             					<br/>
            					<h2>审核信息</h2>
        					</div>
        				</td>
        			</tr>
					<!-- 公司领导审核的内容 -->
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.approveUser')" /><span class="required">*</span></th>
						<td>
								${approveUser.name }
						</td>
					</tr>
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.approveMemo')" /></th>
						<td>
								<s:textarea class="inputText" style="height:100px" id="approveMemo" name="approveMemo"></s:textarea>
						</td>
					</tr>
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.approved')" /></th>
						<td>
							<%-- <s:checkbox class="m10" id="approved" name="approved"/> --%>
							
								<s:if test="approved == true">是</s:if>
								<s:else><font color="red">否</font></s:else>
						</td>
					</tr>				
					<tr>
						<td colspan="2">		
							<div class="title">
             					<br/>
             					<br/>
            					<h2>司机配置信息</h2>
        					</div>
        				</td>
        			</tr>	
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.drivers')" /><span class="required">*</span></th>
						<!-- 司机多选  start-->
						<td style="background-color:;width:350px">
	                        <s:select name="listIds" multiple="true" cssClass="SelectStyle" 
	          				list="userList" listKey="id" listValue="name" ondblclick="moveOption(document.pageForm.listIds, document.pageForm.selectedIds)"
	          				style="height:250px"/>
          				</td>
          				<td align="center" style="background-color:;width:200px"><br/>
          					<input type="button" value="全部添加" onclick="moveAllOption(document.pageForm.listIds, document.pageForm.selectedIds)"><br/> 
							<br/>
							<input type="button" value="添加" onclick="moveOption(document.pageForm.listIds, document.pageForm.selectedIds)"><br/> 
							<br/> 
							<input type="button" value="移除" onclick="moveOption(document.pageForm.selectedIds, document.pageForm.listIds)"><br/> 
							<br/> 
							<input type="button" value="全部移除" onclick="moveAllOption(document.pageForm.selectedIds, document.pageForm.listIds)"> 
							<br>
							<s:textfield type="hidden" name="idString" />
						</td>
          				<td>
          					<s:select name="selectedIds" multiple="true" cssClass="SelectStyle"
          					 list="selectedList" listKey="id" listValue="name" ondblclick="moveOption(document.pageForm.selectedIds, document.pageForm.listIds)"
          					 style="height:250px"/>
          				</td>
          				<!-- 司机多选  end-->
					</tr>				
					<tr>
						<th><s:property value="tr.getText('order.ReserveCarApplyOrder.driverApproveUserMemo')" /></th>
						<td>
								<s:textarea class="inputText" style="height:100px" id="driverApproveUserMemo" name="driverApproveUserMemo"></s:textarea>
						</td>
					</tr>
					<tr>
	                <td colspan="2">
		                	<input type="button" id="sub" class="inputButton" value="提交配置"/>
		                	<a class="p15" href="javascript:history.go(-1);">返回</a>
		                
	                </td>
	            </tr>
				</tbody>
			</table>
			</s:form>
		</div>
		
	</div>
	<script type="text/javascript">
	
	formatDateField1($("#fromDate"));
	formatDateField1($("#toDate"));
	
	//审批司机
	//其他项设置为只读
   	$("#carCount").attr("disabled",true);
   	$("#fromDate").removeAttr("onfocus"); 
	$("#fromDate").attr("disabled", true); 
	$("#toDate").removeAttr("onfocus"); 
	$("#toDate").attr("disabled", true); 
   	$("#reason").attr("disabled",true);
   	
   	//提交车辆配置
	$("#sub").click(function(){
		coverShow();
		$('#pageForm').attr("action", "reserveCarApplyOrder_approveDriver.action").submit();
	});
	
	// 配置具体的验证规则
	$(function(){    	
		$("#pageForm").validate({
			submitout: function(element) { $(element).valid(); },
			rules:{
				selectedIds:{
					required:true,
				},
			},
			invalidHandler: function(form, validator){
				 coverHidden();
			}
	  });
	});
			
	<!--操作全部-->
    function moveAllOption(e1, e2){ 
	      var fromObjOptions=e1.options; 
	      for(var i=0;i<fromObjOptions.length;i++){ 
	       fromObjOptions[0].selected=true; 
	       e2.appendChild(fromObjOptions[i]); 
	       i--; 
      	} 
     	document.pageForm.idString.value=getvalue(document.pageForm.selectedIds); 
    }

    <!--操作单个-->
    function moveOption(e1, e2){ 
        var fromObjOptions=e1.options; 
        for(var i=0;i<fromObjOptions.length;i++){ 
	        if(fromObjOptions[i].selected){ 
		        e2.appendChild(fromObjOptions[i]); 
		        i--; 
       		} 
    	} 
     	document.pageForm.idString.value=getvalue(document.pageForm.selectedIds); 
    } 

    function getvalue(geto){ 
	    var allvalue = ""; 
	    for(var i=0;i<geto.options.length;i++){ 
    		allvalue +=geto.options[i].value + ","; 
    	} 
    	return allvalue; 
    } 

    function changepos1111(obj,index) 
    { 
    	if(index==-1){ 
    		if (obj.selectedIndex>0){ 
    			obj.options(obj.selectedIndex).swapNode(obj.options(obj.selectedIndex-1)) 
    		} 
    	}else if(index==1){ 
    				if (obj.selectedIndex<obj.options.length-1){ 
    						obj.options(obj.selectedIndex).swapNode(obj.options(obj.selectedIndex+1)) 
    				} 
    	} 
    } 
	
	</script>
</cqu:border>