libxml_use_internal_errors(true);

$xml = new DOMDocument();
$xml->load('shiporder.xml');

if (!$xml->schemaValidate('shiporder.xsd')) {
    var_dump(libxml_get_errors()); exit;
} else {
    echo 'success';
}
