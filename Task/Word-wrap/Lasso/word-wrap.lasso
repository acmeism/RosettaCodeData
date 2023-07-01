define wordwrap(
    text::string,
    row_length::integer = 75
) => {
    return regexp(`(?is)(.{1,` + #row_length + `})(?:$|\W)+`, '$1<br />\n', #text, true) -> replaceall
}

local(text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris consequat ornare lectus, dignissim iaculis libero consequat sed. Proin quis magna in arcu sagittis consequat sed ac risus. Ut a pharetra dui. Phasellus molestie, mauris eget scelerisque laoreet, diam dolor vulputate nulla, in porta sem sem sit amet lacus.')

wordwrap(#text, 40)
'<hr />'
wordwrap(#text)
'<hr />'
wordwrap(#text, 90)
