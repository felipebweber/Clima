//
//  WeatherManager.swift
//  Clima
//
//  Created by Felipe Weber on 03/03/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dc05b8287f28b9113a9f84641e77bff5&units=metric"
    
    func fetchWeather(cityName: String){
        // essa linha eh para quando for fazer buscas com nome composto de cidade fazer a concatenacao de %20
        if let cityEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted){
//            print(cityEncoded)
            let urlString = "\(weatherURL)&q=\(cityEncoded)"
//            print(urlString)
            performRequest(urlString: urlString)
        }
    }
    
    //perform = executar
    func performRequest(urlString: String){
        //1. create a URL
//        print(urlString)
        
        
        
        if let url = URL(string: urlString){
//            print(url)
            //2. create a URLSession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            //4. start the task
            task.resume()
        }
       
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil{
            print(error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
}
