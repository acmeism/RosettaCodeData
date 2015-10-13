<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- bottles.xsl defines $entire-bottles-song -->
	<xsl:import href="bottles.xsl"/>

	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:variable name="hello-world">
		<xsl:text>Hello, world!&#10;</xsl:text>
	</xsl:variable>

	<!-- Main template -->
	<xsl:template match="/">
		<results>
			<xsl:apply-templates select="//code"/>
		</results>
	</xsl:template>

	<!-- <code/> template -->
	<xsl:template match="code">
		<xsl:call-template name="run">
			<xsl:with-param name="code" select="string(.)"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Runs HQ9+ code from string -->
	<xsl:template name="run">
		<xsl:param name="code"/>

		<xsl:call-template name="_run-remaining-code">
			<!-- Initial value is the entire input program plus a newline -->
			<xsl:with-param name="quine" select="concat($code,'&#10;')"/>

			<!-- Initial value is the entire input program with [hq] changed to upper-case -->
			<xsl:with-param name="code" select="translate($code, 'hq', 'HQ')"/>

			<!-- Initial value is empty -->
			<xsl:with-param name="output"/>

			<!-- Initial value is 0 -->
			<xsl:with-param name="accumulator" select="0"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Runs the remainder of some already-started HQ9+ code -->
	<!-- Tail recursion allows this function to effectively update its own state -->
	<xsl:template name="_run-remaining-code">
		<!-- The text to be output on 'Q' -->
		<xsl:param name="quine"/>
		<!-- The remaining instructions for the program, already upper-case -->
		<xsl:param name="code"/>
		<!-- Output that has already been collected -->
		<xsl:param name="output"/>
		<!-- Current accumulator value -->
		<xsl:param name="accumulator"/>

		<!--
			 If there are instructions remaining, runs the next instruction and then recurses.
			 If there are no instructions left, produces the final output and accumulator before exiting.
		-->
		<xsl:choose>
			<xsl:when test="$code = ''">
				<!-- Reached the end of the program; output results -->
				<result>
					<xsl:if test="$accumulator != 0">
						<xsl:attribute name="accumulator"><xsl:value-of select="$accumulator"/></xsl:attribute>
					</xsl:if>
					<xsl:copy-of select="$output"/>
				</result>
			</xsl:when>
			<xsl:otherwise>
				<!-- At least one more instruction; run and recurse -->
				<xsl:variable name="inst" select="substring($code, 1, 1)"/>
				<xsl:variable name="remaining" select="substring($code, 2)"/>

				<!-- Decide what to add to accumulator -->
				<xsl:variable name="accumulator-inc">
					<xsl:choose>
						<xsl:when test="$inst = '+'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Decide what to append to output -->
				<xsl:variable name="output-inc">
					<xsl:choose>
						<xsl:when test="$inst = 'H'"><xsl:value-of select="$hello-world"/></xsl:when>
						<xsl:when test="$inst = 'Q'"><xsl:value-of select="$quine"/></xsl:when>
						<xsl:when test="$inst = '9'"><xsl:value-of select="$entire-bottles-song"/></xsl:when>
					</xsl:choose>
				</xsl:variable>

				<!-- Recurse to continue processing program -->
				<xsl:call-template name="_run-remaining-code">
					<!-- $quine is the $quine originally passed without changes -->
					<xsl:with-param name="quine" select="$quine"/>
					<!-- $code is the $code from this invocation with the first character removed -->
					<xsl:with-param name="code" select="$remaining"/>
					<!-- $output is the $output from this invocation with $output-inc appended -->
					<xsl:with-param name="output">
						<xsl:copy-of select="$output"/>
						<xsl:copy-of select="$output-inc"/>
					</xsl:with-param>
					<!-- $accumulator is the $accumulator from this invocation with $accumulator-inc added -->
					<xsl:with-param name="accumulator" select="$accumulator + $accumulator-inc"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
