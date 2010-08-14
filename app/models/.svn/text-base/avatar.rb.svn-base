# Code from tutorial: 
# http://clarkware.com/cgi/blosxom/2007/02/24#FileUploadFu

class Avatar < ActiveRecord::Base
  belongs_to :user  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes,
                 :resize_to => '125x125>',
                 :thumbnails => { :thumb => '100x100>' }

  validates_as_attachment

end
