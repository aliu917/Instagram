# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
- [x] Allow the logged in user to add a profile photo
- [x] Display the profile photo with each post
- [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!
- [x] Double tap to like photo
- [x] Clicking on number of likes displays all users who liked that post
- [x] Made post creation on its own tab in the center like the real Instagram

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Extending the app so that it could delete posts
2. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

Registering new user and logging in:

<img src='https://recordit.co/6kFCANxHv2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

User can like by either tapping button or double clicking heart:

<img src='https://recordit.co/e20cJjkXw9.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

User can post a new photo:

<img src='https://recordit.co/JHwoKo6E67.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

One user commenting:

<img src='https://recordit.co/BiiYhyFHc0.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

Liking and commenting for multiple users on same post:

<img src='https://recordit.co/jMGjlelqFk.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

Infinite scroll (hot spotting from my phone because hotel wifi is not working, so it's super slow to load but it works):

<img src='https://recordit.co/8S93X1WeHo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

User can change their profile image:

<img src='http://recordit.co/FQKbX4DWbZ.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

User can edit their bio:

<img src='https://recordit.co/XosOyJ8xl2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

Show that user can click on profile photo to view profiles of different users (but user can only edit their profile in their own profile tab)

<img src='https://recordit.co/aOEyCHw3mc.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Describe any challenges encountered while building the app.

I was trying to store an array for each post that contained PFUser objects but somehow when I switched users (login with different account) a lot of information about the users in the array was lost.

## License

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
