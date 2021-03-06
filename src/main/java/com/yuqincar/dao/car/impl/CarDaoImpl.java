package com.yuqincar.dao.car.impl;


import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.yuqincar.dao.car.CarDao;
import com.yuqincar.dao.common.impl.BaseDaoImpl;
import com.yuqincar.domain.car.Car;
import com.yuqincar.domain.car.CarCare;
import com.yuqincar.domain.car.CarExamine;
import com.yuqincar.domain.car.CarInsurance;
import com.yuqincar.domain.car.CarRefuel;
import com.yuqincar.domain.car.CarRepair;
import com.yuqincar.domain.car.CarStatusEnum;
import com.yuqincar.domain.car.CarViolation;
import com.yuqincar.domain.monitor.TemporaryWarning;
import com.yuqincar.domain.monitor.WarningMessage;
import com.yuqincar.domain.order.Order;
import com.yuqincar.utils.QueryHelper;

@Repository
public class CarDaoImpl extends BaseDaoImpl<Car> implements CarDao {

	public boolean isPlateNumberExist(long selfId, String plateNumber) {
		if(plateNumber == null || plateNumber.equals("")){
			return false;
		}	
		
		List<Car> cars = getSession().createQuery("from Car c where c.plateNumber=? and c.id<>?")
				.setParameter(0, plateNumber)
				.setParameter(1, selfId)
				.list();
		if(cars.size()!=0) 
			return true;
		return false;		
	}

	public boolean isVINExist(long selfId, String VIN) {
		if(VIN == null || VIN.equals("")){
			return false;
		}
		
		List<Car> cars = getSession().createQuery("from Car c where c.VIN=? and c.id<>?")
				.setParameter(0, VIN)
				.setParameter(1, selfId)
				.list();
		if(cars.size()!=0) 
			return true;
		return false;
	}

	public boolean isEngineSNExist(long selfId, String EngineSN) {
		if(EngineSN == null || EngineSN.equals("")){
			return false;
		}
		
		List<Car> cars = getSession().createQuery("from Car c where c.EngineSN=? and c.id<>?")
				.setParameter(0, EngineSN)
				.setParameter(1, selfId)
				.list();
		if(cars.size()!=0) 
			return true;
		return false;
	}

	public boolean canDeleteCar(long id) {
		
		List<Order> orders = getSession().createQuery("from order_ where car_id=?").
				setParameter(0, id).list();
		List<CarCare> carCares =getSession().createQuery("from CarCare where car.id=?").
				setParameter(0, id).list();
		List<CarExamine> carExamines = getSession().createQuery("from CarExamine where car.id=?").
				setParameter(0,id).list();
		List<CarInsurance> carInsurances = getSession().createQuery("from CarInsurance where car.id=?").
				setParameter(0,id).list();
		List<CarRefuel> carRefuels = getSession().createQuery("from CarRefuel where car.id=?").
				setParameter(0,id).list();
		List<CarRepair> carRepairs = getSession().createQuery("from CarRepair where car.id=?").
				setParameter(0,id).list();
		List<CarViolation> carViolations = getSession().createQuery("from CarViolation where car.id=?").
				setParameter(0,id).list();
		List<TemporaryWarning> temporaryWarnings = getSession().createQuery("from TemporaryWarning where car.id=?").
				setParameter(0,id).list();
		List<WarningMessage> warningMessages = getSession().createQuery("from WarningMessage where car.id=?").
				setParameter(0,id).list();
		if(orders.size()!=0 || carCares.size()!=0 || carExamines.size()!=0 || carInsurances.size()!=0 ||
				carRefuels.size()!=0 || carViolations.size()!=0 || temporaryWarnings.size()!=0 || warningMessages.size()!=0) 
			return false;
		return true;
	}

	public Car getByPlateNumber(String plateNumber) {
		return (Car) getSession().createQuery(//
				"FROM Car d WHERE d.plateNumber=?")
				.setParameter(0, plateNumber)
				.uniqueResult();
	}

	public List<Car> searchByPlateNumber(String plateNumber) {
		if(plateNumber!=null && !plateNumber.isEmpty())
			return (List<Car>) getSession().createQuery(//
					"FROM Car c WHERE c.status=? and c.plateNumber like ? order by c.plateNumber asc")
					.setParameter(0,CarStatusEnum.NORMAL)
					.setParameter(1, "%"+plateNumber+"%")
					.list();
		else
			return	(List<Car>) getSession().createQuery(//
					"FROM Car c WHERE c.status=? order by c.plateNumber asc")
					.setParameter(0,CarStatusEnum.NORMAL).list();
	}
	
	public List<Car> findByDriverNameAndPlateNumberAndServicePointName(String driverName, String plateNumber,
			String servicePointName) {
		QueryHelper helper = new QueryHelper(Car.class, "c");
		//实时监控查询得到的车辆的状态必须是NORMAL的
		helper.addWhereCondition("c.status=?", CarStatusEnum.NORMAL);
		helper.addWhereCondition("c.borrowed=?", false);
		//实时监控查询得到的车辆必须是配置了GPS设备的，所以device不能为null
		helper.addWhereCondition("c.device is not null");
		//设置司机名称
	    if ((driverName != null) && (!"".equals(driverName))) {
			 helper.addWhereCondition("c.driver.name=?", driverName);
		}
	    //设置车牌号
	    if ((plateNumber != null) && (!"".equals(plateNumber))) {
			 helper.addWhereCondition("c.plateNumber=?", plateNumber);
		}
	    //设置服务点
	    if ((servicePointName != null) && (!"".equals(servicePointName))) {
			 helper.addWhereCondition("c.servicePoint.name=?", servicePointName);
		}
	    String hql = helper.getQueryListHql();
		Query query = getSession().createQuery(hql);
		for (int i = 0; i < helper.getParameters().size(); i++) {
			query.setParameter(i, helper.getParameters().get(i));
		}
		return query.list();
	    
	}

	public List<Car> findByServicePointName(String servicePointName) {
		return getSession().createQuery(//
				"FROM Car c WHERE c.servicePoint.name=?")
				.setParameter(0, servicePointName)
				.list();
	}

	public List<Car> findByDriverName(String driverName) {
		return getSession().createQuery(//
				"FROM Car c WHERE c.status=? and c.driver.name like ?")
				.setParameter(0, CarStatusEnum.NORMAL)
				.setParameter(1, "%"+driverName+"%")//
				.list();
	}

	public List<Car> getAllNormalCars() {
		return getSession().createQuery(//
			   "FROM Car c WHERE c.status=? and c.device is not null and c.borrowed=?")
			   .setParameter(0, CarStatusEnum.NORMAL).setParameter(1, false)
			   .list();
	}

	public Car getCarByDeviceSN(String SN){
		return (Car)getSession().createQuery("From Car c where c.device.SN=?").setParameter(0, SN).uniqueResult();
	}

	public List<Car> getAllCarFromNotStandingAndNotTempStandingGarage() {
		return getSession().createQuery("FROM Car c WHERE c.standingGarage=0 and c.tempStandingGarage=0").list();
	}
	
	public List<Car> getAllStandingGarageCar(){
		return getSession().createQuery("FROM Car c WHERE c.standingGarage=?").setParameter(0, true).list();
	}
}
