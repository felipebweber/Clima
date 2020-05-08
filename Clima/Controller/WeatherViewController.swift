//
//  ViewController.swift
//  Clima
//
//  Created by Felipe Weber on 28/02/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionViewWeatherHour: UICollectionView!
    @IBOutlet weak var collectionViewWeatherDays: UICollectionView!
    
    let collectionViewHoursIdentifier = "collectionViewHours"
    let collectionViewDaysIdentifier = "collectionViewDays"
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var weatherDayModel = Array<WeatherDayModel>()
    var tempWeatherHour = [WeatherDayModel]()
    var tempWeatherDay = [WeatherDayModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        collectionViewWeatherHour.delegate = self
        collectionViewWeatherHour.dataSource = self
        
        collectionViewWeatherDays.delegate = self
        collectionViewWeatherDays.dataSource = self
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func convertToCelsius(t: Int) -> Int{
        return t - 273
    }
    
    func weekDayNameBy(stringDate: String) -> String {
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
    
    func weekDayNumber(stringDate: String) -> String {
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "dd"
        return df.string(from: date);
    }
    
    func getHour(stringDate: String) -> String {
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "HH"
        return df.string(from: date);
    }
    
    func hourToInt(hour: String) -> Int {
        guard let hourInt = Int(hour) else { return 15 }
        return hourInt
    }
    
    func hourNow() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
    
    func dateLocal() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    func weatherDayByHourNow(weatherDay: Array<WeatherDayModel>) {
        for weather in weatherDay {
//            let hour = getHour(stringDate: weather.dt_txt)
            let dayServer = weekDayNumber(stringDate: weather.dt_txt)
            guard let dayS = Int(dayServer) else { return }
            let dayLocal = dateLocal()
            if dayS == dayLocal {
//                print("Dia: \(dayServer), Hour: \(hour), Temp: \(weather.temp)")
                let app = WeatherDayModel(id: weather.id, temp_min: weather.temp_min, temp_max: weather.temp_max, temp: weather.temp, cityName: weather.cityName, dt_txt: weather.dt_txt)
                tempWeatherHour.append(app)
            }
            if dayS == dayLocal+1 {
//                print("Dia proximo: \(dayServer), Hour: \(hour), Temp: \(weather.temp)")
                let app = WeatherDayModel(id: weather.id, temp_min: weather.temp_min, temp_max: weather.temp_max, temp: weather.temp, cityName: weather.cityName, dt_txt: weather.dt_txt)
                tempWeatherHour.append(app)
            }
        }
    }
    
    
    func weatherDayByDay(weatherDay: Array<WeatherDayModel>) {
        var dayLocal = dateLocal()
            for weather in weatherDay {
                let hour = getHour(stringDate: weather.dt_txt)
                let dayServer = weekDayNumber(stringDate: weather.dt_txt)
                guard let dayS = Int(dayServer) else { return }
                
                if dayS == dayLocal+1 {
                    print("Dia: \(dayServer), Hour: \(hour), Temp: \(weather.temp)")
                    let app = WeatherDayModel(id: weather.id, temp_min: weather.temp_min, temp_max: weather.temp_max, temp: weather.temp, cityName: weather.cityName, dt_txt: weather.dt_txt)
                    dayLocal = dayLocal + 1
                    tempWeatherDay.append(app)
                }
            }
        print("Tamanho do array: \(tempWeatherDay.count)")
        }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // to hilde keyboard
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text! != ""{
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateDayWeather(weatherDay: [WeatherDayModel]) {
        DispatchQueue.main.async {
            self.weatherDayModel = weatherDay
            self.tempWeatherDay = []
            self.weatherDayByHourNow(weatherDay: weatherDay)
            self.tempWeatherDay = []
            self.weatherDayByDay(weatherDay: weatherDay)
            self.collectionViewWeatherHour.reloadData()
            self.collectionViewWeatherDays.reloadData()
        }
    }
    
    func didUpdateWeather(weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(erro: Error) {
           print(erro)
       }
}


extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewWeatherHour {
            return tempWeatherHour.count
        } else {
            return tempWeatherDay.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewWeatherHour {
            let cellHours = collectionViewWeatherHour.dequeueReusableCell(withReuseIdentifier: collectionViewHoursIdentifier, for: indexPath) as! WeatherHourCollectionViewCell
//            let conditionName = "\(weatherDayModel[indexPath.item].conditionName)"
            let hour = getHour(stringDate: tempWeatherHour[indexPath.item].dt_txt)
            let hourInt = hourToInt(hour: hour)
            var imageName = ""
            if hourInt > 18 || hourInt < 6 {
                imageName = "moon.stars"
            } else {
                imageName = tempWeatherHour[indexPath.item].conditionName
            }
            
            cellHours.imageViewWeatherHour.image = UIImage(systemName: imageName)
//            let tempMax = convertToCelsius(t: weatherDayModel[indexPath.item].temp_max)
            cellHours.tempMax.text = "\(tempWeatherHour[indexPath.item].temp)"
//            let tempMin = convertToCelsius(t: weatherDayModel[indexPath.item].temp_min)
            print(tempWeatherHour[indexPath.item].dt_txt)
//            let hour = getHour(stringDate: weatherDayModel[indexPath.item].dt_txt)
            cellHours.hour.text = hour
            return cellHours
        }
        
        if collectionView == collectionViewWeatherDays {
            let cellDays = collectionViewWeatherDays.dequeueReusableCell(withReuseIdentifier: collectionViewDaysIdentifier, for: indexPath) as! WeatherDaysCollectionViewCell
            print(tempWeatherDay[indexPath.item].dt_txt)
            let day = tempWeatherDay[indexPath.item].dt_txt
            let weekday = weekDayNameBy(stringDate: day)
            
            let hour = getHour(stringDate: tempWeatherDay[indexPath.item].dt_txt)
            let hourInt = hourToInt(hour: hour)
            
            // isso não funciona :(
            if hourInt == 0 {
                print("Hour: \(hourInt)")
                print("Day: \(weekday)")
                cellDays.labelDay.text = weekday
                cellDays.labelTempMin.text = "\(tempWeatherDay[indexPath.item].temp_max)"
                cellDays.labelTempMin.text = "\(tempWeatherDay[indexPath.item].temp_min)"
                
                var imageName = ""
                if hourInt > 18 || hourInt < 6 {
                    imageName = "moon.stars"
                } else {
                    imageName = tempWeatherDay[indexPath.item].conditionName
                }
                
                cellDays.imageViewWeatherDay.image = UIImage(systemName: imageName)
            }
            
            
            return cellDays
        }
        return UICollectionViewCell()
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewWeatherHour {
            let widthCell = collectionView.bounds.width / 7
            return CGSize(width: widthCell, height: 100)
        } else {
            let widthCell = collectionView.bounds.width
            return CGSize(width: widthCell, height: 40)
        }
    }
}

extension Date {
   
}
