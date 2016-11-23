package com.yuqincar.service.monitor.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yuqincar.dao.monitor.MonitorGroupDao;
import com.yuqincar.domain.car.Car;
import com.yuqincar.domain.monitor.MonitorGroup;
import com.yuqincar.service.car.CarService;
import com.yuqincar.service.monitor.MonitorGroupService;

@Service
public class MonitorGroupServiceImpl implements MonitorGroupService{

	@Autowired
	private MonitorGroupDao monitorGroupDao;
	
	@Autowired
	private CarService carService;
	
	@Transactional
	public void delete(Long id) {
		monitorGroupDao.delete(id);
	}
	@Transactional
	public void save(MonitorGroup monitorGroup) {
		monitorGroupDao.save(monitorGroup);
	}
	@Transactional
	public void update(MonitorGroup monitorGroup) {
		monitorGroupDao.update(monitorGroup);
	}
	public List<MonitorGroup> getAll() {
		return monitorGroupDao.getAll();
	}
	public MonitorGroup getById(Long id) {
		return monitorGroupDao.getById(id);
	}
	public List<Car> sortCarByPlateNumber() {
		//排序
		List<Car> carsList = carService.getCarsForMonitoring();
		List<Car> sortList = new ArrayList<Car>();
		List<String> plateNumberList = new ArrayList<String>();
		for(Car car:carsList){
			plateNumberList.add(car.getPlateNumber());
		}
		Collections.sort(plateNumberList);
		for(String plateNumber:plateNumberList){
			sortList.add(carService.getCarByPlateNumber(plateNumber));
		}
		return sortList;
	}

	
}
