let $json := '
{
  "Astring" : "string-value",
  "Anumber" : 5.7,
  "Anull"   : null,
  "Aarray"  : ["One","Two", 3],
  "Aobject" : {
               "key1": "value1",
               "key2": "value2"
             },
  "Atrue"   : true,
  "Afalse"  : false
}
'
let $xml := json-to-xml($local:json)
return (
 "XPath fn:json-to-xml#1 function:"
 ,""
 ,$xml
 ,""
 ,"Round trip, using fn:xml-to-json#1:"
 ,""
 ,xml-to-json($xml)
 ,""
 ,"Using BaseX json:parse#2 function to create an XPath 3.1 map:"
 ,""
 ,json:parse($local:json, map{"format":"xquery"})
)
