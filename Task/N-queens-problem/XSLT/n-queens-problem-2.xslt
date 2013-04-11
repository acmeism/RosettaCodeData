<!-- 8-queens.xsl disguised as XML file for the browsers -->

<!-- Valery Chernysh's .xsl.xml technique for execution in all browsers -->
<?xml-stylesheet href="#" type="text/xsl"?>

<!-- alternative over specifying input in data:data section -->
<!DOCTYPE xsl:stylesheet [
  <!ENTITY N "8">
]>

<!-- this is the stylesheet being referenced by href="#" above -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  xmlns:n-queens="urn:n-queens"
  exclude-result-prefixes="n-queens exslt"
>
<!-- find David Carlisle's  exslt:node-set() for IE browsers at bottom -->

<!--
     Pattern allowing repeated processing of produced node-set results:
       <xsl:variable name="blah0">...</xsl:variable>
       <xsl:variable name="blah" select="exslt:node-set($blah0)"/>
-->
  <xsl:output omit-xml-declaration="yes"/>


  <!-- entry point -->
  <xsl:template match="/xsl:stylesheet">
    <!-- generate &N;x$&N;board -->
    <xsl:variable name="row0">
      <xsl:call-template name="n-queens:row">
        <xsl:with-param name="n" select="&N;"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="row" select="exslt:node-set($row0)"/>

    <xsl:variable name="rows0">
      <xsl:for-each select="$row/*">
        <r><xsl:copy-of select="$row"/></r>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="rows" select="exslt:node-set($rows0)"/>

<html><pre>
    <!-- determine all solutions of $N queens problem -->
    <xsl:call-template name="n-queens:search">
      <xsl:with-param name="b" select="$rows/*"/>
    </xsl:call-template>
</pre></html>

  </xsl:template>


  <!-- recursive search for all solutions -->
  <xsl:template name="n-queens:search">
    <xsl:param name="b"/>  <!-- remaining rows of not threatened fields -->
    <xsl:param name="s"/>  <!-- partial solution of queens fixated sofar -->

    <!-- complete board filled means solution found -->
    <xsl:if test="not($b)">
      <xsl:value-of select="$s"/><xsl:text>&#10;</xsl:text>
    </xsl:if>

    <!-- check each remaining possible position in next row -->
    <xsl:for-each select="$b[1]/*">

      <!-- sieve out fields by new current (.) queen in current row -->
      <xsl:variable name="sieved0">
        <xsl:call-template name="n-queens:sieve">
          <xsl:with-param name="c" select="."/>
          <xsl:with-param name="b" select="$b[position()>1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="sieved" select="exslt:node-set($sieved0)"/>

      <!-- recursive call -->
      <xsl:call-template name="n-queens:search">
        <xsl:with-param name="b" select="$sieved/*"/>
        <xsl:with-param name="s" select="concat($s, .)"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- sieve out fields in remaining rows attacked by queen at column $c -->
  <xsl:template name="n-queens:sieve">
    <xsl:param name="c"/>  <!-- column of newly fixed queen -->
    <xsl:param name="b"/>  <!-- remaining rows -->

    <xsl:for-each select="$b">
      <!-- row number for diagonal attack determination -->
      <xsl:variable name="r" select="position()"/>

      <!-- copy fields not vertically or diagonally attacked -->
      <r><xsl:copy-of select="*[. != $c][. - $r != $c][. + $r != $c]"/></r>
    </xsl:for-each>
  </xsl:template>

  <!-- generate node-set of the form "<f>1</f><f>2</f>...<f>$n</f>" -->
  <xsl:template name="n-queens:row">
    <xsl:param name="n"/>

    <xsl:if test="$n>0">
      <xsl:call-template name="n-queens:row">
        <xsl:with-param name="n" select="$n - 1"/>
      </xsl:call-template>

      <f><xsl:value-of select="$n"/></f>
    </xsl:if>
  </xsl:template>


<!--
     IE browser exslt:node-set() (XSLT 1.0+), w/o msxsl pollution above

     from http://dpcarlisle.blogspot.com/2007/05/exslt-node-set-function.html
-->
<msxsl:script xmlns:msxsl="urn:schemas-microsoft-com:xslt"
              language="JScript" implements-prefix="exslt"
>
  this['node-set'] = function (x) {
    return x;
  }
</msxsl:script>

</xsl:stylesheet>
