## Migration Guides

### Migrating from versions < 3.4.0

#### Navigation Bar Customization

- `ALKConfiguration.navigationBarBackgroundColor`, has been deprecated. Use `UIAppearance` for navigation bar configuration.
- `ALKConfiguration.navigationBarItemColor`, has been deprecated. Use `UIAppearance` for navigation bar configuration.
- `ALKConfiguration.navigationBarTitleColor`, has been deprecated. Use `UIAppearance` for navigation bar configuration.

If you are using `ALKBaseNavigationViewController` to present the conversation then, you can customize it like this:

```swift
// Use `appearance(whenContainedInInstancesOf:)` method to limit the changes to instances of `ALKBaseNavigationViewController`.
let navigationBarProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [ALKBaseNavigationViewController.self])

navigationBarProxy.tintColor = UIColor.blue
navigationBarProxy.barTintColor = UIColor.gray
navigationBarProxy.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // title color
```

### Migrating from versions < 3.1.0

####  ChatBar Configuration
- `ALKConfiguration.hideContactInChatBar`, has been deprecated. Use `ALKConfiguration.chatBar.showOptions` to only show some options.

    ```swift
    config.optionsToShow = .some([.gallery, .location, .camera, .video])
    ```
- `ALKConfiguration.hideAllOptionsInChatBar` has been deprecated. Use `ALKConfiguration.chatBar.showOptions` to hide the all attachment options.

    ```swift
    configuration.chatBar.optionsToShow = .none
    ```

####  Navigation button Configuration

  -  ConversationList configuration
   `ALKConfiguration.rightNavBarImageForConversationListView`, has been deprecated. Use `ALKConfiguration.navigationItemsForConversationList` to add buttons in the navigation bar
   
  ```swift
    // ConversationList
    var navigationItemsForConversationList = [ALKNavigationItem]()

    // Example for button with text
    let buttonOne = ALKNavigationItem(identifier: 1234, text: "FAQ")

    // Adding an item in the list
    navigationItemsForConversationList.append(buttonOne)

    // Example for button with icon
    let buttonTwo = ALKNavigationItem(identifier:23456, icon: UIImage(named: "icon_download", in: Bundle(for: ALKConversationListViewController.self), compatibleWith: nil)!)

    // Adding an item in the list
    navigationItemsForConversationList.append(buttonTwo)
    
    config.navigationItemsForConversationList = navigationItemsForConversationList

    // Add an Observer to get the event callback
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ALKNavigationItem.NSNotificationForConversationListNavigationTap), object: nil, queue: nil, using: { notification in

        guard let notificationUserInfo = notification.userInfo else { return }
        let identifier =   notificationUserInfo["identifier"] as! Int
        print("Navigation button click for identifier in ConversationList is : ",identifier)
    })
  ```
  
  -  ConversationView configuration
    
  ```swift
    // ConversationView
    var navigationItemsForConversationView = [ALKNavigationItem]()

    let buttonOne = ALKNavigationItem(identifier: 1234, text: "FAQ")

    // Adding an item in the list
    navigationItemsForConversationView.append(buttonOne)

    // Example for button with icon
    let buttonTwo = ALKNavigationItem(identifier:23456, icon: UIImage(named: "icon_download", in: Bundle(for: ALKConversationListViewController.self), compatibleWith: nil)!)

    // Adding an item in the list
    navigationItemsForConversationView.append(buttonOne)

    config.navigationItemsForConversationView = navigationItemsForConversationView
  ```