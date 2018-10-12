# OnTheMap
An app allows users to share their location and a URL with their fellow students. To visualize this data, On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves “on the map,” so to speak. 

<img width="297" alt="screenshot 2018-10-12 at 17 01 21" src="https://user-images.githubusercontent.com/28652344/46881170-95220c00-ce42-11e8-9464-0ebd00c98799.png"> <img width="297" alt="screenshot 2018-10-12 at 17 13 53" src="https://user-images.githubusercontent.com/28652344/46881175-98b59300-ce42-11e8-839d-36c4b0449afc.png"> <img width="298" alt="screenshot 2018-10-12 at 17 14 48" src="https://user-images.githubusercontent.com/28652344/46881181-9bb08380-ce42-11e8-9fa9-31efe1ec9751.png"> <img width="297" alt="screenshot 2018-10-12 at 17 15 43" src="https://user-images.githubusercontent.com/28652344/46881183-9e12dd80-ce42-11e8-8cbb-c5c3ce0638f0.png">


First, the user logs in to the app using their Udacity username and password. After login, the app downloads locations and links previously posted by other students. These links can point to any URL that a student chooses. We encourage students to share something about their work or interests.
After viewing the information posted by other students, a user can post their own location and link. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “Costa Rica” or “Seattle, WA.”

The app has three view controller scenes:

- Login View: Allows the user to log in using their Udacity credentials, or (as an extra credit exercise) using their Facebook account
- Map and Table Tabbed View: Allows users to see the locations of other students in two formats.  
- Information Posting View: Allows the users specify their own locations and links.
