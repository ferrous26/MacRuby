require 'rbconfig'
require 'rubygems/config_file'
require 'rubygems/user_interaction'

unless MacRuby.const_defined?(:Compiler)
  load File.join(RbConfig::CONFIG['bindir'], 'macrubyc')
end

module Gem
  class Compiler
    include Gem::UserInteraction

    def initialize
      @current_directory = []
      @config            = Gem.configuration
    end

    def call gem
      @spec = gem.spec

      return if skipping_compilation?
      say compilation_message if @config.verbose

      gem_files.each do |file|
        say compile_file_msg(file) if @config.really_verbose
        absolute_file_path = File.join(@spec.full_gem_path, file)
        MacRuby::Compiler.compile_file(absolute_file_path)
      end
    end

    def skipping_compilation?
      ConfigFile::PLATFORM_DEFAULTS['compile'] == false
    end

    def compilation_message
      slash = @config.really_verbose ? '/' : ''
      "Compiling #{@spec.full_name}#{slash}"
    end

    # @todo get better at deciding which files to compile;
    #       right now we ignore the .rb.data file in the mime-types gem
    #       and probably some other silly edge cases that are similar
    def gem_files
      files = @spec.files - @spec.test_files - @spec.extra_rdoc_files
      files.reject { |file| file.match /^(?:test|spec)/ }
        .select { |file| file.match /\.rb$/ }
    end

    def compile_file_msg file
      name = File.basename(file)
      dirs = file.chomp(name).split(File::SEPARATOR)
      tabs = "\t" * dirs.count

      dirs.each_with_index do |dir, index|
        unless @current_directory[index] == dir
          @current_directory[index] = dir
          say( "\t" * (index + 1) + dir + File::SEPARATOR)
        end
      end

      "#{tabs}#{name} => #{name}o"
    end
  end

  @post_install_hooks << Compiler.new

  ConfigFile::PLATFORM_DEFAULTS['install'] = '--no-rdoc --no-ri'
  ConfigFile::PLATFORM_DEFAULTS['update']  = '--no-rdoc --no-ri'

  Platform::MACRUBY         = Platform.new([Platform.local.cpu, RUBY_ENGINE])
  Platform::MACRUBY_CURRENT = Platform.new([Platform.local.cpu, RUBY_ENGINE,
                                            MACRUBY_VERSION.split('.')[0, 2].join('.')])
  platforms << Platform::MACRUBY_CURRENT
end
