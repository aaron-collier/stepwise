FactoryBot.define do
  factory :walk do
    association :user
    distance_miles { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    steps          { rand(3000..8000) }
    walked_on      { Date.today }
  end
end
