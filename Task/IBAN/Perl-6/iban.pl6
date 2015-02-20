subset IBAN of Str where sub ($_ is copy) {
    s:g/\s//;
    return False if m/<-[ 0..9 A..Z a..z ]>/ or .chars != <
        AD 24 AE 23 AL 28 AT 20 AZ 28 BA 20 BE 16 BG 22 BH 22 BR 29 CH 21
        CR 21 CY 28 CZ 24 DE 22 DK 18 DO 28 EE 20 ES 24 FI 18 FO 18 FR 27
        GB 22 GE 22 GI 23 GL 18 GR 27 GT 28 HR 21 HU 28 IE 22 IL 23 IS 26
        IT 27 KW 30 KZ 20 LB 28 LI 21 LT 20 LU 20 LV 21 MC 27 MD 24 ME 22
        MK 19 MR 27 MT 31 MU 30 NL 18 NO 15 PK 24 PL 28 PS 29 PT 25 RO 24
        RS 22 SA 24 SE 24 SI 19 SK 24 SM 27 TN 24 TR 26 VG 24
    >.hash{.substr(0,2).uc};

    s/(.**4)(.+)/$1$0/;
    return .subst(:g, /\D/, { :36(~$_) }) % 97 == 1;
}

say "$_ is {$_ ~~ IBAN ?? 'valid' !! 'invalid' }" for
'GB82 WEST 1234 5698 7654 32',
'gb82 west 1234 5698 7654 32',
'GB82 TEST 1234 5698 7654 32';
