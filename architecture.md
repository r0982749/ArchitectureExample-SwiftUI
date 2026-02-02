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

### AppCoordinator

```swift
@MainActor
final class AppCoordinator: ObservableObject {
    // Shared services
    let apiClient: APIClientProtocol

    @Published var selectedUserID: Int? = nil

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    @ViewBuilder
    func rootView() -> some View {
        NavigationStack {
            UserListView(
                viewModel: UserListViewModel(apiClient: apiClient),
                showUserDetail: { [weak self] userID in
                    self?.selectedUserID = userID
                }
            )
            .navigationDestination(isPresented: Binding(
                get: { self.selectedUserID != nil },
                set: { if !$0 { self.selectedUserID = nil } }
            )) {
                if let userID = selectedUserID {
                    UserDetailView(
                        viewModel: UserDetailViewModel(userID: userID, apiClient: apiClient)
                    )
                }
            }
        }
    }
}
```

The AppCoordinator is basically an improved ContentView, this class can be used to direct navigation within the app.

```swift
@main
struct MultiScreenApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.rootView()
        }
    }
}
``

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
