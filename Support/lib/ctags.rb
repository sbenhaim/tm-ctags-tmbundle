module Ctags
  def Ctags.parse(line, index)
    name = line[/^(\w+)/, 1]
    path = line.split(/\t+/)[1]
    type = line.split(/\t+/)[-2]
    line_no = line[ /line:(\d+)/, 1]
    file = File.basename(path) + ":" + line_no
    
    args = parse_args( line )
    signature = name + "(" 
    signature << " " + args.join(", ") + " "
    signature << ")"
    
    overview = "#{type} #{signature}   < #{file}:#{line_no} >"
    
    { 
      'name' => name, 
      'signature' => signature, 
      'file' => file, 
      'path' => path, 
      'line' => line_no, 
      'index' => index, 
      'args' => args, 
      'type' => type,
      'overview' => overview
    }
  end
  
  def Ctags.parse_args( line )
    sig = line[ %r{/\^\s*(.+?)\$/}, 1]
    raw = sig[/\((.*?)\)/, 1]
    if raw
      raw.delete(" ").split(',')
    else
      []
    end
  end

  def Ctags.build_snippet( hit )
    if hit['args']
      args = []
      hit['args'].each_with_index do |arg, i|
        arg.gsub!('$', '\$')
        args << "${#{i + 1}:#{arg}}"
      end
      
    end
    snippet = hit['name']
    snippet << '('
    snippet << ' ' + args.join(", ") + ' ' if args
    snippet << ')$0'
  end
  
  def Ctags.tm_goto( hit )
    TextMate.go_to :file => File.join(ENV['TM_PROJECT_DIRECTORY'], hit['path']), :line => hit['line']
  end
end