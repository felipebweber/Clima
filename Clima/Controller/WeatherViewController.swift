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
            return weatherDayModel.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewWeatherHour {
            let cellHours = collectionViewWeatherHour.dequeueReusableCell(withReuseIdentifier: collectionViewHoursIdentifier, for: indexPath) as! WeatherHourCollectionViewCell
            let conditionName = "\(weatherDayModel[indexPath.item].conditionName)"
            cellHours.imageViewWeatherHour.image = UIImage(systemName: conditionName)
            let tempMax = convertToCelsius(t: weatherDayModel[indexPath.item].temp_max)
            cellHours.tempMax.text = "\(tempMax)"
            let tempMin = convertToCelsius(t: weatherDayModel[indexPath.item].temp_min)
            cellHours.tempMin.text = "\(tempMin)"
            return cellHours
        } else {
            let cellDays = collectionViewWeatherDays.dequeueReusableCell(withReuseIdentifier: collectionViewDaysIdentifier, for: indexPath) as! WeatherDaysCollectionViewCell
            cellDays.labelDay.text = "O meu deus"
            return cellDays
        }
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewWeatherHour {
            let widthCell = collectionView.bounds.width / 7
            return CGSize(width: widthCell, height: 100)
        } else {
            let widthCell = collectionView.bounds.width
            return CGSize(width: widthCell, height: 50)
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    
}
