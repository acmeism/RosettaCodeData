<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:lo="urn:uuid:59afd337-03a8-49d9-a7a8-8e2cbc4ef9cc">
	<!-- Note: xmlns:lo is defined as a sort of pseudo-private namespace -->

	<!-- Given a count and a suffix (default " on the wall"), renders one number-containing line of the bottles song -->
	<xsl:template name="lo:line">
		<xsl:param name="count"/>
		<xsl:param name="suffix"> on the wall</xsl:param>
		<xsl:value-of select="$count"/>
		<xsl:text> bottle</xsl:text>
		<xsl:if test="$count != 1">s</xsl:if>
		<xsl:text> of beer</xsl:text>
		<xsl:value-of select="$suffix"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<!-- Given a count, renders one verse of the bottles song -->
	<xsl:template name="lo:verse">
		<xsl:param name="count"/>
		<xsl:call-template name="lo:line">
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:call-template name="lo:line">
			<xsl:with-param name="count" select="$count"/>
			<!-- empty suffix for this line -->
			<xsl:with-param name="suffix"/>
		</xsl:call-template>
		<xsl:text>Take one down, pass it around&#10;</xsl:text>
		<xsl:call-template name="lo:line">
			<xsl:with-param name="count" select="$count - 1"/>
		</xsl:call-template>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<!-- Given a starting count, renders the entire bottles song -->
	<xsl:template name="lo:song">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="lo:verse">
				<xsl:with-param name="count" select="$count"/>
			</xsl:call-template>
			<xsl:call-template name="lo:song">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- The entire bottles song -->
	<xsl:variable name="entire-bottles-song">
		<xsl:call-template name="lo:song">
			<xsl:with-param name="count" select="99"/>
		</xsl:call-template>
	</xsl:variable>

</xsl:stylesheet>
