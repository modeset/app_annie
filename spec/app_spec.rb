require 'spec_helper'

describe AppAnnie::App do

  describe 'building an app from a hash' do
    let(:raw_hash) {{  "status"=>true,
                       "app_name"=>"Test App",
                       "app_id"=>"com.testco.TestApp",
                       "last_sales_date"=>"2013-12-25",
                       "first_sales_date"=>"2012-07-29",
                       "icon"=> "https://lh5.ggpht.com/87Gx7aUL0CajI9b9mLWkFJxcwlCydi_KYxDTZMeyu7nzaDo4MwOA2_8jn8Xz666hUG4=w300" }}

    subject { AppAnnie::App.new(raw_hash) }
    its(:raw) { should eq(raw_hash) }
    its(:id) { should eq('com.testco.TestApp') }
    its(:name) { should eq('Test App') }
    its(:status) { should be_true }
    its(:icon) { should eq('https://lh5.ggpht.com/87Gx7aUL0CajI9b9mLWkFJxcwlCydi_KYxDTZMeyu7nzaDo4MwOA2_8jn8Xz666hUG4=w300') }
    its(:first_sales_date) { should eq('2012-07-29') }
    its(:last_sales_date) { should eq('2013-12-25') }
  end

end
