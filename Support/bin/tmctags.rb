#!/usr/bin/env ruby

require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'

require ENV['TM_BUNDLE_SUPPORT'] + '/lib/tm_ctags.rb'

unless ENV['TM_PROJECT_DIRECTORY']
  TextMate.exit_show_tool_tip "You must be working with a project or directory to use TM Ctags."
  exit
end

unless File.exists?( ENV['TM_PROJECT_DIRECTORY'] + "/.tmtags" )
  TextMate.exit_show_tool_tip "You need to Update Tags for this project/directory first. (⌥⌘P)"
  exit
end

RESULT_LIMIT = 300

action = ARGV[0]

case action
when 'complete'
  nib = 'AutoComplete'
  word = ENV['TM_CURRENT_WORD']
  regex = /^#{word}/i
  method = TM_Ctags.method(:build_snippet)
when 'find'
  nib = 'GotoSymbol'
  word = ENV['TM_CURRENT_WORD']
  regex = /^#{word}[^\w]/
  method = TM_Ctags.method(:goto)
when 'goto'
  nib = 'GotoSymbol'
  word = TextMate::UI.request_string :title => "Goto Project Symbol", :prompt => "Symbol"
  regex = /^#{word}/i
  method = TM_Ctags.method(:goto)
else
  exit
end

nib = ENV['TM_BUNDLE_SUPPORT'] + "/nibs/#{nib}.nib"

tags = File.read( ENV['TM_PROJECT_DIRECTORY'] + "/.tmtags" ).grep( regex )

hits = []

index = 1
tags.each do |line| 
  hit = TM_Ctags::parse(line, index) 
  unless hit['type'] == 'variable'
    hits << hit
    index += 1
  end
  break if index > RESULT_LIMIT;
end

TextMate.exit_show_tool_tip "Not found." if hits.length == 0

if hits.length < 2
	print method.call(hits[0] )
  exit
end

result = %x{ "$DIALOG" -mc -p '#{{'hits' => hits}.to_plist.gsub("'", '"')}' "#{nib}" | pl }

result = OSX::PropertyList.load(result)

if result['result']
  print method.call( result['result']['returnArgument'][0] )
else
  TextMate.exit_discard
end
