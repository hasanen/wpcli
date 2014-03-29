require 'spec_helper'

describe Wpcli::Client do
  let(:wp_user_list) do <<EOF
+----+--------------------------+----------------+------------------------------+---------------------+------------------------------------+
| ID | user_login               | display_name   | user_email                   | user_registered     | roles                              |
+----+--------------------------+----------------+------------------------------+---------------------+------------------------------------+
| 1  | test@domain.com          | Test 1         | test@domain.com              | 2013-11-24 19:26:45 | administrator                      |
| 2  | test@domain.net          | Test 2         | test@domain.net              | 2013-11-25 12:41:38 | author                             |
+----+--------------------------+----------------+------------------------------+---------------------+------------------------------------+
EOF
    end
let(:wp_user_list_tabs_newlines) { "ID\tuser_login\tdisplay_name\tuser_email\tuser_registered\troles\n1\tadmin\tadmin\tadmin@domain.tld\t2014-01-07 09:04:08\tadministrator\n" }
let(:wp_role_list_tabs_newlines) { "name\trole\nAdministrator\tadministrator\nEditor\teditor\nAuthor\tauthor\nContributor\tcontributor\nSubscriber\tsubscriber\n" }


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

  let(:single_user) do <<EOF
+---------------------+------------------------------------+
| Field               | Value                              |
+---------------------+------------------------------------+
| ID                  | 1                                  |
| user_login          | username                           |
| user_pass           | hash_of_paassword                  |
| user_nicename       | Firstname Lastname                 |
| user_email          |                                    |
| user_url            |                                    |
| user_registered     | 2013-11-25 12:41:38                |
| user_activation_key |                                    |
| user_status         | 0                                  |
| display_name        | Nickname                           |
| roles               | administrator                      |
+---------------------+------------------------------------+
EOF
    end
    let(:single_user_not_found) do <<EOF
+-------+-------+
| Field | Value |
+-------+-------+
| roles | null  |
+-------+-------+
EOF
    end

  describe '.new' do
    let(:path) { "path_to_wp" }
    let(:command) { "user role" }

    before :each do
      @wpcli = Wpcli::Client.new path
        @wpcli.stub(:`).with("wp --path=#{path} #{command}").and_return(wp_role_list)
    end
    context 'with path' do
      it 'uses --path parameter' do
        @array = @wpcli.run command
        @array.kind_of?(Array).should be(true)
      end
    end
  end
  describe 'run' do
    before :each do
      @wpcli = Wpcli::Client.new
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
      context 'pretty format' do
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
      context 'tabs and newlines' do
        before :each do
          @wpcli.stub(:`).with("wp user list").and_return(wp_user_list_tabs_newlines)
          @array = @wpcli.run "user list"
        end

        describe 'returns array' do
          it { @array.kind_of?(Array).should be(true) }

          it 'which contains hashes' do
            @array.first.kind_of?(Hash).should be(true)
          end

          it 'which has two hashes' do
           @array.size.should eq(1)
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

    context 'single user' do
      before :each do
        @wpcli.stub(:`).with("wp user get username").and_return(single_user)
        @array = @wpcli.run "user get username"
      end

      describe 'returns array' do
          it { @array.kind_of?(Array).should be(true) }

          it 'which has one hash' do
           @array.size.should eq(1)
          end


        it 'hash has correct columns' do
          @array.first.has_key?(:ID).should be(true)
          @array.first.has_key?(:user_login).should be(true)
          @array.first.has_key?(:user_pass).should be(true)
          @array.first.has_key?(:user_nicename).should be(true)
          @array.first.has_key?(:user_email).should be(true)
          @array.first.has_key?(:user_url).should be(true)
          @array.first.has_key?(:user_registered).should be(true)
          @array.first.has_key?(:user_activation_key).should be(true)
          @array.first.has_key?(:user_status).should be(true)
          @array.first.has_key?(:display_name).should be(true)
          @array.first.has_key?(:roles).should be(true)
          @array.first.keys.size.should eq(11)
        end
      end
    end
    context 'single user not found' do
      before :each do
        @wpcli.stub(:`).with("wp user get username").and_return(single_user_not_found)
        @array = @wpcli.run "user get username"
      end

      describe 'returns array' do
          it { @array.kind_of?(Array).should be(true) }

          it 'which has zore hash' do
            @array.size.should eq(0)
          end
      end
    end

    context 'multivalue after single value' do
      before :each do
        @wpcli.stub(:`).with("wp user get username").and_return(single_user)
        @array = @wpcli.run "user get username"
        @wpcli.stub(:`).with("wp role list").and_return(wp_role_list_tabs_newlines)
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
  end
end
