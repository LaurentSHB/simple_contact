require 'sinatra'
require 'action_mailer'

class Mailer < ActionMailer::Base
  def contact(params = {})
    @params = params
    mail(
      :to      => "l.buffevant@studio-hb.com",
      :from    => "technique@studio-hb.com",
      :subject => "Test") do |format|
        #format.text
        format.html
    end
  end
end

configure do
  set :root,    File.dirname(__FILE__)
  set :views,   File.join(Sinatra::Application.root, 'views')
  set :haml,    { :format => :html5 }
    
  if production?
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.sendgrid.net",
      :port => '25',
      :authentication => :plain,
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :domain => ENV['SENDGRID_DOMAIN'],
    }
    ActionMailer::Base.view_paths = File.join(Sinatra::Application.root, 'views')
  else
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => '587',
      :authentication => :plain,
      :user_name => "technique@studio-hb.com",
      :password => "aqwxsz21",
      :domain => "studio-hb.com"
    }
    ActionMailer::Base.delivery_method = :smtp
     ActionMailer::Base.view_paths = File.join(Sinatra::Application.root, 'views')
  end
end

post '/' do
  email = Mailer.contact(params)
  email.deliver
  "ok"
end

# get '/' do
#   email = Mailer.contact(params)
#   email.deliver
#   
# end

