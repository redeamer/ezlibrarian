class Book < ActiveRecord::Base
  has_many :reviews, :as => :treasure, :dependent => :delete_all, :order => "created_on"
  has_many :holder_change_histories, :as => :treasure, :dependent => :delete_all, :order => "created_on"

  validates_presence_of :title, :author, :publisher, :published_on, :isbn, :pages, :content, :value, :holder
  validates_length_of :title, :original_title, :author, :translator, :publisher, :isbn, :intro_url, :maximum => 200
  
  def holder
    holder_id ? User.find(:first, :conditions => "users.id = #{holder_id}") : nil
  end

  def after_save
    last_hch = HolderChangeHistory.find(:first, :conditions => "treasure_id = #{self.id} and treasure_type='Book'", :order => 'created_on desc')
    if !last_hch || (last_hch.holder_id != self.holder_id)
      hch = HolderChangeHistory.new
      hch.treasure = self
      hch.holder_id = self.holder_id
      hch.save
    end
  end

end
