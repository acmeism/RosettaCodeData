import Data.Char (toUpper)
import Data.Maybe (fromJust)

validateIBAN :: String -> Either String String
validateIBAN [] = Left "No IBAN number."
validateIBAN xs =
    case lookupCountry of
        Nothing -> invalidBecause "Country does not exist."
        Just l  -> if length normalized /= l
                        then invalidBecause "Number length does not match."
                        else check
    where
        -- remove blanks and make all letters uppercase
        normalized = map toUpper $ concat $ words xs
        -- get the country code
        country = take 2 normalized
        -- search number length
        lookupCountry = lookup country countries
        countries :: [(String, Int)]
        countries = zip (words "AL AT BE BA BG HR CZ DO FO FR DE GR GT \
            \IS IL KZ LV LI LU MT MU MD NL PK PL RO SA SK ES CH TR GB \
            \AD AZ BH BR CR CY DK EE FI GE GI GL HU IE IT KW LB LT MK \
            \MR MC ME NO PS PT SM RS SI SE TN AE VG")
            [28,20,16,20,22,21,24,28,18,27,22,27,28,26,23,20,21,21,20,
            31,30,24,18,24,28,24,24,24,24,21,26,22,24,28,22,29,21,28,18,
            20,18,22,23,18,28,22,27,30,28,20,19,27,27,22,15,29,25,27,22,
            19,24,24,23,24]
        digits = ['0'..'9']
        letters = ['A'..'Z']
        -- letters to be replaced
        replDigits = zip letters $ map show [10..35]
        -- digits and letters allowed in the IBAN number
        validDigits = digits ++ letters
        -- see if all digits and letters in the IBAN number are allowed
        sane = all (`elem` validDigits) normalized
        -- take the first 4 digits from the number and put them at its end
        (p1, p2) = splitAt 4 normalized
        p3 = p2 ++ p1
        -- convert the letters to numbers and
        -- convert the result to an integer
        p4 :: Integer
        p4 = read $ concat $ map convertLetter p3
        convertLetter x | x `elem` digits = [x]
                        | otherwise       = fromJust $ lookup x replDigits
        -- see if the number is valid
        check = if sane
                    then if p4 `mod` 97 == 1
                            then Right xs
                            else invalidBecause "Validation failed."
                    else invalidBecause "Number contains illegal digits."

        invalidBecause reason = Left $ "Invalid IBAN number " ++ xs ++
            ": " ++ reason
