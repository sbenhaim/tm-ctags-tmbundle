#!/usr/bin/env ruby

require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/osx/plist'

require ENV['TM_BUNDLE_SUPPORT'] + '/lib/ctags.rb'

nib = ENV['TM_BUNDLE_SUPPORT'] + '/nibs/GotoSymbol.nib'

hits = []
l_column = 0

tags = File.readlines( ENV['TM_PROJECT_DIRECTORY'] + "/.tmtags" ).grep /^#{ENV['TM_CURRENT_WORD']}[^\w]/
tags.each_with_index do |line, i|
  hits << Ctags::parse(line, i)
end

TextMate.exit_show_tool_tip "not found" if hits.length == 0

if hits.length < 2
  Ctags::tm_goto( hits[0] ) 
  exit
end

result = %x{ "$DIALOG" -mc -p '#{{'hits' => hits}.to_plist}' "#{nib}" | pl }
result = OSX::PropertyList.load(result)

if result['result']
  Ctags::tm_goto( result['result']['returnArgument'][0] )
else
  TextMate.exit_discard
end