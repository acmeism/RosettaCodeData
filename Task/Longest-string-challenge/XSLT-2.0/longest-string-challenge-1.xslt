<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
<xsl:template match="/*">
  <t><xsl:copy-of select="for $l in max( for $s in s return string-length($s))
	  return s[string-length(.) eq $l]" /></t>
</xsl:template>
</xsl:stylesheet>
