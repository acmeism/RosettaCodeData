XML.ignoreProcessingInstructions = false;
var xml = <?xml version="1.0"?>
<root>
  <element>Some text here</element>
</root>;
var xmlString = xml.toXMLString();
