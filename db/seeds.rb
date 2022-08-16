# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

20.times do |n|
  start_start_day = Date.new(2022, 8, 1)
  start_end_day = Date.new(2022, 8, 16)
  Book.create(
    user_id: 2,
    title: "test#{n}",
    body: "test_place#{n}",
    created_at: (rand*10).days.ago
  )
end 