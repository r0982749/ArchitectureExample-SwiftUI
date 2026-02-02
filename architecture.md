# SwiftUI Architecture

## MVVM

### Model layer

```
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

```
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

```
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

```
struct UserListView: View {
    @Environment(UserListViewModel.self) var viewModel

    // ...
}

// In your App or parent:
UserListView()
    .environment(UserListViewModel(apiClient: APIClient()))
```

