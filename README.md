# AS Adstacks Media — Responsive Flutter Web Dashboard

A fully responsive, pixel-perfect single-page web dashboard application built with **Flutter 3** and **Riverpod 2.0**, replicating the precise UI/UX layout of the AS Adstacks Media office dashboard while adding full dynamic interactivity.

---

## ✨ Features & Highlights

1. **Pixel-Perfect Visual Replication**:
   - Custom-painted elliptical orbit logo (`AS Adstacks`).
   - High-resolution custom vector illustrated avatars (0% system font emojis).
   - Exact color palette, spacing, typography, and card placements matching the reference design.
   - Interactive calendar (`October 2023`) with highlighted dates and custom celebration cards (`Birthday` & `Anniversary`).

2. **Fully Responsive Across All Screen Sizes**:
   - **Desktop (>1200px)**: Three-column layout (`LeftSidebar` + `CenterFeed` + `RightSidebar`).
   - **Tablet (850px - 1200px)**: Adaptive grid layout where the right sidebar stacks elegantly below the main feed.
   - **Mobile (<850px)**: Compact Top Bar layout with an automatic slide-out **Drawer menu** for navigation.

3. **100% Dynamic & Interactive State Management (`Riverpod`)**:
   - **Projects Panel**: Tap to select active project; long-press to add new projects.
   - **Creators Panel**: Search filtering in real-time; tap to edit creator details; long-press to delete.
   - **Profile & Banner**: Tap profile to update admin details; long-press banner to customize announcements.
   - **Workspaces**: Add (`+`), rename, and delete workspace channels dynamically.
   - **Performance Chart**: Add yearly data points with smooth 400ms chart animation.

---

## 🛠 Tech Stack & Libraries Used

- **Framework**: Flutter (Dart 3)
- **State Management**: `flutter_riverpod` (^3.3.2)
- **Data Visualization**: `fl_chart` (^1.2.0)
- **Calendar**: `table_calendar` (^3.2.0)
- **Typography**: `google_fonts` (^8.1.0)

---

## 🚀 Running Locally

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application on Chrome:
   ```bash
   flutter run -d chrome
   ```

---

## 🌐 Deployment Instructions

### 1. Build Production Web Release
Generate an optimized web release bundle:
```bash
flutter build web --release
```
The compiled output will be generated inside the `build/web` directory.

### 2. Deploy to Vercel
1. Install the Vercel CLI or connect your GitHub repository to [Vercel](https://vercel.com).
2. Set the Output Directory to `build/web`.
3. Deploy directly:
   ```bash
   vercel deploy --prod
   ```

### 3. Deploy to Firebase Hosting
1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```
2. Initialize Firebase inside the project folder:
   ```bash
   firebase init hosting
   ```
   - Set public directory to: `build/web`
   - Configure as single-page app: `Yes`
3. Deploy:
   ```bash
   firebase deploy --only hosting
   ```
