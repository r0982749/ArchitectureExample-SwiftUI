# Modern App Architecture

## Modern app architecture in Android

A modern Android app architecture uses the following techniques (among others):

- Adaptive and layered architecture
- Unidirectional data flow (UDF) in all layers of the app
- UI layer with state holders to manage the complexity of the UI
- Coroutines and flows
- Dependency injection best practices

## Common architectural principles

### Separation of concerns

Separation of concerns in Android Jetpack Compose means structuring your app so that each part has a single, well-defined responsibility. This makes your code easier to understand, test, and maintain.

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- Layered architecture
- Viewmodels
- ...

</details>

### Adaptive layouts

Optimize user experience.

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- Problems with device orientation changes.

```xml
<activity
    android:name=".MainActivity"
    android:screenOrientation="portrait" />
```

**No longer supported!**

Solve by using Scrollview.

```kotlin
Row(
    modifier = Modifier
        .horizontalScroll(rememberScrollState())
) {
    Text("Item 1")
    Text("Item 2")
    Text("Item 3")
}
```

Or LazyColumn for presenting a lot of elements.

```kotlin
LazyColumn {
    items(100) { index ->
        Text("Item $index")
    }
}
```

</details>

### Drive UI from data models

Drive your UI from data models, preferably persistent models. Data models represent the data of an app.

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- Make use of UIState, ViewModels, ...

 </details>

### Single source of truth

When a new data type is defined in your app, you should assign a single source of truth (SSOT) to it. The SSOT is the owner of that data, and only the SSOT can modify or mutate it.

In an offline-first application, the source of truth for application data is typically a database.

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- SSOT is the Room DB.
- Data models are protected (val attributes)

 </details>

### Unidirectional data flow

In UDF, state flows in only one direction, typically from parent component to child component. The events that modify the data flow in the opposite direction.

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- Make use of UIState, ViewModels, ...

 </details>

## UI layer

- UI Elements + State = UI
- UDF
- Viewmodels
- using Flow vars to get data
- Thread safety by using Coroutines
- Navigation triggered by events

### Best practices

#### Show in-progress operations

```kotlin
@Composable
fun LatestNewsScreen(
    modifier: Modifier = Modifier,
    viewModel: NewsViewModel = viewModel()
) {
    Box(modifier.fillMaxSize()) {

        if (viewModel.uiState.isFetchingArticles) {
            CircularProgressIndicator(Modifier.align(Alignment.Center))
        }

        // Add other UI elements. For example, the list.
    }
}
```

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- OK. cf. ToDoListView

 </details>

#### Show errors

Simular to Show in-progress...

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- OK. cf. ToDoListView

 </details>

## Data layer

- Repositories
- Data Sources
- Source of truth
  > In order to provide offline-first support, a local data source—such as a database—is the recommended source of truth.
- Threading
- lifecycle awareness
- Represent business models (vs. data models)
- Expose errors -> try/catch
- Save and retrieve data from disk
  - large datasets -> Room
  - small datatsets (e.g. preferences) -> DataStore
  - chunks of data (e.g. JSON) -> File
- Workmanager
  - schedule asynchronous and reliable work
  - the recommended library for persistent work

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

- Implementations of Room and Retrofit in combination with HILT DI (lifecycle management).

 </details>

## Domain layer

The domain layer is responsible for encapsulating complex business logic, or simple business logic that is reused by multiple ViewModels. This layer is optional because not all apps will have these requirements. You should only use it when needed-for example, to handle complexity or favor reusability.

Because use cases contain reusable logic, they can also be used by other use cases.

### Use case in Kotlin

In Kotlin, you can make use case class instances callable as functions by defining the invoke() function with the operator modifier.

```kotlin
 class FormatDateUseCase(userRepository: UserRepository) {

    private val formatter = SimpleDateFormat(
        userRepository.getPreferredDateFormat(),
        userRepository.getPreferredLocale()
    )

    operator fun invoke(date: Date): String {
        return formatter.format(date)
    }
}
```

The invoke() method in FormatDateUseCase allows you to call instances of the class as if they were functions. The invoke() method is not restricted to any specific signature—it can take any number of parameters and return any type. You can also overload invoke() with different signatures in your class.

