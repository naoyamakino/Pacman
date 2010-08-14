#
# Code from http://clarkware.com/cgi/blosxom/2007/02/24#FileUploadFu
# for the most part.
#
class AvatarsController < ApplicationController
  before_filter :require_user

  def index
  end


  def create
    begin 
      @avatar = Avatar.new(params[:avatar])
      @old_avatar = current_user.avatar
      @avatar.user = current_user

      if @avatar.save
        if @old_avatar
          @old_avatar.destroy
        end 

        flash[:notice] = 'Avatar successfully updated.'
      else
        flash[:error] = 'The file you uploaded is not an accepted image file'
      end
    rescue TypeError
      flash[:error] = 'The file you uploaded is not an image file.'
    ensure
      redirect_to users_url
    end
  end

  #TODO: Fix field_name to human readable...some error messages generated not user friendly.
  private
  def packErrors(avatar)
    errors = ""
    if avatar && avatar.errors.count > 0
      @avatar.errors.each do |field_name, message|
        errors += field_name.capitalize + " " + message 
      end
    end

    errors
  end

end
