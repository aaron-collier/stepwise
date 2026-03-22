# Stepwise

A personal walk-tracking app. Single user, no auth for now.

## Stack
- Rails 8, full stack ERB views, SQLite
- RSpec + FactoryBot for all tests
- No API layer — server-rendered only
- Bootstrap 5 for CSS — no Tailwind, no custom CSS unless Bootstrap utilities don't cover it

## Models (planned)
- User: first_name, last_name, email
- Walk: distance_miles (decimal), steps (integer), walked_on (date), user_id
- One User has many Walks

## Rules you must follow
- Write RSpec specs before or alongside implementation — never after
- Use FactoryBot factories, never fixtures
- No callbacks on models — use service objects if logic is needed
- migrations must be reversible
- Keep controllers thin — no business logic
- Do not add gems without asking me first
