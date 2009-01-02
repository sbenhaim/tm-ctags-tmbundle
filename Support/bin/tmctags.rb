#!/usr/bin/env ruby

require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes.rb'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate.rb'

require ENV['TM_BUNDLE_SUPPORT'] + '/lib/tm_ctags.rb'

unless ENV['TM_PROJECT_DIRECTORY']
  TextMate.exit_show_tool_tip "You must be working with a project or directory to use TM Ctags."
  exit
end

ENV['TM_CTAGS_EXTRA_LIB'] = "" unless ENV['TM_CTAGS_EXTRA_LIB'] != nil

unless File.exists?( File.join(ENV['TM_PROJECT_DIRECTORY'],".tmtags") ) | File.exists?( File.join( ENV['TM_CTAGS_EXTRA_LIB'], ".tmtags") )
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
  word = TextMate::UI.request_string(:title => "Goto Project Symbol", :prompt => "Symbol")
  exit if word == nil
  regex = /^#{word}/i
  method = TM_Ctags.method(:goto)
else
  exit
end

nib = ENV['TM_BUNDLE_SUPPORT'] + "/nibs/#{nib}.nib"

hits = []

for f in [ File.join(ENV['TM_PROJECT_DIRECTORY'], ".tmtags"), File.join( ENV['TM_CTAGS_EXTRA_LIB'], ".tmtags") ]
  next unless File.exists?( f )
  tags = File.read( f ).grep( regex )

  index = 1
  tags.each do |line|
    hit = TM_Ctags::parse(line, index)
    hit['f'] = File.dirname( f );
    # unless hit['type'] == 'variable'
      hits << hit
      index += 1
    # end
    break if index > RESULT_LIMIT;
  end
end

TextMate.exit_show_tool_tip "Not found." if hits.length == 0

if action == 'complete'
  
  TextMate::exit_insert_snippet( hits[0]['name'] + hits[0]['insert'] ) if hits.length < 2
  
  TextMate::UI.complete(hits, :extra_chars => '_')
  
else
  
  if hits.length < 2
	  TM_Ctags::goto( hits[0] ) 
  	TextMate::exit_discard
	end

  result = %x{ "$DIALOG" -mc -p '#{{'hits' => hits}.to_plist.gsub("'", '"')}' "#{nib}" | pl }

  result = OSX::PropertyList.load(result)

  if result['result']
    TM_Ctags::goto( result['result']['returnArgument'][0] )
  else
    TextMate::exit_discard
  end

end