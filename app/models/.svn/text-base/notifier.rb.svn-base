class Notifier < ActionMailer::Base
  default_url_options[:host] = "cmpt470.csil.sfu.ca:8009"

  def password_reset_email(user)
    subject       "Password Reset Instructions"  
    from          "Pacman Live "  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => url_for(:controller => 'password_reset', :action => 'edit', :id => user.perishable_token)
  end

end
