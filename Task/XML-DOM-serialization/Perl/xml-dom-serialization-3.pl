use XML::LibXML;

$xml = XML::LibXML::Document->new('1.0');
$node = $xml->createElement('root');
$xml->setDocumentElement($node);
$node2 = $xml->createElement('element');
$text = $xml->createTextNode('Some text here');
$node2->addChild($text);
$node->appendWellBalancedChunk('text');
$node->addChild($node2);

print $xml->toString;
