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
	validate :passwordmaker
	validate :handle_maker


	has_many :shout

	def passwordmaker
		password = (0...20).map { (65 + rand(26)).chr }.join.downcase
	end

	def handle_maker 
		handle.gsub(" ","_") 
	end


end


class Shout < ActiveRecord::Base
	
		before_validation :setcounter
		before_validation :time_created
		validates :message, presence: true, length: {minimum: 1, maximum: 200}
		validates_presence_of :created_at 
		validates_presence_of :user
		validates_presence_of :likes

		belongs_to :user

		def time_created

			self.created_at ||= Time.now

		end

		def setcounter

			self.likes ||= 0

		end


	end






describe User do 

	before do
		@user = User.new
		@user.name = "Merolin"
		@user.handle = "Krallin"
		@user.password = "exalnjbhjochuwdxgzfr"
	end

	describe "should be a valid user" do
	  it "should be valid with correct data" do
	  	@user.name = ""
	    @user.valid?.should be_falsy	
		end
	end

  describe "should be false if it has no name" do
		it "should be invalid if name is missing" do
			@user.name = nil
			@user.valid?.should be_falsy
  	end
	end

  describe "should be a valid handle" do
		it "should be invalid if handle has whitespace" do
			@user.valid?.should be_truthy
  	end
	end

	describe "should be a valid handle" do
		it "should be invalid if handle has whitespace" do
			@user.name = "ha ri"
			@user.valid?.should be_truthy
  	end
	end

end


describe Shout do 

	before do
		@shout = Shout.new
		@shout.message = "Hallo ihr doofen Nüsse!"
		@shout.time_created	
		@shout.likes = 0
	end

	describe :created_at do
			it "should have 2014-09-27" do
				expect(@shout.created_at.class).to eq(Time)				
	  	end
		end

	describe :message do
			it "should be a normal message" do
				@shout.message = "Hallo ihr doofen Nüsse!"
				@shout.valid?.should be_truthy
	  	end
		end

	describe :likes do
			it "should have no likes yet" do
				expect(@shout.likes).to eq(0)	
	  	end
		end

end



