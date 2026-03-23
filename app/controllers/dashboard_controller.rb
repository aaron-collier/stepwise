class DashboardController < ApplicationController
  def index
    @user      = User.first
    @presenter = DashboardPresenter.new(@user)
    @walks     = @user.walks.recent(5)
    @stats     = {
      steps_today:        @user.walks.where(walked_on: Date.today).sum(:steps),
      miles_today:        @user.walks.where(walked_on: Date.today).sum(:distance_miles),
      avg_steps_per_walk: @user.walks.average(:steps)&.round || 0,
      avg_steps_per_day:  compute_avg_steps_per_day(@user)
    }
  end

  private

  def compute_avg_steps_per_day(user)
    days = user.walks.select(:walked_on).distinct.count
    return 0 if days.zero?
    (user.walks.sum(:steps).to_f / days).round
  end
end
