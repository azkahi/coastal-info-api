FactoryGirl.define do
  factory :coastal_data do
    region { Faker::Lorem.word }
    station { Faker::Lorem.word }
    start_date { Faker::Date.between(3.months.ago, 3.months.from_now) }
    end_date { Faker::Date.between(3.months.ago, 3.months.from_now) }
    prediction { Faker::Boolean.boolean }
  end
end