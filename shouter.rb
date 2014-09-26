require 'sinatra'
require 'sinatra/reloader'
require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)


class User < ActiveRecord::Base

	validates_presence_of :name 
	validates :handle, uniqueness: true
	validates_length_of :password, minimum: 20, maximum: 20, :allow_blank => false, uniqueness: true

	def passwordmaker
		password = (0...20).map { (65 + rand(26)).chr }.join.downcase
	end

end



describe User do 

	before do
		@user = User.new
		@user.name = "Merolin"
		@user.handle = "Krallin"
		@user.password = "exalnjbhjochuwdxgzfr"
	end

	  it "should be valid with correct data" do
    @user.valid?.should be_truthy
  end

  # describe :name do
  #   it "should be invalid if it's missing" do
  #     @student.name = nil
  #     @shouter.valid?.should be_falsy
  #   end


end