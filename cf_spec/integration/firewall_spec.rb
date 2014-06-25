$: << 'cf_spec'
require 'spec_helper'

describe 'deploying a firewall test app', :null_buildpack do
  subject(:app) { Machete.deploy_app(app_name) }

  context 'an app that does not access the internet' do
    let(:app_name) { 'offline_app' }

    it 'deploys the app successfully' do
      expect(app).to be_running
      expect(app.homepage_body).to include 'Index of'
      expect(app.host).not_to have_internet_traffic
    end
  end

  context 'an uncached buildpack that accesses the internet' do
    let(:app_name) { 'online_app' }

    context 'in an offline environment', if: Machete::BuildpackMode.offline? do
      it 'causes an error when trying to access the internet' do
        expect(app.host).to have_internet_traffic
        expect(app).to have_logged 'Network is unreachable'
        expect(app).to have_logged 'Staging failed: Buildpack compilation step failed'
        expect(app).not_to be_running
      end
    end
    
    context 'in an online environment', if: Machete::BuildpackMode.online? do
      it 'is in online mode and does not fail' do
        expect(app).to be_running
        expect(app.homepage_body).to include 'Index of'
      end
    end
  end
end
