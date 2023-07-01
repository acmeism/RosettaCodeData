use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

-- Derive an NSDecimalNumber from an AppleScript number or numeric text.
-- NSDecimalNumbers also allow arithmetic and have a far greater range than AS numbers.
on decimalNumberFrom(n)
    return current application's class "NSDecimalNumber"'s decimalNumberWithString:(n as text)
end decimalNumberFrom

-- Multiply two NSDecimalNumbers.
on multiply(dn1, dn2)
    return dn1's decimalNumberByMultiplyingBy:(dn2)
end multiply

-- Add two NSDecimalNumbers.
on add(dn1, dn2)
    return dn1's decimalNumberByAdding:(dn2)
end add

on billTotal(quantitiesAndPrices, taxRate, currencySymbol)
    -- Set up an NSNumberFormatter for converting between currency strings and NSDecimalNumbers.
    set currencyFormatter to current application's class "NSNumberFormatter"'s new()
    tell currencyFormatter to setNumberStyle:(current application's NSNumberFormatterCurrencyStyle)
    tell currencyFormatter to setCurrencySymbol:(currencySymbol)
    tell currencyFormatter to setGeneratesDecimalNumbers:(true)

    -- Tot up the bill from the list of quantities (numbers or numeric strings) and unit prices (currency strings with symbols).
    set subtotal to decimalNumberFrom(0) -- or:  current application's class "NSDecimalNumber"'s zero()
    repeat with thisEntry in quantitiesAndPrices
        set {quantity:quantity, unitPrice:unitPrice} to thisEntry
        set entryTotal to multiply(decimalNumberFrom(quantity), currencyFormatter's numberFromString:(unitPrice))
        set subtotal to add(subtotal, entryTotal)
    end repeat
    -- Work out the tax and add it to the subtotal.
    set tax to multiply(subtotal, decimalNumberFrom(taxRate / 100))
    set total to add(subtotal, tax)

    -- Format and return the results.
    return (current application's class "NSString"'s stringWithFormat_("Subtotal:  %@
Tax:  %@
Total:  %@", ¬
        currencyFormatter's stringFromNumber:(subtotal), ¬
        currencyFormatter's stringFromNumber:(tax), ¬
        currencyFormatter's stringFromNumber:(total))) ¬
        as text
end billTotal

-- Demo code:
set currencySymbol to "$"
set quantitiesAndPrices to {{quantity:"4000000000000000", unitPrice:currencySymbol & "5.50"}, ¬
    {quantity:2, unitPrice:currencySymbol & 2.86}}
set taxRate to 7.65
return billTotal(quantitiesAndPrices, taxRate, currencySymbol)
