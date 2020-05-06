//
//  WeatherManager.swift
//  Clima
//
//  Created by Felipe Weber on 03/03/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: class {
    func didUpdateWeather(weather: WeatherModel)
    func didUpdateDayWeather(weatherDay: [WeatherDayModel])
    func didFailWithError(erro: Error)
}

final class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dc05b8287f28b9113a9f84641e77bff5&units=metric"
    
//    let weatherURLDays = "https://samples.openweathermap.org/data/2.5/forecast/hourly?id=3451138&appid=439d4b804bc8187953eb36d2a8c26a02#"
    let weatherURLDays = "https://api.openweathermap.org/data/2.5/forecast?id=3451138&appid=dc05b8287f28b9113a9f84641e77bff5&units=metric"
    
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        // essa linha eh para quando for fazer buscas com nome composto de cidade fazer a concatenacao de %20
        if let cityEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted){
            let urlString = "\(weatherURL)&q=\(cityEncoded)"
            let urlStringDay = "\(weatherURLDays)&q=\(cityEncoded)"
            print(urlString)
            print(urlStringDay)
            performRequest(with: urlString)
            performRequestDay(with: urlStringDay)
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        let urlStringDay = "\(weatherURLDays)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        fetchWeatherDay(urlDay: urlStringDay)
    }
    
    func fetchWeatherDay(urlDay: String) {
        performRequestDay(with: urlDay)
    }
    
    //perform = executar
    func performRequestDay(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        print(url)
        let session = URLSession(configuration: .default)
        //3. give the session a task
        let task = session.dataTask(with: url) { [weak self] (data, _, error) in
            if error != nil{
                print(error!)
                self?.delegate?.didFailWithError(erro: error!)
                return
            }
            if let data = data {
                if let weatherDayArray = self?.parseDayJSON(data) {
                    self?.delegate?.didUpdateDayWeather(weatherDay: weatherDayArray)
                }
            }
        }
        //4. start the task
        task.resume()
    }
    
    //perform = executar
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        //3. give the session a task
        let task = session.dataTask(with: url) { [weak self] (data, _, error) in
            if error != nil{
                print(error!)
                self?.delegate?.didFailWithError(erro: error!)
                return
            }
            if let data = data {
                if let weather = self?.parseJSON(data) {
                    self?.delegate?.didUpdateWeather(weather: weather)
                }
            }
        }
        //4. start the task
        task.resume()
    }
    
    func parseDayJSON(_ weatherData: Data) -> [WeatherDayModel]{
        let decoder = JSONDecoder()
        var weatherDayModel = [WeatherDayModel]()
        if let decodeData = try? decoder.decode(WeatherDayDataResponse.self, from: weatherData) {
            for dd in decodeData.list {
                guard let id = dd.weather.first?.id else { return [] }
                let app = WeatherDayModel(id: id, temp_min: Int(dd.main.temp_min), temp_max: Int(dd.main.temp_max), temp: Int(dd.main.temp), cityName: decodeData.city.name, dt_txt: dd.dt_txt)
                weatherDayModel.append(app)
            }
        }
        return weatherDayModel
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(WeatherDataResponse.self, from: weatherData) else { return nil }
        let name = decodeData.name
        let temp = decodeData.main.temp
        guard let id = decodeData.weather.first?.id else { return nil }
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        return weather
    }
    
    
}
