local testStr = "one^|uno||three^^^^|four^^^|^cuatro|"
for k, v in ipairs(Tokenize(testStr, "|", "^")) do
    print(k, v)
end
