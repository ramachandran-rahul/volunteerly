# Volunteerly

**Volunteerly** is a Swift-based iOS application designed to help users discover and participate in volunteering opportunities based on their personal preferences. It offers a seamless way for users to explore volunteering events, manage their profiles, track booked events, and customize their preferences. The app leverages **Firebase** for user authentication and event data storage.

---

## Features

### 1. User Authentication
- **Login**: Users can log in using their email and password.
- **Create Account**: New users can register with their name, email, and password.
- **Reset Password**: Users can request a password reset link via email.

### 2. User Profile Management
- **Profile View**: Displays user information such as name, email, and preferences.
- **Preferences**: Users can select or edit preferences to customize the types of events they want to see. Categories include:
  - Environmental
  - Social Impact
  - Health & Safety
  - Animal Welfare
  - Sports

  **Technical Note**: Preferences are stored in Firebase Firestore. When users update preferences, the app fetches new events based on those preferences.

### 3. Event Discovery
- **Opportunities View**: Browse volunteering events based on selected preferences.
- **Search Bar**: Filter events in real-time by typing keywords like title or organization.
- **Event Details**: Each event displays:
  - Title
  - Organization
  - Description
  - Start and End Dates
  - Location (shown on a map)
  - Category
  - Contact Email

  **Technical Note**: Events are fetched from Firebase Firestore using queries based on user preferences and filtered by upcoming dates.

### 4. Event Registration
- **Sign Up for Events**: Users can register for any available event.
- **Back Out of Events**: If needed, users can back out of registered events before they start.
- **Booked Events**: Users' booked events are displayed on their profile.

  **Technical Note**: Registered events are tracked via Firebase Firestore, where each event's ID is added to the `bookedEvents` array in the user's document.

### 5. Event Sharing
- **Share Events**: Share event details with others via iOS Share Sheet (ShareSheet), including the event title, organization, and dates.

### 6. Map Integration
- **Event Location**: Each event's location is displayed on a map using coordinates from Firebase Firestore.

---

## Technical Aspects

### 1. Firebase Integration
- **Firebase Authentication**: Handles user login, registration, and password management.
- **Firebase Firestore**: Stores event data, user preferences, and registered events:
  - **Users Collection**: Stores each user's preferences and booked events.
  - **Events Collection**: Stores event details such as title, organization, category, start/end dates, and location.

### 2. Data Flow
- **Fetching Events**: Events are fetched from Firestore based on user preferences and upcoming dates.
- **Updating Preferences**: Updates are saved in Firestore, triggering new event queries to match preferences.
- **Event Registration**: When users register or back out, event IDs are added or removed from `bookedEvents` in Firestore.

### 3. Search Functionality
The search bar filters events locally based on keywords without making new calls to Firestore.

### 4. ShareSheet Integration
The app uses `UIActivityViewController` for sharing event details via email, messages, or social media.

### 5. Custom UI Components
- **CategoryPillView**: Displays event categories (e.g., Environmental, Social Impact) as tags.
- **CustomTextFieldModifier**: Enhances text fields with icons and styling for input fields (e.g., email, password).

### 6. Map Integration
Uses **MapKit** to display event locations on a map, with data retrieved from Firebase Firestore’s `GeoPoint` format.

---

## How to Use

### 1. Login/Register
- New users can register by providing their name, email, and password.
- Existing users can log in or reset their password via email.
- Existing login credentials:
- User Name: rahulgriffindor@gmail.com
- Password: Rahu!97

### 2. Browse Events
- The **Opportunities View** lists available events based on user preferences.
- Use the **Search Bar** to filter events by title or organization.

### 3. View Event Details
- Tap any event to see its full details, including a map of the event's location.

### 4. Sign Up for Events
- Users can register for events and track registered events in the **Profile View**.

### 5. Edit Preferences
- Users can update preferences in the **Profile View**, which adjusts the events shown in the **Opportunities View**.

### 6. Track Booked Events
- Users can view their registered events in the **Profile View** and back out if needed.

---

## User Roles

### General Users
- Can sign up, log in, browse volunteering events, register for events, manage preferences, and share events.

---

## GitHub Link:
[Volunteerly](https://github.com/ramachandran-rahul/volunteerly.git)