```kotlin
class MyViewModel(formatDateUseCase: FormatDateUseCase) : ViewModel() {
    init {
        val today = Calendar.getInstance()
        val todaysDate = formatDateUseCase(today)
        /* ... */
    }
}
```

### Usage

#### Complex business logic

#### Reusable simple business logic

You should encapsulate repeatable business logic present in the UI layer in a use case class. This makes it easier to apply any changes everywhere the logic is used.

#### Combine repositories

Consult multiple data sources to create a UI dataset.

<details>
 <summary>In our project (Assignment 8 To Do List)</summary>

In our app a ToDo object has references to User. To present the name of assignedUser, we could make a usecase GettListToDosWithUsersInformationUseCase.

In assignment 8 we solved this with the introduction of ToDoWithUsers and related Transactoin queries.

 </details>

## Data layer access restriction

One other consideration when implementing the domain layer is whether you should still allow direct access to the data layer from the UI layer, or force everything through the domain layer.

An advantage of making this restriction is that it stops your UI from bypassing domain layer logic, for example, if you are performing analytics logging on each access request to the data layer.

However, the potentially significant disadvantage is that it forces you to add use cases even when they are just simple function calls to the data layer, which can add complexity for little benefit.

A good approach is to add use cases only when required. If you find that your UI layer is accessing data through use cases almost exclusively, it may make sense to only access data this way.

## UI Events

UI events are actions that should be handled in the UI layer, either by the UI or by the ViewModel.

The ViewModel is normally responsible for handling the business logic of a particular user event—for example, the user clicking on a button to refresh some data.

Usually, the ViewModel handles this by exposing functions that the UI can call. User events might also have UI behavior logic that the UI can handle directly.

- Business logic -> Handled by the ViewModel
- UI Behaviour logic - Handled by the UI

<details>

 <summary>In our project (Assignment 8 To Do List)</summary>

A example of UI Behaviour logic is the dropdwon element to select the user. In AddEditToDoScreen there is the var isUserDropDownExpanded the defines the state. In this case th stae handling should be handled by the UI itself.

 </details>

## Handle ViewModel events

### Navigation examples

ViewModel events should always result in a UI state update.

For example, consider the case of navigating to the home screen when the user is logged in on the login screen.

```kotlin
@Composable
fun LoginScreen(
    viewModel: LoginViewModel = viewModel(),
    onUserLogIn: () -> Unit
) {

    val currentOnUserLogIn by rememberUpdatedState(onUserLogIn)

    // Whenever the uiState changes, check if the user is logged in.
    LaunchedEffect(viewModel.uiState)  {
        if (viewModel.uiState.isUserLoggedIn) {
            currentOnUserLogIn()
        }
    }

    // Rest of the UI for the login screen.
}
```

**Extra info**

```kotlin
val currentOnUserLogIn by rememberUpdatedState(onUserLogIn)
```

This line wraps the onUserLogIn lambda in a state object that Compose can track.
In Compose, lambdas passed to LaunchedEffect can be captured at the time the effect is launched. If onUserLogIn changes later, the old effect would still hold the old lambda. RememberUpdatedState ensures that the most recent lambda is always used without restarting the LaunchedEffect.

So, currentOnUserLogIn() inside the effect always calls the latest version of onUserLogIn.

The navigation in this example is **not** lifecycle-aware. So it could trigger navigation when the screen isn't visible.

To solve this, we can add the lifecycle to th eobservation.

```kotlin
@Composable
fun LoginScreen(
    onUserLogIn: () -> Unit, // Caller navigates to the right screen
    viewModel: LoginViewModel = viewModel()
) {
    Button(
        onClick = {
            // ViewModel validation is triggered
            viewModel.login()
        }
    ) {
        Text("Log in")
    }
    // Rest of the UI

    val lifecycle = LocalLifecycleOwner.current.lifecycle
    val currentOnUserLogIn by rememberUpdatedState(onUserLogIn)
    LaunchedEffect(viewModel, lifecycle)  {
        // Whenever the uiState changes, check if the user is logged in and
        // call the `onUserLogin` event when `lifecycle` is at least STARTED
        snapshotFlow { viewModel.uiState }
            .filter { it.isUserLoggedIn }
            .flowWithLifecycle(lifecycle)
            .collect {
                currentOnUserLogIn()
            }
    }
}
```

