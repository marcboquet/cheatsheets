require 'json'
require 'htmlentities'
require 'sqlite3'
require 'unicode_utils'

em = "9️⃣"
puts UnicodeUtils.debug(em)
puts em.codepoints.map{|cp|cp.to_s(16)}
em.codepoints.each do |codepoint|
  puts codepoint.to_s(16)
  puts codepoint.to_s(16).to_i(16)
  puts [codepoint.to_s(16).to_i(16)].pack('U')
end;nil;
puts em.codepoints.map{|cp|cp.to_s(16).to_i(16)}.pack('U')

emoji_data = JSON.parse(File.read "emoji.json")


# From /System/Library/Input Methods/CharacterPalette.app/Contents/Resources/Category-Emoji.plist
emoji_grouped = {
  "People" => "😄,😃,😀,😊,☺️,😉,😍,😘,😚,😗,😙,😜,😝,😛,😳,😁,😔,😌,😒,😞,😣,😢,😂,😭,😪,😥,😰,😅,😓,😩,😫,😨,😱,😠,😡,😤,😖,😆,😋,😷,😎,😴,😵,😲,😟,😦,😧,😈,👿,😮,😬,😐,😕,😯,😶,😇,😏,😑,👲,👳,👮,👷,💂,👶,👦,👧,👨,👩,👴,👵,👱,👼,👸,😺,😸,😻,😽,😼,🙀,😿,😹,😾,👹,👺,🙈,🙉,🙊,💀,👽,💩,🔥,✨,🌟,💫,💥,💢,💦,💧,💤,💨,👂,👀,👃,👅,👄,👍,👎,👌,👊,✊,✌️,👋,✋,👐,👆,👇,👉,👈,🙌,🙏,☝️,👏,💪,🚶,🏃,💃,👫,👪,👬,👭,💏,💑,👯,🙆,🙅,💁,🙋,💆,💇,💅,👰,🙎,🙍,🙇,🎩,👑,👒,👟,👞,👡,👠,👢,👕,👔,👚,👗,🎽,👖,👘,👙,💼,👜,👝,👛,👓,🎀,🌂,💄,💛,💙,💜,💚,❤️,💔,💗,💓,💕,💖,💞,💘,💌,💋,💍,💎,👤,👥,💬,👣,💭",
  "Nature" => "🐶,🐺,🐱,🐭,🐹,🐰,🐸,🐯,🐨,🐻,🐷,🐽,🐮,🐗,🐵,🐒,🐴,🐑,🐘,🐼,🐧,🐦,🐤,🐥,🐣,🐔,🐍,🐢,🐛,🐝,🐜,🐞,🐌,🐙,🐚,🐠,🐟,🐬,🐳,🐋,🐄,🐏,🐀,🐃,🐅,🐇,🐉,🐎,🐐,🐓,🐕,🐖,🐁,🐂,🐲,🐡,🐊,🐫,🐪,🐆,🐈,🐩,🐾,💐,🌸,🌷,🍀,🌹,🌻,🌺,🍁,🍃,🍂,🌿,🌾,🍄,🌵,🌴,🌲,🌳,🌰,🌱,🌼,🌐,🌞,🌝,🌚,🌑,🌒,🌓,🌔,🌕,🌖,🌗,🌘,🌜,🌛,🌙,🌍,🌎,🌏,🌋,🌌,🌠,⭐️,☀️,⛅️,☁️,⚡️,☔️,❄️,⛄️,🌀,🌁,🌈,🌊",
  "Objects" => "🎍,💝,🎎,🎒,🎓,🎏,🎆,🎇,🎐,🎑,🎃,👻,🎅,🎄,🎁,🎋,🎉,🎊,🎈,🎌,🔮,🎥,📷,📹,📼,💿,📀,💽,💾,💻,📱,☎️,📞,📟,📠,📡,📺,📻,🔊,🔉,🔈,🔇,🔔,🔕,📢,📣,⏳,⌛️,⏰,⌚️,🔓,🔒,🔏,🔐,🔑,🔎,💡,🔦,🔆,🔅,🔌,🔋,🔍,🛁,🛀,🚿,🚽,🔧,🔩,🔨,🚪,🚬,💣,🔫,🔪,💊,💉,💰,💴,💵,💷,💶,💳,💸,📲,📧,📥,📤,✉️,📩,📨,📯,📫,📪,📬,📭,📮,📦,📝,📄,📃,📑,📊,📈,📉,📜,📋,📅,📆,📇,📁,📂,✂️,📌,📎,✒️,✏️,📏,📐,📕,📗,📘,📙,📓,📔,📒,📚,📖,🔖,📛,🔬,🔭,📰,🎨,🎬,🎤,🎧,🎼,🎵,🎶,🎹,🎻,🎺,🎷,🎸,👾,🎮,🃏,🎴,🀄️,🎲,🎯,🏈,🏀,⚽️,⚾️,🎾,🎱,🏉,🎳,⛳️,🚵,🚴,🏁,🏇,🏆,🎿,🏂,🏊,🏄,🎣,☕️,🍵,🍶,🍼,🍺,🍻,🍸,🍹,🍷,🍴,🍕,🍔,🍟,🍗,🍖,🍝,🍛,🍤,🍱,🍣,🍥,🍙,🍘,🍚,🍜,🍲,🍢,🍡,🍳,🍞,🍩,🍮,🍦,🍨,🍧,🎂,🍰,🍪,🍫,🍬,🍭,🍯,🍎,🍏,🍊,🍋,🍒,🍇,🍉,🍓,🍑,🍈,🍌,🍐,🍍,🍠,🍆,🍅,🌽",
  "Places" => "🏠,🏡,🏫,🏢,🏣,🏥,🏦,🏪,🏩,🏨,💒,⛪️,🏬,🏤,🌇,🌆,🏯,🏰,⛺️,🏭,🗼,🗾,🗻,🌄,🌅,🌃,🗽,🌉,🎠,🎡,⛲️,🎢,🚢,⛵️,🚤,🚣,⚓️,🚀,✈️,💺,🚁,🚂,🚊,🚉,🚞,🚆,🚄,🚅,🚈,🚇,🚝,🚋,🚃,🚎,🚌,🚍,🚙,🚘,🚗,🚕,🚖,🚛,🚚,🚨,🚓,🚔,🚒,🚑,🚐,🚲,🚡,🚟,🚠,🚜,💈,🚏,🎫,🚦,🚥,⚠️,🚧,🔰,⛽️,🏮,🎰,♨️,🗿,🎪,🎭,📍,🚩,🇯🇵,🇰🇷,🇩🇪,🇨🇳,🇺🇸,🇫🇷,🇪🇸,🇮🇹,🇷🇺,🇬🇧",
  "Symbols" => "1️⃣,2️⃣,3️⃣,4️⃣,5️⃣,6️⃣,7️⃣,8️⃣,9️⃣,0️⃣,🔟,🔢,#️⃣,🔣,⬆️,⬇️,⬅️,➡️,🔠,🔡,🔤,↗️,↖️,↘️,↙️,↔️,↕️,🔄,◀️,▶️,🔼,🔽,↩️,↪️,ℹ️,⏪,⏩,⏫,⏬,⤵️,⤴️,🆗,🔀,🔁,🔂,🆕,🆙,🆒,🆓,🆖,📶,🎦,🈁,🈯️,🈳,🈵,🈴,🈲,🉐,🈹,🈺,🈶,🈚️,🚻,🚹,🚺,🚼,🚾,🚰,🚮,🅿️,♿️,🚭,🈷,🈸,🈂,Ⓜ️,🛂,🛄,🛅,🛃,🉑,㊙️,㊗️,🆑,🆘,🆔,🚫,🔞,📵,🚯,🚱,🚳,🚷,🚸,⛔️,✳️,❇️,❎,✅,✴️,💟,🆚,📳,📴,🅰,🅱,🆎,🅾,💠,➿,♻️,♈️,♉️,♊️,♋️,♌️,♍️,♎️,♏️,♐️,♑️,♒️,♓️,⛎,🔯,🏧,💹,💲,💱,©,®,™,❌,‼️,⁉️,❗️,❓,❕,❔,⭕️,🔝,🔚,🔙,🔛,🔜,🔃,🕛,🕧,🕐,🕜,🕑,🕝,🕒,🕞,🕓,🕟,🕔,🕠,🕕,🕖,🕗,🕘,🕙,🕚,🕡,🕢,🕣,🕤,🕥,🕦,✖️,➕,➖,➗,♠️,♥️,♣️,♦️,💮,💯,✔️,☑️,🔘,🔗,➰,〰,〽️,🔱,◼️,◻️,◾️,◽️,▪️,▫️,🔺,🔲,🔳,⚫️,⚪️,🔴,🔵,🔻,⬜️,⬛️,🔶,🔷,🔸,🔹",
}

