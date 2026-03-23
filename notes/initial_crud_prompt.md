Read CLAUDE.md before doing anything else.

## Task: Application layout, navigation, seed data, and profile page

### Context
Stepwise has a working data model (User, Walk) with passing model specs.
We are now building the application shell: layout, navbar, seed data,
and a minimal profile page. No walk interface yet — that is a separate task.

### 1. Seed file
Create db/seeds.rb that creates exactly one User record if none exists:
- first_name: your first name
- last_name: your last name
- email: your email address
Use find_or_create_by(email:) so re-running seeds is safe.

### 2. Application layout (app/views/layouts/application.html.erb)
- Bootstrap 5 navbar, fixed to top, app name "Stepwise" as brand link to root
- Navbar links: Dashboard (root_path), Profile (profile_path)
- Main content wrapped in a container with padding-top to clear the fixed navbar
- Flash message display below navbar (Bootstrap alert, dismissible)
- No custom CSS — Bootstrap utilities only

### 3. Routes (config/routes.rb)
- root "dashboard#index"
- get "/profile", to: "profile#show", as: :profile
- get "/profile/edit", to: "profile#edit", as: :edit_profile
- patch "/profile", to: "profile#update"
- Do not use resourceful routes for profile — explicit named routes only

### 4. ProfileController (app/controllers/profile_controller.rb)
- The single user is always User.first — no authentication, no user lookup by id
- show action: renders profile show view
- edit action: renders profile edit view
- update action: updates User.first, redirects to profile_path on success,
  re-renders edit on failure
- No new, create, or destroy actions

### 5. DashboardController (app/controllers/dashboard_controller.rb)
- index action only
- Set @user = User.first
- No walk stats yet — leave @walks and @stats as nil placeholders with comments
  marking where they will be populated in the next task

### 6. Views
app/views/profile/show.html.erb
- Bootstrap card showing first_name, last_name, email
- Edit profile button linking to edit_profile_path

app/views/profile/edit.html.erb
- Bootstrap card with form to edit first_name, last_name, email
- Save and Cancel buttons (cancel returns to profile_path)
- form_with model semantics pointing to /profile with method patch

app/views/dashboard/index.html.erb
- H1 greeting: "Good morning/afternoon/evening, [first_name]"
  (time-based: morning before 12, afternoon before 17, evening otherwise)
- Placeholder cards for stats (we will populate these in the next task)
  with Bootstrap card skeleton and a comment: <!-- stats placeholder -->
- Placeholder for recent walks table with comment: <!-- walks placeholder -->

### Constraints
- Bootstrap 5 utilities only — no custom CSS, no inline styles
- No Turbo, no Stimulus, no Hotwire — plain ERB and Rails helpers only
- Do not generate walk interface, walk controller, or walk routes
- Migrations must not be created in this task — schema is complete
- Keep controllers thin — no business logic outside the model

### Tests to write (RSpec)
spec/requests/profile_spec.rb
- GET /profile returns 200
- GET /profile/edit returns 200
- PATCH /profile with valid params redirects to /profile
- PATCH /profile with invalid params returns 422

spec/requests/dashboard_spec.rb
- GET / returns 200

### Done when
- rails db:seed runs without errors and creates exactly one user
- All 5 request specs pass
- rspec spec/requests passes clean
- Navbar renders on all pages with correct links
- No Minitest files exist
