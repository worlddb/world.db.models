# encoding: utf-8

# Note: WorldDb::VERSION gets used by core, that is, worlddb-models


module WorldDbTool    # todo/check - rename to WorldDbTool or WorldDbCommands or WorldDbShell ??

  MAJOR = 2 ## todo: namespace inside version or something - why? why not??
  MINOR = 4
  PATCH = 0
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "worlddb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )}"
  end

end # module WorldDbTool
