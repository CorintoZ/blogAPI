FactoryBot.define do
  factory :product do
    name { Faker::FunnyName.name }
    description { Faker::Superhero.descriptor }
    price { Faker::Number.between(from: 1, to: 10) }
    stock { Faker::Number.between(from: 1, to: 10) }
  end
end
