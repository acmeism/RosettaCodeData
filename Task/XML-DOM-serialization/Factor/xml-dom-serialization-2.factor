USING: sequences xml.syntax xml.writer ;

3 [XML <element>Some text here</element> XML] <repetition>
[XML <element2><element3>1.0</element3></element2> XML] append
<XML <root><-></root> XML>
pprint-xml
