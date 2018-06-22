@load "ordchr"

function invalid()  { print("INVALID " $0); next }
function valid()    { print("VALID__ " $0) }

BEGIN {
    ccibanlen["AL"] = 28; ccibanlen["AD"] = 24; ccibanlen["AT"] = 20;
    ccibanlen["AZ"] = 28; ccibanlen["BH"] = 22; ccibanlen["BA"] = 20;
    ccibanlen["BR"] = 29; ccibanlen["BG"] = 22; ccibanlen["CR"] = 21;
    ccibanlen["HR"] = 21; ccibanlen["CY"] = 28; ccibanlen["CZ"] = 24;
    ccibanlen["DK"] = 18; ccibanlen["DO"] = 28; ccibanlen["EE"] = 20;
    ccibanlen["FO"] = 18; ccibanlen["FI"] = 18; ccibanlen["FR"] = 27;
    ccibanlen["GE"] = 22; ccibanlen["DE"] = 22; ccibanlen["GI"] = 23;
    ccibanlen["GR"] = 27; ccibanlen["GL"] = 18; ccibanlen["GT"] = 28;
    ccibanlen["HU"] = 28; ccibanlen["IS"] = 26; ccibanlen["IE"] = 22;
    ccibanlen["IT"] = 27; ccibanlen["KZ"] = 20; ccibanlen["KW"] = 30;
    ccibanlen["LV"] = 21; ccibanlen["LB"] = 28; ccibanlen["LI"] = 21;
    ccibanlen["LT"] = 20; ccibanlen["LU"] = 20; ccibanlen["MK"] = 19;
    ccibanlen["MT"] = 31; ccibanlen["MR"] = 27; ccibanlen["MU"] = 30;
    ccibanlen["MC"] = 27; ccibanlen["MD"] = 24; ccibanlen["ME"] = 22;
    ccibanlen["NL"] = 18; ccibanlen["NO"] = 15; ccibanlen["PK"] = 24;
    ccibanlen["PS"] = 29; ccibanlen["PL"] = 28; ccibanlen["PT"] = 25;
    ccibanlen["RO"] = 24; ccibanlen["SM"] = 27; ccibanlen["SA"] = 24;
    ccibanlen["RS"] = 22; ccibanlen["SK"] = 24; ccibanlen["SI"] = 19;
    ccibanlen["ES"] = 24; ccibanlen["SE"] = 24; ccibanlen["CH"] = 21;
    ccibanlen["TN"] = 24; ccibanlen["TR"] = 26; ccibanlen["AE"] = 23;
    ccibanlen["GB"] = 22; ccibanlen["VG"] = 24; ccibanlen["BE"] = 16;
}

{
    iban = toupper($0)
    gsub(/\s+/, "", iban)
    ccode = substr(iban, 1, 2)

    if (    ! match(iban, /^[A-Z0-9]+$/) ||
            ! (ccode in ccibanlen) ||
            length(iban) != ccibanlen[ccode])
        invalid()

    ibanrev = gensub(/^(.{4})(.+)/, "\\2\\1", 1, iban)
    ibancsum = ""
    for (i = 1; i <= length(ibanrev); i++) {
        currchar = substr(ibanrev, i, 1)
        if (match(currchar, /[A-Z]/))
            currchar = ord(currchar) - 55
        ibancsum = ibancsum currchar
    }

    ibancsum % 97 == 1 ? valid() : invalid()
}
