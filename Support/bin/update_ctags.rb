#!/usr/bin/env ruby

require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/progress.rb'

dir = ENV['TM_PROJECT_DIRECTORY']

# Required arguments
base_args = [
  "-f .tmtags",
  "--tag-relative=yes",
  "--fields=Kn",
]


if File.exist? "#{ENV['TM_CTAGS_OPTIONS']}"

  args = ["--options='#{ENV['TM_CTAGS_OPTIONS']}'"]

else
  
  args = [
    "--excmd=pattern",
    "--PHP-kinds=+cfi-v",
    "--regex-PHP='/abstract class ([^ ]*)/\1/c/'",
    "--regex-PHP='/interface ([^ ]*)/\1/c/'" ,
    "--regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/'",
    "--JavaScript-kinds=+cf",
    "--regex-JavaScript='/(\w+) ?: ?function/\1/f/'",
    ]
    
  filter = ""
  
  includes = ENV['TM_CTAGS_INCLUDES']
  
  if includes
    filter = "find -E . -iregex '(#{includes.split(' ').join('|')})' | "
    args << "-L -"
  else
    args << "-R"
    
    standard_excludes = %w{.git .svn .cvs}

    user_excludes = []
    user_excludes = ENV['TM_CTAGS_EXCLUDES'].split(' ') if ENV['TM_CTAGS_EXCLUDES']

    excludes = (standard_excludes + user_excludes).uniq

    excludes = excludes.map { |excl| "--exclude='#{excl}'" }

    args += excludes
  end
    
end

args += base_args
  
ctags_bin = ENV['TM_BUNDLE_SUPPORT'] + '/bin/ctags'
  
Dir.chdir(dir)

TextMate.call_with_progress( :title => "TM Ctags", :message => "Tagging your project…", :indeterminate => true ) do
  result = `#{filter}"#{ctags_bin}" #{args.join(' ')}`
  puts "All done."
end