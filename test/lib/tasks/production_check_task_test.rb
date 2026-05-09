require "test_helper"
require "rake"

class ProductionCheckTaskTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks if Rake::Task.tasks.none? { |task| task.name == "production:check" }
    Rake::Task["production:check"].reenable
  end

  test "checks required production environment variables" do
    with_env("RAILS_ENV" => "production", "DATABASE_URL" => "postgres://example", "RAILS_MASTER_KEY" => "secret") do
      assert_output(/Check Render Build Command includes: bin\/rails db:migrate.*Production check passed/m) do
        Rake::Task["production:check"].invoke
      end
    end
  end

  private

  def with_env(values)
    original_values = values.keys.to_h { |key| [ key, ENV[key] ] }
    values.each { |key, value| ENV[key] = value }

    yield
  ensure
    original_values.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
  end
end
