# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostHelper do
  let(:post) { create(:post) }

  describe '#body_preview_text' do
    it 'returns only the first 120 body characters' do
      expect(body_preview_text(post.body)).to eq("#{post.body[0..120]}...")
    end
  end
end
