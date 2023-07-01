def XML:
  def String    : ((consume("\"") | parse("[^\"]*") | consume("\"")) //
                   (consume("'") | parse("[^']*") | consume("'")));

  def CDataSec  : box("@CDATA";   q("<![CDATA[") | string_except("]]>") | q("]]>") ) | ws;
  def PROLOG    : box("@PROLOG";  q("<?xml") | string_except("\\?>") | q("?>"));
  def DTD       : box("@DTD";     q("<!") | parse("[^>]") | q(">"));
  # The XML spec specifically disallows double-hyphen within comments
  def COMMENT   : box("@COMMENT"; q("<!--") | string_except("--") | q("-->"));

  def CharData  : parse("[^<]+");  # only `<` is disallowed

  # This is more permissive than required:
  def Name      : parse("[A-Za-z:_][^/=<>\n\r\t ]*");

  def Attribute : keyvalue(Name | ws | q("=") | ws | String | ws);
  def Attributes: box( plus(Attribute) ) | .result[-1] |= {"@attributes": add} ;

  # <foo> must be matched with </foo>
  def Element   :
    def Content : star(Element // CDataSec // CharData // COMMENT);
    objectify( q("<")
         | Name
         | .result[-1] as $name
	 | ws
         | (Attributes // ws)
         | (  (q("/>")
	   // (q(">") | Content | q("</") | q($name) | ws | q(">")))
         | ws) ) ;

  {remainder: . }
  | ws
  | optional(PROLOG) | ws
  | optional(DTD) | ws
  | star(COMMENT | ws)
  | Element | ws             # for HTML, one would use star(Element) here
  | star(COMMENT | ws)
  | .result;
