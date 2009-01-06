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
nib_title = "Jump to Tag…"

case action
when 'complete'
  word = ENV['TM_CURRENT_WORD']
  regex = /^#{word}/i
  nib_title = "Completions"
when 'find'
  word = ENV['TM_CURRENT_WORD']
  regex = /^#{word}[^\w]/
when 'goto'
  word = TextMate::UI.request_string(:title => "Jump to Tag…", :prompt => "Tag")
  exit if word == nil
  regex = /^#{word}/i
  method = TM_Ctags.method(:goto)
else
  exit
end

hits = []

for f in [ File.join(ENV['TM_PROJECT_DIRECTORY'], ".tmtags"), File.join( ENV['TM_CTAGS_EXTRA_LIB'], ".tmtags") ]
  next unless File.exists?( f )
  tags = File.read( f ).grep( regex )

  index = 1
  tags.each do |line|
    hit = TM_Ctags::parse( line )
    hit['f'] = File.dirname( f );
    # unless hit['type'] == 'variable'
      hits << hit
      index += 1
    # end
    break if index > RESULT_LIMIT;
  end
end

hits = hits.sort_by { |h| h['file'] }.each_with_index {|h, i| h['index'] = i }

TextMate.exit_show_tool_tip "Not found." if hits.length == 0
  
if hits.length < 2
  TM_Ctags::goto( hits[0] ) 
	TextMate::exit_discard
end

result = %x{ "$DIALOG" -mc -p '#{{'hits' => hits, 'title' => nib_title}.to_plist.gsub("'", '"')}' "TM_Ctags.nib" | pl }

result = OSX::PropertyList.load(result)

if result['result']
  method = action == 'complete' ? :build_snippet : :goto
  print TM_Ctags.send( method, result['result']['returnArgument'][0] )
else
  TextMate::exit_discard
end