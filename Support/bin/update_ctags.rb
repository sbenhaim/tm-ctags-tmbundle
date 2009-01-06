#!/usr/bin/env ruby

=begin
  TODO SB: TAGS_INCLUDE, TAGS_EXCLUDE, EXPOSE CTAGS COMMAND, kinds
=end

# require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'
# require ENV['TM_SUPPORT_PATH'] + '/lib/progress.rb'
# 
# dir = ENV['TM_PROJECT_DIRECTORY']
# nib = ENV['TM_BUNDLE_SUPPORT'] + "/nibs/Progress.nib"
# 
# excludes = ENV['TM_CTAGS_EXCLUDES'] || ".git .svn .cvs"
# excludes = excludes.split(' ').map { |excl| "--exclude='#{excl}'" }

args = [
  "-f .tmtags",
  "--fields=Kn",
  "--excmd=pattern",
  "-R",
  "--tag-relative=yes",
  "--PHP-kinds=+cfi-v",
  "--regex-PHP='/abstract class ([^ ]*)/\1/c/'",
  "--regex-PHP='/interface ([^ ]*)/\1/c/'" ,
  "--regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/'",
  "--JavaScript-kinds=+cf",
  "--regex-JavaScript='/(\w+) ?: ?function/\1/f/'",
  ]
  
p args.join(' ')
exit
  
args += excludes
  
ctags_bin = ENV['TM_BUNDLE_SUPPORT'] + '/bin/ctags'
  
Dir.chdir(dir)

TextMate.call_with_progress( :title => "TM Ctags", :message => "Tagging your project…", :indeterminate => true ) do
  result = `"#{ctags_bin}" #{args.join(' ')}`
  puts "All done."
end