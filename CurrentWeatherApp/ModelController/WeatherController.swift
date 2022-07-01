//
//  WeatherController.swift
//  CurrentWeatherApp
//
//  Created by Ivan Ramirez on 2/2/22.
//

import Foundation

class WeatherController {
    
    ///This is a private API linked to Ivan's profile on the api.openweathermap.org website. At the time of this project's creation, the API key is in the free tier and is active. Instructors and the students can use this API key. Be mindful, that the time will come when this API key will be deactivated at which time the instructor or student will need to register for a new api key on the api.openweathermap.org website to use in their projects.
    private let myAPIKey = "a715b4215a6ddc28e9eb0d95ea296611"
    private let baseURL = "https://api.openweathermap.org"
    
    //API syntax for reference
    //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    
    /**
     Get the user's weather Details
     - Lat is latitude
     - Lon is longitude
     
     ## Important Note ##
     The user needs to grant permission to get those values
     */
    func fetchWeather(lat: String, lon: String, completion: @escaping (Result<WeatherInfo, NetworkingError>) -> Void) {
        
        guard var url = URL(string:baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        
        url.appendPathComponent("data")
        url.appendPathComponent("2.5")
        url.appendPathComponent("weather")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // the query
        let latQuery = URLQueryItem(name: "lat", value: lat)
        
        let longQuery = URLQueryItem(name: "lon", value: lon)
        
        let apiKey = URLQueryItem(name: "appid", value: "a715b4215a6ddc28e9eb0d95ea296611")
        
        let units = URLQueryItem(name: "units", value: "imperial")
        
        // append those queries to the URL
        components?.queryItems = [latQuery, longQuery, apiKey, units]
        
        guard let builtURL = components?.url else {
            
            completion(.failure(.badBuiltURL))
            return
        }
        //Just for testing
        print("\n\(builtURL.description)\n")
        
        URLSession.shared.dataTask(with: builtURL) { (data, response, error) in
            if let error = error {
                print(error)
                completion(.failure(.errorWithRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(WeatherInfo.self, from: data)
                completion(.success(user))
            } catch let error{
                print(error)
                print(error.localizedDescription)
                completion(.failure(.errorWithRequest))
            }
        }.resume()
    }
}


