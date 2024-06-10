# frozen_string_literal: true

# Create default user if not exists.
User.create(email: 'example@email.com', password: 'Password123?') unless User.any?

user = User.first
body = Faker::Lorem.paragraph(sentence_count: 50)

# Create default posts as example.
15.times do |i|
  user.posts.create!(title: "Blog Number ##{i}", body:, published_at: Time.zone.now)
end
