Rails.application.config.sorcery.submodules = []

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.username_attribute_names = [ :name ]
    user.password_attribute_name = :password
    user.crypted_password_attribute_name = :crypted_password
    user.salt_attribute_name = :salt
  end

  config.user_class = "User"
end
