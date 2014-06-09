$: << 'cf_spec'
require "spec_helper"

describe 'deploying a firewall test app' do
  context "an app that does not access the internet" do
    let(:app_name) { "offline_app" }

    it "deploys the app successfully" do
      Machete.deploy_app(app_name) do |app|
        expect(app.homepage_html).to include "Index of"
      end
    end
  end

  context 'an uncached buildpack that accesses the internet' do
    let(:app_name) { 'online_app' }

    context 'in an online environment', if: Machete::BuildpackMode.online? do
      it 'does not fail' do
        Machete.deploy_app(app_name) do |app|
          expect(app.homepage_html).to include 'Index of'
        end
      end
    end

    context 'in an offline environment', if: Machete::BuildpackMode.offline? do
      it 'causes an error when trying to access the internet' do
        Machete.deploy_app(app_name) do |app|
          expect(app.output).to include 'Connection refused'
          expect(app.cf_internet_log).to include 'cf-to-internet-traffic'
        end
      end
    end
  end
end
