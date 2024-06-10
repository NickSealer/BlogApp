# frozen_string_literal: true

# == Schema Information
# Schema version: 20240607154648
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
class Comment < ApplicationRecord
  belongs_to :post

  validates :content, presence: true
  validates :content, length: { minimum: 20, maximum: 200 }
end
