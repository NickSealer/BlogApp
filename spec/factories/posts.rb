# frozen_string_literal: true

# == Schema Information
# Schema version: 20240607154648
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  body         :text
#  published_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph(sentence_count: 30) }
    published_at { Time.zone.now }

    user
  end
end
