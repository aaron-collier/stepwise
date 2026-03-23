Read CLAUDE.md before doing anything else.

## Task: Walks interface, dashboard stats, and recent walks table

### Context
The application shell is complete. Navbar, layout, profile page, and dashboard
stub are all working. This task builds the full walks CRUD interface, populates
the dashboard stat cards, and fills in the recent walks table.
The dashboard view already has <!-- stats placeholder --> and
<!-- walks placeholder --> comments marking where new code goes.

### 1. Routes (config/routes.rb)
Add inside the existing routes block:
resources :walks, except: [:show]
No other route changes.

### 2. WalksController (app/controllers/walks_controller.rb)
All actions scope to User.first — no authentication.
- index: @walks = User.first.walks.order(walked_on: :desc, created_at: :desc)
- new: @walk = User.first.walks.build
- create: build from walk_params, save, redirect to walks_path on success,
  render :new with status 422 on failure
- edit: @walk = User.first.walks.find(params[:id])
- update: find, update, redirect to walks_path on success,
  render :edit with status 422 on failure
- destroy: find, destroy, redirect to walks_path with notice

Private:
- walk_params: permit :distance_miles, :steps, :walked_on

### 3. Walk model addition
Add a scope to app/models/walk.rb:
  scope :recent, ->(n) { order(walked_on: :desc, created_at: :desc).limit(n) }

### 4. Dashboard stats (app/controllers/dashboard_controller.rb)
Replace the @walks and @stats nil placeholders with:
  @user  = User.first
  @walks = @user.walks.recent(5)
  @stats = {
    steps_today:        @user.walks.where(walked_on: Date.today).sum(:steps),
    miles_today:        @user.walks.where(walked_on: Date.today).sum(:distance_miles),
    avg_steps_per_walk: @user.walks.average(:steps)&.round || 0,
    avg_steps_per_day:  compute_avg_steps_per_day(@user)
  }

Add a private method for avg_steps_per_day:
  def compute_avg_steps_per_day(user)
    days = user.walks.select(:walked_on).distinct.count
    return 0 if days.zero?
    (user.walks.sum(:steps).to_f / days).round
  end

### 5. Views

app/views/walks/index.html.erb
- Page heading "My Walks" with "Log a Walk" button (triggers modal, see below)
- Bootstrap table: date, distance (miles), steps, actions (edit, delete)
- walked_on formatted as "Mon, Jan 6 2025"
- distance_miles formatted to 2 decimal places with " mi" suffix
- steps formatted with number_with_delimiter
- Edit link per row, Delete button per row with confirm dialog
- Empty state message if no walks exist: "No walks yet — log your first one!"

app/views/walks/_form.html.erb (partial)
- Fields: walked_on (date field, defaults to today), distance_miles
  (number field, step 0.01, min 0.01), steps (number field, min 1)
- Per-field is-invalid + invalid-feedback inline error pattern
- Top-level alert-danger summary if errors present

app/views/walks/_modal.html.erb (partial)
- Bootstrap modal with id="walkModal"
- Modal title changes between "Log a Walk" and "Edit Walk" via data attribute
- Renders the _form partial inside the modal body
- Submit button inside modal footer: "Save Walk"
- Plain Bootstrap JS modal — no Turbo, no Stimulus
- Modal is triggered by buttons setting form action and method via vanilla JS

app/views/walks/new.html.erb
- Renders _modal partial

app/views/walks/edit.html.erb
- Renders _modal partial

app/views/dashboard/index.html.erb
- Replace <!-- stats placeholder --> with Bootstrap card row:
  4 stat cards side by side (col-md-3):
  1. "Today's Steps" — @stats[:steps_today] formatted with number_with_delimiter
     with a muted target note "Goal: 10,000 steps"
     card border-success if steps_today >= 10000, border-warning otherwise
  2. "Today's Miles" — @stats[:miles_today] formatted to 2 decimal places
  3. "Avg Steps / Walk" — @stats[:avg_steps_per_walk] with number_with_delimiter
  4. "Avg Steps / Day" — @stats[:avg_steps_per_day] with number_with_delimiter
     with same border-success/border-warning logic as Today's Steps card
- Replace <!-- walks placeholder --> with:
  - "Recent Walks" heading with "View All" link to walks_path
  - Bootstrap table of @walks (same columns as walks index)
  - Empty state if @walks.empty?

### 6. Presenter (app/presenters/dashboard_presenter.rb)
- Move the time-based greeting logic from the dashboard view into a presenter
- DashboardPresenter.new(user, time: Time.current) with a greeting method
  that returns "Good morning", "Good afternoon", or "Good evening"
  based on the hour (before 12, before 17, otherwise)
- Update DashboardController to instantiate the presenter and pass to view
- Update dashboard view to call @presenter.greeting

### 7. Tests

spec/models/walk_spec.rb (add to existing file)
- recent scope returns walks in correct order
- recent scope limits to n records

spec/requests/walks_spec.rb (create)
- GET /walks returns 200
- GET /walks/new returns 200
- POST /walks with valid params redirects to /walks
- POST /walks with invalid params returns 422
- GET /walks/:id/edit returns 200
- PATCH /walks/:id with valid params redirects to /walks
- PATCH /walks/:id with invalid params returns 422
- DELETE /walks/:id redirects to /walks

spec/requests/dashboard_spec.rb (modify)
- Add: GET / returns 200 with walks present (create 3 walks via factory, check stats render)

spec/presenters/dashboard_presenter_spec.rb (create)
- returns "Good morning" for hours 0-11
- returns "Good afternoon" for hours 12-16
- returns "Good evening" for hours 17-23

### Constraints
- Bootstrap 5 utilities only — no custom CSS, no inline styles
- No Turbo, no Stimulus, no Hotwire — plain ERB and vanilla JS only
- Presenter lives in app/presenters/ — no display logic in views or controllers
- Keep controllers thin — no business logic outside models and presenters
- Do not modify migrations or schema

### Done when
- rails db:seed runs cleanly (idempotent)
- rspec spec/models passes clean
- rspec spec/requests passes clean
- rspec spec/presenters passes clean
- Walks can be created, edited, and deleted in the browser
- Dashboard stat cards update correctly after adding walks
- Modal opens and closes correctly for new and edit
- No Minitest files exist
