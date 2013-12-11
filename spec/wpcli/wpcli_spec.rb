require 'spec_helper'

describe WPCLI::Client do

  describe '.new' do

  end
  describe 'run' do
    let(:wp_user_list) do <<EOF
+----+--------------------------+----------------+------------------------------+---------------------+------------------------------------+
| ID | user_login               | display_name   | user_email                   | user_registered     | roles                              |
+----+--------------------------+----------------+------------------------------+---------------------+------------------------------------+
| 1  | test@domain.com          | Test 1         | test@domain.com              | 2013-11-24 19:26:45 | administrator                      |
| 2  | test@domain.net          | Test 2         | test@domain.net              | 2013-11-25 12:41:38 | author                             |
+----+--------------------------+----------------+------------------------------+---------------------+------------------------------------+
EOF
    end

    let(:wp_role_list) do <<EOF
+------------------+------------------------------------+
| name             | role                               |
+------------------+------------------------------------+
| Administrator    | administrator                      |
| Editor           | editor                             |
| Author           | author                             |
| Contributor      | contributor                        |
| Subscriber       | subscriber                         |
+------------------+------------------------------------+
EOF
    end

    before :each do
      @wpcli = WPCLI::Client.new
    end

    context 'role list' do
      before :each do
        @wpcli.stub(:`).with("wp role list").and_return(wp_role_list)
        @array = @wpcli.run "role list"
      end

      describe 'returns array' do
        it { @array.kind_of?(Array).should be(true)}

        it 'which contains hashes' do
          @array.first.kind_of?(Hash).should be(true)
        end

        it 'which has five hashes' do
          @array.size.should eq(5)
        end

        it 'first hash has correct columns' do
          @array.first.has_key?(:name).should be(true)
          @array.first.has_key?(:role).should be(true)
          @array.first.keys.size.should eq(2)
        end
      end
    end

    context 'user list' do
      before :each do
        @wpcli.stub(:`).with("wp user list").and_return(wp_user_list)
        @array = @wpcli.run "user list"
      end

      describe 'returns array' do
        it { @array.kind_of?(Array).should be(true) }

        it 'which contains hashes' do
          @array.first.kind_of?(Hash).should be(true)
        end

        it 'which has two hashes' do
         @array.size.should eq(2)
        end

        it 'first hash has correct columns' do
          @array.first.has_key?(:id).should be(true)
          @array.first.has_key?(:display_name).should be(true)
          @array.first.has_key?(:user_email).should be(true)
          @array.first.has_key?(:user_registered).should be(true)
          @array.first.has_key?(:user_login).should be(true)
          @array.first.has_key?(:roles).should be(true)
          @array.first.keys.size.should eq(6)
        end
      end
    end
  end
end