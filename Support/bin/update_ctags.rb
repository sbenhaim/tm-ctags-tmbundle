#!/usr/bin/env ruby

dir = ENV['TM_PROJECT_DIRECTORY']

args = [
  "-f .tmtags",
  "--fields=Kn",
  "--excmd=pattern",
  "-R" ,
  "--exclude='.svn|.git|.csv'",
  "--tag-relative=yes",
  "--PHP-kinds=+cf",
  "--regex-PHP='/abstract class ([^ ]*)/\1/c/'",
  "--regex-PHP='/interface ([^ ]*)/\1/c/'" ,
  "--regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/'"
  ]
  
ctags_bin = ENV['TM_BUNDLE_SUPPORT'] + '/bin/ctags'
  
Dir.chdir(dir)

result = `"#{ctags_bin}" #{args.join(' ')}`

puts result
puts "All done."