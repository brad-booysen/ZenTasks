# ZenTasks

## Code Documentation

* Configuration
* Flows - all app screens/flows
* Lifecycle - basic app launch files
* DataManager - data managers

**DashboardContentView** contains a horizontal list
of projects and vertical list of tasks. These lists have their own
files in order to keep the code organized and easier to maintain.

**ProjectsSectionView** is the horizontal list of projects. By default
the user can create 2 projects for free, and for unlimited projects
they must upgrade to the premium version via In-App Purchase.
To adjust the free projects count, see the AppConfig file.

**TasksSectionView** is the vertical list of tasks. A task may belong
to a project, but it's not mandatory for a task to have a project.
When a task is created, it will show on the dashboard if the start
date for the task matches the current date.

**AddProjectContentView** lets users create a new
project. To create a project, a title and description must be
provided. The due date is optional. The
user can select a background image for a task. All images are
stored in the Assets file.

**AddTaskOverlayView** this view lets users add a new task.
Each task must have a title, description, start date and end date.

Whenever all tasks for a project are marked as completed, the
entire project will be marked as completed and the confetti
animation will show.

To delete a task, the user must triple-tap on a task.
Once a task is created, it cannot be edited.

**ProjectDetailsContentView** shows all tasks for the
selected project as well as the project completion progress.

**SideMenuContentView** shows the settings for the
app. The user may select an avatar.
The avatar image is stored in the documents folder.

**ProjectTileView** shows a project with a
background image, project title, description, as well as the
completion progress.

**TaskTileView** shows a single task. While this
view is very simple, you can change the way a task is
displayed to the user like adding more details, or providing an animation when the user interacts with a task.

**DataManager** takes care of storing/
retrieving of data from Core Data, as well as processing other
data used in the app.

Any changes to the way the app filters tasks, or creates
projects, can be made in this file.

**AppConfig** contains some helpful
configurations that can be changed if needed.

## Replace AdMob IDs

1. Open the **Info.plist** file in Xcode. Look for ‘GADApplicationIdentifier’ and replace the existing value with your Google AdMob App ID.
2. Open the **AppConfig.swift** file in Xcode. Look for ‘adMobAdID’ and replace the existing value with your Google AdMob Interstitial Ad ID.

## Change/Create In-App Purchase

### Step 1: Create your IAP product identifier

To create your IAP product identifier, you must have a valid Apple Developer account.

- Go to [App Store Connect](https://appstoreconnect.apple.com)
- Select your app, then click ‘In-App Purchases’ from the Features section on the left side
- On the ‘Create an In-App Purchase’ view, select the type as ‘Non-
Consumable’ then for Reference Name you can type anything you
want, and for the last step ‘Product ID’ you must type your unique In-
App Purchase product identifier.

It’s recommended that you use your bundle identifier plus some extra text at the
end for example: com.yourBundleldentifier.premium

### Step 2: Replace In-App Purchase Identifier

Open the ‘AppConfig.swift’ file in Xcode. Look for
‘premiumVersion’ and replace the existing value with your IAP product identifier that you created in step 1 above.

That’s all you have to do!

### Troubleshooting In-App Purchases

If the IAP price doesn’t show up in the app,
or in the logs you get errors saying “Product no found”, then
follow these steps to troubleshoot the issue:

1. Make sure you test on a real device only

2. Your App Store Connect IAP product identifier must
match the one inside AppConfig

3. If your app is not on TestFlight, make sure to sign in with your
Apple Sandbox ID. To create an Apple Sandbox ID, go to App
Store Connect -> Users and Access and see the Sandbox Testers
on the left side. Create a new Sandbox account here.

4. Check all your contracts, agreements, tax and banking info in App
Store Connect. All must be accepted.

5. Check your in-app purchase product, the status must be
Approved, or Ready to Submit. If your product shows “Missing
Metadata” then you must fill out all the fields in App Store
Connect for your IAP product.

Thank you for your business and feel free to [contact me](https://www.bradbooysen.com/contact) for all your app needs.
Email: hey@bradbooysen.com
