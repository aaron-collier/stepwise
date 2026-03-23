class DashboardPresenter
  def initialize(user, time: Time.current)
    @user = user
    @time = time
  end

  def greeting
    case @time.hour
    when 0..11  then 'Good morning'
    when 12..16 then 'Good afternoon'
    else             'Good evening'
    end
  end
end
