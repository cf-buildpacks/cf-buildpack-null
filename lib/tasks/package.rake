require 'cloud_foundry/buildpack_packager'

desc 'package the buildpack as a zip'
task :package do
  CloudFoundry::BuildpackPackager.package
end