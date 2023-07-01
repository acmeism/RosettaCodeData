<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xcsvt="http://www.seanbdurkin.id.au/xslt/csv-to-xml.xslt"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xcsv="http://www.seanbdurkin.id.au/xslt/xcsv.xsd"
   version="2.0"
   exclude-result-prefixes="xsl xs xcsvt xcsv">
 <xsl:import href="csv-to-xml.xslt" />
 <xsl:output indent="yes" encoding="UTF-8" method="html" doctype-system="about:legacy-compat" />
 <xsl:import-schema schema-location="http://www.seanbdurkin.id.au/xslt/xcsv.xsd"
                    use-when="system-property('xsl:is-schema-aware')='yes'" />
 <xsl:param name="url-of-csv" as="xs:string" select="'roseta.csv'" />


 <xsl:variable name="phase-1-result">
   <xsl:call-template name="xcsvt:main" />
 </xsl:variable>

 <xsl:template match="/">
   <html lang="en">
     <head><title>CSV to HTML translation - Extra Credit</title></head>
     <body>
       <xsl:apply-templates select="$phase-1-result" mode="phase-2" />
     </body>
   </html>
 </xsl:template>

 <xsl:template match="xcsv:comma-separated-single-line-values" mode="phase-2">
  <table>
    <xsl:apply-templates mode="phase-2" />
  </table>
 </xsl:template>

 <xsl:template match="xcsv:row[1]" mode="phase-2">
  <th>
    <xsl:apply-templates mode="phase-2" />
  </th>
 </xsl:template>

 <xsl:template match="xcsv:row" mode="phase-2">
  <tr>
    <xsl:apply-templates mode="phase-2" />
  </tr>
 </xsl:template>

 <xsl:template match="xcsv:value" mode="phase-2">
  <td>
    <xsl:apply-templates mode="phase-2" />
  </td>
 </xsl:template>

 <xsl:template match="xcsv:notice" mode="phase-2" />

 </xsl:stylesheet>
