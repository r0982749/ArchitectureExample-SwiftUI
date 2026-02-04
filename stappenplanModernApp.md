# Stand van zaken

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

Om het beste resultaat te bekomen, zullen ook de Util klassen aangepast moeten worden. Zodat ze ook voldoen aan de modern app principes, maar dit is nog niet noodzakelijk en kan achteraf gebeuren.

Door deze aanpassing door te voeren, moeten we waarschijnlijk de datatypes aanpassen van de Services in de ViewModels, maar door het behouden van de functionaliteit moeten er verder geen aanpassingen gemaakt worden aan de UI laag.

Met deze aanpassing bestaat ook de mogelijkheid om "mock" implementaties aan te maken voor de services (of offline first varianten). Dit is mogelijk gemaakt door het gebruiken van het "protocol" keyword.

### Utils

#### "WebServiceUtils" -> NetworkRequester

De "WebServiceUtils" klasse kan verder generiek gemaakt worden. We kunnen ervoor zorgen dat duplicate code vermeden wordt en de leesbaarheid van de klasse stijgt.

Bij het uitvoeren van deze update zal ook de Service laag aangepast moeten worden om de nieuwe manier van network request te volgen. Het impact van deze verandering zal dus miniem zijn als de originele werking van de "WebServiceUtils" klasse bewaard wordt.

```swift
enum HTTPMethod: String { case GET, POST, PUT, DELETE }

enum NetworkRequester {
    static func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        body: Data? = nil,
        jwt: String? = nil
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body { request.httpBody = body }
        if let jwt = jwt {
            request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        }
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

Dit is een voorbeeld van een generieke "request" methode die alle HTTP request kan versturen. De "NetworkRequester" is een enum doordat dit ervoor zorgt dat er geen variabelen kunnen aangemaakt worden van het type NetworkRequester.

Op deze manier kunnen we ervoor zorgen dat deze util klasse enkel gebruikt wordt om data op te halen.

## UI laag

### View

### ViewModel

Om de View te kunnen sturen met de ViewModel kunnen we gebruik maken van een "@Observable" klasse. Door de klasse observable te maken zorgen we ervoor dat de View wordt geupdate als de ViewModel wijzigd.

Hierna kunnen we in de View de "@State" annotatie om de ViewModel te kunnen gebruiken.

```swift
@Observable
class SomeViewModel {
    @Published var name: String = "John"
}

struct SomeView: View {
    @State private var someViewModel = SomeViewModel()

    var body: some View {
        //...
    }
}
```

Voor gedeelde ViewModels, voor bijvoorbeeld de huidige gebruiker op te vragen, kunnen we het environment gebruiken.

Het is aangeraden om de gedeelde ViewModels zo "hoog" mogelijk toe te voegen aan het environment, bijvoorbeeld in de "@main" app struct.

```swift
@main
struct SomeApp: App {
    @State private var someViewModel = SomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(someViewModel)
        }
    }
}
```

Dit laat toe om dan in de View de ViewModel op te halen uit het environment in plaats van ze door te geven doorheen onze app. Het is aangeraden om "ContentView" te gebruiken om de entry point van de app te beperken in complexiteit ("@main" struct), en dus al de Views pas op te roepen in de "ContentView" struct.

```swift
struct ContentView: View {
    var body: some View {
        SomeView()
    }
}

struct SomeView: View {
    @Environment(SomeViewModel.self) var someViewModel

    var body: some View {
        //...
    }
}
```

Op deze manier kan je een specifieke ViewModel ophalen uit het environment op basis van zijn type (in dit geval "SomeViewModel").

# Stappenplan

1. "DAOs" omvormen naar Services

    - Impact:

        - Aanpassen referenties naar de klasse in UI laag

    - Voordelen:

        - Door gebruik te maken van protocol'en wordt de UI laag gescheiden van de data laag, waardoor we bijvoorbeeld gebruik kunnen maken van offline first services.

2. "WebServiceUtils" omvormen

    - Impact:

        - Aanpassen van de services die voorheen de WebServiceUtils klasse gebruikte (Als we ervoor kiezen om ook de namen van methodes aan te passen)
    
    - Voordelen:

        - De web requests worden generiek gemaakt waardoor leesbaarheid stijgt en duplicate code vermeden wordt.
