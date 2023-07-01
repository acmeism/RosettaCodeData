# Read EUC-JP text from file.
str = File.open(path, "r:euc-jp") {|f| f.read}

# Read EUC-JP text from file; transcode text from EUC-JP to UTF-8.
str = File.open(path, "r:euc-jp:utf-8") {|f| f.read}
