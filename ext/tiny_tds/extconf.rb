ENV['RC_ARCHS'] = '' if RUBY_PLATFORM =~ /darwin/

# :stopdoc:

require 'mkmf'
require 'rbconfig'
require_relative './extconsts'

# Shamelessly copied from nokogiri
#

def do_help
  print <<HELP
usage: ruby #{$0} [options]
    --with-freetds-dir=DIR
      Use the freetds library placed under DIR.
HELP
  exit! 0
end

do_help if arg_config('--help')

# Make sure to check the ports path for the configured host
host = RbConfig::CONFIG['host']
project_dir = File.join(['..']*4)
freetds_dir = File.join(project_dir, 'ports', host, 'freetds', FREETDS_VERSION)
freetds_dir = File.expand_path(freetds_dir)

if File.directory?(freetds_dir)
  puts "Using freetds port path #{freetds_dir}"
  dir_config('freetds', "#{freetds_dir}/include", "#{freetds_dir}/lib")
else
  dir_config('freetds')
end

have_dependencies = [
  find_header('sybfront.h'),
  find_header('sybdb.h'),
  find_library('sybdb', 'tdsdbopen'),
  find_library('sybdb', 'dbanydatecrack')
].inject(true) do |memo, current|
  memo && current
end

unless have_dependencies
  abort 'Failed! Do you have FreeTDS 0.95.80 or higher installed?'
end

create_makefile('tiny_tds/tiny_tds')

# :startdoc:
