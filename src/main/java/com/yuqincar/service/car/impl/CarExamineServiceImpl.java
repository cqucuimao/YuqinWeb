package com.yuqincar.service.car.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yuqincar.dao.car.CarDao;
import com.yuqincar.dao.car.CarExamineDao;
import com.yuqincar.domain.car.Car;
import com.yuqincar.domain.car.CarCare;
import com.yuqincar.domain.car.CarExamine;
import com.yuqincar.domain.car.CarStatusEnum;
import com.yuqincar.domain.car.PlateTypeEnum;
import com.yuqincar.domain.common.PageBean;
import com.yuqincar.domain.privilege.User;
import com.yuqincar.service.car.CarExamineService;
import com.yuqincar.service.sms.SMSService;
import com.yuqincar.utils.DateUtils;
import com.yuqincar.utils.QueryHelper;

@Service
public class CarExamineServiceImpl implements CarExamineService {
	@Autowired
	private CarExamineDao carExamineDao;
	@Autowired
	private CarDao carDao;
	@Autowired
	private SMSService smsService;

	@Transactional
	public void saveCarExamine(CarExamine carExamine) {
		carExamineDao.save(carExamine);
		
		Car car=carExamine.getCar();
		car.setNextExaminateDate(carExamine.getNextExamineDate());
		if(car.getNextExaminateDate().after(new Date()))
			car.setExamineExpired(false);
		else
			car.setExamineExpired(true);
		carDao.update(car);
	}

	public CarExamine getCarExamineById(long id) {
		return carExamineDao.getById(id);
	}

	public PageBean<CarExamine> queryCarExamine(int pageNum, QueryHelper helper) {
		return carExamineDao.getPageBean(pageNum, helper);
	}

	public boolean canDeleteCarExamine(CarExamine carExamine) {
		return carExamine.isAppointment()==true;
	}

	@Transactional
	public void deleteCarExamineById(Long id) {
		CarExamine carExamine=carExamineDao.getById(id);
		Car car=carExamine.getCar();
		carExamineDao.delete(id);
		
		CarExamine ce=carExamineDao.getRecentCarExamine(car);
		if(ce!=null){
			car.setNextExaminateDate(ce.getNextExamineDate());
			if(car.getNextExaminateDate().before(new Date()))
				car.setExamineExpired(true);
			else
				car.setExamineExpired(false);
			carDao.update(car);
		}
	}

	public boolean canUpdateCarExamine(CarExamine carExamine) {
		return carExamine.isAppointment()==true;
	}

	@Transactional
	public void updateCarExamine(CarExamine carExamine) {
		carExamineDao.update(carExamine);
		
		Car car=carExamine.getCar();
		car.setNextExaminateDate(carExamine.getNextExamineDate());
		if(car.getNextExaminateDate().after(new Date()))
			car.setExamineExpired(false);
		else
			car.setExamineExpired(true);
		carDao.update(car);
	}
	
	public PageBean<Car> getNeedExamineCars(int pageNum) {
		Date now=new Date();
		Date b = new Date(now.getTime() +  24*60*60*1000 * 15L );
		QueryHelper helper = new QueryHelper(Car.class, "c");
		helper.addWhereCondition("c.nextExaminateDate < ? and c.status=? and c.borrowed=?", b,CarStatusEnum.NORMAL,false);
		helper.addOrderByProperty("c.nextExaminateDate", true);
		return carDao.getPageBean(pageNum, helper);
	}

	public Date getNextExamineDate(Car car, Date recentExamineDate) {
		Date nextExamineDate = null;
		Date registDate = car.getRegistDate();
		List<Date> dates = new ArrayList<Date>();
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(registDate);
		//蓝牌车且座位数小于7(假设报废期限30年)
		if(car.getPlateType() == PlateTypeEnum.BLUE && car.getSeatNumber() < 7){
			//前六年，两年一审
			for(int i=0;i<6;i++){					
				calendar.add(Calendar.YEAR, +2);
				dates.add(calendar.getTime());
				calendar.setTime(calendar.getTime());
				
			}
			//六年以上十年以下，一年一审
			calendar.setTime(dates.get(5));
			for(int i=6;i<10;i++){
				calendar.add(Calendar.YEAR, +1);
				dates.add(calendar.getTime());
				calendar.setTime(calendar.getTime());
			}
			//十年以上，一年两审
			calendar.setTime(dates.get(9));
			for(int i=10;i<50;i++){
				calendar.add(Calendar.MONTH, +6);
				dates.add(calendar.getTime());
				calendar.setTime(calendar.getTime());
			}
			for(int i=0;i<dates.size();i++){
				if(recentExamineDate.getTime()<dates.get(i).getTime()){
					nextExamineDate = dates.get(i);
					break;
				}
				
			}
		}
		//黄牌车，或者座位数大于7(假设报废期限30年)
		if(car.getPlateType() == PlateTypeEnum.YELLOW || car.getSeatNumber() >= 7){
			//前十年，一年一审
			for(int i=0;i<10;i++){					
				calendar.add(Calendar.YEAR, +1);
				dates.add(calendar.getTime());
				calendar.setTime(calendar.getTime());
				
			}
			//十年以上，一年两审
			calendar.setTime(dates.get(9));
			for(int i=10;i<30;i++){
				calendar.add(Calendar.MONTH, +6);
				dates.add(calendar.getTime());
				calendar.setTime(calendar.getTime());
			}
			for(int i=0;i<dates.size();i++){
				if(recentExamineDate.getTime()<dates.get(i).getTime()){
					nextExamineDate = dates.get(i);
					break;
				}
				
			}
		}
		return nextExamineDate;
	}
	
	@Transactional
	public void saveAppointment(CarExamine carExamine) {
		carExamine.setAppointment(true);
		carExamineDao.save(carExamine);
	}
	
	@Transactional
	public void updateAppointment(CarExamine carExamine) {
		carExamineDao.update(carExamine);
	}
	
	public CarExamine getUnDoneAppointExamine(Car car){
		QueryHelper helper=new QueryHelper(CarExamine.class,"ce");
		helper.addWhereCondition("ce.car=?", car);
		helper.addWhereCondition("ce.appointment=?", true);
		helper.addWhereCondition("ce.done=?", false);
		helper.addOrderByProperty("ce.date", false);
		List<CarExamine> list=carExamineDao.getPageBean(1, helper).getRecordList();
		if(list!=null && list.size()>0){
			return list.get(0);
		}else
			return null;
	}
	
}
