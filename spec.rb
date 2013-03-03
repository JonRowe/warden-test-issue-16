ENV['RACK_ENV']    ||= 'test'

require 'rack'
require 'rack/null_session'
require 'warden'
require 'warden/always_authenticate'

require 'rack/test'
require './strategies.rb'

describe "testing failure with multiple unmatched strategies" do
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.app do

      use Rack::NullSession
      use Warden::Manager do |manager|
        manager.default_strategies :password, :basic
        manager.failure_app = -> env { [401,{},['BAD']] }
        manager.scope_defaults :default, {}
      end
      use Warden::AlwaysAuthenticate
      run -> env { [200,{'Content-Type' => 'text/plain'},'OK'] }
    end
  end

  subject { get '/' }

  its(:status) { should == 401   }
  its(:body)   { should == 'BAD' }
end