- snapshotFlow converts Compose state → Flow.
- filter only emits when the user is actually logged in.
- .flowWithLifecycle(lifecycle) prevents collecting flows when the UI is in the background.
- .collect {} -> collect and trigger the callback

| Concept                                 | Previous Example                                                          | New Example                                            |
| --------------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------ |
| **Detecting login success**             | Directly inside `LaunchedEffect(viewModel.uiState)`                       | Using `snapshotFlow + filter`                          |
| **Lifecycle safety**                    | ❌ Not lifecycle-aware → could trigger navigation when screen not visible | ✅ Uses `flowWithLifecycle(lifecycle)`                 |
| **Callback freshness**                  | 👍 Used `rememberUpdatedState`                                            | 👍 Still uses it                                       |
| **Flow-based reactive logic**           | ❌ No flow                                                                | ✅ Accurate state observation via `snapshotFlow`       |
| **Prevent unnecessary effect restarts** | `LaunchedEffect(viewModel.uiState)` restarts every time state changes     | `snapshotFlow` emits changes without restarting effect |

<details>

 <summary>In our project (Assignment 8 To Do List)</summary>

Navigation is done directly in the UI event. There is no complex logic and no need to wait for a result before we navigate. No complex logic to be lifecycle aware is needed.

 </details>

### Showing errors

Consuming certain ViewModel events in the UI might result in other UI state updates. For example, when showing transient messages on the screen to let the user know that something happened, the UI needs to notify the ViewModel to trigger another state update when the message has been shown on the screen. The event that happens when the user has consumed the message (by dismissing it or after a timeout) can be treated as "user input" and as such, the ViewModel should be aware of that.

```kotlin
@Composable
fun LatestNewsScreen(
    snackbarHostState: SnackbarHostState,
    viewModel: LatestNewsViewModel = viewModel(),
) {
    // Rest of the UI content.

    // If there are user messages to show on the screen,
    // show it and notify the ViewModel.
    viewModel.uiState.userMessage?.let { userMessage ->
        LaunchedEffect(userMessage) {
            snackbarHostState.showSnackbar(userMessage)
            // Once the message is displayed and dismissed, notify the ViewModel.
            viewModel.userMessageShown()
        }
    }
}
```

<details>

 <summary>In our project (Assignment 8 To Do List)</summary>

When accessing the API/DB, an error is shown when something went wrong. cf. AddEditToDoScreen (supriseError and saveError).

 </details>

## Build an offline-first app

An offline-first app is an app that is able to perform all, or a critical subset of its core functionality without access to the internet. That is, it can perform some or all of its business logic offline.

### Design offline-first app

An offline-first app has a minimum of 2 data sources for every repository that utilizes network resources:

- The local data source
  - The canonical source of truth for the app.
- The network data source
  - The network data source is the actual state of the application. The local data source is at best synchronized with the network data source. It can also lag behind it, in which case the app needs to be updated when back online. Inversely, the network data source may lag behind the local data source until the app can update it when connectivity returns.

The local data source and network data source may therefore have their own models. t is good practice to keep both the data source model and the Network data source model internal to the data layer and expose a **third** type for external layers to consume.

### Reads

Reads are the fundamental operation on app data in an offline-first app. You must therefore ensure that your app can read the data (local), and that as soon as new data (network) is available the app can display it. An app that can do this is a reactive app because they expose read APIs with observable types (Flow).

### Error handling strategies in Reads

- .cath on local data source

```kotlin
class AuthorViewModel(
    authorsRepository: AuthorsRepository,
    ...
) : ViewModel() {
   private val authorId: String = ...

   // Observe author information
    private val authorStream: Flow<Author> =
        authorsRepository.getAuthorStream(
            id = authorId
        )
        .catch { emit(Author.empty()) }
}
```

- Exponential backoff on network data source

In exponential backoff, the app keeps attempting to read from the network data source with increasing time intervals until it succeeds, or other conditions dictate that it should stop.

Important to define maximum of retries, retry is based on type of error.

- Network connectivity monitoring on network data source

In this approach, read requests are queued until the app is certain it can connect to the network data source. Workmanger can be used for this.

### Writes

When writing data in offline-first apps, there are three strategies to consider. Which you choose depends on the type of data being written and the requirements of the app.

- Online-only writes

Attempt to write the data across the network boundary. If successful, update the local data source, otherwise throw an exception and leave it to the caller to respond appropriately.

