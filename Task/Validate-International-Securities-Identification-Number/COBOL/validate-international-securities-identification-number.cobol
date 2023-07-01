        >>SOURCE FORMAT FREE
*>   this is gnucobol 2.0
identification division.
program-id. callISINtest.
data division.
working-storage section.
01  ISINtest-result binary-int.
procedure division.
start-callISINtest.
    display 'should be valid ' with no advancing
    call 'ISINtest' using 'US0378331005' ISINtest-result
    perform display-ISINtest-result
    display 'should not be valid ' with no advancing
    call 'ISINtest' using 'US0373831005' ISINtest-result
    perform display-ISINtest-result
    display 'should not be valid ' with no advancing
    call 'ISINtest' using 'U50378331005' ISINtest-result
    perform display-ISINtest-result
    display 'should not be valid ' with no advancing
    call 'ISINtest' using 'US03378331005' ISINtest-result
    perform display-ISINtest-result
    display 'should be valid ' with no advancing
    call 'ISINtest' using 'AU0000XVGZA3' ISINtest-result
    perform display-ISINtest-result
    display 'should be valid ' with no advancing
    call 'ISINtest' using 'AU0000VXGZA3' ISINtest-result
    perform display-ISINtest-result
    display 'should be valid ' with no advancing
    call 'ISINtest' using 'FR0000988040' ISINtest-result
    perform display-ISINtest-result
    stop run
    .
display-ISINtest-result.
    evaluate ISINtest-result
    when 0
        display ' is valid'
    when -1
        display ' invalid length '
    when -2
        display ' invalid countrycode '
    when -3
        display ' invalid base36 digit '
    when -4
        display ' luhn test failed'
    when other
        display ' invalid return code ' ISINtest-result
    end-evaluate
    .
end program callISINtest.

identification division.
program-id. ISINtest.
data division.
working-storage section.
01  country-code-values value
    'ADAEAFAGAIALAMAOAQARASATAUAWAXAZBABBBDBEBFBGBHBIBJBLBMBNBOBQBRBS'
&   'BTBVBWBYBZCACCCDCFCGCHCICKCLCMCNCOCRCUCVCWCXCYCZDEDJDKDMDODZECEE'
&   'EGEHERESETFIFJFKFMFOFRGAGBGDGEGFGGGHGIGLGMGNGPGQGRGSGTGUGWGYHKHM'
&   'HNHRHTHUIDIEILIMINIOIQIRISITJEJMJOJPKEKGKHKIKMKNKPKRKWKYKZLALBLC'
&   'LILKLRLSLTLULVLYMAMCMDMEMFMGMHMKMLMMMNMOMPMQMRMSMTMUMVMWMXMYMZNA'
&   'NCNENFNGNINLNONPNRNUNZOMPAPEPFPGPHPKPLPMPNPRPSPTPWPYQARERORSRURW'
&   'SASBSCSDSESGSHSISJSKSLSMSNSOSRSSSTSVSXSYSZTCTDTFTGTHTJTKTLTMTNTO'
&   'TRTTTVTWTZUAUGUMUSUYUZVAVCVEVGVIVNVUWFWSYEYTZAZMZW'.
    03  country-codes occurs 249
        ascending key country-code
        indexed by cc-idx.
        05  country-code pic xx.

01  b pic 99.
01  base36-digits pic x(36) value
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.

01  i pic 99.
01  p pic 99.
01  luhn-number pic x(20).
01  luhntest-result binary-int.

linkage section.
01  test-number any length.
01  ISINtest-result binary-int.

procedure division using test-number ISINtest-result.
start-ISINtest.
    display space test-number with no advancing

    *> format test
    if function length(test-number) <> 12
        move -1 to ISINtest-result
        goback
    end-if

    *> countrycode test
    search all country-codes
    at end
        move -2 to ISINtest-result
        goback
    when test-number(1:2) = country-code(cc-idx)
        continue
    end-search

    *> convert each character from base 36 to base 10
    *> and add to the luhn-number
    move 0 to p
    perform varying i from 1 by 1 until i > 12
        if test-number(i:1) >= '0' and <= '9'
            move test-number(i:1) to luhn-number(p + 1:1)
            add 1 to p
        else
            perform varying b from 9 by 1 until b > 35
            or base36-digits(b + 1:1) = test-number(i:1)
                continue
            end-perform
            if b > 35
                 move -3 to ISINtest-result
                 goback
            end-if
            move b to luhn-number(p + 1:2)
            add 2 to p
        end-if
    end-perform

    call 'luhntest' using luhn-number(1:p) luhntest-result
    if luhntest-result <> 0
        move -4 to ISINtest-result
        goback
    end-if

    move 0 to ISINtest-result
    goback
    .
end program ISINtest.

identification division.
program-id. luhntest.
data division.
working-storage section.
01  i pic S99.
01  check-sum pic 999.
linkage section.
01  test-number any length.
01  luhntest-result binary-int.
procedure division using test-number luhntest-result.
start-luhntest.
    display space test-number with no advancing
    move 0 to check-sum

    *> right to left sum the odd numbered digits
    compute i = function length(test-number)
    perform varying i from i by -2 until i < 1
        add function numval(test-number(i:1)) to check-sum
    end-perform
    display space check-sum with no advancing

    *> right to left double sum the even numbered digits
    compute i = function length(test-number) - 1
    perform varying i from i by -2 until i < 1
        add function numval(test-number(i:1)) to check-sum
        add function numval(test-number(i:1)) to check-sum
        *> convert a two-digit double sum number to a single digit
        if test-number(i:1) >= '5'
            subtract 9 from check-sum
        end-if
    end-perform
    display space check-sum with no advancing

    if function mod(check-sum,10) = 0
        move 0 to luhntest-result *> success
    else
        move -1 to luhntest-result *> failure
    end-if
    goback
    .
end program luhntest.
