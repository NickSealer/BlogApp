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
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_presence_of :title, :body, :published_at
  validates :title, length: { minimum: 3, maximum: 100 }
  validates :body, length: { minimum: 300, maximum: 2000 }
end
