require 'sinatra'
require 'action_mailer'

class Mailer < ActionMailer::Base
  def contact(params = {})
    @params = params
    mail(
      :to      => ENV['MAIL_TO'],
      :from    => ENV['MAIL_FROM'],
      :subject => "Nouvelle demande de contact") do |format|
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
  end
end

post '/' do
  email = Mailer.contact(params)
  email.deliver
  redirect ENV['CONTACT_REDIRECTION']
end

get '/contact' do
  File.read(File.join('public', 'form.html'))
end

