#!/usr/bin/env ruby
puts ARGV.scan(/hbt{2,5}n/).map(&:to_s).join
