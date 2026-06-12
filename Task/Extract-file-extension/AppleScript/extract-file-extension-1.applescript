on getFileNameExtension from txt given underscores:keepingUnderscores : true, dot:includingDot : false
    set astid to AppleScript's text item delimiters
    -- Extract the file or bundle name from the path.
    set AppleScript's text item delimiters to "/"
    if (txt ends with "/") then
        set itemName to text item -2 of txt
    else
        set itemName to text item -1 of txt
    end if
    -- Extract the extension.
    if (itemName contains ".") then
        set AppleScript's text item delimiters to "."
        set extn to text item -1 of itemName
        if ((not keepingUnderscores) and (extn contains "_")) then set extn to ""
        if ((includingDot) and (extn > "")) then set extn to "." & extn
    else
        set extn to ""
    end if
    set AppleScript's text item delimiters to astid

    return extn
end getFileNameExtension

set output to {}
repeat with thisString in {"http://example.com/download.tar.gz", "CharacterModel.3DS", ".desktop", "document", "document.txt_backup", "/etc/pam.d/login"}
    set end of output to {thisString's contents, getFileNameExtension from thisString with dot without underscores}
end repeat

return output
