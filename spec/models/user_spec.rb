# frozen_string_literal: true

# == Schema Information
# Schema version: 20240607154648
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  describe 'AR associations' do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments).through(:posts) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
  end

  describe 'AR validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'Instance methods' do
    describe '#downcase_email' do
      it 'returns downcased email' do
        user = create(:user, email: 'EXAMPLE@EMAIL.COM')
        expect(user.email).to eq(user.email.downcase)
      end
    end
  end
end
