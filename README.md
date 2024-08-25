# Weather iOS App

## Overview

Weather is an iOS application that allows users to register locations, view current weather information, and receive notifications about significant weather updates. The app is built using VIPER architecture, Core Data for persistence, and includes robust networking and location management features.

## Features

- **Location Management**: Users can register multiple locations and view weather updates for each.
- **Weather Information**: Current weather information is fetched from OpenWeatherMap API.
- **Push Notifications**: Users receive notifications when significant weather changes occur for their registered locations.
- **Core Data**: Locations and related weather data are persisted using Core Data.
- **Location Services**: The app tracks the user's location and updates weather information accordingly.
- **Background Monitoring**: The app monitors weather changes even when in the background or fully closed.

## Architecture

- **VIPER**: The app is structured using the VIPER architecture, separating the application logic into distinct components: View, Interactor, Presenter, Entity, and Router.
- **Networking Layer**: A professional networking layer handles API requests and responses, including error management and JSON decoding.
- **Core Data Integration**: Core Data is used for persisting location and weather data, including CRUD operations with detailed validation.

## Networking Layer

The networking layer is built with extensibility and error handling in mind. API endpoints and app credentials like `appId` and base URL are stored in the `.plist` file for easy configuration.

## Location Services

Location Services are managed with proper permission handling, including prompting the user to enable location services if not already granted. If permissions are denied, a modal redirects the user to the app settings.

## Core Data

### Location Entity

The `LocationEntity` stores information about registered locations.

### WeatherResponseEntity

This `WeatherResponseEntity` stores weather data related to the location.

### CRUD Operations

- **Save**: Locations are saved only if they do not already exist in Core Data. The `cityIdentifier` is used to validate uniqueness.
- **Update**: Existing locations can be updated with new weather data.
- **Fetch**: Locations can be fetched by `cityIdentifier` for further operations or display.

## Notifications

Notifications are triggered when significant weather changes are detected for any of the registered locations. These notifications are sent even if the app is in the background or completely closed.

## Additional Information

- **Error Handling**: The app has robust error handling, including dealing with errors from the API and Core Data.
- **Background Fetch**: Weather updates are monitored in the background, ensuring that the user is always informed about significant changes.

| Feature         |  Evidence               |
|-----------------|--------------------------------|
| Register Location |<img src="https://github.com/user-attachments/assets/ba4ae01c-d4b2-49e0-87f4-c2e8607fb10b" width="200">|
| Saved Location | <img src="https://github.com/user-attachments/assets/51947df8-a824-48a5-b37a-fe659bbdbd95" width="200"> |
| Saved Location Detail | <img src="https://github.com/user-attachments/assets/b18539fc-cb9c-42f7-9b28-b5613014ac8a" width="200"> |
| Current Location Detail | <img src="https://github.com/user-attachments/assets/44690ab9-e07c-4aac-b868-559816226901" width="200"> |
