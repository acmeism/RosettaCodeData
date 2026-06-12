#!/usr/bin/env python

def textBetween(thisText, startString, endString):
    if startString == "start":
        startIndex = 0
    else:
        try:
            startIndex = thisText.index(startString)
        except ValueError:
            return "Start delimiter not found"

    if startString != "start":
        startIndex += len(startString)

    returnText = thisText[startIndex:]

    if endString == "end":
        return returnText
    else:
        try:
            endIndex = returnText.index(endString)
        except ValueError:
            return returnText

    returnText = returnText[:endIndex]

    return returnText

testStrings = [["Hello Rosetta Code world", "Hello ", " world"],
               ["Hello Rosetta Code world", "start", " world"],
               ["Hello Rosetta Code world", "Hello ", "end"],
               ["Hello Rosetta Code world", "start", "end"],
               ["</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"],
               ["<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"],
               ["<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"],
               ["The quick brown fox jumps over the lazy other fox", "quick ", " fox"],
               ["One fish two fish red fish blue fish", "fish ", " red"],
               ["FooBarBazFooBuxQuux", "Foo", "Foo"]]

for lst in testStrings:
    print(textBetween(*lst))
