#!/usr/bin/env ruby

require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'

require ENV['TM_BUNDLE_SUPPORT'] + '/lib/ctags.rb'

nib = ENV['TM_BUNDLE_SUPPORT'] + '/nibs/AutoComplete.nib'

word = ENV['TM_CURRENT_WORD']
tags = File.read( ENV['TM_PROJECT_DIRECTORY'] + "/.tmtags" ).grep /^#{word}/i

hits = []

index = 1
tags.each do |line| 
  hit = Ctags::parse(line, index) 
  unless hit['type'] == 'variable'
    hits << hit
    index += 1
  end
  break if index > 300;
end

TextMate.exit_show_tool_tip "not found" if hits.length == 0

if hits.length == 1
	print Ctags::build_snippet( hits[0] )
  exit
end

result = %x{ "$DIALOG" -mc -p '#{{'hits' => hits}.to_plist.gsub("'", '"')}' "#{nib}" | pl }

result = OSX::PropertyList.load(result)

if result['result']
  print Ctags::build_snippet( result['result']['returnArgument'][0] )
else
  TextMate.exit_discard
end