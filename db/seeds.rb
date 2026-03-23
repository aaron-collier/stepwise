user = User.find_or_create_by(email: 'aaron@example.com') do |u|
  u.first_name = 'Aaron'
  u.last_name  = 'Collier'
end

puts "Seed user: #{user.first_name} #{user.last_name} (#{user.email})"
