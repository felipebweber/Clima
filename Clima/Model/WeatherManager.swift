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
    func didFailWithError(erro: Error)
}

final class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dc05b8287f28b9113a9f84641e77bff5&units=metric"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        // essa linha eh para quando for fazer buscas com nome composto de cidade fazer a concatenacao de %20
        if let cityEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted){
            //            print(cityEncoded)
            let urlString = "\(weatherURL)&q=\(cityEncoded)"
            //            print(urlString)
            performRequest(with: urlString)
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
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
                if let weather = self?.parseJSON(data){
                    self?.delegate?.didUpdateWeather(weather: weather)
                }
            }
        }
        //4. start the task
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode(WeatherDataResponse.self, from: weatherData) else { return nil }
        let name = decodeData.name
        let temp = decodeData.main.temp
        let id = decodeData.weather[0].id
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        return weather
    }
    
    
}
