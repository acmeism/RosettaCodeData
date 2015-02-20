str = File.open('input.txt', 'rb') {|f| f.read}
File.open('output.txt', 'wb') {|f| f.write str}
