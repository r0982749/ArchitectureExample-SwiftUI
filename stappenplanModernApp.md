# Stappenplan

## Data laag

Deze laag zal de "source of thruth" worden, en zal met zijn data de rest van de app aansturen.

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

actor TransportService: TransportServiceProtocol {
    func fetchTransports() async throws -> [Transport]? {
        // implementation
    }
}
```

Om dit resultaat te bekomen zullen ook de Util klassen aangepast moeten worden. Zodat ze ook voldoen aan de modern app principes.

Door deze aanpassing door te voeren moeten we waarschijnlijk de datatypes aanpassen van de Services in de ViewModels, maar door het te behouden van de functionaliteit moeten er verder geen aanpassingen gemaakt worden aan de UI laag.

Met deze aanpassing bestaat ook de mogelijkheid om "mock" implementaties aan te maken voor de services (of offline first varianten). Dit is mogelijk gemaakt door het gebruiken van het "protocol" keyword.

### Utils

#### "WebServiceUtils" -> NetworkRequester

De "WebServiceUtils" klasse kan verder generiek gemaakt worden, we kunnen ervoor zorgen dat 

## UI laag

### View

### ViewModel