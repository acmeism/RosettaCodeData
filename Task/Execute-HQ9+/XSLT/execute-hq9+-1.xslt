<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- bottles.xsl defines $entire-bottles-song -->
	<xsl:import href="bottles.xsl"/>

	<xsl:output method="text" encoding="utf-8"/>

	<xsl:variable name="hello-world">
		<xsl:text>Hello, world!&#10;</xsl:text>
	</xsl:variable>

	<!-- Main template -->
	<xsl:template match="/">
		<xsl:call-template name="run">
			<xsl:with-param name="code" select="string(.)"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Runs HQ9+ code from string starting at given index (default 1) -->
	<xsl:template name="run">
		<xsl:param name="code"/>
		<xsl:param name="starting-at" select="1"/>

		<!-- Fetches instruction and forces to upper-case -->
		<xsl:variable name="inst" select="translate(substring($code, $starting-at, 1), 'hq', 'HQ')"/>

		<!-- Only if not at end -->
		<xsl:if test="$inst != ''">
			<xsl:choose>
				<xsl:when test="$inst = 'H'">
					<xsl:value-of select="$hello-world"/>
				</xsl:when>
				<xsl:when test="$inst = 'Q'">
					<xsl:value-of select="$code"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:when>
				<xsl:when test="$inst = '9'">
					<xsl:value-of select="$entire-bottles-song"/>
				</xsl:when>
				<xsl:when test="$inst = '+'">
					<!-- XSLT has no meaningful equivalent of write-only variables -->
				</xsl:when>
				<!-- Otherwise, do nothing -->
			</xsl:choose>

			<!-- Proceed with next instruction -->
			<xsl:call-template name="run">
				<xsl:with-param name="code" select="$code"/>
				<xsl:with-param name="starting-at" select="$starting-at + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
