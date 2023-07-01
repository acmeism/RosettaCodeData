proc verifyIBAN {iban} {
    # Normalize by up-casing and stripping illegal chars (e.g., space)
    set iban [regsub -all {[^A-Z0-9]+} [string toupper $iban] ""]
    # Get the expected length from the country-code part
    switch [string range $iban 0 1] {
	NO { set len 15 }
	BE { set len 16 }
	DK - FI - FO - GL - NL { set len 18}
	MK - SI { set len 19 }
	AT - BA - EE - KZ - LT - LU { set len 20 }
	CH - CR - HR - LI - LV { set len 21 }
	BG - BH - DE - GB - GE - IE - ME - RS { set len 22 }
	AE - GI - IL { set len 23 }
	AD - CZ - ES - MD - PK - RO - SA - SE - SK - TN - VG { set len 24 }
	PT { set len 25 }
	IS - TR { set len 26 }
	FR - GR - IT - MC - MR - SM { set len 27 }
	AL - AZ - CY - DO - GT - HU - LB - PL { set len 28 }
	BR - PS { set len 29 }
	KW - MU { set len 30 }
	MT { set len 31 }
	default {
	    # unsupported country code
	    return false
	}
    }
    # Convert to number
    set num [string map {
	A 10 B 11 C 12 D 13 E 14 F 15 G 16 H 17 I 18 J 19 K 20 L 21 M 22
	N 23 O 24 P 25 Q 26 R 27 S 28 T 29 U 30 V 31 W 32 X 33 Y 34 Z 35
    } [string range $iban 4 end][string range $iban 0 3]]
    # Verify length and modulus
    return [expr {[string length $iban] == $len && $num % 97 == 1}]
}
