use AppleScript version "2.4" -- Mac OS X 10.10 (Yosemite) or later.
use framework "Foundation"

on getFileNameExtension from txt given underscores:keepingUnderscores : true, dot:includingDot : false
    -- Get an NSString version of the text and extract the 'pathExtension' from that as AppleScript text.
    set txt to current application's class "NSString"'s stringWithString:(txt)
    set extn to txt's pathExtension() as text
    if ((not keepingUnderscores) and (extn contains "_")) then set extn to ""
    if ((includingDot) and (extn > "")) then set extn to "." & extn

    return extn
end getFileNameExtension

set output to {}
repeat with thisString in {"http://example.com/download.tar.gz", "CharacterModel.3DS", ".desktop", "document", "document.txt_backup", "/etc/pam.d/login"}
    set end of output to {thisString's contents, getFileNameExtension from thisString with dot without underscores}
end repeat

return output
