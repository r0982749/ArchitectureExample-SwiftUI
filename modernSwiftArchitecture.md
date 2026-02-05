## Architectuur

### High level architectuur

![High level architectuur](https://i.ibb.co/cXpHt9T7/High-level.png)

### Dependency chart

![Dependency chart](https://i.ibb.co/HTgJDyjv/Dependency-chart.png)

### Voorbeeld met concrete namen

![Naming convention chart](https://i.ibb.co/0yFDBdp8/i-OS-Architecture.png)

# 2. UI laag

### ViewModel

```swift
@Observable
class SomeViewModel {
    var name: String = "John"
}

struct SomeView: View {
    @State private var someViewModel = SomeViewModel()

    var body: some View {
        //...
    }
}
```

#### Gedeelde ViewModels (Environment)

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

### View

```swift
struct SomeView: View {
    @State private var someViewModel = SomeViewModel()

    var body: some View {
        //...
    }
}

private extension SomeView {
    var calculatedField: Int { ... }

    func doSomething() { ... }
}
```

## Service laag

### Interface

```swift
protocol SomeServiceProtocol {
    func fetchSomething() async throws -> [String]?
}
```

### Implementatie

```swift
actor SomeService: SomeServiceProtocol {
    func fetchSomething() async throws -> [String]? {
        //...
    }
}
```

## Data laag

### Model

```swift
struct User {
    let firstname: String
    let lastname: String
    var fullname: String { "\(firstname) \(lastname)" }
}
```

### Mapper

```swift
struct UserMapper {
    func getUserFromJson(_ json: String) -> User? {
        do {
            let userDTO = try getUserDTOFromJson(json)
            
            return map(from: userDTO)
        }
        catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    func map(from userDTO: UserDTO) -> User {
        return User(firstname: userDTO.firstname, lastname: userDTO.lastname)
    }
    
    private func getUserDTOFromJson(_ json: String) throws -> UserDTO {
        return try JSONDecoder().decode(UserDTO.self, from: Data(json.utf8))
    }
}
```

### DTO

```swift
struct UserDTO: Decodable {
    let firstname: String
    let lastname: String
}
```

## Utils

### Netwerkrequests in util laag

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