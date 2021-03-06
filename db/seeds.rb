def user_attributes_for(resource)
  resource.user_attributes = {
    email: "#{resource.name.parameterize}@example.com",
    password: 'password'
  }
end

NAMES = %w(Marco Sara Zeno Zoe)

NAMES.each do |name|
  Commoner.find_or_create_by name: name do |commoner|
    user_attributes_for commoner
  end
  # puts "#{name} created"
end

AdminUser.find_or_create_by email: 'admin@example.com' do |admin_user|
  admin_user.password = 'password'
  admin_user.password_confirmation = 'password'
end
