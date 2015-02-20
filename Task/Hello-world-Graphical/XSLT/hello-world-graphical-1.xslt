<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	<xsl:template match="/*">
		<!--
			Use a template to insert some text into a simple SVG graphic
			with hideous colors.
		-->
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 200">
			<rect x="0" y="0" width="400" height="200" fill="cyan"/>
			<circle cx="200" cy="100" r="50" fill="yellow"/>
			<text x="200" y="115"
				style="font-size: 40px;
					text-align: center;
					text-anchor: middle;
					fill: black;">
				<!-- The text inside the element -->
				<xsl:value-of select="."/>
			</text>
		</svg>
	</xsl:template>
</xsl:stylesheet>
