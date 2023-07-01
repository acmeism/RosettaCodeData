var subject = "Hello world!";

// Two different ways to create the RegExp object
// Both examples use the exact same pattern... matching "hello "
var re_PatternToMatch = /Hello (World)/i; // creates a RegExp literal with case-insensitivity
var re_PatternToMatch2 = new RegExp("Hello (World)", "i");

// Test for a match - return a bool
var isMatch = re_PatternToMatch.test(subject);

// Get the match details
//    Returns an array with the match's details
//    matches[0] == "Hello world"
//    matches[1] == "world"
var matches = re_PatternToMatch2.exec(subject);
