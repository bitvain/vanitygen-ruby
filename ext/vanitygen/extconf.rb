require 'mkmf'
require 'set'

headers = Set.new
Dir[File.expand_path '../*.{h,c}', __FILE__].each do |filename|
  File.open filename do |file|
    headers.merge file.grep(/^\#include *</).map { |l| l.gsub(/^\#include *<(.*)>\s*$/, '\1') }
  end
end
headers.to_a.sort.each do |header|
  have_header header
end

File.open(File.expand_path '../../../vanitygen-c/Makefile', __FILE__) do |makefile|
  libs = makefile.grep(/^LIBS=.*$/).first.gsub(/(LIBS=| )-l/, ' ').split
  libs.sort.each do |lib|
    have_library lib
  end
end

$CFLAGS << " -std=c99"

create_makefile 'vanitygen/vanitygen_ext'
