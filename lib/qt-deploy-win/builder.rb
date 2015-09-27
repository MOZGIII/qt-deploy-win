require "fileutils"
require "visual_studio"

module QtDeployWin
  class Builder
    def initialize(options)
      @options = options
      @errors = []
      @visual_studio = VisualStudio.find("vs2013")
      validate
    end

    def path(name)
      case name
      when :qt_dir, :dist_dir, :executable, :windeployqt_args
        return @options[name]
      when :windeployqt
        qtdir = path(:qt_dir)
        return nil unless qtdir
        @windeployqt ||= which("windeployqt", "#{qtdir}/bin")
      end
    end

    def errors
      @errors
    end

    def valid?
      @errors.empty?
    end

    def env
      qtdir = path(:qt_dir)
      {
        "QTDIR" => qtdir,
        "PATH" => "#{qtdir}/bin" + File::PATH_SEPARATOR + ENV["PATH"],
        "VSINSTALLDIR" => @visual_studio.root,
        "VCINSTALLDIR" => @visual_studio.toolsets.cpp
      }
    end

    def build
      raise "Task not valid, unable to exec" unless valid?

      distdir = path(:dist_dir)
      main_executable = path(:executable)

      # Setup distdir
      preapare_distdir(distdir)

      # Copy main executable
      dist_main_path = File.join(distdir, File.basename(main_executable))
      FileUtils.cp main_executable, dist_main_path

      # Package
      args = path(:windeployqt_args) || []
      system env, path(:windeployqt), dist_main_path, *args
    end

    protected

    def preapare_distdir(distdir)
      # Create distdir
      FileUtils.mkdir_p distdir

      # Clean distdir
      FileUtils.rm_rf Dir["#{distdir}/*"]
    end

    def validate
      qtdir = path(:qt_dir)
      @errors << ":qt_dir is not set" unless qtdir
      @errors << ":qt_dir not fould at \"#{qtdir}\"" unless qtdir && File.directory?(qtdir)

      distdir = path(:dist_dir)
      @errors << ":dist_dir is not set" unless distdir
      @errors << ":dist_dir at \"#{qtdir}\" is already exists and not a directory" if distdir && File.exists?(distdir) && !File.directory?(distdir)

      windeployqt = path(:windeployqt)
      @errors << ":windeployqt is not set" unless windeployqt
      @errors << ":windeployqt at \"#{windeployqt}\" is not fould" unless windeployqt && File.exists?(windeployqt)

      main_executable = path(:executable)
      @errors << ":executable is not set" unless main_executable
      @errors << ":executable at \"#{main_executable}\" is not fould" unless main_executable && File.file?(main_executable)

      @errors << "Visual Studio 2013 was not found" unless @visual_studio
    end

    def which(cmd, paths = ENV['PATH'])
      pathext_env = ENV['PATHEXT']
      exts = pathext_env ? pathext_env.split(';') : ['']
      paths.split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end
      nil
    end
  end
end
