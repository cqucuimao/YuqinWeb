﻿<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
		body, html,#BaiduMap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
</style>
<link rel="stylesheet" type="text/css" href="skins/main.css">
</head>
<body>
    
    <!-- 被监控车辆正在执行订单时的弹出框 -->
        <div id="carOrderDetail" class="editBlock detailM" style="display:none;">
        <table id="orderDetail">
            <tbody>
                <tr>
                    <th width="70">订单号：</th>
                    <td></td>
                </tr>
                <tr>
                    <th width="70">客户单位：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>联系人：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>计费方式：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>计划时间：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>车型：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>车牌：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>司机：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>始发地：</th>
                    <td></td>
                </tr>
                <tr>
                    <th>目的地：</th>
                    <td></td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td>
                        <div class="bottomBar borderT alignCenter"><a id="trackUrlHaveOrder" href="fdafs" target="_blank"><input class="inputButton" type="button" value="查看轨迹" id="viewTrackBnHaveOrder"/></a></div>
                    </td>
                    <td>
                        <div class="bottomBar borderT alignCenter"><input class="inputButton" type="button" value="移除" id="removeCarHaveOrder"/></div>
               </td>
                </tr>
            </tfoot>
        </table>
        </div>
        <!-- 被监控车辆没有执行订单时的弹出框 -->
        <div id="carNoOrder" class="editBlock detailM" style="display:none;">
        <table id="noOrder">
           <tr><td colspan="2">车辆当前没有正在执行的订单</td></tr>
           <tr>
               <td>
                   <div class="bottomBar borderT alignCenter"><a id="trackUrlNoOrder" href="fdafs" target="_blank"><input class="inputButton" type="button" value="查看轨迹" id="viewTrackBnNoOrder"/></a></div>
               </td>
               <td>
                   <div class="bottomBar borderT alignCenter"><input class="inputButton" type="button" value="移除" id="removeCarNoOrder"/></div>
               </td>
           </tr>
        </table>
        </div>
        
    <div id="BaiduMap" class="mt10 map">
    </div>

    <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="js/artDialog4.1.7/artDialog.source.js?skin=blue"></script>
    <script type="text/javascript" src="js/artDialog4.1.7/jquery.artDialog.source.js"></script>
    <script type="text/javascript" src="js/common.js"></script>
    <script src="http://api.map.baidu.com/api?v=2.0&ak=${baiduKey }"></script>
    <script type="text/javascript">
    
    //百度地图
    var map = new BMap.Map("BaiduMap");
    var mapPoint = new BMap.Point(106.464617,29.570331);
    map.centerAndZoom(mapPoint, 10);
    map.enableScrollWheelZoom(true);
    
    //地图左上角功能区
    var contentMark="<span class='actionBar'><a href='javascript:addAllCars()'>所有车辆</a><em class='line'></em>"
                    		+"<a href='javascript:addCarsBySuperType(\"大巴\")'>大巴</a><em class='line'></em>"
                    		+"<a href='javascript:addCarsBySuperType(\"考斯特\")'>考斯特</a><em class='line'></em>"
                    		+"<a href='javascript:addCarsBySuperType(\"商务车\")'>商务车</a><em class='line'></em>"
                    		+"<a href='javascript:addCarsBySuperType(\"小车\")'>小车</a><em class='line'></em>"
                    		+"<a href='javascript:addCarsBySuperType(\"越野车\")'>越野车</a><em class='line'></em>"
                    		+"<a href='javascript:clearAllCars()'>清除所有</a></span>"
    
    //为百度地图添加左上角标签                
    $("#BaiduMap").append(contentMark); 
   
    //百度地图API中gps坐标转百度地图坐标的web服务请求格式,前缀与后缀
    var head="baidu.action?coords=";
    
   //需求要求每次查询并选中的结果会 添加(原有的不清除) 到地图 所以需要一个全局变量 记录所有查询到的车辆信息
    var allRecordedCars=window.opener.allRecordedCars;
    //因为 移除车辆 这个操作与主页面的 checkboxBox相关 所以需要取得交互的变量 checkboxStatus和其对应的所有复选框对象
    var checkboxStatus=window.opener.checkboxStatus;
    var checkboxes=window.opener.checkboxes;
    var allCheckboxes=window.opener.allCheckboxes;
    var theCheckAllBox=window.opener.theCheckAllBox;    //全选复选框   用于删除某一辆车时，复选框置false
    

    //监控车辆刷新时间   单位 毫秒，10s刷新一次
    var monitorInterval=10000;
    //刷新的组别索引
    var flushGroupIndex=0;
    //刷新的分组的总数
    var flushGroupNum=10;
    //百度地图的GPS坐标转Baidu坐标的API接口限制数
    var limitLen=98;

    //每隔10秒刷新位置。每个10s执行一次flushByGroup()
    window.setInterval(flushByGroup,monitorInterval); 

    //子窗口关闭之前，需要通知父窗口
    window.onbeforeunload=function() { 
       //将父窗口的双屏标志位置为false
       window.opener.sonWindowFlag=false;
    }
    
    //页面加载完毕后立即刷新所有车辆
    window.onload=function(){ 
  	  window.opener.sonWindowFlag=true;
    	  //获取监控屏的百度地图对象
    	  window.opener.map=map;
    }
   
   //对当前所有选中车辆进行分组刷新
   function flushByGroup(){
 	       //如果被监控的车辆数目大于0
     	   var allSelectedCars=new Array();  //用于保存被勾选的车辆信息及相应的gps经纬度数据的 连续数组	
     	   var index=0; 
     	   //根据id遍历allRecordedCars
     	   for(var id=0;id<allRecordedCars.length;id++){
     		   //如果当前记录存在
     		   if(allRecordedCars[id] !== undefined){
     		      //如果当前记录的车辆是被监控的
     		      if(allRecordedCars[id][1]){
        		     //显示定义二维数组，记录被勾选的车辆车牌号,车辆真实id,车辆当前的状态，0 正常     异常（1 异常行驶     2 设备拔出）
        	         allSelectedCars[index]=new Array(3);
        	         allSelectedCars[index][0]=allRecordedCars[id][0].number;//车牌号
        	         allSelectedCars[index][1]=id;										 //车辆Id	
        	         allSelectedCars[index][2]=allRecordedCars[id][2];			 //车辆状态，用于更换不同颜色车辆图片	
        			 index++;
     		       }
     		    }
     	   }
		  
     	   if(allSelectedCars.length>0){
	     		 for(var i=0;i<allSelectedCars.length;i++){
	     			  var plateNumber=allSelectedCars[i][0];
	     			  var car_id=allSelectedCars[i][1];
	     			  var is_CarNormal = allSelectedCars[i][2];
		       		  console.log("++++发送请求URL,车牌号="+plateNumber+"++++");
		       		  $.get("realtime_getCapcareData.action?carPlateNumber="+encodeURI(plateNumber)+"&carId="+car_id+"&isCarNormal="+is_CarNormal,function(capcareData){
		       				 console.log("++++请求返回的数据++++");
		       				 console.log(capcareData);
		       				 var carPlateNumber = capcareData.plateNumber;
		       				 var carId = capcareData.carId;
		       				 var isCarNormal = capcareData.isCarNormal;
		       				 var carDirection = capcareData.direction;
		       				 var point;      //选中的记录的经纬度坐标点
	       	  	             var marker;     //地图上的标识物
	       	  	             //自定义信息显示
        	      		     var opts={
      				                width : 10,     // 信息窗口宽度
      				                height: 10,     // 信息窗口高度
      				                title : "车辆信息" , // 信息窗口标题
      				                enableMessage:false//设置允许信息窗发送短息
      			             };
	       	  	             //地图上的经纬度坐标点
        	      		     point = new BMap.Point(parseFloat(capcareData.longitude),parseFloat(capcareData.latitude));
        	      		     //获取当前车辆的状态status和速度speed
        	      		     var carStatus=capcareData.status;
        	      		     var carSpeed=capcareData.speed;
        	      		     //定义车辆状态的图片路径
        	      		     var imagePath;
        	      		     //如果车辆处于正常状态
        	      		     if(isCarNormal==0){
        	      		        //判断车辆具体处于什么状态：无网络(status:2) 行驶(status:1,speed!=0) 停留(status:1,speed=0)
            	      		    if(carStatus==2){
            	      		       imagePath="images/auto4.png";
            	      		    }else{
            	      		       if(carSpeed==0)
            	      		    	  imagePath="images/auto1.png";
            	      		       else
            	      		    	  imagePath="images/auto3.png"; 
            	      		    }
        	      		     }else if(isCarNormal==1){
        	      		    	 //当前状态为异常行驶
        	      		    	 imagePath="images/auto2.png";
        	      		     }else{
        	      		         //当前状态为设备拔出
        	      		    	 imagePath="images/auto5.png";
        	      		     }
        	      		     
        	      		     //清除地图上当前车辆标识
        	      		     var allOverlay = map.getOverlays();         	      		    	   
		    			     for (var i = 0; i < allOverlay.length; i++){
		    				      //这里可能发生异常的原因是 getOverlays对象得到的覆盖物的个数不定  不知道是什么原因  对于非车辆覆盖物 抛出的异常直接忽略
		    				      try{
		    				          if(allOverlay[i].getLabel().content == carPlateNumber){
		    					         map.removeOverlay(allOverlay[i]);
		    			              }
		    				      }catch(error){}
		    			     }
        	      		     
        	      		     //自定义车辆图标
        	      		     var myIcon = new BMap.Icon(imagePath, new BMap.Size(40,50));
        	      		     marker = new BMap.Marker(point,{icon:myIcon});// 创建标注
        	      		     //增加车牌信息  label的offset属性能够调整基于中心点的偏移位置
        	      		     var label = new BMap.Label(carPlateNumber,{offset:new BMap.Size(-18,-17)});
    	      		         marker.setLabel(label);
    	      		         marker.setRotation(carDirection);//设置旋转角度
    	      		         //if(checkboxStatus[carId]){
    	      		        	map.addOverlay(marker);     // 将标注添加到地图中       
    	      		         //}
							 //添加label和marker的鼠标监听事件
    	      		         label.addEventListener('mouseover', function(){
	  	      		       		 marker.setTop(true);
	  	      		       	 });
    	      		         marker.addEventListener('mouseover', function(){
	  	      		       		 marker.setTop(true);
	  	      		       	 });
    	      		         
    	      		       	label.addEventListener('mouseout', function(){
	  	      		       		 marker.setTop(false);
	  	      		       	 });
  	      		        	marker.addEventListener('mouseout', function(){
	  	      		       		 marker.setTop(false);
	  	      		       	 });
        	      		     //非常重要的一个问题
        	      		     //这里有一个关键问题  批量事件绑定环境下   响应函数需要的参数的变化问题   使用 闭包 将局部变量carId 和 carPlateNumber 作为参数传递到 事件响应函数中去
        	      		     marker.addEventListener('click',(function(myCarId,myCarPlateNumber){
        	      		    	 return function(){
            	      		    	  $.get("realtime_orderDetail.action?id="+myCarId+"&timestamp="+new Date().getTime(),function(orderJson){
            	      		    		    
            	      		    		    console.log("查询订单的车辆carId="+myCarId);
            	      		    		    console.log("返回的订单数据");
            	      		    		    console.log(orderJson);
            	      		    		  
            	      		    	        var data=orderJson;
            	      		    	        //如果存在正在执行的订单，则显示具体订单信息，否则进行提示 
            	      		    	        if(data.status==1){
            	      		    	           var dialog = art.dialog({
                                                 height:400,
                                                 width:400,
              		        	               title: "车辆详情信息",
                                                 lock: true,      //遮罩层效果
                                                 drag: false,     //拖动效果
                                                 content: document.getElementById("carOrderDetail")
              			                   });
              	      		               //获得表格正文的行对象数组，并未每行的列赋值
              	      		    	       var tbTrs=$("#orderDetail").children("tbody").find("tr");
              	      		    	       for(var k=0;k<tbTrs.length;k++){  
              	      		    		       var tds=$(tbTrs[k]).find("td"); 
              	      		    		       $(tds[0]).html(data.order[k]);
              	      		    	       }
              	      		    	       //获得订单信息表格的查看轨迹按钮对象
             	      		    	           $("#viewTrackBnHaveOrder").bind("click",function(){
             	      		    	    	      //关闭订单信息框
             	      		    	    	      dialog.close();
             	      		    	    	      //跳转到轨迹播放页面
             	      		    	    	      $("#trackUrlHaveOrder").attr("href","replay_home.action?carId="+myCarId);
             	      		    	           });
              	      		    	                  	      		    	       
             	      		    	           $("#removeCarHaveOrder").bind("click",function(){
             	      		    	        	//将全选按钮值为false
               	      		    	        	  theCheckAllBox.prop("checked", false);
             	      		    	        	   
             	      		    	        	//在allRecordedCars中将相应车辆的选中状态值为false
            	      		    	    	          allRecordedCars[myCarId][1]=false;
            	      		    	    	          //如果该车辆在当前复选框中被选中，则改变复选框状态
            	      		    	    	          if(checkboxStatus[myCarId]==true){
            	      		    	    	        	  checkboxes.each(function(){
            	      		    	    	        		  if($(this).prop("id")==myCarId){
            	      		    	    	        			 $(this).prop("checked", false);
            	      		    	    	        		  }
            	      		    	    	        	  });
            	      		    	    	        	  checkboxStatus[myCarId]=false;
            	      		    	    	          }
         	      		    	                  //在地图上清除相应的车辆标识
      	      		    	    	          var allOverlay = map.getOverlays();
      	      		    			          for (var i = 0; i < allOverlay.length; i++){
      	      		    				          //这里可能发生异常的原因是 getOverlays对象得到的覆盖物的个数不定  不知道是什么原因  对于非车辆覆盖物 抛出的异常直接忽略
      	      		    				          try{
         	      		    				              if(allOverlay[i].getLabel().content == myCarPlateNumber){
          	      		    					          map.removeOverlay(allOverlay[i]);
          	      		    			              }
         	      		    				      }catch(error){}
      	      		    			          }
      	      		    			          //关闭订单信息框
      	      		    	    	          dialog.close();
         	      		    	               });            	      		    	
            	      		    	        }else{
            	      		    	           var dialog = art.dialog({
                                                 height:200,
                                                 width:300,
              		        	               title: "车辆详情信息",
                                                 lock: true,      //遮罩层效果
                                                 drag: false,     //拖动效果
                                                 content: document.getElementById("carNoOrder")
              			                   });
            	      		    	           //获得订单信息表格的查看轨迹按钮对象
             	      		    	           $("#viewTrackBnNoOrder").bind("click",function(){
             	      		    	    	      //关闭订单信息框
             	      		    	    	      dialog.close();
             	      		    	    	      //跳转到轨迹播放页面
             	      		    	    	      $("#trackUrlNoOrder").attr("href","replay_home.action?carId="+myCarId);
             	      		    	    	 
             	      		    	           });
            	      		    	           
             	      		    	          $("#removeCarNoOrder").bind("click",function(){
             	      		    	        	//将全选按钮值为false
              	      		    	        	  theCheckAllBox.prop("checked", false);
            	      		    	    	             	      		    	    
             	      		    	        	//在allRecordedCars中将相应车辆的选中状态值为false
           	      		    	    	          allRecordedCars[myCarId][1]=false;
           	      		    	    	          //如果该车辆在当前复选框中被选中，则改变复选框状态
           	      		    	    	          if(checkboxStatus[myCarId]==true){
           	      		    	    	        	  checkboxes.each(function(){
           	      		    	    	        		  if($(this).prop("id")==myCarId){
           	      		    	    	        			 $(this).prop("checked", false);
           	      		    	    	        		  }
           	      		    	    	        	  });
           	      		    	    	        	  checkboxStatus[myCarId]=false;
           	      		    	    	          }
            	      		    	    	     //在地图上清除相应的车辆标识
            	      		    	    	     var allOverlay = map.getOverlays();         	      		    	   
            	      		    			     for (var i = 0; i < allOverlay.length; i++){
            	      		    				      //这里可能发生异常的原因是 getOverlays对象得到的覆盖物的个数不定  不知道是什么原因  对于非车辆覆盖物 抛出的异常直接忽略
            	      		    				      try{
            	      		    				          if(allOverlay[i].getLabel().content == myCarPlateNumber){
             	      		    					         map.removeOverlay(allOverlay[i]);
             	      		    			              }
            	      		    				      }catch(error){}
            	      		    			     }
            	      		    			     //关闭订单信息框
            	      		    	    	     dialog.close();
            	      		    	          });          	      		    	                    	      		    	         
            	      		    	        }     	      		    	        
            	      		    	    }); 
            	                  };	      		    	 
        	      		     })(carId,carPlateNumber)); 
	       		  });
       	   }
    	   }
  }
 
    //添加所有车辆
    function addAllCars(){
    	$.ajaxSettings.async=false;
    	//获取所有未报废的车辆  此处由于alarmAction中已经存在该方法，所以直接向此action发送请求
    	$.get("realtime_allNormalCars.action",function(allNormalCars){
    		
    		console.log("*****所有车辆的信息******");
    		console.log("监控界面中车辆="+allNormalCars.length);
    		
    		
    		for(var i=0;i<allNormalCars.length;i++){
    			var carId=allNormalCars[i].id;
    			if(allRecordedCars[carId]==undefined){
   	   		       allRecordedCars[carId]=new Array(3);
   	   		     }
    			//以id作为索引的车辆记录包含两个信息  车辆具体信息 和 是否被选中 用于监控
	   		    allRecordedCars[carId][0]=allNormalCars[i];
	   		    //添加所有车辆  所有选中状态都为true
	   		    allRecordedCars[carId][1]=true;
	   		    //用于记录车辆当前处于 正常状态 0 还是 异常状态(异常状态包括  异常行驶 1  和 设备拔出 2) 默认初始化都处于正常状态
	   		    allRecordedCars[carId][2]=0;
    		}
    		if(allCheckboxes==undefined)
    			allCheckboxes = new Array(allNormalCars);
   		   //所有复选框状态都值为 选中     有可能没有查询车辆 即 没有对应的复选框
       	   allCheckboxes.each(function(){
       	        $(this).prop("checked", true);
       	   });
    		//在checkboxStatus数组中添加所有复选框的勾选状态
    		if(checkboxStatus == undefined)
    			checkboxStatus = new Array(allNormalCars);
   			for(var i=0;i<checkboxStatus.length;i++){
   			    checkboxStatus[i]=true;
   			}
    	});
    	$.ajaxSettings.async=true;
    	flushByGroup();
    }
    
    //根据车型大类添加车辆
    function addCarsBySuperType(superType){
    	console.log("superType="+superType);
    	$.ajaxSettings.async=false;
    	//获取所有未报废的车辆  此处由于alarmAction中已经存在该方法，所以直接向此action发送请求
    	$.get("realtime_getCarsBySuperType.action?superType="+superType,function(carsData){
    		
    		console.log("*****所有车辆的信息******");
    		console.log("监控界面中车辆="+carsData.length);

    		/* if(allCheckboxes==undefined)
    			allCheckboxes = new Array(carsData); */
    		for(var i=0;i<carsData.length;i++){
    			var carId=carsData[i].id;
    			if(allRecordedCars[carId]==undefined){
   	   		       allRecordedCars[carId]=new Array(3);
   	   		     }
    			//以id作为索引的车辆记录包含两个信息  车辆具体信息 和 是否被选中 用于监控
	   		    allRecordedCars[carId][0]=carsData[i];
	   		    //添加所有车辆  所有选中状态都为true
	   		    allRecordedCars[carId][1]=true;
	   		    //用于记录车辆当前处于 正常状态 0 还是 异常状态(异常状态包括  异常行驶 1  和 设备拔出 2) 默认初始化都处于正常状态
	   		    allRecordedCars[carId][2]=0;
	   		    
		   		if(checkboxStatus[carId]==false){
	 	        	  checkboxes.each(function(){
	 	        		  if($(this).prop("id")==carId){
	 	        			 $(this).prop("checked", true);
	 	        		  }
	 	        	  });
	 	        	  checkboxStatus[carId]=true;
	 	        }
    		}
       		
    		//在checkboxStatus数组中添加所有复选框的勾选状态
    		
    	});
    	$.ajaxSettings.async=true;
    	flushByGroup();
    }
    
    //清除所有车辆
    function clearAllCars(){
    	console.log("++++++执行清除车辆的函数++++++");
    	//在页面上清除所有复选框的勾选状态  有可能没有查询车辆 即 没有对应的复选框
    	if(allCheckboxes!=undefined){
 		   //所有复选框状态都值为 选中
     	   allCheckboxes.each(function(){
     	        $(this).prop("checked", false);
     	   });
 		}
		//在checkboxStatus数组中清除所有复选框的勾选状态
		if(allCheckboxes!=undefined){
	      	for(var i=0;i<checkboxStatus.length;i++){
			    checkboxStatus[i]=false;
			    checkboxes.each(function(){
	      	    	$(this).prop("checked", false);
	      		});
			}
	      	
	    }
      	//清除allRecordedCars中的车辆记录的选中状态
  		for(var i=0;i<allRecordedCars.length;i++){
  			if(allRecordedCars[i]!==undefined)
  			   allRecordedCars[i][1]=false;
  		}
  	    //清除地图上的所有覆盖物,这里需要手动清除，因为flushTrack由于条件限制，不会进行任何操作
  		map.clearOverlays();
    }
   
    </script>
</body>
</html>
