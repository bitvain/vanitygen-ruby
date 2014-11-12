require 'mkmf'
require 'set'

def required_headers
  Set.new.tap do |ret|
    Dir[File.expand_path '../*.{h,c}', __FILE__].each do |filename|
      File.open filename do |file|
        ret.merge file.grep(/^\#include *</).map { |l| l.gsub(/^\#include *<(.*)>\s*$/, '\1') }
      end
    end
  end
end

def required_libs
  File.open(File.expand_path '../../../vanitygen-c/Makefile', __FILE__) do |makefile|
    makefile.grep(/^LIBS=.*$/).first.gsub(/(LIBS=| )-l/, ' ').split
  end
end

required_headers.sort.each do |header|
  have_header header
end

required_libs.sort.each do |lib|
  have_library lib
end

$CFLAGS << " -std=gnu99"

create_makefile 'vanitygen/vanitygen_ext'
