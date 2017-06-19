//
//  ViewController.swift
//  Pedometer
//
//  Created by 太阳在线YHY on 2017/6/19.
//  Copyright © 2017年 太阳在线. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

	let pedometer = CMPedometer()
	
	@IBOutlet weak var stepNumber: UITextView!

	@IBOutlet weak var stepNumber1: UITextView!

	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.automaticallyAdjustsScrollViewInsets = false
		
		getPedometerData()
		
		getSometimePedometer()
		
	}
	
	
	func getPedometerData() {

		//判断设备支持情况
		guard CMPedometer.isStepCountingAvailable() else {
			self.navigationItem.title = "当前设备不支持获取步数"
			return
		}
		
		//获取今天凌晨时间
		let calendar = Calendar.current
		print(calendar)
		var components = calendar.dateComponents([.year, .month, .day], from: Date())
		print(components)
		components.hour = 0
		components.minute = 0
		components.second = 0
		let date = calendar.date(from: components)!
		
		
		//初始化并开始获取数据
	
		self.pedometer.startUpdates(from: date) { (pedometerData, error) in
			
			//错误处理
			guard error == nil else {
				print(error!)
				return
			}
	
			//获取各个数据
			var stepData = "---今日运动数据---\n"
			if let numberOfSteps = pedometerData?.numberOfSteps {
				stepData += "今日已走\(numberOfSteps)步\n"
				print(stepData)
			}
			if let distance = pedometerData?.distance {
				stepData += "今日已走\(distance)米\n"
				print(stepData)
			}
			if let floorsAscended = pedometerData?.floorsAscended {
				stepData += "今日上楼\(floorsAscended)层\n"
				print(stepData)
			}
			if let floorsDescended = pedometerData?.floorsDescended {
				stepData += "今日下楼\(floorsDescended)层\n"
				print(stepData)
			}
			//print(pedometerData?.currentPace,pedometerData?.currentCadence)
			if let currentPace = pedometerData?.currentPace {
				stepData += "步行速度\(currentPace)m/s\n"
				print(stepData)
			}
			if let currentCadence = pedometerData?.currentCadence {
				stepData += "步速为 \(currentCadence)步/秒"
				print(stepData)
			}
			
			
			//在线程中更新数据
			DispatchQueue.main.async{
				self.stepNumber.text = stepData
			}
		}
	
		
		
	}
	
	func getSometimePedometer() {
		
		let date = Date()
		
		print(date)
		
		//判断设备支持情况
		guard CMPedometer.isStepCountingAvailable() else {
			self.navigationItem.title = "当前设备不支持获取步数"
			return
		}
		
		let dataoformatter = DateFormatter()
		dataoformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		let string = dataoformatter.string(from: date)
		print(string)
		
		let fromeDate = dataoformatter.date(from: "2017-06-11 00:00:00")
		let toDate = dataoformatter.date(from: string)
		
		var stepData = "---查询历史运动数据---\n"
		
		// 查询从 fromeDate 到 toDate 走的步数
		pedometer.queryPedometerData(from: fromeDate!, to: toDate!) { (pedometerData, error) in
			//获取各个数据
		
			if let numberOfSteps = pedometerData?.numberOfSteps {
				stepData += "已走\(numberOfSteps)步\n"
				print(stepData)
			}
			if let distance = pedometerData?.distance {
				stepData += "已走\(distance)米\n"
				print(stepData)
			}
			if let floorsAscended = pedometerData?.floorsAscended {
				stepData += "上楼\(floorsAscended)层\n"
				print(stepData)
			}
			if let floorsDescended = pedometerData?.floorsDescended {
				stepData += "下楼\(floorsDescended)层\n"
				print(stepData)
			}
	//print(pedometerData?.currentPace,pedometerData?.currentCadence)
			if let currentPace = pedometerData?.currentPace {
				stepData += "步行速度\(currentPace)m/s\n"
				print(stepData)
			}
			if let currentCadence = pedometerData?.currentCadence {
				stepData += "步速为 \(currentCadence)步/秒"
				print(stepData)
			}
			
			DispatchQueue.main.async{
				self.stepNumber1.text = stepData
			}

		}
	
		
	}

}

