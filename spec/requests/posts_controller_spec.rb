# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user:) }
  let(:params) { attributes_for(:post, user_id: user.id) }

  describe 'GET /posts' do
    it 'returns post list' do
      get posts_url
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /posts/:id' do
    context 'when post exists' do
      it 'returns post found by :id' do
        get post_url(post_obj)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end

    context 'when post does not exist' do
      it 'redirects to post index' do
        get post_url(post_obj.id + 1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(posts_url)
      end
    end
  end

  describe 'GET /posts/new' do
    context 'authenticated user' do
      it 'renders the new page' do
        sign_in user
        get new_post_url
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end

    context 'unauthenticated user' do
      it 'redirects to sign in page' do
        get new_post_url
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /posts/:id/edit' do
    context 'authenticated user' do
      it 'renders the edit page' do
        sign_in user
        get edit_post_url(post_obj)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end

    context 'unauthenticated user' do
      it 'redirects to sign in page' do
        get edit_post_url(post_obj)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /posts' do
    context 'authenticated user' do
      before { sign_in user }

      it 'creates a new post' do
        expect do
          post posts_url, params: { post: params }
        end.to change(Post, :count).by(1)
      end

      it 'redirects to the new post page' do
        post posts_url, params: { post: params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(post_url(Post.last.id))
      end
    end

    context 'unauthenticated user' do
      it 'redirects to sign in page' do
        post posts_url, params: { post: params }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PUT /posts/:id/edit' do
    context 'authenticated user' do
      it 'updates the post record' do
        sign_in user
        put post_url(post_obj), params: { post: { title: 'New Title Post' } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(post_url(post_obj))
        expect(post_obj.reload.title).to eq('New Title Post')
      end
    end

    context 'unauthenticaed user' do
      it 'redirects to sign in page' do
        put post_url(post_obj), params: { post: { title: 'New Title Post' } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    context 'authenticated user' do
      before do
        sign_in user
        post_obj
      end

      it 'deletes the post record' do
        expect do
          delete post_url(post_obj)
        end.to change(Post, :count).by(-1)
      end

      it 'redirects to post index page' do
        delete post_url(post_obj)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(posts_url)
      end
    end

    context 'unauthenticated user' do
      it 'redirects to sign in page' do
        delete post_url(post_obj)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
