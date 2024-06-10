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
require 'rails_helper'

RSpec.describe Post do
  describe 'AR associations' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'AR validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:published_at) }
    it { is_expected.to validate_length_of(:title).is_at_least(3).is_at_most(100) }
    it { is_expected.to validate_length_of(:body).is_at_least(300).is_at_most(2000) }
  end
end
