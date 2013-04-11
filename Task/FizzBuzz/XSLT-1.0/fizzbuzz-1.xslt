<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" encoding="utf-8"/>

	<!-- Outputs a line for a single FizzBuzz iteration. -->
	<xsl:template name="fizzbuzz-single">
		<xsl:param name="n"/>
		
		<!-- $s will be "", "Fizz", "Buzz", or "FizzBuzz". -->
		<xsl:variable name="s">
			<xsl:if test="$n mod 3 = 0">Fizz</xsl:if>
			<xsl:if test="$n mod 5 = 0">Buzz</xsl:if>
		</xsl:variable>
		
		<!-- Output $s. If $s is blank, also output $n. -->
		<xsl:value-of select="$s"/>
		<xsl:if test="$s = ''">
			<xsl:value-of select="$n"/>
		</xsl:if>
		
		<!-- End line. -->
		<xsl:value-of select="'&#10;'"/>
	</xsl:template>
	
	<!-- Calls fizzbuzz-single over each value in a range. -->
	<xsl:template name="fizzbuzz-range">
		<!-- Default parameters: From 1 through 100 -->
		<xsl:param name="startAt" select="1"/>
		<xsl:param name="endAt" select="$startAt + 99"/>
		
		<!-- Simulate a loop with tail recursion. -->
		
		<!-- Loop condition -->
		<xsl:if test="$startAt &lt;= $endAt">
			<!-- Loop body -->
			<xsl:call-template name="fizzbuzz-single">
				<xsl:with-param name="n" select="$startAt"/>
			</xsl:call-template>

			<!-- Increment counter, repeat -->
			<xsl:call-template name="fizzbuzz-range">
				<xsl:with-param name="startAt" select="$startAt + 1"/>
				<xsl:with-param name="endAt" select="$endAt"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Main procedure -->
	<xsl:template match="/">
		<!-- Default parameters are used -->
		<xsl:call-template name="fizzbuzz-range"/>
	</xsl:template>
</xsl:stylesheet>