- Queued writes

When you have an object you would like to write, insert it into a queue. Proceed to drain the queue with exponential back off when the app gets back online. On Android, draining an offline queue is persistent work that is often delegated to WorkManager.

- Lazy writes

Write to the local data source first, then queue the write to notify the network at the earliest convenience. This is non trivial as there can be conflicts between the network and local data sources when the app comes back online.

### Synchronization and conflict resolution

When an offline-first app restores its connectivity, it needs to reconcile the data in its local data source with that in the network data source. This process is called synchronization.

- Pull-based synchronization

In pull-based synchronization, the app reaches out to the network to read the latest application data on demand.

This approach works best when the app expects brief to intermediate periods of no network connectivity.

- Push-based synchronization

In push-based synchronization, the local data source tries to mimic a replica set of the network data source to the best of its ability. It proactively fetches an appropriate amount of data on first start-up to set a baseline, after which it relies on notifications from the server to alert it when that data is stale.

- Hybrid synchronization

Some apps use a hybrid approach that is pull or push based depending on the data. For example, a social media app may use pull-based synchronization to fetch the user's following feed on demand due to the high frequency of feed updates. The same app may opt to use push-based synchronization for data about the signed-in user including their username, profile picture and so on.

### Conflict resolution in Writes

- Last write wins

In this approach, devices attach timestamp metadata to the data they write to the network. When the network data source receives them, it discards any data older than its current state while accepting those newer than its current state.

## State holders and UI state

The UI state and the logic that produces it defines the UI layer.

### UI State

- Screen UI state is what you need to display on the screen.

- UI element state refers to properties intrinsic to UI elements that influence how they are rendered.
  - A UI element may be shown or hidden and may have a certain font, font size, or font color. In Android Views,

### Logic

- Business logic is the implementation of product requirements for app data.

- UI logic is related to how to display UI state on the screen.

  - Obtaining the right search bar hint when the user has selected a category, scrolling to a particular item in a list, or the navigation logic to a particular screen when the user clicks a button.

### The UI state production pipeline

The UI state production pipeline refers to the steps undertaken to produce UI state.

- UI state produced and managed by the UI itself.

```kotlin
@Composable
fun Counter() {
    // The UI state is managed by the UI itself
    var count by remember { mutableStateOf(0) }
    Row {
        Button(onClick = { ++count }) {
            Text(text = "Increment")
        }
        Button(onClick = { --count }) {
            Text(text = "Decrement")
        }
    }
}
```

- UI logic -> UI

```kotlin
@Composable
fun ContactsList(contacts: List<Contact>) {
    val listState = rememberLazyListState()
    val isAtTopOfList by remember {
        derivedStateOf {
            listState.firstVisibleItemIndex < 3
        }
    }

    // Create the LazyColumn with the lazyListState
    ...

    // Show or hide the button (UI logic) based on the list scroll position
    AnimatedVisibility(visible = !isAtTopOfList) {
        ScrollToTopButton()
    }
}
```

- Business logic → UI

```kotlin
@Composable
fun UserProfileScreen(viewModel: UserProfileViewModel = hiltViewModel()) {
    // Read screen UI state from the business logic state holder
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    // Call on the UserAvatar Composable to display the photo
    UserAvatar(picture = uiState.profilePicture)
}
```

- Business logic → UI logic → UI

```kotlin
@Composable
fun ContactsList(viewModel: ContactsViewModel = hiltViewModel()) {
    // Read screen UI state from the business logic state holder
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    val contacts = uiState.contacts
    val deepLinkedContact = uiState.deepLinkedContact

    val listState = rememberLazyListState()

    // Create the LazyColumn with the lazyListState
    ...

    // Perform UI logic that depends on information from business logic
    if (deepLinkedContact != null && contacts.isNotEmpty()) {
        LaunchedEffect(listState, deepLinkedContact, contacts) {
            val deepLinkedContactIndex = contacts.indexOf(deepLinkedContact)
            if (deepLinkedContactIndex >= 0) {
              // Scroll to deep linked item
              listState.animateScrollToItem(deepLinkedContactIndex)
            }
        }
    }
}
```

### State holder

There are two types of state holders in the UI layer defined by their relationship to the UI lifecycle:

- The business logic state holder.
  - Viewmodel
- The UI logic state holder.
  - Plain class

