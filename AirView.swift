//
//  AirView.swift
//  VolcanoHike
//
//  Created by Kristbjorg Oskarsdottir on 19.4.2021.
//


import SwiftUI
import Foundation


struct RootData: Codable {
    var results: [Result]
}
struct Result: Codable, Hashable {
    var location: String
    var city: String
    var country: String
    var coordinates: Coordinates
    var measurement: [Measurements]
    
    enum CodingKeys: String, CodingKey {
        case location
        case city
        case country
        case coordinates = "coordinates"
        case measurement = "measurements"
    }
}
    struct Coordinates: Codable, Hashable {
        var latitude: Double
        var longitude: Double
        
        enum CoordinatesCodingKeys: String, CodingKey {
            case latitude = "latitude"
            case longitude = "longitude"
        }
    }
    struct Measurements: Codable, Hashable {
        var parameter: String
        var value: Double
        var lastUpdated: String
        var unit: String
        
        enum MeasurementsCodingKey: String, CodingKey {
            case parameter = "parameter"
            case value = "value"
            case lastUpdated = "lastUpdated"
            case unit = "unit"
            
        }
    }


class DataModal: ObservableObject {
    @Published var results = [Result]()
   
    init() {
        guard let url = URL(string: "https://api.openaq.org/v1/latest?country=IS&parameter=so2") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let airData = try JSONDecoder().decode(RootData.self, from: data)
                print(airData)
                DispatchQueue.main.async {
                    self.results = airData.results
                }
            } catch {
                print("Failed to decode: \(error)")
            }
        }.resume()
    }
}


struct AirView: View {
    
    @ObservedObject var airDataModal = DataModal()
   
    var body: some View {
        
        List(airDataModal.results, id: \.self) { result in
            VStack(alignment: .leading) {
                Text(result.city)
                Text(result.location)
                
                // Vil fá : Coordinates, parameter og lastUpdated
                
            }
        }
        .padding()
        
    }
}



