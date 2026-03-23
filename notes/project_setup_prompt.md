Read CLAUDE.md before doing anything else.

## Task: Generate User and Walk models with migration

### Context
This is a personal walk-tracking app. We are at the very beginning —
no models exist yet. You are generating the foundation of the data model.

### Models to create

User:
- first_name: string, null: false
- last_name: string, null: false
- email: string, null: false, unique index

Walk:
- user: references (sets up user_id foreign key and belongs_to automatically)
- distance_miles: decimal, precision: 8, scale: 2, null: false
- steps: integer, null: false
- walked_on: date, null: false, default: -> { 'CURRENT_DATE' }

### Associations
- User has_many :walks, dependent: :destroy
- Walk belongs_to :user

### Constraints
- Migrations must be reversible
- Add database-level null constraints on all fields listed as null: false
- Add a database-level unique index on users.email
- Date fields should default to CURRENT_DATE at the database level, not in Ruby
- Do not generate controllers, views, or routes — models and migrations only

### Tests to write (RSpec)
- spec/models/user_spec.rb
  - validates presence of first_name, last_name, email
  - validates uniqueness of email
  - has_many :walks association
- spec/models/walk_spec.rb
  - validates presence of distance_miles, steps, walked_on
  - validates numericality of distance_miles (greater than 0)
  - validates numericality of steps (greater than 0, only integer)
  - validates walked_on is not in the future
  - belongs_to :user association

### Factories to write (FactoryBot)
- spec/factories/users.rb — realistic names and email via Faker
- spec/factories/walks.rb — realistic distance (2.0–6.0 miles), steps (3000–8000)

### Done when
- rails db:migrate runs without errors
- rspec spec/models passes with all examples green
- No Minitest files exist or were generated
