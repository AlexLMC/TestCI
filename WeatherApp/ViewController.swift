//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alex on 20.03.2018.
//  Copyright © 2018 LMC. All rights reserved.
//

import UIKit
import Kingfisher

struct WeatherReport :Decodable{
    var location : Location?
    var current : Current?
}
struct Location:Decodable {
    var name: String?
    var region : String?
    var counry : String?
    var lat : Double
    var lon : Double
    var tz_id : String?
    var localtime_epoch : Int?
    var localtime : String?
}
struct Current:Decodable {
    var last_updated_epoch:Int?
    var last_updated:String?
    var temp_c : Int?
    var temp_f : Double?
    var is_day : Double?
    var condition :Condition?
    var wind_mph : Double?
    var wind_kph: Double?
    var wind_degree: Double?
    var wind_dir : String?
    var pressure_mb: Double?
    var pressure_in: Double?
    var precip_mm: Double?
    var precip_in: Double?
    var humidity: Double?
    var cloud: Double?
    var feelslike_c: Double?
    var feelslike_f: Double?
    var vis_km: Double?
    var vis_miles: Double?
}
struct Condition:Decodable {
    var text : String?
    var icon : String?
    var code : Int?
}
class ViewController: UIViewController {
    
    
    @IBOutlet weak var aboutTheather: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var ImagePOGO: UIImageView!
    override func viewDidLoad() {
        func Button(_ sender: UIButton) {
        }
        super.viewDidLoad()
        searchBar.delegate = self
        
        }
    }

   





extension ViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    let urlString = "https://api.apixu.com/v1/current.json?key=5ff4f4011d2d41588f773103182003&q=\(searchBar.text!)"
       
        guard let url = URL(string: urlString) else {return}
       
        let task = URLSession.shared.dataTask(with: url) { (data,response ,error) in
            do{
                let json   = try JSONDecoder().decode(WeatherReport.self, from: data!)
                print(json)
                guard (json.current?.temp_c) != nil else {return}
                let temperature:Int = (json.current?.temp_c!)!
                let urlImageChange :String = "http:\((json.current?.condition?.icon)!)"
                
//                let barIndex = urlImageChange.index(urlImageChange.startIndex, offsetBy: 2)
//                urlImageChange = String(urlImageChange[barIndex ..< urlImageChange.endIndex])
//                print("11")
                print(urlImageChange)
                let urlImage : URL?
                let aboutTheatherText :String
//                if (json.location?.name)! == "Taganrog"{
//                    urlImage = URL(string: "http://don24.ru/uploads/2018/%D0%9C%D0%B0%D1%80%D1%82/%D0%96%D0%9A%D0%A5/%D0%9C%D0%B5%D0%BC%20%D1%80%D0%B5%D0%B4-5aa8e9d24a1f2.png")!
//                    aboutTheatherText = "Ты кто такой ?"
//                }else{
                    urlImage = URL(string: urlImageChange)
                    aboutTheatherText = (json.current?.condition?.text)!
//                }
                
            
               
                //print((json.current?.condition?.icon)!)
                //guard let urlImage = URL(string: "https://i2.wp.com/beebom.com/wp-content/uploads/2016/01/Reverse-Image-Search-Engines-Apps-And-Its-Uses-2016.jpg?w=640&ssl=1") else {return}
                
                DispatchQueue.main.async {
                    if (json.location?.name)! == "Taganrog"{
                        self.cityLable.text = "Ой ой"
                    }else{
                        self.cityLable.text = "В городе \((json.location?.name)!)"
                    }
                    self.temperatureLable.text = "Температура \(String(describing: temperature))c"
                    if (json.location?.name)! == "Moscow"{
                        self.ImagePOGO.image = #imageLiteral(resourceName: "Moscow")
                    }else{
                        self.ImagePOGO.kf.setImage(with: urlImage)
                    }
                    self.aboutTheather.text = aboutTheatherText
                    print("12")
                    print("12")

                }
                
            }
            catch let jsonError{
                print(jsonError)
            }
           
        }
        task.resume()
    }
}
