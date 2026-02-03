# Stappenplan

## Data laag

### "DAOs" -> Services

#### Huidige DAO
```swift
class TransportDAO  {
    func getTransports() async throws -> [Transport]? {
        do {
            let result = try await WebServiceUtils().webServiceGet(url: "/api/meansoftransportation")
            return try JSONDecoder().decode([Transport].self, from: result!)
            
        } catch {
            print("Error getting transports: \(error)")
            return nil
        }
    }
}
```

#### Voorbeeld "modern" Service

```swift
protocol TransportServiceProtocol {
    func fetchTransports() async throws -> [Transport]?
}


```


## UI laag

### View

### ViewModel