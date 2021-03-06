class RenameAuthenticationProviders < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      Authentication.where(:provider => 'open_id').map do |authentication|
        provider = case authentication.uid
                   when /^https:\/\/www\.google\.com\/accounts\/o8\/id/
                     'google'
                   when /^https:\/\/me\.yahoo\.com\/a/
                     'yahoo'
                   when /^https:\/\/me\.yahoo\.co\.jp\/a/
                     'yahoo_japan'
                   when /^https:\/\/id\.mixi\.jp/
                     'mixi'
                   else
                     'open_id'
                   end

        authentication.update_attributes! :provider => provider
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      Authentication.where(:provider => %w(google yahoo yahoo_japan mixi)).map do |authentication|
        authentication.update_attributes! :provider => 'open_id'
      end
    end
  end
end
