import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var Humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        cityName.text = ""
        weatherDescription.text = ""
        weatherTemperature.text = ""
        Humidity.text = ""
        windSpeed.text = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        updateLocation(userLocation: userLocation)
    }
    
    func updateLocation(userLocation: CLLocation) {
        getCityName(userLocation: userLocation)
        getWeather(userLocation: userLocation)
    }
    
    func getCityName(userLocation: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.cityName.text = placemark.locality
                }
            }
        }
    }
    
    func getWeather(userLocation: CLLocation) {
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        let apiKey = "a51cc8978987904af64cd7d31817bc48"
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                self.updateWeather(data: data)
            }
        }.resume()
    }
    
    func updateWeather(data: Data) {
        do {
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
                self.cityName.text = weatherData.name ?? "No Location"
                self.weatherDescription.text = weatherData.weather?[0].description ?? "No description"
                self.weatherTemperature.text = "\(Int((weatherData.main?.temp ?? 273.15) - 273.15))°C"
                self.Humidity.text = "Humidity: \(weatherData.main?.humidity ?? 0)%"
                self.windSpeed.text = "Wind Speed: \((weatherData.wind?.speed ?? 0) * 3.6) km/h"
                self.WeatherIcon(icon: weatherData.weather?[0].icon)
                
            }
        } catch {
            print("Error decoding weather data: \(error)")
        }
    }
    
    func WeatherIcon(icon: String?) {
        guard let icon = icon else { return }
        let urlStr = "https://openweathermap.org/img/w/\(icon).png"
        
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error getting weather icon: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.weatherIcon.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
