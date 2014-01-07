require 'spec_helper'

describe AppAnnie::Account do

  describe 'building an account from a hash' do
    let(:raw_hash) { {
      "account_id"=>110000,
      "platform"=>"ITC",
      "last_sales_date"=>"2014-01-05",
      "account_status"=>"OK",
      "first_sales_date"=>"2013-12-07",
      "publisher_name"=>"AppCo",
      "account_name"=>"AppCo iTunes"
    }}

    subject { AppAnnie::Account.new(raw_hash) }
    its(:raw) { should eq(raw_hash) }
    its(:id) { should eq(110000) }
    its(:name) { should eq('AppCo iTunes') }
    its(:status) { should eq('OK') }
    its(:platform) { should eq('ITC') }
    its(:first_sales_date) { should eq('2013-12-07') }
    its(:last_sales_date) { should eq('2014-01-05') }
    its(:publisher_name) { should eq('AppCo') }
  end

end
