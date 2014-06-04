$: << 'cf_spec'
require "spec_helper"

describe 'deploying a firewall test app', :null_buildpack do
  context "an app that does not access the internet" do
    let(:app_name) { "offline_app" }

    it "deploys the app successfully" do
      Machete.deploy_app(app_name, :null) do |app|
        expect(app.homepage_html).to include "Index of"
      end
    end
  end

  context "an app that accesses the internet" do
    let(:app_name) { "online_app" }

    if Machete::BuildpackMode.offline?

      it "causes an error when trying to access the internet" do
        Machete.deploy_app(app_name, :null) do |app|
          expect(app.output).to include ""
        end
      end
    else
      it "is in online mode and does not fail" do
        Machete.deploy_app(app_name, :null) do |app|
          expect(app.homepage_html).to include "Index of"
        end
      end
    end
  end
end
