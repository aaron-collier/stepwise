# Stepwise - an AI coding agent example application

This is a very simple app (no hotwire/turbo, authentication, etc.) that has a single user (me) that records individual walk distance and step count.

# Goals

The goals with this repository were very simple:

- Gain a better understanding of how AI coding agents can fit into the development workflow.
- Gain a better understanding of the expectations a developer should have of what an AI agent can produce vs. what should remain the developers responsibility.
- Gain a better understanding of what "good prompting" looks like when working with a coding agent.
- Gather ideas on to expand on this understanding to potentially improve developer workflow and velocity.

# Considerations

- This is a very basic, greenfield application. So there is no existing architecture to fit into and work with.
- Some choices (i.e. use vanilla erb view structure vs. hotwire/turbo, no auth) were intentionally made to avoid as much complexity as possible at this stage.

# Summary

I approached this as an expirement from the perspective of someone who has both never used an coding agent and wasn't entirely clear how coding agents fit in a "typical" development workflow. With that in mind, I started with a very generic prompt:

```
As a senior software developer, the rapid rise of AI code agents such as yourself makes me uncomfortable as I'm concerned that agentic coding agents will produce low quality code.

Can you help quell my fears and walk me through adopting agentic coding agents into my workflow? I am being asked to learn more about these practices and presenting project ideas, developer workflows, and other ways that AI may improve our day to day lives. I would like to upskill and start utilizing claude code for a number of high level ideas that I believe would benefit from introducing agentic agents into the workflow.
```

Note: this is obviously a very "conversational" approach where I've kind of personified Claude, this was intentional at the beginning to get a feel for the interaction.

This produced the following response:

```
## On the code quality concern

This one is real and shouldn't be dismissed. Agentic coding agents can produce:

- Architecturally shallow code that works but doesn't scale
- Inconsistent patterns across a codebase
- Over-engineered solutions to simple problems
- Security issues from "plausible but wrong" patterns
- Tests that test the implementation, not the behavior

The mitigation isn't to avoid agents — it's to stay in the architect seat. You define the structure, the contracts, the constraints. The agent fills in the implementation. Your experience tells you immediately when something smells wrong.

## A practical mental model

Think of Claude Code less like a junior dev you hand tickets to, and more like a fast typist who does what you say. Your job shifts from writing every line to:

- Writing clear, constrained specs
- Reviewing diffs with a critical eye
- Catching architectural drift early
- Knowing when to reject and redirect vs. accept and move on

This is actually closer to what senior engineers should be doing anyway.

The key insight here: your judgment is the only thing that closes the loop. Claude Code never merges anything, never makes architectural decisions, and never overrides you. It's a very capable implementer — nothing more.

Now let's get into a concrete workflow.
```

From there, the prompting was much more specific (following something of a "contract" model) and became a cycle of:

- Develop prompt
- Run in plan made
- Apply plan in edit mode

As this was en educational exercise focused on understanding the workflow process, claude chat (web ui) produced the prompts with a few minor edits but I would expect if one was following this as their normal day to day workflow, either writing or carefully tweaking the prompts would be the responsibility of the developer.

# Workflow
## Step 1: Initialize the application and CLAUDE.md file

After I established the project:

```
rails new stepwise --database=sqlite3 --skip-test
cd stepwise
bundle add cssbundling-rails
rails css:install:bootstrap
```
Note: this isn't necessarily the approach I would usually take for `rails new` but I didn't want to veer away from the suggestions I was given during this exercise.

Claude suggested a very simple `CLAUDE.md` file:

```
# Stepwise

A personal walk-tracking app. Single user, no auth for now.

## Stack
- Rails 8, full stack ERB views, SQLite
- RSpec + FactoryBot for all tests
- No API layer — server-rendered only

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
```

You can review the current `CLAUDE.md` file and see the minor changes introduced through this process.

## Step 2: Initial prompt iteration

Claude provided the first prompt which is available at [01_models.md](.claude/prompts/01_models.md) with a little update based on feedback (i.e. I asked to add the data default).

### Prompt structure

#### Constrain claude code

The first line of the prompt should always be:

```
Read CLAUDE.md before doing anything else.
```

This explicitly constrains Claude code to the project definition and choices made there.

#### Directives

You can see in the prompt that the remainder of the file is very explicit about the models to create and how, the associations to establish, constraints the must be followed, the tests to write and the expectations of those tests, factories that may be necessary, and finally `Done` criteria.

#### Result

I ran the prompt in plan mode (which produces a "plan" in an markdown file -- I should have saved this but didn't think of it at the time) which I shared with Claude before applying, which produced this response:

```
This is a very clean plan. Claude Code read your prompt well. A few observations before you approve:

Green flags worth noting:

- Caught that shoulda-matchers isn't present and adapted — that's good situational awareness
- Caught the missing FactoryBot::Syntax::Methods in rails_helper.rb and planned the fix proactively
- CURRENT_DATE lambda is correct in the migration
- Specs first in the execution order — it honored your CLAUDE.md rule
- Hand-crafted migrations instead of generators specifically to avoid Minitest artifacts — smart

One thing to push back on before you approve:

The walked_on factory uses Date.today — a Ruby value evaluated at factory call time, which is fine for a factory. But distance_miles uses rand(2.0..6.0).round(2) which works but Faker::Number.decimal(l_digits: 1, r_digits: 2) is more idiomatic FactoryBot. It's minor — not a blocker, just worth knowing.

One genuine concern: The custom validation uses Date.today:

This will cause intermittent test failures if a spec sets walked_on to Date.today and the comparison is strict >. Today is valid, so that's fine — but it's worth confirming the spec tests Date.tomorrow as the invalid case and Date.today as the valid boundary. Check that when the specs come back.

Everything else is solid. Approve it.
```

## Step 3: CRUD and layout

See prompt at [02_layout_and_profile.md](.claude/prompts/02_layout_and_profile.md)

This followed the same plan/discuss/apply pattern.

## Step 4: Update interface

See prompt at [03_interfaces.md](.claude/prompts/03_interfaces.md)

This followed the same plan/discuss/apply pattern.

# Conclusion

For greenfield projects, this is a rather smooth workflow that shifts the developers focus from typing code to being able to describe the expected architecture very clearly with structured prompts that lead to code that requires minimal intervention.

This very simple project was running in just a couple of hours, and a lot of that time was reading the verbose discussion in the chat bot, not wrangling the coding agent. While this doesn't give any insight into how effective it may be to incorporate this kind of workflow into a "legacy" codebase, it may provide us with an opportunity to quickly get MVPs in front of POs to assist in planning, etc.
