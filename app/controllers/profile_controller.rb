class ProfileController < ApplicationController
  def show
    @user = User.first
  end

  def edit
    @user = User.first
  end

  def update
    @user = User.first
    if @user.update(profile_params)
      redirect_to profile_path, notice: 'Profile updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    # Fix this.
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
