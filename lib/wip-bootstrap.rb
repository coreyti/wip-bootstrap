require 'rubygems'
require 'fileutils'
require 'wip-bootstrap/version'

module WIP
  module Bootstrap
    class << self
      def run
        setup
        install! unless installed?
      end

      private

        def setup
          @source_home = File.expand_path(File.join(File.dirname(__FILE__), '..'))
          @target_home = Gem.user_home
          @user_name   = ENV['SUDO_USER'] || ENV['USER']
          @group_id    = ENV['SUDO_GID']  || ENV['staff'] # Ack!
          @receipt     = home_path(".wip/boostrap-v#{WIP::Bootstrap::VERSION}")
        end

        def installed?
          File.exist?(@receipt)
        end

        def install!
          banner('bootstrapping `wip`') {
            line('wip-bootstrap version', WIP::Bootstrap::VERSION)

            target_dir = home_path('.wip')
            line('installing .wip to', target_dir) {
              copy(files_path('wip/.'), target_dir)
              chown(target_dir)
            }

            target_rc = home_path('.wiprc')
            line('installing .wiprc to', home_path('.wiprc')) {
              copy(files_path('wiprc'), target_rc)
              chown(target_rc)
            }

            target_profile = home_path('.profile')
            line('appending `source ~/.wiprc` to', target_profile) {
              if (File.exist?(target_profile))
                File.open(target_profile, 'a') do |f|
                  f.write(%Q{\n[[ -s "$HOME/.wiprc" ]] && source "$HOME/.wiprc"\n})
                end
              else
                raise NotImplementedError
              end

            } unless grep?(target_profile, 'source "$HOME/.wiprc"')

            line('delivering receipt to', @receipt) {
              touch(@receipt)
            }
          }
        end

        def copy(source, target)
          FileUtils.cp_r(source, target)
        end

        def chown(file)
          FileUtils.chown_R(@user_name, @group_id, file)
        end

        def touch(file)
          FileUtils.touch(file)
        end

        def home_path(path)
          File.join(@target_home, path)
        end

        def files_path(path)
          File.join(@source_home, 'files', path)
        end

        def grep?(file, content)
          result = File.open(file, 'r') { |f| f.grep(/#{Regexp.escape(content)}/) }
          result.length > 0
        end

        def banner(title, &block)
          rule(title)
          yield
          rule
        end

        def rule(content = nil)
          if content
            puts "-- #{content} #{('-' * (74 - (content).length))}"
          else
            puts "-" * 78
          end
        end

        def line(label, value)
          puts "  * #{pad(label)} #{value}"
          yield if block_given?
        end

        def pad(label)
          "#{label}#{'.' * 30}"[0,30]
        end
    end
  end
end
