require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'sequel'

describe "Chatterbot::DB" do
  before(:each) do
    @db_tmp = Tempfile.new("config.db")
    @db_uri = "sqlite://#{@db_tmp.path}"

    @bot = Chatterbot::Bot.new    
    @bot.config[:db_uri] = @db_uri
  end

  describe "get_connection" do
    it "should make sure sequel is actually installed" do
      @bot.stub!(:has_sequel?).and_return(false)
      @bot.should_receive(:display_db_config_notice)
      @bot.db
    end
  end
  
  describe "table creation" do
    [:blacklist, :tweets, :config].each do |table|
      it "should create table #{table}" do
        @bot.db
        @tmp_conn = Sequel.connect(@db_uri)
        @tmp_conn.tables.include?(table).should == true
      end
    end      
  end
  
  describe "store_database_config" do
    it "doesn't fail" do
      @bot = Chatterbot::Bot.new    
      @bot.config[:db_uri] = @db_uri

      @bot.db      
      @bot.store_database_config.should == true
    end
  end
end
