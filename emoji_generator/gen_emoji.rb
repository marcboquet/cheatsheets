require 'json'
require 'htmlentities'

em = "😄"
puts em
puts em.codepoints.count
em.codepoints.each do |codepoint|
  puts codepoint.to_s(16)
  puts codepoint.to_s(16).to_i(16)
  puts [codepoint.to_s(16).to_i(16)].pack('U')
end;nil;
#puts em.codepoints.map{|cp|cp.to_s(16).to_i(16)}.pack('U')

JSON.parse(File.read "emoji.json").each do |emoji|
  
end



emoji_cheats = ''

JSON.parse(File.read "emoji_grouped.json").each do |emoji_group|
  group = emoji_group[0]
  emojis = emoji_group[1]
  puts "#{group} #{emojis.count}"
  
  emoji_entries = ''
  
  emojis.each do |emoji_info|
    
    # TODO fix HASH KEY error with markdown
    next if emoji_info[1] == "HASH KEY"
    
    
    emoji_code = emoji_info[0]
    emoji_name = emoji_info[1]
    emoji_char = HTMLEntities.new.decode emoji_code
    
    emoji_entries << <<-ENTRY
    entry do
      command ':code_here:'
      name    '<span style="font-size:2em;">#{emoji_char} </span>#{emoji_name}'
      notes   '`#{emoji_code}`'
    end
    ENTRY
  end
  
  emoji_cheats << <<-CATEGORY
  category do
    id '#{group}'
    
    #{emoji_entries}
  end
  CATEGORY

end

cheatfile = ''
cheatfile << <<-CHEATSHEET
cheatsheet do
  title 'Emoji'
  docset_file_name 'Emoji'
  keyword 'emoji'
  source_url 'http://cheat.kapeli.com'

  introduction 'All the emoji'
  
  #{emoji_cheats}
  
end
CHEATSHEET

File.open('emoji.rb','w+') { |f| f << cheatfile }