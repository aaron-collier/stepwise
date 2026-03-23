class DashboardController < ApplicationController
  def index
    @user  = User.first
    @walks = nil  # TODO: populate with @user.walks in next task
    @stats = nil  # TODO: populate with aggregate stats in next task
  end
end
