//
//  ViewController.swift
//  LocationInfomation
//
//  Created by 402-07 on 2018. 8. 12..
//  Copyright © 2018년 moonbc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

import AVFoundation


class ViewController: UIViewController , CLLocationManagerDelegate{
    
    //위치 정보 사용을 위한 인스턴스 생성
    var locationManager: CLLocationManager = CLLocationManager()
    //시작 위치를 지정할 인스턴스 변수 생성
    var startLocation: CLLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblLatitude: UILabel!
    
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var lblAltitude: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //위치 정보 정밀도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //delegate 설정
        locationManager.delegate = self
        //위치정보 사용여부를 묻는 대화상자를 출력
        locationManager.requestWhenInUseAuthorization()
        
        
        mapView.showsUserLocation = true
        
        let url  = URL(fileURLWithPath: Bundle.main.path(forResource: "가시나", ofType: "mp3")!)
        
        var audioPlayer = try! AVAudioPlayer(contentsOf: url)
        
        audioPlayer.prepareToPlay()

        audioPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        
    }

    @IBAction func locationInformation(_ sender: Any) {
        //이벤트가 발생한 객체를 가져오기
        let btn = sender as! UIButton
        if(btn.title(for: .normal) == "위치정보수집시작") {
            btn.setTitle("위치정보수집종료", for: .normal)
            
            //위치정보 업데이트 시작 - delegate에 설정된 메소드 호출
            locationManager.startUpdatingLocation()
            	mapView.showsUserLocation = true
        }else {
            btn.setTitle("위치정보수집시작", for: .normal)
            //위치정보 업데이트 중지
            locationManager.stopUpdatingLocation()
            
            
        }
    }
    
    
    //위치 정보가 갱신될 때 호출 되는 메소드
    //locations는 위치 정보의 배열입니다.
    //마지막 데이터가 가장 최근의 데이터입니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //가장 최근의 위치 정보 가져오기
        let lastlocation = locations[locations.count-1]
        //위도 출력하기
        
        lblLatitude.text = String(format: "%.4f", lastlocation.coordinate.latitude)
        lblLongitude.text = String(format: "%.4f", lastlocation.coordinate.longitude)
        lblAltitude.text = String(format: "%.4f", lastlocation.altitude)
        
        //지도 위치 변경하기
        //지도의 중앙점을 만들기
        let pLocation = CLLocationCoordinate2DMake(lastlocation.coordinate.latitude, lastlocation.coordinate.longitude)
        
        //지도에 표시할 거리
        let delta = MKCoordinateSpanMake(0.5, 0.5)
        //영역 만들기
        let pRegion = MKCoordinateRegionMake(pLocation, delta)
        mapView.setRegion(pRegion, animated: true)
        
        
        //시작 위치 만들기
        if startLocation == nil {
            startLocation = lastlocation
        }
        
        lblDistance.text = String(format: "%.4f", lastlocation.distance(from: startLocation))
        
        
        
        
    }
    
}

