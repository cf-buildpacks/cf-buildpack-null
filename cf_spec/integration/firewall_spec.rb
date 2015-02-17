$: << 'cf_spec'
require 'spec_helper'

describe 'deploying a firewall test app', :null_buildpack do
  subject(:app) { Machete.deploy_app(app_name) }
  let(:browser) { Machete::Browser.new(app) }

  context 'an app that does not access the internet' do
    let(:app_name) { 'offline_app' }

    it 'deploys the app successfully' do
      expect(app).to be_running

      browser.visit_path('/')
      expect(browser).to have_body 'Index of'

      expect(app.host).not_to have_internet_traffic
    end
  end

  context 'an uncached buildpack that accesses the internet' do
    let(:app_name) { 'online_app' }

    it 'is in online mode and does not fail' do
      expect(app.host).to have_internet_traffic
      expect(app).to be_running

      browser.visit_path('/')
      expect(browser).to have_body 'Index of'
    end
  end
end
