//
//  ViewController.swift
//  GoogleMapsSwift
//
//  Created by Next on 28/06/17.
//  Copyright © 2017 Next. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController,GMSMapViewDelegate {

    
    
    @IBOutlet weak var mMapView: GMSMapView!
    @IBOutlet weak var mButton: UIButton!
    
    
    private let baseWidth:Double = 20/14
    private let baseHeight:Double = 30/14
    
    fileprivate var i = 1
    
    var locations:[CLLocationCoordinate2D]!
    var markerView:UIImageView!
    
    
    //private var markers:[GMSMarker]!
    private var mMarker:GMSMarker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadLocations()
        mMapView.clear()
        mMapView.delegate = self
        
        let firstLocation = locations[0]
        mMarker = GMSMarker.init(position: firstLocation)
        //self.markerView = UIImageView.init(frame: CGRect(x:0,y:0,width:Double(baseWidth*14),height:Double(baseHeight*14)))
        //markerView.image = #imageLiteral(resourceName: "taxi.png")
        let taxiData:Data = try! Data.init(contentsOf: Bundle.main.url(forResource: "taxi", withExtension: "png")!)
        let image = UIImage.init(data: taxiData, scale: 5)
        self.mMarker.icon = image
        mMarker.map = self.mMapView
        
        mMapView.camera = GMSCameraPosition.camera(withLatitude: firstLocation.latitude, longitude: firstLocation.longitude, zoom: 14)
        
        if let stylesFile = Bundle.main.url(forResource: "style", withExtension: "json")
        {
            mMapView.mapStyle = try! GMSMapStyle.init(contentsOfFileURL: stylesFile)
        }
        markPolyLine(handler: {
        
            polyLine in
            
            polyLine.map = self.mMapView
        
        })
        self.mButton.addTarget(self, action: #selector(self.moveToMarker), for: .touchUpInside)
        
        
        
//        let ambulanceMarker = GMSMarker.init(position: self.locations[0])
//        ambulanceMarker.map = self.mMapView
//        var j = 0
//        let data1 = try! Data.init(contentsOf: Bundle.main.url(forResource: "1", withExtension: "png")!)
//        let data2 = try! Data.init(contentsOf: Bundle.main.url(forResource: "2", withExtension: "png")!)
//        let data3 = try! Data.init(contentsOf: Bundle.main.url(forResource: "3", withExtension: "png")!)
//        let image1 = UIImage.init(data: data1, scale: 3)
//        let image2 = UIImage.init(data: data2, scale: 3)
//        let image3 = UIImage.init(data: data3, scale: 3)
//        let timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: {_ in
//        
//            switch j
//            {
//            case 0:
//                ambulanceMarker.icon = image1
//                j+=1
//                break
//            case 1:
//                ambulanceMarker.icon = image2
//                j+=1
//                break
//            case 2:
//                ambulanceMarker.icon = image3
//                j = 0
//                break
//            default:
//                break
//            }
//            
//        })
    }

    func moveToMarker()
    {
        let camPos = GMSCameraPosition.camera(withTarget: self.mMarker.position, zoom: 16)
        self.mMapView.animate(to: camPos)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        if position.zoom <= 14
        {
            print("less than 14")
            let taxiData:Data = try! Data.init(contentsOf: Bundle.main.url(forResource: "taxi", withExtension: "png")!)
            let image = UIImage.init(data: taxiData, scale: 5)
            self.mMarker.icon = image
        }
        else
        {
            print("greater or equal to 14")
            let taxiData:Data = try! Data.init(contentsOf: Bundle.main.url(forResource: "taxi", withExtension: "png")!)
            let image = UIImage.init(data: taxiData, scale: 5)
            self.mMarker.icon = image
            
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setTimeInterval), userInfo: nil, repeats: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLocations()
    {

        var tuples = [(17.424314, 78.422836),
            (17.424194, 78.423339),
            (17.423954, 78.423842),
            (17.423754, 78.424387),
            (17.423594, 78.424932),
            (17.423354, 78.425435),
            (17.423154, 78.426022),
            (17.422954, 78.426692),
            (17.422634, 78.427195),
            (17.422394, 78.427656),
            (17.421994, 78.428033),
            (17.421634, 78.428453),
            (17.420468, 78.429013),
            (17.420152, 78.428984),
            (17.419864, 78.428984),
            (17.419658, 78.429013),
            (17.419507, 78.429085),
            (17.419301, 78.429185),
            (17.419095, 78.429286),
            (17.418889, 78.429315),
            (17.418818, 78.429342),
            (17.418714, 78.429338),
            (17.418637, 78.429338),
            (17.418610, 78.429342),
            (17.418459, 78.429338),
            (17.418375, 78.429352),
            (17.418282, 78.429356),
            (17.418261, 78.429359),
            (17.418216, 78.429377),
            (17.418139, 78.429367),
            (17.418137, 78.429366),
            (17.418073, 78.429350),
            (17.418055, 78.429350),
            (17.418037, 78.429360),
            (17.418027, 78.429378),
            (17.418019, 78.429410)]
        locations = [CLLocationCoordinate2D]()
        
        tuples = tuples.reversed()
        for tuple in tuples
        {
            locations.append(CLLocationCoordinate2D(latitude: tuple.0, longitude: tuple.1))
        }
    }
    
    func setTimeInterval()
    {
        if i < self.locations.count
        {
            CATransaction.begin()
            CATransaction.setValue(Int(3), forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({() -> Void in
            })
            let degrees = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: self.locations[i-1], toCoordinate: self.locations[i]))
            
            CATransaction.begin()
            CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
            self.mMarker.rotation = degrees
            CATransaction.commit()
            print(degrees)
            self.mMarker.position = self.locations[i]
            i+=1
            
            CATransaction.commit()
        }
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool)
    {
        //mMapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        
    }
    
    
    
    func markPolyLine(handler:@escaping (GMSPolyline)->Void)
    {
        let directionsKey = "AIzaSyAGwfE5OvPFFzQUD4dRye3BfhF1GWJSaew"
        let directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=Suchitra&destination=Ameerpet&key=\(directionsKey)"
        URLSession.shared.dataTask(with: URL.init(string: directionsUrl)!)
        {
            data,response,error in
            
            if let data = data
            {
                if let json = try? JSONSerialization.jsonObject(with: data)
                {
                    let jsonObject = json as! [String:Any]
                    let routes = jsonObject["routes"] as! [Any]?
                    if let mainRoute = routes?[0] as? [String:Any]
                    {
                        DispatchQueue.main.async
                        {
                            let polyLine = mainRoute["overview_polyline"] as! [String:Any]
                            let points = polyLine["points"] as! String
                            let path = GMSPath.init(fromEncodedPath: points)
                            let ActualpolyLine = GMSPolyline.init(path: path)
                            handler(ActualpolyLine)
                        }
                    }
                }
                
                
            }
            //print(response)
        }.resume()
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        
        
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
       
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

