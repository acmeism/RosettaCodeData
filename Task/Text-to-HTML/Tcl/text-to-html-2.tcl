set sample "
This is an example of how a pseudo-markdown-ish formatting scheme could
work. It's really much simpler than markdown, but does support a few things.

# Block paragraph types

* This is a bulleted list

* And this is the second item in it

1. Here's a numbered list

2. Second item

3. Third item

# Inline formatting types

The formatter can render text with _italics_, *bold* and in a `typewriter`
font. It also does the right thing with <angle brackets> and &amp;ersands,
but relies on the encoding of the characters to be conveyed separately."

puts [markupText "Sample" $sample]
