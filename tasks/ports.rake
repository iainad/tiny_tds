# encoding: UTF-8
require 'mini_portile2'
require 'fileutils'
require_relative 'ports/libiconv'
require_relative 'ports/openssl'
require_relative 'ports/freetds'
require_relative '../ext/tiny_tds/extconsts'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if defined? OpenSSL

namespace :ports do
  default_host = RbConfig::CONFIG['host']
  openssl = Ports::Openssl.new(OPENSSL_VERSION)
  libiconv = Ports::Libiconv.new(ICONV_VERSION)
  freetds = Ports::Freetds.new(FREETDS_VERSION)

  directory "ports"

  desc "Activate all ports for the provided host (default: #{default_host})"
  task :use, [:host] do |task, args|
    args.with_defaults(host: default_host)

    [openssl, libiconv, freetds].each do |lib|
      lib.host = args.host
      lib.activate
    end

    ENV['LD_LIBRARY_PATH'] = ENV['LIBRARY_PATH'] if ENV.include?('LIBRARY_PATH')
  end

  task :debug, [:host] do |task, args|
    args.with_defaults(host: default_host)

    puts `ldd #{File.join('lib', 'tiny_tds','tiny_tds.so')}`
  end

  desc "Compile openssl for the provided host (default: #{default_host})"
  task :openssl, [:host] do |task, args|
    args.with_defaults(host: default_host)

    openssl.files = [OPENSSL_SOURCE_URI]
    openssl.host = args.host
    openssl.cook
  end

  desc "Compile libiconv for the provided host (default: #{default_host})"
  task :libiconv, [:host] do |task, args|
    args.with_defaults(host: default_host)

    libiconv.files = [ICONV_SOURCE_URI]
    libiconv.host = args.host
    libiconv.cook
  end

  desc "Compile freetds for the provided host (default: #{default_host})"
  task :freetds, [:host] do |task, args|
    args.with_defaults(host: default_host)

    freetds.files = [FREETDS_SOURCE_URI]
    freetds.host = args.host

    if libiconv
      freetds.configure_options << "--with-libiconv-prefix=#{libiconv.path}"
    end

    freetds.cook
  end

  desc "Compile all ports for the provided host (default: #{default_host})"
  task :compile, [:host] do |task,args|
    args.with_defaults(host: default_host)

    puts "Compiling ports for #{args.host}..."

    ['openssl','libiconv','freetds'].each do |lib|
      Rake::Task["ports:#{lib}"].invoke(args.host)
    end
  end

  desc 'Build the ports windows binaries via rake-compiler-dock'
  task 'cross' do
    require 'rake_compiler_dock'

    # make sure to install our bundle
    build = ['bundle']

    # build the ports for all our cross compile hosts
    GEM_PLATFORM_HOSTS.each do |gem_platform, host|
      build << "rake ports:compile[#{host}]"
    end

    RakeCompilerDock.sh build.join(' && ')
  end
end

desc 'Build ports and activate libraries for the current architecture.'
task :ports => ['ports:compile', 'ports:use']
