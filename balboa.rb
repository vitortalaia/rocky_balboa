require 'active_support/all'
require 'capybara'
require 'capybara/poltergeist'
require 'highline/import'
require 'holidays'

Capybara.default_driver = :poltergeist
Capybara.run_server = false
Capybara.app_host = 'http://punchclock.cm42.io/'

module Balboa
  class Puncher
    include Capybara::DSL

    def initialize(email, password, project)
      @email = email
      @password = password
      @project = project

      login!
    end

    def punch!(from_to, start=8, lunch=12)
      punching_to_project

      from_to.each do |date|
        next if date.saturday? or date.sunday?

        next if date.holiday?(:br) and !punch_on_holiday?(date)

        punch_date(date)

        create_punch(date, start, lunch)
        create_punch(date, lunch+1, start+9)
      end
    end

    private
    def holiday_name(holiday)
      Holidays.on(holiday, :br).first[:name]
    end
    def punch_on_holiday?(date)
      HighLine.agree("  #{holiday_name(date)}. Deseja Punch mesmo assim? ") do |q|
       q.responses[:not_valid] = '  Por favor "yes" ou "no".'
      end
    end

    def punching_to_project
      puts "Punch to #{@project}"
    end

    def punch_date(date)
      puts "  "+date.to_s
    end

    def punch_hours(start, finish)
      puts "    #{start} - #{finish}"
    end

    def create_punch(date, start, finish)
      start, finish = "%02d:00" % start, "%02d:00" % finish

      punch_hours(start, finish)

      visit('/punches/new')

      fill_in 'punch[from_time]', with: start
      fill_in 'punch[to_time]', with: finish
      fill_in 'punch[when_day]', with: date.to_s
      select @project, from: 'punch[project_id]'

      click_button 'Criar Punch'
    end

    def login!
      visit('/users/sign_in')

      fill_in 'E-mail', with: @email
      fill_in 'Password', with: @password

      click_button 'Sign in'
    end
  end
end
