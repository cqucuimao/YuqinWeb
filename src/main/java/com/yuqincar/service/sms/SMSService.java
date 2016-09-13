package com.yuqincar.service.sms;

import java.util.Map;

public interface SMSService {
	public final static String SMS_TEMPLATE_MILE_ORDER_ACCEPTED = "91550674";
	public final static String SMS_TEMPLATE_DAY_ORDER_ACCEPTED = "91550675";
	public final static String SMS_TEMPLATE_EXAMINE_APPOINTMENT = "91550677";
	public final static String SMS_TEMPLATE_REPAIR_APPOINTMENT = "91550678";
	public final static String SMS_TEMPLATE_VERFICATION_CODE = "91550121";
	public final static String SMS_TEMPLATE_ORDER_POSTPONE = "91550688";
	public final static String SMS_TEMPLATE_ORDER_CANCELLED = "91550689";
	public final static String SMS_TEMPLATE_ORDER_ENQUEUE = "91550805";
	public final static String SMS_TEMPLATE_NEW_ORDER = "91551512";
	public final static String SMS_TEMPLATE_CARCARE_APPOINTMENT_GENERATED_FOR_DRIVER="91551668";
	public final static String SMS_TEMPLATE_CARCARE_APPOINTMENT_GENERATED_FOR_MANAGER="91551669";
	public final static String SMS_TEMPLATE_CARCARE_APPOINTMENT_GENERATED_NO_DRIVER="91551670";
	
	/**
	 * 发送模板短信
	 * @param templateId
	 * @param params
	 * @param devMode
	 * @return identifier 相当于短信id
	 */
	
	public String sendTemplateSMS(String phoneNumber,String templateId,Map<String,String> params);
	
	public void sendSMSInQueue();
}
