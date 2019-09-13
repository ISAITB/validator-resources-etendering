<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Tender-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ubl:dummy-for-xmlns="" cbc:dummy-for-xmlns="" cac:dummy-for-xmlns="" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
	<xsl:param name="archiveNameParameter"/>
	<xsl:param name="fileNameParameter"/>
	<xsl:param name="fileDirParameter"/>
	<xsl:variable name="document-uri">
		<xsl:value-of select="document-uri(/)"/>
	</xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
		<xsl:apply-templates select="." mode="schematron-get-full-path"/>
	</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
		<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
		<xsl:text>/</xsl:text>
		<xsl:choose>
			<xsl:when test="namespace-uri()=''">
				<xsl:value-of select="name()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*:</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>[namespace-uri()='</xsl:text>
				<xsl:value-of select="namespace-uri()"/>
				<xsl:text>']</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
		<xsl:text>[</xsl:text>
		<xsl:value-of select="1+ $preceding"/>
		<xsl:text>]</xsl:text>
	</xsl:template>
	<xsl:template match="@*" mode="schematron-get-full-path">
		<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
		<xsl:text>/</xsl:text>
		<xsl:choose>
			<xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/></xsl:when>
			<xsl:otherwise>
				<xsl:text>@*[local-name()='</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>' and namespace-uri()='</xsl:text>
				<xsl:value-of select="namespace-uri()"/>
				<xsl:text>']</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
		<xsl:for-each select="ancestor-or-self::*">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="name(.)"/>
			<xsl:if test="preceding-sibling::*[name(.)=name(current())]">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="not(self::*)">
			<xsl:text/>/@<xsl:value-of select="name(.)"/></xsl:if>
	</xsl:template><!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
		<xsl:for-each select="ancestor-or-self::*">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="name(.)"/>
			<xsl:if test="parent::*">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="not(self::*)">
			<xsl:text/>/@<xsl:value-of select="name(.)"/></xsl:if>
	</xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
	<xsl:template match="text()" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
	</xsl:template>
	<xsl:template match="comment()" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
	</xsl:template>
	<xsl:template match="processing-instruction()" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
	</xsl:template>
	<xsl:template match="@*" mode="generate-id-from-path">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:value-of select="concat('.@', name())"/>
	</xsl:template>
	<xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
		<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
	</xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
	<xsl:template match="*" mode="generate-id-2" priority="2">
		<xsl:text>U</xsl:text>
		<xsl:number level="multiple" count="*"/>
	</xsl:template>
	<xsl:template match="node()" mode="generate-id-2">
		<xsl:text>U.</xsl:text>
		<xsl:number level="multiple" count="*"/>
		<xsl:text>n</xsl:text>
		<xsl:number count="node()"/>
	</xsl:template>
	<xsl:template match="@*" mode="generate-id-2">
		<xsl:text>U.</xsl:text>
		<xsl:number level="multiple" count="*"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="string-length(local-name(.))"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="translate(name(),':','.')"/>
	</xsl:template><!--Strip characters--><xsl:template match="text()" priority="-1"/>

<!--SCHEMA SETUP-->
<xsl:template match="/">
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="ESENS business rules" schemaVersion="iso">
			<xsl:comment>
				<xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/></xsl:comment>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Tender-2" prefix="ubl"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
			<svrl:active-pattern>
				<xsl:attribute name="document">
					<xsl:value-of select="document-uri(/)"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</svrl:active-pattern>
			<xsl:apply-templates select="/" mode="M4"/>
		</svrl:schematron-output>
	</xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">ESENS business rules</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/ubl:Tender" priority="1005" mode="M4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Tender"/>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)">
					<xsl:attribute name="id">ESENS-T45-R001</xsl:attribute>
					<xsl:attribute name="flag">fatal</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>A tender receipt notification MUST not contain empty elements.</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="(cbc:UBLVersionID)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
					<xsl:attribute name="id">ESENS-T45-R003</xsl:attribute>
					<xsl:attribute name="flag">fatal</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>A tender receipt notification MUST have a syntax identifier.</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>

	<!--RULE -->
<xsl:template match="cbc:UBLVersionID" priority="1004" mode="M4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:UBLVersionID"/>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 2.1 ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 2.1 ',concat(' ',normalize-space(.),' ') ) ) )">
					<xsl:attribute name="id">ESENS-T45-R002</xsl:attribute>
					<xsl:attribute name="flag">fatal</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>UBL version must be 2.1</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PartyIdentification/cbc:ID" priority="1003" mode="M4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyIdentification/cbc:ID"/>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="(@schemeID)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID)">
					<xsl:attribute name="id">ESENS-T45-R007</xsl:attribute>
					<xsl:attribute name="flag">warning</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>A party identifier MUST have a schemeID attribute</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PartyIdentification//@schemeID" priority="1002" mode="M4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyIdentification//@schemeID"/>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION SE:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION SE:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
					<xsl:attribute name="id">ESENS-T45-R006</xsl:attribute>
					<xsl:attribute name="flag">fatal</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>SchemeID for party identifier must be from PEPPOL Policy for identifiers,
                policy 8 </svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:EndpointID" priority="1001" mode="M4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID"/>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="(@schemeID)"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID)">
					<xsl:attribute name="id">ESENS-T45-R005</xsl:attribute>
					<xsl:attribute name="flag">warning</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>An endpoint identifier MUST have a schemeID attribute</svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>

	<!--RULE -->
<xsl:template match="//cbc:EndpointID//@schemeID" priority="1000" mode="M4">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID//@schemeID"/>

		<!--ASSERT -->
<xsl:choose>
			<xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION SE:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<xsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION SE:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
					<xsl:attribute name="id">ESENS-T45-R004</xsl:attribute>
					<xsl:attribute name="flag">fatal</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:apply-templates select="." mode="schematron-select-full-path"/>
					</xsl:attribute>
					<svrl:text>SchemeID for endpoint identifier must be from PEPPOL Policy for identifiers,
                policy 8 </svrl:text>
				</svrl:failed-assert>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>
	<xsl:template match="text()" priority="-1" mode="M4"/>
	<xsl:template match="@*|node()" priority="-2" mode="M4">
		<xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
	</xsl:template>
</xsl:stylesheet>