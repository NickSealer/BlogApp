# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to posts_url, notice: "Resource: #{params[:controller].singularize} #{params[:id]} not found."
  end
end
