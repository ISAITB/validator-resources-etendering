<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

	<xsl:template match="/">
		<schematron-output xmlns="http://www.ascc.net/xml/schematron" title="unchecked" schemaVersion="1.0" phase="not implemented">
			<active-pattern name="unchecked"/>
		</schematron-output>
	</xsl:template>

	<xsl:template match="*|@*|text()"/>

</xsl:stylesheet>
