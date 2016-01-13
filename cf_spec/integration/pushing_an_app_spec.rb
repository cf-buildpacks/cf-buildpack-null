$: << 'cf_spec'
require 'spec_helper'

describe 'app state' do
  subject(:app) { Machete.deploy_app(app_name, {buildpack: 'binary_buildpack'}) }
  let(:browser) { Machete::Browser.new(app) }
  let(:app_name) { 'app_that_does_not_access_the_internet' }

  it 'deploys the app successfully' do
    expect(app).to be_running

    browser.visit_path('/')
    expect(browser).to have_body 'Index of'
  end
end

describe 'logging' do
  subject(:app) { Machete.deploy_app(app_name, {buildpack: 'binary_buildpack'}) }
  let(:browser) { Machete::Browser.new(app) }

  context 'an app that does not access the internet' do
    let(:app_name) { 'app_that_does_not_access_the_internet' }

    it 'logs no internet traffic' do
      expect(app.host).not_to have_internet_traffic
    end
  end

  context 'an app that accesses the internet' do
    let(:app_name) { 'app_that_accesses_the_internet' }

    it 'logs internet traffic' do
      expect(app.host).to have_internet_traffic
    end
  end
end
