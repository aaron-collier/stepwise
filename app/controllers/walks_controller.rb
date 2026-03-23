class WalksController < ApplicationController
  before_action :set_walk, only: %i[edit update destroy]

  def index
    @walks = User.first.walks.order(walked_on: :desc, created_at: :desc)
    @walk  = User.first.walks.build
  end

  def new
    @walk = User.first.walks.build
  end

  def create
    @walk = User.first.walks.build(walk_params)
    if @walk.save
      redirect_to walks_path, notice: 'Walk logged.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @walk.update(walk_params)
      redirect_to walks_path, notice: 'Walk updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @walk.destroy
    redirect_to walks_path, notice: 'Walk deleted.'
  end

  private

  def set_walk
    @walk = User.first.walks.find(params[:id])
  end

  def walk_params
    params.require(:walk).permit(:distance_miles, :steps, :walked_on)
  end
end
