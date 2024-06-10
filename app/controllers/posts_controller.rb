# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :post, only: %i[show edit update destroy]

  def index
    @posts ||= Post.paginate(page: params[:page], per_page: 12)
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.new(post_params)
    return render :new, status: :unprocessable_entity unless @post.save

    redirect_to post_url(@post), notice: 'Post created.'
  end

  def update
    return render :edit, status: :unprocessable_entity unless post.update(post_params)

    redirect_to post_url(post), notice: 'Post updated.'
  end

  def destroy
    @post.destroy!

    redirect_to posts_url, notice: 'Post deleted.'
  end

  private

  def post
    @post ||= Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published_at)
  end
end
