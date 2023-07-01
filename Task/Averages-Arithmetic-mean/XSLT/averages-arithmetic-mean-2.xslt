<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text"/>

	<xsl:template match="/">
		<xsl:variable name="values" select="/*/*"/>
		<xsl:value-of select="sum($values) div count($values)"/>
	</xsl:template>
</xsl:stylesheet>
