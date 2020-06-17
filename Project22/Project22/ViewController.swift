//
//  ViewController.swift
//  Project22
//
//  Created by paigu on 2020/06/17.
//  Copyright © 2020 paigu. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?


    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //ロケーションサービスを使用するためにユーザーの許可を必要とする
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .gray
    }

    func locationManager( manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            //デバイスが指定されたクラスを使用したエリア監視をサポートしているかどうかを示す
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                //デバイスがiBeaconプロトコルを使用したビーコンレンジングをサポートしているかどうかを示す
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let uuid = UUID(uuidString: "d63dcebc-8c85-4d91-a54e-874011cd413f")!

        let beaconRegion = CLBeaconRegion.init(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        //監視開始
        locationManager?.startMonitoring(for: beaconRegion)
        //送信開始
        locationManager?.startRangingBeacons(in: beaconRegion)

    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1){
            switch distance {

            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"

            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    //範囲内のビーコン
    func locationManager( manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {

    if let beacon = beacons.first {
        update(distance: beacon.proximity)
    }else{
        update(distance: .unknown)
    }
}
}
