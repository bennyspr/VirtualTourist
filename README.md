# VirtualTourist
 This iPhone app allows users specify travel locations around the world, and create virtual photo albums for each location. The locations and photo albums will be stored in Core Data.

### Prerequisites
In order to use the app you need a [Flickr](https://www.flickr.com/) account and then replace the following strings on the Constant.swift file with your account information: ADD_YOUR_KEY, ADD_YOUR_SECRET, and ADD_YOUR_USER_ID.
```
struct Constant {
    struct Flickr {
        static let apiBaseURL = "https://api.flickr.com/"
        static let apiKey = "ADD_YOUR_KEY"
        static let apiSecret = "ADD_YOUR_SECRET"
        static let userID = "ADD_YOUR_USER_ID"
    }
    struct Queue {
        static let download = "download"
    }
}
```

<br><b>IDE:</b> Xcode 8.1+
<br><b>Language:</b> Swift 3
<br><b>iOS Deployment Target:</b> 9.3
<table>
<tr>
<td>
<kbd>
<img src="https://bennyspr.com/img/github/virtualTourist/Simulator_Screen_Shot_1.png" width="300">
</kbd>
</td>
<td>
<kbd>
<img src="https://bennyspr.com/img/github/virtualTourist/Simulator_Screen_Shot_2.png" width="300">
</kbd>
</td>
</tr>
<tr>
<td>
<kbd>
<img src="https://bennyspr.com/img/github/virtualTourist/Simulator_Screen_Shot_3.png" width="300">
</kbd>
</td>
<td>
<kbd>
<img src="https://bennyspr.com/img/github/virtualTourist/Simulator_Screen_Shot_4.png" width="300">
</kbd>
</td>
</tr>
</table>
