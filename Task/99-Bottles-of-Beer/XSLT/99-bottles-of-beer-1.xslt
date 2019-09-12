<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text" encoding="utf-8"/>

    <!-- Main procedure -->
    <xsl:template match="/">
        <!-- Default parameters are used -->
        <xsl:call-template name="sing-all-verses-in-range"/>
    </xsl:template>

    <!-- Calls sing-verse-starting-with-number over each value in a range. -->
    <xsl:template name="sing-all-verses-in-range">
        <!-- Default parameters: From 99 through 1 -->
        <xsl:param name="first" select="99"/>
        <xsl:param name="final" select="1"/>

        <!-- Simulate a loop with tail recursion. -->
        <xsl:if test="$first &gt;= $final">
            <!-- Process $first -->
            <xsl:call-template name="sing-verse-starting-with-number">
                <xsl:with-param name="n" select="$first"/>
            </xsl:call-template>

            <!-- Process $first - 1 through $final -->
            <xsl:call-template name="sing-all-verses-in-range">
                <xsl:with-param name="first" select="$first - 1"/>
                <xsl:with-param name="final" select="$final"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Outputs a single verse. Each verse starts with $n bottles and ends with $n - 1 bottles. -->
    <xsl:template name="sing-verse-starting-with-number">
        <xsl:param name="n"/>

        <!-- "$n bottles of beer on the wall" -->
        <xsl:call-template name="sing-line-containing-number">
            <xsl:with-param name="n" select="$n"/>
        </xsl:call-template>

        <!-- "$n bottles of beer" -->
        <xsl:call-template name="sing-line-containing-number">
            <xsl:with-param name="n" select="$n"/>
            <!-- For the second line, specify blank suffix -->
            <xsl:with-param name="suffix"/>
        </xsl:call-template>

        <xsl:text>Take one down, pass it around&#10;</xsl:text>

        <!-- "($n - 1) bottles of beer on the wall" -->
        <xsl:call-template name="sing-line-containing-number">
            <!-- End verse with one less bottle -->
            <xsl:with-param name="n" select="$n - 1"/>
        </xsl:call-template>

        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <!-- Outputs "[number] bottle[s] of beer[ on the wall]" -->
    <xsl:template name="sing-line-containing-number">
        <xsl:param name="n"/>
        <!-- If no suffix is specified, use " on the wall" -->
        <xsl:param name="suffix"> on the wall</xsl:param>

        <xsl:value-of select="$n"/>
        <xsl:text> bottle</xsl:text>
        <!-- Add "s" iff appropriate -->
        <xsl:if test="$n != 1">s</xsl:if>
        <xsl:text> of beer</xsl:text>
        <xsl:value-of select="$suffix"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
