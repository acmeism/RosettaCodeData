<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" version="4.01" indent="yes"/>

    <!-- Most XSLT processors have some way to supply a different value for this parameter -->
    <xsl:param name="column-count" select="3"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Rosetta Code: Create an HTML table (XSLT)</title>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
        <xsl:variable name="values" select="/*/*"/>
    </xsl:template>

    <!--
        Rendering HTML from XSLT is so basic as to be trivial. The trickier part of this transform is taking the
        single-column list of numbers in the input and folding it into multiple columns. A common strategy is to only
        apply templates to every Nth value in the list, but then to have that template pull in the skipped values to
        form a row.
    -->

    <xsl:template match="/numbers">
        <table>
            <tr>
                <th/>
                <th>X</th>
                <th>Y</th>
                <th>Z</th>
            </tr>
            <!--
                Here, we have the template applied to every Nth input element rather than every element. In XSLT,
                indices are 1-based, so the start index of every row mod N is 1.
            -->
            <xsl:apply-templates select="number[position() mod $column-count = 1]"/>
        </table>
    </xsl:template>

    <xsl:template match="number">
        <tr>
            <th>
                <xsl:value-of select="position()"/>
            </th>
            <!--
                Here, we compensate for the skipping by including the skipped values in the processing for this value.
            -->
            <xsl:for-each select=". | following-sibling::number[position() &lt; $column-count]">
                <td>
                    <xsl:value-of select="."/>
                </td>
            </xsl:for-each>
        </tr>
    </xsl:template>
</xsl:stylesheet>
