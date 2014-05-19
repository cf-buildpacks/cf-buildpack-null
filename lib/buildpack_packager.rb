require 'zip'


  module BuildpackPackager
    DEPENDENCIES = []

    EXCLUDE_FROM_BUILDPACK = [
        /\.git/
    ]

    class << self
      def package
        Dir.mktmpdir do |temp_dir|
          copy_buildpack_contents(temp_dir)
          download_dependencies(temp_dir) unless ENV['ONLINE']
          compress_buildpack(temp_dir)
        end
      end

      private

      def copy_buildpack_contents(target_path)
        run_cmd "cp -r * #{target_path}"
      end

      def download_dependencies(target_path)
        dependency_path = File.join(target_path, 'dependencies')

        run_cmd "mkdir -p #{dependency_path}"

        DEPENDENCIES.each do |uri|
          run_cmd "cd #{dependency_path}; curl #{uri} -O"
        end
      end

      def in_pack?(file)
        !EXCLUDE_FROM_BUILDPACK.any? { |re| file =~ re }
      end

      def compress_buildpack(target_path)
        Zip::File.open('null_buildpack.zip', Zip::File::CREATE) do |zipfile|
          Dir[File.join(target_path, '**', '**')].each do |file|
            zipfile.add(file.sub(target_path + '/', ''), file) if (in_pack?(file))
          end
        end
      end

      def run_cmd(cmd)
        puts "$ #{cmd}"
        `#{cmd}`
      end
    end
  end
