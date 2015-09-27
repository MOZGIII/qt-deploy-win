require "qt-deploy-win"

module QtDeployWin
  module Cli
    def self.print_usage
      puts "Usage: #{$0} some-qt-app.exe dist-dir"
    end

    def self.print_extended_usage
      print_usage
      puts
      puts "Pass an executable as a first argument" +
        " and it will be copied to the directoy passed" +
        " as a second argument along with all dependencies."
      puts
      puts "You should also specify a correct path to the Qt" + 
        " installation directroy."
      puts "Current ENV['QTDIR']: #{ENV['QTDIR']}"
      puts "Example ENV['QTDIR']: C:/Qt/5.5/msvc2013"
    end

    def self.exec
      target, dist_dir = ARGV.shift, ARGV.shift
      unless target && dist_dir
        print_extended_usage
        exit 2
      end

      builder = ::QtDeployWin::Builder.new(
        executable: target,
        dist_dir: dist_dir,
        qt_dir: ENV["QTDIR"],
        windeployqt_args: ARGV.to_a
      )

      unless builder.valid?
        print_usage
        puts
        puts "The following errors occured:"
        builder.errors.each do |err|
          puts "  " + err
        end
        exit
      end

      builder.build
    end
  end
end