emoji_named = JSON.parse(File.read "emoji_grouped.json")



db = SQLite3::Database.new( "/System/Library/Input Methods/CharacterPalette.app/Contents/Resources/CharacterDB.sqlite3" )

emoji_cheats = ''

emoji_grouped.each_key do |group|
  emojis = emoji_grouped[group].split(',')
  puts "#{group} #{emojis.count}"
  
  emoji_entries = ''
  
  emojis.each do |emoji_char|
    
    rows = db.execute("select * from unihan_dict where uchr like ?", emoji_char)
    # rows are of form ["9️⃣", "KEYCAP 9|||||||||||||||"]
    emoji_name = rows.first[1].split("|").first
    
    
    emoji_code = "emoji_info[0]"
    
    char_data = emoji_data.select{|data|data["name"]==emoji_name}.first
    emoji_entries << <<-ENTRY
    entry do
      command ':#{char_data["short_name"]}:'
      name    '<span style="font-size:2em;">#{emoji_char} </span>#{emoji_name}'
      notes   'Unified: `#{char_data["unified"]}`'
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
  
  notes 'Information obtained from:
  
https://bitbucket.org/grumdrig/emoji-list/

https://github.com/arvida/emoji-cheat-sheet.com

https://github.com/iamcal/emoji-data

http://www.unicode.org/~scherer/emoji4unicode/snapshot/emojidata.html'

end
CHEATSHEET

File.open('emoji.rb','w+') { |f| f << cheatfile }

`cheatset generate emoji.rb`
