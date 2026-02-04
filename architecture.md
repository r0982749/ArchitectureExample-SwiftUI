# SwiftUI Architecture

## MVVM

### Model layer

```swift
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
```

### Service layer (Receive data from API)

```swift
actor APIClient {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://api.example.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}
```

Keyword actor is used for built in concurrency and thread safety. Actors ensure that only one task can access their mutable state at a time and requires the use of the `await` keyword to access it's methods or properties.

#### Further decoupling

```swift
enum NetworkHelper {
    static func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

```swift
actor APIClient: APIClientProtocol {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://api.example.com/users")!
        return try await NetworkHelper.fetchData(from: url)
    }
}
```

OR

```swift
extension URLSession {
    func decode<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, _) = try await data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

```swift
actor APIClient: APIClientProtocol {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://api.example.com/users")!
        return try await URLSession.shared.decode([User].self, from: url)
    }
}
```

These examples can then be updated to also use different HTTP methods to send requests to the API.

```swift
enum HTTPMethod: String { case GET, POST, PUT, DELETE }
```

```swift
struct NetworkHelper {
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

```swift
extension URLSession {
    func request<T: Decodable>(
        _ type: T.Type,
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
        
        let (data, _) = try await data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

### ViewModel layer

```swift
@Observable
class UserListViewModel {
    private let apiClient = APIClient()
    var users = [User]()
    var isLoading = false

    func loadUsers() async {
        isLoading = true
        do {
            users = try await apiClient.fetchUsers()
        } catch {
            // handle error
        }
        isLoading = false
    }
}
```

### View layer

```swift
struct UserListView: View {
    @State var viewModel = UserListViewModel()
    
    var body: some View {
        List(viewModel.users) { user in
            Text(user.name)
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}
```

### Util layer

```
Utilities/
├── Formatting/
│   └── DateFormatting.swift
├── Extensions/
│   └── ...
├── ColorPalette.swift
```

This layer can be used to store the formatters and extensions, basically anything usefull that can be reused.


## Dependency Injection


### Environment Injection

```swift
struct UserListView: View {
    @Environment(UserListViewModel.self) var viewModel

    // ...
}

// In your App or parent:
UserListView()
    .environment(UserListViewModel(apiClient: APIClient()))
```

Use this method if the ViewModel is Global or Shared between multiple views.

### Service to ViewModel DI

```swift
protocol APIClientProtocol {
    func fetchUsers() async throws -> [User]
}
```

```swift
actor APIClient: APIClientProtocol {
    func fetchUsers() async throws -> [User] {
        // ... implementation ...
    }
}
```

```swift
@Observable
class UserListViewModel {
    private let apiClient: APIClientProtocol
    var users = [User]()
    var isLoading = false

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func loadUsers() async {
        isLoading = true
        do {
            users = try await apiClient.fetchUsers()
        } catch {
            // handle error
        }
        isLoading = false
    }
}
```

```swift
@State var viewModel = UserListViewModel(apiClient: APIClient())
```

#### For testing purposes

```swift
class MockAPIClient: APIClientProtocol {
    func fetchUsers() async throws -> [User] {
        [User(id: 1, name: "Test User", email: "test@example.com")]
    }
}

let testViewModel = UserListViewModel(apiClient: MockAPIClient())
```

## Keywords

### Extension Keyword

```swift
struct User: Codable, Identifiable {
    // Core properties
}

extension User: CustomStringConvertible {
    var description: String { "\(name) (\(email))" }
}
```

Extension can be used to add extra logic to an existing struct or class. It can be used to improve organisation and readability ("clean code"). 

Rules:
- Don't add stored properties
- Avoid overusing extensions
- Prefer extensions for grouping related methods

### Protocol keyword

```swift
protocol Greetable {
    var name: String { get }
    func greet() -> String
}

struct User: Greetable {
    let name: String
    func greet() -> String { "Hello, \(name)!" }
}
```

A protocol behaves like the mix between an "interface" and an "abstract class" in Java. It is like a contract that the implementing type has to follow.

## Annotations

### @State (modern way to use ViewModels in Views)
The "@State" annotation is used for local variables within a view, when the variable is changed the view updates. The ViewModel is destoyed when leaving the View, theoretically saving memory.

```swift
@MainActor
@Observable
final class AppCoordinator {
    var name: String = "Tester"
    
    @ViewBuilder
    func rootView() -> some View {
        Text("Hello, \(name)!")
    }
}
```

```swift
@State private var coordinator = AppCoordinator()
```

### @StateObject & @Published (Old pattern, do not use)
A variable with the "@StateObject" annotation updates the view when a property of the object that is annotated with "@Published" is changed. The ViewModel is not destroyed and recreated everytime the View is changed.
The class itself must be an "ObservableObject"

```swift
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var name: String = "Tester"
    
    @ViewBuilder
    func rootView() -> some View {
        Text("Hello, \(name)!")
    }
}
```

```swift
@StateObject private var coordinator = AppCoordinator()
```    
