use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

set aVariable to current application's class "NSMutableString"'s stringWithString:("world!")
tell aVariable to insertString:("Hello ") atIndex:(0)
return aVariable as text
