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

```
actor APIClient {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://api.example.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}
```

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
