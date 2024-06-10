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
require 'rails_helper'

RSpec.describe Comment do
  describe 'AR associations' do
    it { is_expected.to belong_to(:post) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:post_id) }
  end

  describe 'AR validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_least(20).is_at_most(200) }
  end
end
