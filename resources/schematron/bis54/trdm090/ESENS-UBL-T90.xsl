<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Tender-2"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

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
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
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
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
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
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
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
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="eSENS business and syntax rules for Submit Tender (TRDM090)"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                                             prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                                             prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                                             prefix="ext"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Tender-2"
                                             prefix="ubl"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">eSENS business and syntax rules for Submit Tender (TRDM090)</svrl:text>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*" priority="1000" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*"/>

		    <!--REPORT -->
      <xsl:if test="normalize-space(.) = '' and not(*)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="normalize-space(.) = '' and not(*)">
            <xsl:attribute name="id">eSENS-T90-S002</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T90-S002] A Submit Tender document MUST NOT contain empty elements.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>

   <!--PATTERN -->
   <xsl:variable name="syntaxError"
                 select="string('[eSENS-T90-S003] A Submit Tender document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>

	  <!--RULE -->
   <xsl:template match="ubl:Tender" priority="1043" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl:Tender"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:UBLVersionID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
               <xsl:attribute name="id">eSENS-T90-R001</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R001] A Tender MUST have a syntax identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(ext:UBLExtensions)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(ext:UBLExtensions)">
            <xsl:attribute name="id">eSENS-T90-S301</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S301] UBLExtensions SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:ProfileExectuionID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileExectuionID)">
            <xsl:attribute name="id">eSENS-T90-S305</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S305] ProfileExecutionID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:CopyIndicator)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CopyIndicator)">
            <xsl:attribute name="id">eSENS-T90-S307</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S307] CopyIndicator SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:UUID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UUID)">
            <xsl:attribute name="id">eSENS-T90-S308</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S308] UUID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:TenderTypeCode)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:TenderTypeCode)">
            <xsl:attribute name="id">eSENS-T90-S309</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S309] TenderTypeCode SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:ConctractName)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ConctractName)">
            <xsl:attribute name="id">eSENS-T90-S311</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S311] ContractName SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:Note)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:Note)">
            <xsl:attribute name="id">eSENS-T90-S312</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S312] Note SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:ValidityPeriod)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ValidityPeriod)">
            <xsl:attribute name="id">eSENS-T90-S313</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S313] ValidityPeriod SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cac:DocumentReference) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(cac:DocumentReference) &gt; 1">
               <xsl:attribute name="id">eSENS-T90-S314</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S314] DocumentReference SHOULD be used at least twice.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)">
               <xsl:attribute name="id">eSENS-T90-R013</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R013] DocumentReference Identifiers MUST be unique.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)) = count(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)) = count(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)">
               <xsl:attribute name="id">eSENS-T90-R014</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R014] FileName values MUST be unique.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(cac:Signature)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Signature)">
            <xsl:attribute name="id">eSENS-T90-S328</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S328] Signature SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:TendererQualificationDocumentReference)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(cac:TendererQualificationDocumentReference)">
            <xsl:attribute name="id">eSENS-T90-S350</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S350] TendererQualificationDocumentReference SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:SubcontractorParty)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:SubcontractorParty)">
            <xsl:attribute name="id">eSENS-T90-S351</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S351] SubcontractorParty SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cac:ContractingParty) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(cac:ContractingParty) = 1">
               <xsl:attribute name="id">eSENS-T90-S352</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S352] ContractingParty SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(cac:OriginatorCustomerParty)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(cac:OriginatorCustomerParty)">
            <xsl:attribute name="id">eSENS-T90-S356</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S356] OriginatorCustomerParty SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cbc:CustomizationID" priority="1042" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cbc:CustomizationID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm090:ver3.0:extended:urn:www.peppol.eu:bis:peppol54a:ver1.0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm090:ver3.0:extended:urn:www.peppol.eu:bis:peppol54a:ver1.0'">
               <xsl:attribute name="id">eSENS-T90-R002</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R002] CustomizationID value MUST be 'urn:www.cenbii.eu:transaction:biitrdm090:ver3.0:extended:urn:www.peppol.eu:bis:peppol54a:ver1.0'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S303</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S303] CustomizationID SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cbc:ProfileID" priority="1041" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cbc:ProfileID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii54:ver3.0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii54:ver3.0'">
               <xsl:attribute name="id">eSENS-T90-R003</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R003] ProfileID value MUST be 'urn:www.cenbii.eu:profile:bii54:ver3.0'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S304</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S304] ProfileID SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cbc:ID" priority="1040" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl:Tender/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeURI"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeURI">
               <xsl:attribute name="id">eSENS-T90-R004</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R004] A Submit Tender Identifier MUST have a schemeURI attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@schemeURI)='urn:uuid'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@schemeURI)='urn:uuid'">
               <xsl:attribute name="id">eSENS-T90-R005</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R005] schemeURI for Submit Tender Identifier MUST be 'urn:uuid'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeURI')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeURI')]">
            <xsl:attribute name="id">eSENS-T90-S306</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S306] A Submit Tender Identifier SHOULD NOT have any attributes but schemeURI</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
               <xsl:attribute name="id">eSENS-T90-R006</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R006] A Submit Tender Identifier MUST be expressed in a UUID syntax (RFC 4122)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cbc:IssueTime" priority="1039" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cbc:IssueTime"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
               <xsl:attribute name="id">eSENS-T90-R007</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R007] IssueTime MUST have a granularity of seconds</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cbc:UBLVersionID" priority="1038" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cbc:UBLVersionID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S302</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S302] UBLVersionID SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cbc:ContractFolderID" priority="1037" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cbc:ContractFolderID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S310</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S310] ContractFolderID SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference" priority="1036" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0">
               <xsl:attribute name="id">eSENS-T90-S315</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S315] DocumentReference SHOULD NOT contain any elements but ID, DocumentTypeCode, LocaleCode, VersionID, DocumentDescription, Attachment</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="count(./cbc:DocumentDescription) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cbc:DocumentDescription) &gt; 1">
            <xsl:attribute name="id">eSENS-T90-S320</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S320] DocumentDescription SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:EndpointID" priority="1035" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID">
               <xsl:attribute name="id">eSENS-T90-R010</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R010] An Endpoint Identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">
               <xsl:attribute name="id">eSENS-T90-R011</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R011] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T90-S316</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S316] EndpointID SHOULD NOT have any attributes but schemeID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference[normalize-space(./cbc:DocumentTypeCode)='311']/cbc:ID"
                 priority="1034"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference[normalize-space(./cbc:DocumentTypeCode)='311']/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
               <xsl:attribute name="id">eSENS-T90-R012</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R012] DocumentReference Identifier for a Call for Tender Reference MUST be expressed in a UUID syntax (RFC 4122)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode"
                 priority="1033"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T90-S317</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S317] DocumentTypeCode SHOULD NOT have any attributes but listID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cbc:LocaleCode"
                 priority="1032"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cbc:LocaleCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@listID)='ISO639-1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@listID)='ISO639-1'">
               <xsl:attribute name="id">eSENS-T90-R015</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R015] listID for LocaleCode MUST be 'ISO639-1'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">
               <xsl:attribute name="id">eSENS-T90-R016</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R016] LocalCode MUST be a valid Language Code.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T90-S318</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S318] LocaleCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cbc:VersionID"
                 priority="1031"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cbc:VersionID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S319</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S319] VersionID SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cbc:DocumentDescription"
                 priority="1030"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cbc:DocumentDescription"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S321</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S321] DocumentDescription SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cac:Attachment"
                 priority="1029"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cac:Attachment"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:ExternalReference)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:ExternalReference)=0">
               <xsl:attribute name="id">eSENS-T90-S322</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S322] Attachment SHOULD NOT contain any elements but ExternalReference</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference"
                 priority="1028"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)-count(./cbc:MimeCode)-count(./cbc:FileName)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)-count(./cbc:MimeCode)-count(./cbc:FileName)=0">
               <xsl:attribute name="id">eSENS-T90-S323</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S323] Attachment/ExternalReference SHOULD NOT contain any elements but DocumentHash, HashAlgorithmMethod, MimeCode, FileName</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash"
                 priority="1027"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">
               <xsl:attribute name="id">eSENS-T90-R017</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R017] DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S324</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S324] DocumentHash SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod"
                 priority="1026"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">
               <xsl:attribute name="id">eSENS-T90-R018</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R018] HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S325</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S325] HashAlgorithmMethod SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName"
                 priority="1025"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S326</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S326] FileNAme SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode"
                 priority="1024"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S327</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S327] MimeCode SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:TendererParty" priority="1023" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:TendererParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)-count(./cac:PartyName)-count(./cac:PostalAddress)-count(./cac:PartyLegalEntity)-count(./cac:Contact)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)-count(./cac:PartyName)-count(./cac:PostalAddress)-count(./cac:PartyLegalEntity)-count(./cac:Contact)=0">
               <xsl:attribute name="id">eSENS-T90-S329</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S329] TendererParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PostalAddress, PartyLegalEntity, Contact</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cac:PartyName) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./cac:PartyName) = 1">
               <xsl:attribute name="id">eSENS-T90-S332</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S332] PartyName SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="count(./cac:PartyLegalEntity) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cac:PartyLegalEntity) &gt; 1">
            <xsl:attribute name="id">eSENS-T90-S342</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S342] PartyLegalEntity SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:PartyIdentification) and (./cbc:EndpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
               <xsl:attribute name="id">eSENS-T90-R020</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R020] A Tender MUST identify the Economic Operator by its party and endpoint identifiers.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyIdentification/cbc:ID" priority="1022" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PartyIdentification/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID">
               <xsl:attribute name="id">eSENS-T90-R008</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R008] A Party Identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">
               <xsl:attribute name="id">eSENS-T90-R009</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R009] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T90-S331</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S331] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:Name" priority="1021" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Name"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S333</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S333] Name SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:TendererParty/cac:PostalAddress"
                 priority="1020"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:TendererParty/cac:PostalAddress"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:StreetName)-count(./cbc:AdditionalStreetName)-count(./cbc:CityName)-count(./cbc:PostalZone)-count(./cbc:CountrySubentity)-count(./cac:Country)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:StreetName)-count(./cbc:AdditionalStreetName)-count(./cbc:CityName)-count(./cbc:PostalZone)-count(./cbc:CountrySubentity)-count(./cac:Country)=0">
               <xsl:attribute name="id">eSENS-T90-S334</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S334] PostalAddress SHOULD NOT contain any elements but StreetName, AdditionalStreetName, CityName, PostalZone, CountrySubentity, Country</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:StreetName" priority="1019" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:StreetName"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S335</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S335] cbc:StreetName SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:AdditionalStreetName" priority="1018" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:AdditionalStreetName"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S336</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S336] cbc:AdditionalStreetName SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:CityName" priority="1017" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:CityName"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S337</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S337] cbc:CityName SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:PostalZone" priority="1016" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:PostalZone"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S338</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S338] cbc:PostalZone SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:CountrySubentity" priority="1015" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:CountrySubentity"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S339</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S339] cbc:CountrySubentity SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Country" priority="1014" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Country"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:IdentificationCode)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:IdentificationCode)=0">
               <xsl:attribute name="id">eSENS-T90-S340</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S340] cac:Country SHOULD NOT contain any elements but IdentificationCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Country/cbc:IdentificationCode"
                 priority="1013"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:Country/cbc:IdentificationCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T90-S341</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S341] Country Identification Code SHOULD NOT contain any attributes but listID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyLegalEntity" priority="1012" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PartyLegalEntity"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:CompanyLegalForm)-count(./cac:RegistrationAddress) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:CompanyLegalForm)-count(./cac:RegistrationAddress) = 0">
               <xsl:attribute name="id">eSENS-T90-S343</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S343] cac:PartyLegalEntity SHOULD NOT contain any elements but CompanyLegalForm, RegistrationAddress.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyLegalEntity/cbc:CompanyLegalForm"
                 priority="1011"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PartyLegalEntity/cbc:CompanyLegalForm"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S344</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S344] CompanyLegalForm SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyLegalEntity/cac:RegistrationAddress"
                 priority="1010"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PartyLegalEntity/cac:RegistrationAddress"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:Country) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:Country) = 0">
               <xsl:attribute name="id">eSENS-T90-S345</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S345] cac:RegistrationAddress SHOULD NOT contain any elements but Country.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Contact" priority="1009" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Contact"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:Telephone)-count(./cbc:Telefax)-count(./cbc:ElectronicMail)-count(./cbc:Name)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:Telephone)-count(./cbc:Telefax)-count(./cbc:ElectronicMail)-count(./cbc:Name)= 0">
               <xsl:attribute name="id">eSENS-T90-S346</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S346] Contact SHOULD NOT contain any elements but Telephone, Telefax, ElectronicMail, Name.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:Telephone" priority="1008" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Telephone"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S347</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S347] cbc:Telephone SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:Telefax" priority="1007" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Telefax"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S348</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S348] cbc:Telefax SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:ElectronicMail" priority="1006" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:ElectronicMail"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S349</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S349] cbc:ElectronicMail SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:ContractingParty" priority="1005" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:ContractingParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:Party)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:Party)=0">
               <xsl:attribute name="id">eSENS-T90-S353</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S353] ContractingParty SHOULD NOT contain any elements but Party.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:ContractingParty/cac:Party"
                 priority="1004"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:ContractingParty/cac:Party"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0">
               <xsl:attribute name="id">eSENS-T90-S354</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S354] ContractingParty Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="count(./cac:PartyName) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cac:PartyName) &gt; 1">
            <xsl:attribute name="id">eSENS-T90-S355</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S355] ContractingParty/Party/PartyName SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:PartyIdentification) and (./cbc:EndpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
               <xsl:attribute name="id">eSENS-T90-R019</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T90-R019] A Tender MUST identify the Contracting Authority by its party and endpoint identifiers.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:ContractingParty/cac:Party | ubl:Tender/cac:TendererParty"
                 priority="1003"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:ContractingParty/cac:Party | ubl:Tender/cac:TendererParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cac:PartyIdentification) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./cac:PartyIdentification) = 1">
               <xsl:attribute name="id">eSENS-T90-S330</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S330] PartyIdentification SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:TenderedProject" priority="1002" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:TenderedProject"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:ProcurementProjectLot)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:ProcurementProjectLot)= 0">
               <xsl:attribute name="id">eSENS-T90-S357</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S357] TenderedProject SHOULD NOT contain any elements but ProcurementProjectLot</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot"
                 priority="1001"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)= 0">
               <xsl:attribute name="id">eSENS-T90-S358</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T90-S358] ProcurementProjectLot SHOULD NOT contain any elements but ID</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot/cbc:ID"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot/cbc:ID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T90-S359</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T90-S359] Procurement Project Lot Identifier SHOULD NOT contain any attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
</xsl:stylesheet>
