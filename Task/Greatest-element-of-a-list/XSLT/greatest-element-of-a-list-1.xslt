<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text"/>

	<xsl:template match="/">
		<xsl:for-each select="/*/*">
			<!-- without data-type="number", items are sorted alphabetically -->
			<xsl:sort data-type="number" order="descending"/>
			<xsl:if test="position() = 1">
				<xsl:value-of select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