## UI State production

Fundamentally, state production is the incremental application of changes to the UI state. State always exists, and it changes as a result of events.

Events can come from:

- Users: As they interact with the app's UI.
- Other sources of state change: APIs that present app data from UI, domain, or data layers like snackbar timeout events, use cases or repositories respectively.

### The UI state production pipeline

State production in Android apps can be thought of as a processing pipeline: Inputs -> State holders -> Output

- Input can be local to the UI, external to the UI or a combination.
- State holders: Types that apply business logic and/or UI logic.
- Output: The UI State that the app can render to provide users the information they need.

## Recommendations for Android architecture

The Android Developers architecture recommendations aim to improve an app's quality, robustness, maintainability, and scalability by promoting separation of concerns and unidirectional data flow (UDF).

The recommendations are grouped by topic, each with a priority: Strongly recommended, Recommended, or Optional.

Here is a summary of the recommendations, including the tables per topic:

### Layered Architecture
The recommended layered architecture favors separation of concerns, drives UI from data models, and adheres to the single source of truth principle and UDF.

| Recommendation | Priority | Description |
|---|---|---|
| Use a clearly defined data layer. | Strongly recommended | Exposes application data and contains the vast majority of your app's business logic. Create repositories even if they contain only a single data source. |
| Use a clearly defined UI layer. | Strongly recommended | Displays application data and serves as the primary point of user interaction. |
| The data layer should expose application data using a repository. | Strongly recommended | UI layer components (Composables, Activities, ViewModels) should not interact directly with data sources (Databases, DataStore, Network, etc.). |
| Use coroutines and flows. | Strongly recommended | Use coroutines and flows for communication between layers. |
| Use a domain layer. | Recommended in big apps | Use a domain layer (use cases) if you need to reuse business logic across multiple ViewModels or simplify complex business logic in a ViewModel. |

### UI Layer

The UI layer's role is to display application data and handle user interaction.

| Recommendation                                      | Priority               | Description                                                                                                         |
|-----------------------------------------------------|------------------------|---------------------------------------------------------------------------------------------------------------------|
| Follow Unidirectional Data Flow (UDF).              | Strongly recommended   | ViewModels expose UI state using the observer pattern and receive actions from the UI through method calls.        |
| Use AAC ViewModels if their benefits apply to your app. | Strongly recommended   | Use Android Architecture Components ViewModels to handle business logic and fetch application data to expose UI state.                         |
| Use lifecycle-aware UI state collection.            | Strongly recommended   | Collect UI state using the appropriate lifecycle-aware coroutine builder: repeatOnLifecycle (Views) or collectAsStateWithLifecycle (Compose). |
| Do not send events from the ViewModel to the UI.    | Strongly recommended   | Process the event immediately in the ViewModel and cause a state update with the result of handling the event.     |
| Use a single-activity application.                  | Recommended            | Use Navigation Fragments or Navigation Compose to navigate between screens and handle deep links.                  |
| Use Jetpack Compose.                                | Recommended            | Use Jetpack Compose to build new apps for phones, tablets, foldables, and Wear OS.                                 |

### View model

ViewModels are responsible for providing the UI state and access to the data layer.

| Recommendation                                         | Priority               | Description                                                                                                                   |
|--------------------------------------------------------|------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| ViewModels should be agnostic of the Android lifecycle.| Strongly recommended   | Do not hold a reference to any lifecycle-related types (Activity, Fragment, Context, Resources).                             |
| Use coroutines and flows.                              | Strongly recommended   | Interact with the data or domain layers using Kotlin flows (for receiving data) and suspend functions within viewModelScope. |
| Use ViewModels at screen level.                        | Strongly recommended   | Use ViewModels in screen-level components (Composables, Activities/Fragments, Navigation Destinations/Graphs), not in reusable UI components. |
| Use plain state holder classes in reusable UI components.| Strongly recommended  | Use plain state holder classes for reusable UI components so the state can be hoisted and controlled externally.             |
| Do not use AndroidViewModel.                           | Recommended            | Use the basic ViewModel class. Move any dependency on the Application class to the UI or data layer.                         |
| Expose a UI state.                                     | Recommended            | Expose data to the UI through a single property (e.g., `uiState`), ideally a StateFlow created with `stateIn` and the `WhileSubscribed(5000)` policy. |

