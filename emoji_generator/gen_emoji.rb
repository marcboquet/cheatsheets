require 'json'
require 'htmlentities'
require 'sqlite3'
require 'unicode_utils'

emoji_data = JSON.parse(File.read "emoji.json")

# From /System/Library/Input Methods/CharacterPalette.app/Contents/Resources/Category-Emoji.plist
emoji_grouped = {
  "People" => "😄,😃,😀,😊,☺️,😉,😍,😘,😚,😗,😙,😜,😝,😛,😳,😁,😔,😌,😒,😞,😣,😢,😂,😭,😪,😥,😰,😅,😓,😩,😫,😨,😱,😠,😡,😤,😖,😆,😋,😷,😎,😴,😵,😲,😟,😦,😧,😈,👿,😮,😬,😐,😕,😯,😶,😇,😏,😑,👲,👳,👮,👷,💂,👶,👦,👧,👨,👩,👴,👵,👱,👼,👸,😺,😸,😻,😽,😼,🙀,😿,😹,😾,👹,👺,🙈,🙉,🙊,💀,👽,💩,🔥,✨,🌟,💫,💥,💢,💦,💧,💤,💨,👂,👀,👃,👅,👄,👍,👎,👌,👊,✊,✌️,👋,✋,👐,👆,👇,👉,👈,🙌,🙏,☝️,👏,💪,🚶,🏃,💃,👫,👪,👬,👭,💏,💑,👯,🙆,🙅,💁,🙋,💆,💇,💅,👰,🙎,🙍,🙇,🎩,👑,👒,👟,👞,👡,👠,👢,👕,👔,👚,👗,🎽,👖,👘,👙,💼,👜,👝,👛,👓,🎀,🌂,💄,💛,💙,💜,💚,❤️,💔,💗,💓,💕,💖,💞,💘,💌,💋,💍,💎,👤,👥,💬,👣,💭",
  "Nature" => "🐶,🐺,🐱,🐭,🐹,🐰,🐸,🐯,🐨,🐻,🐷,🐽,🐮,🐗,🐵,🐒,🐴,🐑,🐘,🐼,🐧,🐦,🐤,🐥,🐣,🐔,🐍,🐢,🐛,🐝,🐜,🐞,🐌,🐙,🐚,🐠,🐟,🐬,🐳,🐋,🐄,🐏,🐀,🐃,🐅,🐇,🐉,🐎,🐐,🐓,🐕,🐖,🐁,🐂,🐲,🐡,🐊,🐫,🐪,🐆,🐈,🐩,🐾,💐,🌸,🌷,🍀,🌹,🌻,🌺,🍁,🍃,🍂,🌿,🌾,🍄,🌵,🌴,🌲,🌳,🌰,🌱,🌼,🌐,🌞,🌝,🌚,🌑,🌒,🌓,🌔,🌕,🌖,🌗,🌘,🌜,🌛,🌙,🌍,🌎,🌏,🌋,🌌,🌠,⭐️,☀️,⛅️,☁️,⚡️,☔️,❄️,⛄️,🌀,🌁,🌈,🌊",
  "Objects" => "🎍,💝,🎎,🎒,🎓,🎏,🎆,🎇,🎐,🎑,🎃,👻,🎅,🎄,🎁,🎋,🎉,🎊,🎈,🎌,🔮,🎥,📷,📹,📼,💿,📀,💽,💾,💻,📱,☎️,📞,📟,📠,📡,📺,📻,🔊,🔉,🔈,🔇,🔔,🔕,📢,📣,⏳,⌛️,⏰,⌚️,🔓,🔒,🔏,🔐,🔑,🔎,💡,🔦,🔆,🔅,🔌,🔋,🔍,🛁,🛀,🚿,🚽,🔧,🔩,🔨,🚪,🚬,💣,🔫,🔪,💊,💉,💰,💴,💵,💷,💶,💳,💸,📲,📧,📥,📤,✉️,📩,📨,📯,📫,📪,📬,📭,📮,📦,📝,📄,📃,📑,📊,📈,📉,📜,📋,📅,📆,📇,📁,📂,✂️,📌,📎,✒️,✏️,📏,📐,📕,📗,📘,📙,📓,📔,📒,📚,📖,🔖,📛,🔬,🔭,📰,🎨,🎬,🎤,🎧,🎼,🎵,🎶,🎹,🎻,🎺,🎷,🎸,👾,🎮,🃏,🎴,🀄️,🎲,🎯,🏈,🏀,⚽️,⚾️,🎾,🎱,🏉,🎳,⛳️,🚵,🚴,🏁,🏇,🏆,🎿,🏂,🏊,🏄,🎣,☕️,🍵,🍶,🍼,🍺,🍻,🍸,🍹,🍷,🍴,🍕,🍔,🍟,🍗,🍖,🍝,🍛,🍤,🍱,🍣,🍥,🍙,🍘,🍚,🍜,🍲,🍢,🍡,🍳,🍞,🍩,🍮,🍦,🍨,🍧,🎂,🍰,🍪,🍫,🍬,🍭,🍯,🍎,🍏,🍊,🍋,🍒,🍇,🍉,🍓,🍑,🍈,🍌,🍐,🍍,🍠,🍆,🍅,🌽",
  "Places" => "🏠,🏡,🏫,🏢,🏣,🏥,🏦,🏪,🏩,🏨,💒,⛪️,🏬,🏤,🌇,🌆,🏯,🏰,⛺️,🏭,🗼,🗾,🗻,🌄,🌅,🌃,🗽,🌉,🎠,🎡,⛲️,🎢,🚢,⛵️,🚤,🚣,⚓️,🚀,✈️,💺,🚁,🚂,🚊,🚉,🚞,🚆,🚄,🚅,🚈,🚇,🚝,🚋,🚃,🚎,🚌,🚍,🚙,🚘,🚗,🚕,🚖,🚛,🚚,🚨,🚓,🚔,🚒,🚑,🚐,🚲,🚡,🚟,🚠,🚜,💈,🚏,🎫,🚦,🚥,⚠️,🚧,🔰,⛽️,🏮,🎰,♨️,🗿,🎪,🎭,📍,🚩,🇯🇵,🇰🇷,🇩🇪,🇨🇳,🇺🇸,🇫🇷,🇪🇸,🇮🇹,🇷🇺,🇬🇧",
  "Symbols" => "0️⃣,1️⃣,2️⃣,3️⃣,4️⃣,5️⃣,6️⃣,7️⃣,8️⃣,9️⃣,🔟,🔢,#️⃣,🔣,⬆️,⬇️,⬅️,➡️,🔠,🔡,🔤,↗️,↖️,↘️,↙️,↔️,↕️,🔄,◀️,▶️,🔼,🔽,↩️,↪️,ℹ️,⏪,⏩,⏫,⏬,⤵️,⤴️,🆗,🔀,🔁,🔂,🆕,🆙,🆒,🆓,🆖,📶,🎦,🈁,🈯️,🈳,🈵,🈴,🈲,🉐,🈹,🈺,🈶,🈚️,🚻,🚹,🚺,🚼,🚾,🚰,🚮,🅿️,♿️,🚭,🈷,🈸,🈂,Ⓜ️,🛂,🛄,🛅,🛃,🉑,㊙️,㊗️,🆑,🆘,🆔,🚫,🔞,📵,🚯,🚱,🚳,🚷,🚸,⛔️,✳️,❇️,❎,✅,✴️,💟,🆚,📳,📴,🅰,🅱,🆎,🅾,💠,➿,♻️,♈️,♉️,♊️,♋️,♌️,♍️,♎️,♏️,♐️,♑️,♒️,♓️,⛎,🔯,🏧,💹,💲,💱,©,®,™,❌,‼️,⁉️,❗️,❓,❕,❔,⭕️,🔝,🔚,🔙,🔛,🔜,🔃,🕛,🕧,🕐,🕜,🕑,🕝,🕒,🕞,🕓,🕟,🕔,🕠,🕕,🕖,🕗,🕘,🕙,🕚,🕡,🕢,🕣,🕤,🕥,🕦,✖️,➕,➖,➗,♠️,♥️,♣️,♦️,💮,💯,✔️,☑️,🔘,🔗,➰,〰,〽️,🔱,◼️,◻️,◾️,◽️,▪️,▫️,🔺,🔲,🔳,⚫️,⚪️,🔴,🔵,🔻,⬜️,⬛️,🔶,🔷,🔸,🔹",
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
    
    char_data = emoji_data.select{|data|data["name"]==emoji_name}.first
    

    emoji_name.capitalize!
    
    ## fix some edge cases
    emoji_char = "\\#️⃣"if emoji_char == "#️⃣"
    emoji_name.gsub!(/^(.* letter)( \w{1,2})$/) { "#{$1}#{$2.to_s.upcase}" }
    emoji_name.gsub!(/^(Squared )(\w{1,3})( .*)?$/) { "#{$1}#{$2.to_s.upcase}#{$3}" }
    emoji_name.gsub!(/^(Squared CJK unified ideograph-)(\w+)$/) { "#{$1}#{$2.to_s.upcase}" }
    emoji_name.gsub!(/^(Regional indicator symbol letters )(\w{2})$/) { "#{$1}#{$2.to_s.upcase}" }
    emoji_name.gsub!(/^(Negative squared)(.*)( \w{1,2})$/) { "#{$1}#{$2}#{$3.to_s.upcase}" }
    ##
    
    
    emoji_entries << <<-ENTRY
    entry do
      command ':#{char_data["short_name"]}:'
      name    '#{emoji_char} #{emoji_name}'
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
  
  #{emoji_cheats}
  
  notes 'Information obtained from:
  
* https://bitbucket.org/grumdrig/emoji-list/
* https://github.com/arvida/emoji-cheat-sheet.com
* https://github.com/iamcal/emoji-data
* http://www.unicode.org/~scherer/emoji4unicode/snapshot/emojidata.html'

end
CHEATSHEET

File.open('emoji.rb','w+') { |f| f << cheatfile }

`cheatset generate emoji.rb`
