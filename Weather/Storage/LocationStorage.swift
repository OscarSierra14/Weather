//
//  LocationStorage.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 23/08/24.
//

import CoreData
import UIKit

enum LocationStorageError: Error {
    case locationAlreadyExists
    case locationNotFound
    case saveFailed(Error)
}

protocol LocationStorageProtocol: AnyObject {
    func save(location: Location) throws
    func fetchLocation(byCityIdentifier cityIdentifier: Int64) -> SavedLocation?
    func fetchAllLocations() -> [SavedLocation]
    func update(location: Location) throws
}

class LocationStorage: LocationStorageProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(location: Location) throws {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityIdentifier == %d", location.currentWeather.id as CVarArg)
        
        let existingLocations = try context.fetch(fetchRequest)
        
        if existingLocations.isEmpty {
            // La ubicación no existe, crear una nueva entidad
            let locationEntity = LocationEntity(context: context)
            locationEntity.id = location.id
            locationEntity.cityName = location.cityName
            locationEntity.latitude = location.latitude
            locationEntity.longitude = location.longitude
            locationEntity.registrationDate = location.registrationDate
            locationEntity.cityIdentifier = Int64(location.currentWeather.id)
            locationEntity.information = location.currentWeather.weather.first?.information
            
            let weatherEntity = WeatherResponseEntity(context: context)
            weatherEntity.icon = location.currentWeather.weather.first?.iconURL
            weatherEntity.name = location.currentWeather.name
            weatherEntity.temp = location.currentWeather.main.temp
            
            
            locationEntity.currentWeather = weatherEntity
            
            try context.save()
        } else {
            throw LocationStorageError.locationAlreadyExists
        }
    }
    
    func fetchLocation(byCityIdentifier cityIdentifier: Int64) -> SavedLocation? {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currentWeather.cityIdentifier == %d", cityIdentifier)
        
        do {
            let entities = try context.fetch(fetchRequest)
            if let entity = entities.first {
                return SavedLocation(
                    id: entity.id,
                    name: entity.currentWeather?.name,
                    savedName: entity.cityName,
                    latitude: entity.latitude,
                    longitude: entity.longitude,
                    registrationDate: entity.registrationDate,
                    icon: entity.currentWeather?.icon,
                    temperature: entity.currentWeather?.temp,
                    information: entity.information
                )
            }
        } catch {
            print("Failed to fetch location: \(error)")
        }
        return nil
    }
    
    func fetchAllLocations() -> [SavedLocation] {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        
        do {
            let locationEntities = try context.fetch(fetchRequest)
            return locationEntities.map { entity in
                return SavedLocation(
                    id: entity.id,
                    name: entity.currentWeather?.name,
                    savedName: entity.cityName,
                    latitude: entity.latitude,
                    longitude: entity.longitude,
                    registrationDate: entity.registrationDate,
                    icon: entity.currentWeather?.icon,
                    temperature: entity.currentWeather?.temp,
                    information: entity.information
                )
            }
        } catch {
            print("Failed to fetch locations: \(error)")
            return []
        }
    }
    
    func update(location: Location) throws {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityIdentifier == %d", location.currentWeather.id)
        
        do {
            let entities = try context.fetch(fetchRequest)
            if let entityToUpdate = entities.first {
                entityToUpdate.id = location.id
                entityToUpdate.cityName = location.cityName
                entityToUpdate.latitude = location.latitude
                entityToUpdate.longitude = location.longitude
                entityToUpdate.registrationDate = location.registrationDate
                entityToUpdate.cityIdentifier = Int64(location.currentWeather.id)
                entityToUpdate.information = location.currentWeather.weather.first?.information
                
                let weatherEntity = entityToUpdate.currentWeather
                weatherEntity?.icon = location.currentWeather.weather.first?.iconURL
                weatherEntity?.name = location.currentWeather.name
                weatherEntity?.temp = location.currentWeather.main.temp
                
                try context.save()
            } else {
                throw LocationStorageError.locationNotFound
            }
        } catch {
            debugPrint("Failed to update location: \(error)")
            throw error
        }
    }
}
