package com.yuqincar.domain.order;

import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import com.yuqincar.domain.car.Car;
import com.yuqincar.domain.common.BaseEntity;
import com.yuqincar.domain.privilege.User;
import com.yuqincar.utils.Text;

@Entity
public class ReserveCarApplyOrder extends BaseEntity {
	@Text("申请原因")
	private String reason;
	
	@Text("申请人")
	@OneToOne(fetch=FetchType.LAZY)
	@JoinColumn(nullable = false)
	private User proposer;
	
	@Text("申请车辆数量")
	private int carCount;
	
	@Text("使用起始日期")
	private Date fromDate;
	
	@Text("使用结束日期")
	private Date toDate;
	
	@Text("申请状态")
	@Column(nullable = false)
	private ReserveCarApplyOrderStatusEnum status;
	
	@Text("车辆审批人")
	@OneToOne(fetch=FetchType.LAZY)
	private User carApproveUser;
	
	@Text("车辆审批人意见")
	private String carApproveUserMemo;
	
	@Text("车辆审批人是否审批通过")
	private boolean carApproved;
	
	@Text("审批车辆")
	@OneToMany
	@JoinTable(name = "reserveApply_car", joinColumns = { @JoinColumn(name = "apply_id")},
		inverseJoinColumns = { @JoinColumn(name = "car_id") })
	private Set<Car> cars;
	
	@Text("司机审批人")
	@OneToOne(fetch=FetchType.LAZY)
	private User driverApproveUser;
	
	@Text("司机审批意见")
	private String driverApproveUserMemo;
	
	@Text("司机审批人是否审批通过")
	private boolean driverApproved;
	
	@Text("审批司机")
	@OneToMany
	@JoinTable(name = "reserveApply_driver", joinColumns = { @JoinColumn(name = "apply_id")},
		inverseJoinColumns = { @JoinColumn(name = "driver_id") })
	private Set<User> drivers;
	
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public User getProposer() {
		return proposer;
	}
	public void setProposer(User proposer) {
		this.proposer = proposer;
	}
	public int getCarCount() {
		return carCount;
	}
	public void setCarCount(int carCount) {
		this.carCount = carCount;
	}
	public Date getFromDate() {
		return fromDate;
	}
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}
	public Date getToDate() {
		return toDate;
	}
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}
	public ReserveCarApplyOrderStatusEnum getStatus() {
		return status;
	}
	public void setStatus(ReserveCarApplyOrderStatusEnum status) {
		this.status = status;
	}
	public User getCarApproveUser() {
		return carApproveUser;
	}
	public void setCarApproveUser(User carApproveUser) {
		this.carApproveUser = carApproveUser;
	}
	public String getCarApproveUserMemo() {
		return carApproveUserMemo;
	}
	public void setCarApproveUserMemo(String carApproveUserMemo) {
		this.carApproveUserMemo = carApproveUserMemo;
	}
	public boolean isCarApproved() {
		return carApproved;
	}
	public void setCarApproved(boolean carApproved) {
		this.carApproved = carApproved;
	}
	public Set<Car> getCars() {
		return cars;
	}
	public void setCars(Set<Car> cars) {
		this.cars = cars;
	}
	public User getDriverApproveUser() {
		return driverApproveUser;
	}
	public void setDriverApproveUser(User driverApproveUser) {
		this.driverApproveUser = driverApproveUser;
	}
	public String getDriverApproveUserMemo() {
		return driverApproveUserMemo;
	}
	public void setDriverApproveUserMemo(String driverApproveUserMemo) {
		this.driverApproveUserMemo = driverApproveUserMemo;
	}
	public boolean isDriverApproved() {
		return driverApproved;
	}
	public void setDriverApproved(boolean driverApproved) {
		this.driverApproved = driverApproved;
	}
	public Set<User> getDrivers() {
		return drivers;
	}
	public void setDrivers(Set<User> drivers) {
		this.drivers = drivers;
	}	
}
