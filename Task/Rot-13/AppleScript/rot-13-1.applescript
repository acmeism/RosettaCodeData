to rot13(textString)
    do shell script "tr a-zA-Z n-za-mN-ZA-M <<<" & quoted form of textString
end rot13
