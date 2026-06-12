# syntax: GAWK -f ASCII_CONTROL_CHARACTERS.AWK
BEGIN {
    PROCINFO["sorted_in"] = "@val_str_asc"
    ascii_control_characters()
    print("VALUE CODE MEANING")
    for (c in arr) { printf("X'%2s' %-3s %s\n",substr(arr[c],1,2),c,substr(arr[c],3)) }
    print("")
    main("CR")
    main("DEL")
    main("NG")
    exit(errors == 0 ? 0 : 1)
}
function main(c) {
    if (c in arr) {
      printf("X'%2s' %-3s %s\n",substr(arr[c],1,2),c,substr(arr[c],3))
    }
    else {
      error(sprintf("%s is not an ASCII control",c))
    }
}
function ascii_control_characters() {
    arr["NUL"] = "00 Null"
    arr["SOH"] = "01 Start of Heading"
    arr["STX"] = "02 Start of Text"
    arr["ETX"] = "03 End of Text"
    arr["EOT"] = "04 End of Transmission"
    arr["ENQ"] = "05 Enquiry"
    arr["ACK"] = "06 Acknowledge"
    arr["BEL"] = "07 Bell"
    arr["BS" ] = "08 BackSpace"
    arr["HT" ] = "09 Horizontal Tabulation"
    arr["LF" ] = "0A Line Feed"
    arr["VT" ] = "0B Vertical Tabulation"
    arr["FF" ] = "0C Form Feed"
    arr["CR" ] = "0D Carriage Return"
    arr["SO" ] = "0E Shift Out"
    arr["SI" ] = "0F Shift In"
    arr["DLE"] = "10 Data Link Escape"
    arr["DC1"] = "11 Device Control 1 (XON)"
    arr["DC2"] = "12 Device Control 2"
    arr["DC3"] = "13 Device Control 3 (XOFF)"
    arr["DC4"] = "14 Device Control 4"
    arr["NAK"] = "15 Negative Acknowledge"
    arr["SYN"] = "16 Synchronous Idle"
    arr["ETB"] = "17 End of Transmission Block"
    arr["CAN"] = "18 Cancel"
    arr["EM" ] = "19 End of Medium"
    arr["SUB"] = "1A Substitute"
    arr["ESC"] = "1B Escape"
    arr["FS" ] = "1C File Separator"
    arr["GS" ] = "1D Group Separator"
    arr["RS" ] = "1E Record Separator"
    arr["US" ] = "1F Unit Separator"
    arr["SP" ] = "20 Space"
    arr["DEL"] = "7F Delete"
}
function error(message) { printf("error: %s\n",message) ; errors++ }
