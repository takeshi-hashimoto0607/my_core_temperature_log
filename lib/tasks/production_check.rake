namespace :production do
  desc "Check production deployment prerequisites"
  task check: :environment do
    required_env_keys = %w[RAILS_ENV DATABASE_URL RAILS_MASTER_KEY]
    missing_env_keys = required_env_keys.select { |key| ENV[key].blank? }

    abort "Missing environment variables: #{missing_env_keys.join(', ')}" if missing_env_keys.any?

    puts "Check Render Build Command includes: bin/rails db:migrate"
    puts "Production check passed"
  end
end
