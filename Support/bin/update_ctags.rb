#!/usr/bin/env ruby

require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'

dir = ENV['TM_PROJECT_DIRECTORY']
nib = ENV['TM_BUNDLE_SUPPORT'] + "/nibs/Progress.nib"

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

working = { 'working' => 1, 'text' => "Indexing your project..." }
token = %x{"$DIALOG" -ac -p '#{working.to_plist}' "#{nib}" | pl}
token = OSX::PropertyList.load(token)
result = `"#{ctags_bin}" #{args.join(' ')}`
working = { 'working' => 0, 'text' => 'All done.'}
%x{"$DIALOG" -t #{token} -p '#{working.to_plist}'}