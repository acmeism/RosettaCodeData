use XML::DOM::BagOfTricks qw(createDocument createTextElement);

my ($doc, $root) = createDocument('root');
$root->appendChild(
    createTextElement($doc, 'element', 'Some text here')
);
print $doc->toString;
