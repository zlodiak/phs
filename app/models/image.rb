class Image < ActiveRecord::Base
  validates :title, presence: true
  validates :image, presence: true

  belongs_to :user

  has_attached_file :image, 
                    :styles => { 
                                  :giant => "1000x500>", 
                                  :large => "600x400>", 
                                  :medium => "300x300>", 
                                  :thumb => "200x100>" 
                    }, 
                    :default_url => "/images/:style/missing.png"
  
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/  
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]  

  validate :file_size_validation, :if => "image?"  

  def file_size_validation
    errors[:image] << "should be less than 2MB" if image.size.to_i > 5.megabytes
  end  
end
