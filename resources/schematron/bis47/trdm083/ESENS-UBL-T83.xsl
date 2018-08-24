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
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:CallForTenders-2"
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
                              title="eSENS business and syntax rules for Call for Tenders Light (Tansaction 83)"
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
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CallForTenders-2"
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
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">eSENS business and syntax rules for Call for Tenders Light (Tansaction 83)</svrl:text>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*" priority="1000" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*"/>

		    <!--REPORT -->
      <xsl:if test="normalize-space(.) = '' and not(*)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="normalize-space(.) = '' and not(*)">
            <xsl:attribute name="id">eSENS-T83-S002</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T83-S002] A Call For Tenders document MUST NOT contain empty elements.</svrl:text>
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
                 select="string('[eSENS-T83-S003] A Call For Tenders document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders" priority="1062" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl:CallForTenders"/>

		    <!--REPORT -->
      <xsl:if test="(ext:UBLExtensions)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(ext:UBLExtensions)">
            <xsl:attribute name="id">eSENS-T83-S301</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S301] UBLExtensions SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:UBLVersionID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
               <xsl:attribute name="id">eSENS-T83-R001</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R001] A Call For Tenders MUST have a syntax identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(cbc:ProfileExectuionID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileExectuionID)">
            <xsl:attribute name="id">eSENS-T83-S305</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S305] ProfileExecutionID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:CopyIndicator)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CopyIndicator)">
            <xsl:attribute name="id">eSENS-T83-S307</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S307] CopyIndicator SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:UUID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UUID)">
            <xsl:attribute name="id">eSENS-T83-S308</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S308] UUID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:ApprovalDate)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ApprovalDate)">
            <xsl:attribute name="id">eSENS-T83-S310</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S310] ApprovalDate SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:IssueTime)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueTime)">
               <xsl:attribute name="id">eSENS-T83-R007</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R007] A Call For Tenders MUST have an issue time.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(cac:AdditionalDocumentReference/cbc:ID)) = count(cac:AdditionalDocumentReference/cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(cac:AdditionalDocumentReference/cbc:ID)) = count(cac:AdditionalDocumentReference/cbc:ID)">
               <xsl:attribute name="id">eSENS-T83-R024</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R024] Additional Document Reference Identifiers MUST be unique.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">
               <xsl:attribute name="id">eSENS-T83-R029</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R029] Lot identifiers MUST be unique.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(cbc:Note)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:Note)">
            <xsl:attribute name="id">eSENS-T83-S311</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S311] Note SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:VersionID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:VersionID)">
               <xsl:attribute name="id">eSENS-T83-R038</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R038] A Call For Tenders MUST have a version identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(cbc:PreviousVersionID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:PreviousVersionID)">
            <xsl:attribute name="id">eSENS-T83-S313</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S313] PreviousVersionID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:LegalDocumentReference)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(cac:LegalDocumentReference)">
            <xsl:attribute name="id">eSENS-T83-S314</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S314] LegalDocumentReference SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:TechnicalDocumentReference)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(cac:TechnicalDocumentReference)">
            <xsl:attribute name="id">eSENS-T83-S315</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S315] TechnicalDocumentReference SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:Signature)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Signature)">
            <xsl:attribute name="id">eSENS-T83-S331</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S331] Signature SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(cac:ContractingParty) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(cac:ContractingParty) &gt; 1">
            <xsl:attribute name="id">eSENS-T83-S332</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S332] ContractingParty SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:OriginatorCustomerParty)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(cac:OriginatorCustomerParty)">
            <xsl:attribute name="id">eSENS-T83-S345</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S345] OriginatorCustomerParty SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:ReceiverParty)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ReceiverParty)">
            <xsl:attribute name="id">eSENS-T83-S346</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S346] Receiver Party SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:TenderingTerms)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:TenderingTerms)">
               <xsl:attribute name="id">eSENS-T83-S347</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S347] TenderingTerms SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:TenderingProcess)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:TenderingProcess)">
               <xsl:attribute name="id">eSENS-T83-S368</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S368] TenderingProcess SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:UBLVersionID"
                 priority="1061"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:UBLVersionID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S302</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S302] UBLVersionID SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:CustomizationID"
                 priority="1060"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:CustomizationID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm083:ver3.0:extended:urn:www.peppol.eu:bis:peppol47x:ver1.0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm083:ver3.0:extended:urn:www.peppol.eu:bis:peppol47x:ver1.0'">
               <xsl:attribute name="id">eSENS-T83-R002</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R002] CustomizationID value MUST be 'urn:www.cenbii.eu:transaction:biitrdm083:ver3.0:extended:urn:www.peppol.eu:bis:peppol47x:ver1.0'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S303</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S303] CustomizationID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:ProfileID" priority="1059" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:ProfileID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii47:ver3.0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii47:ver3.0'">
               <xsl:attribute name="id">eSENS-T83-R003</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R003] ProfileID value MUST be 'urn:www.cenbii.eu:profile:bii47:ver3.0'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S304</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S304] ProfileID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:ID" priority="1058" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeURI"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeURI">
               <xsl:attribute name="id">eSENS-T83-R004</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R004] A Call For Tenders Identifier MUST have a schemeURI attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@schemeURI)='urn:uuid'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@schemeURI)='urn:uuid'">
               <xsl:attribute name="id">eSENS-T83-R005</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R005] schemeURI for Call For Tenders Identifier MUST be 'urn:uuid'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
               <xsl:attribute name="id">eSENS-T83-R006</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R006] A Call For Tenders Identifier value MUST be expressed in a UUID syntax (RFC 4122)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeURI')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeURI')]">
            <xsl:attribute name="id">eSENS-T83-S306</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S306] A Call For Tenders Identifier SHOULD NOT have any attributes but schemeURI</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:ContractFolderID"
                 priority="1057"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:ContractFolderID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S309</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S309] ContractFolderID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:IssueTime" priority="1056" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:IssueTime"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(timezone-from-time(.)) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(timezone-from-time(.)) &gt; 0">
               <xsl:attribute name="id">eSENS-T83-R008</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R008] IssueTime MUST include timezone information.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
               <xsl:attribute name="id">eSENS-T83-R009</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R009] IssueTime MUST have a granularity of seconds</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cbc:VersionID" priority="1055" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cbc:VersionID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S312</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S312] VersionID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='REQUIRED']"
                 priority="1054"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='REQUIRED']"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:DocumentStatusCode)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:DocumentStatusCode)=0">
               <xsl:attribute name="id">eSENS-T83-S317</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S317] AdditionalDocumentReference for a Document with DocumentTypeCode='REQUIRED' SHOULD NOT contain any elements but ID, DocumentTypeCode, DocumentStatusCode</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="normalize-space(./cbc:DocumentStatusCode)='NO RETURN'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="normalize-space(./cbc:DocumentStatusCode)='NO RETURN'">
            <xsl:attribute name="id">eSENS-T83-R023</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T83-R023] DocumentStatusCode 'NO RETURN' is NOT valid for an AdditionalDocumentReference with DocumentType 'REQUIRED'</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(./cbc:DocumentDescription) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cbc:DocumentDescription) &gt; 1">
            <xsl:attribute name="id">eSENS-T83-S326</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S326] DocumentDescription SHOULD NOT be used more than once when DocumentTypeCode = 'REQUIRED'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PROVIDED']"
                 priority="1053"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PROVIDED']"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:Attachment)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(./cac:Attachment)">
               <xsl:attribute name="id">eSENS-T83-R036</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R036] A Provided Document Referernce MUST reference the provided document.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PROVIDED']/cbc:DocumentDescription"
                 priority="1052"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PROVIDED']/cbc:DocumentDescription"/>

		    <!--REPORT -->
      <xsl:if test="/ubl:CallForTenders/cac:ProcurementProjectLot[cbc:ID=normalize-space(.)]/cbc:ID != normalize-space(.)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="/ubl:CallForTenders/cac:ProcurementProjectLot[cbc:ID=normalize-space(.)]/cbc:ID != normalize-space(.)">
            <xsl:attribute name="id">eSENS-T83-R030</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T83-R030] DocumentDescription MUST be a valid Procurement Project Lot Identifier"/&gt;</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference"
                 priority="1051"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)-count(./cbc:IssueDate)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentStatusCode)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)-count(./cbc:IssueDate)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentStatusCode)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0">
               <xsl:attribute name="id">eSENS-T83-S316</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S316] AdditionalDocumentReference SHOULD NOT contain any elements but ID, IssueDate, DocumentTypeCode, LocaleCode, VersionID, DocumentStatusCode, DocumentDescription, Attachment.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:DocumentTypeCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(./cbc:DocumentTypeCode)">
               <xsl:attribute name="id">eSENS-T83-S318</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S318] DocumentTypeCode SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:DocumentStatusCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cbc:DocumentStatusCode)">
               <xsl:attribute name="id">eSENS-T83-S323</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S323] DocumentStatusCode SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:ID"
                 priority="1050"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:ID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S319</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S319] Additional Document Reference Identifier SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentTypeCode"
                 priority="1049"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@listID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@listID">
               <xsl:attribute name="id">eSENS-T83-R017</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R017] DocumentTypeCode MUST have a list Identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'">
               <xsl:attribute name="id">eSENS-T83-R018</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R018] listID for DocumentTypeCode MUST be 'urn:eu:esens:cenbii:documentType'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(PROVIDED|REQUIRED)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(PROVIDED|REQUIRED)$')">
               <xsl:attribute name="id">eSENS-T83-R019</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R019] DocumentTypeCode MUST be one of 'PROVIDED' or 'REQUIRED'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S320</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S320] DocumentTypeCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:LocaleCode"
                 priority="1048"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:LocaleCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@listID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@listID">
               <xsl:attribute name="id">eSENS-T83-R014</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R014] LocaleCode MUST have a list Identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@listID)='ISO639-1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@listID)='ISO639-1'">
               <xsl:attribute name="id">eSENS-T83-R015</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R015] listID for LocaleCode MUST be 'ISO639-1'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">
               <xsl:attribute name="id">eSENS-T83-R016</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R016] LocalCode MUST be a valid Language Code.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S321</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S321] LocaleCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:VersionID"
                 priority="1047"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:VersionID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S322</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S322] Additional Document Reference VersionIdentifier SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentStatusCode"
                 priority="1046"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentStatusCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@listID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@listID">
               <xsl:attribute name="id">eSENS-T83-R020</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R020] DocumentStatusCode MUST have a list Identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentStatusType'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentStatusType'">
               <xsl:attribute name="id">eSENS-T83-R021</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R021] listID for DocumentStatusCode MUST be 'urn:eu:esens:cenbii:documentStatusType'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(NO RETURN|RETURN W/O SIGNATURE|RETURN WITH ADVANCED SIGNATURE|RETURN WITH QUALIFIED SIGNATURE)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(NO RETURN|RETURN W/O SIGNATURE|RETURN WITH ADVANCED SIGNATURE|RETURN WITH QUALIFIED SIGNATURE)$')">
               <xsl:attribute name="id">eSENS-T83-R022</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R022] DocumentStatusCode MUST be one of 'NO RETURN', 'RETURN W/O SIGNATURE', 'RETURN WITH ADVANCED SIGNATURE' or 'RETURN WITH QUALIFIED SIGNATURE'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S324</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S324] DocumentStatusCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentDescription"
                 priority="1045"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentDescription"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S325</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S325] DocumentDescription SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment"
                 priority="1044"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:ExternalReference)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:ExternalReference)=0">
               <xsl:attribute name="id">eSENS-T83-S328</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S328] Attachment SHOULD NOT contain any element but ExternalReference</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"
                 priority="1043"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:URI)-count(./cbc:MimeCode)-count(./cbc:FileName)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:URI)-count(./cbc:MimeCode)-count(./cbc:FileName)=0">
               <xsl:attribute name="id">eSENS-T83-S329</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S329] ExternalReference SHOULD NOT contain any element but URI, MimeCode, FileName</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:URI) or (./cbc:FileName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cbc:URI) or (./cbc:FileName)">
               <xsl:attribute name="id">eSENS-T83-R035</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R035] ExternalReference MUST include either URI or FileName</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"
                 priority="1042"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S330</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S330] URI SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode"
                 priority="1041"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S395</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S395] MimeCode SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName"
                 priority="1040"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S396</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S396] FileName SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ContractingParty"
                 priority="1039"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ContractingParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:Party)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:Party)=0">
               <xsl:attribute name="id">eSENS-T83-S333</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S333] ContractingParty SHOULD NOT contain any elements but cac:Party.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ContractingParty/cac:Party"
                 priority="1038"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ContractingParty/cac:Party"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0">
               <xsl:attribute name="id">eSENS-T83-S334</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S334] A ContractingParty/cac:Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cac:PartyIdentification) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./cac:PartyIdentification) = 1">
               <xsl:attribute name="id">eSENS-T83-S336</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S336] PartyIdentification SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="count(./cac:PartyName) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cac:PartyName) &gt; 1">
            <xsl:attribute name="id">eSENS-T83-S338</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S338] PartyName SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(./cac:PartyLegalEntity) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cac:PartyLegalEntity) &gt; 1">
            <xsl:attribute name="id">eSENS-T83-S340</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S340] PartyLegalEntity SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:PartyIdentification) and (./cbc:EndpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
               <xsl:attribute name="id">eSENS-T83-R034</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R034] A Call for Tenders MUST identify the Contracting Body by its party and endpoint identifiers.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:EndpointID" priority="1037" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID">
               <xsl:attribute name="id">eSENS-T83-R012</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R012] An Endpoint Identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">
               <xsl:attribute name="id">eSENS-T83-R013</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R013] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T83-S335</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S335] EndpointID SHOULD NOT have any further attributes but schemeID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyIdentification/cbc:ID" priority="1036" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PartyIdentification/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID">
               <xsl:attribute name="id">eSENS-T83-R010</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R010] A Party Identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">
               <xsl:attribute name="id">eSENS-T83-R011</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R011] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T83-S337</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S337] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:Name" priority="1035" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Name"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S339</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S339] Name SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity"
                 priority="1034"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:RegistrationAddress)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:RegistrationAddress)=0">
               <xsl:attribute name="id">eSENS-T83-S341</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S341] PartyLegalEntity SHOULD NOT contain any elements but cac:RegistrationAddress.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"
                 priority="1033"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:Country)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:Country)=0">
               <xsl:attribute name="id">eSENS-T83-S342</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S342] RegistrationAddress SHOULD NOT contain any elements but cac:Country.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"
                 priority="1032"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:IdentificationCode)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:IdentificationCode)=0">
               <xsl:attribute name="id">eSENS-T83-S343</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S343] Country SHOULD NOT contain any elements but IdentificationCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"
                 priority="1031"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S344</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S344] IdentificationCode SHOULD NOT have any attributes but listID,</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms"
                 priority="1030"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:MaximumVariantQuantity)-count(./cbc:VariantConstraintIndicator)-count(./cbc:Note)-count(./cbc:AdditionalConditions)-count(./cac:ProcurementLegislationDocumentReference)-count(./cac:CallForTendersDocumentReference)-count(./cac:DocumentProviderParty)-count(./cac:TenderRecipientParty)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:MaximumVariantQuantity)-count(./cbc:VariantConstraintIndicator)-count(./cbc:Note)-count(./cbc:AdditionalConditions)-count(./cac:ProcurementLegislationDocumentReference)-count(./cac:CallForTendersDocumentReference)-count(./cac:DocumentProviderParty)-count(./cac:TenderRecipientParty)=0">
               <xsl:attribute name="id">eSENS-T83-S348</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S348] TenderingTerms SHOULD NOT contain any element but MaximumVariantQuantity, VariantConstraintIndicator, Note, AdditionalConditions, ProcurementLegislationDocumentReference, CallForTendersDocumentReference, DocumentProviderParty, TenderRecipientParty.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:VariantConstraintIndicator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cbc:VariantConstraintIndicator)">
               <xsl:attribute name="id">eSENS-T83-S353</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S353] VariantConstraintIndicator SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="count(./cbc:Note) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(./cbc:Note) &gt; 1">
            <xsl:attribute name="id">eSENS-T83-S354</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S354] Note SHOULD NOT be used more than once</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(./cbc:Note) and normalize-space(/ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode)!='POSTAL'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(./cbc:Note) and normalize-space(/ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode)!='POSTAL'">
            <xsl:attribute name="id">eSENS-T83-R031</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T83-R031] Note MUST only be used when Submission Method Code equals to POSTAL</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(./cbc:AdditionalConditions) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cbc:AdditionalConditions) &gt; 1">
            <xsl:attribute name="id">eSENS-T83-S358</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S358] AdditionalConditions SHOULD NOT be used more than once</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity"
                 priority="1029"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^\d+$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^\d+$')">
               <xsl:attribute name="id">eSENS-T83-S349</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S349] MaximumVariantQuantity SHOULD be expressed as an integer value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S350</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S350] MaximumVariantQuantity SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='false']"
                 priority="1028"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='false']"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)=0 or normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)='0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)=0 or normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)='0'">
               <xsl:attribute name="id">eSENS-T83-S351</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S351] MaximumVariantQuantity SHOULD NOT be used or MUST be equal to 0 when VariantConstraintIndicator is set to false.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='true']"
                 priority="1027"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='true']"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="number(normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)) &gt; 0">
               <xsl:attribute name="id">eSENS-T83-R032</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R032] MaximumVariantQuantity MUST be greater than 0 when VariantConstraintIndicator is set to true.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cbc:Note"
                 priority="1026"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cbc:Note"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^\d+$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^\d+$')">
               <xsl:attribute name="id">eSENS-T83-S355</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S355] Note SHOULD be expressed as an integer value when used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S357</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S357] Note SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cbc:AdditionalConditions"
                 priority="1025"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cbc:AdditionalConditions"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^RETURN (W/O SIGNATURE|WITH (ADVANCED|QUALIFIED) SIGNATURE)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^RETURN (W/O SIGNATURE|WITH (ADVANCED|QUALIFIED) SIGNATURE)$')">
               <xsl:attribute name="id">eSENS-T83-R033</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R033] AdditionalConditions value MUST be one of 'RETURN W/O SIGNATURE', 'RETURN WITH ADVANCED SIGNATURE, 'RETURN WITH QUALIFIED SIGNATURE'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S360</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S360] AdditionalConditions SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference"
                 priority="1024"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentDescription)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentDescription)=0">
               <xsl:attribute name="id">eSENS-T83-S361</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S361] ProcurementLegislationDocumentReference SHOULD NOT contain any elements but ID, DocumentDescription.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID"
                 priority="1023"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S362</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S362] ProcurementLegislationDocumentReference Identifier SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:DocumentDescription"
                 priority="1022"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:DocumentDescription"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S363</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S363] ProcurementLegislationDocumentReference DocumentDescription SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference"
                 priority="1021"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)=0">
               <xsl:attribute name="id">eSENS-T83-S364</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S364] CallForTendersDocumentReference SHOULD NOT contain any elements but ID</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/cbc:ID"
                 priority="1020"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeURI"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeURI">
               <xsl:attribute name="id">eSENS-T83-R025</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R025] A Call For Tenders Document Reference Identifier MUST have a schemeURI attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@schemeURI)='urn:uuid'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@schemeURI)='urn:uuid'">
               <xsl:attribute name="id">eSENS-T83-R026</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R026] schemeURI for Call For Tenders Document Reference Identifier MUST be 'urn:uuid'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
               <xsl:attribute name="id">eSENS-T83-R027</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R027] A Call For Tenders Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeURI')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeURI')]">
            <xsl:attribute name="id">eSENS-T83-S365</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S365] A Call For Tenders Document Reference Identifier SHOULD NOT have any attributes but schemeURI</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:DocumentProviderParty"
                 priority="1019"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:DocumentProviderParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:EndpointID)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:EndpointID)=0">
               <xsl:attribute name="id">eSENS-T83-S366</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S366] DocumentProviderParty SHOULD NOT contain any elements but EndpointID</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty"
                 priority="1018"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:EndpointID)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:EndpointID)=0">
               <xsl:attribute name="id">eSENS-T83-S367</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S367] TenderRecipientParty SHOULD NOT contain any elements but EndpointID</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingProcess"
                 priority="1017"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingProcess"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ProcedureCode)-count(./cbc:ContractingSystemCode)-count(./cbc:SubmissionMethodCode)-count(./cac:TenderSubmissionDeadlinePeriod)-count(./cac:ParticipationRequestReceptionPeriod)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ProcedureCode)-count(./cbc:ContractingSystemCode)-count(./cbc:SubmissionMethodCode)-count(./cac:TenderSubmissionDeadlinePeriod)-count(./cac:ParticipationRequestReceptionPeriod)=0">
               <xsl:attribute name="id">eSENS-T83-S369</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S369] TenderingProcess SHOULD NOT contain any elements but ProcedureCode, ContractingSystemCode, SubmissionMethodCode, TenderSubmissionDeadlinePeriod, ParticipationRequestReceptionPeriod.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:ProcedureCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(./cbc:ProcedureCode)">
               <xsl:attribute name="id">eSENS-T83-S370</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S370] ProcedureCode SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:TenderSubmissionDeadlinePeriod)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cac:TenderSubmissionDeadlinePeriod)">
               <xsl:attribute name="id">eSENS-T83-S373</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S373] TenderSubmissionDeadlinePeriod SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(./cbc:ProcedureCode = '1') and (./cac:ParticipationRequestReceptionPeriod)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(./cbc:ProcedureCode = '1') and (./cac:ParticipationRequestReceptionPeriod)">
            <xsl:attribute name="id">eSENS-T83-R037</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T83-R037] Participation Request Reception Period MUST not be given for proceduretypes without participation contest.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingProcess/cbc:ProcedureCode"
                 priority="1016"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingProcess/cbc:ProcedureCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S371</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S371] ProcedureCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingProcess/cbc:ContractingSystemCode"
                 priority="1015"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingProcess/cbc:ContractingSystemCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S397</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S397] ContractingSystemCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode"
                 priority="1014"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S372</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S372] SubmissionMethodCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod"
                 priority="1013"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0">
               <xsl:attribute name="id">eSENS-T83-S374</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S374] TenderSubmissionDeadlinePeriod SHOULD NOT contain any elements but EndDate and EndTime.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:EndDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(./cbc:EndDate)">
               <xsl:attribute name="id">eSENS-T83-S375</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S375] TenderSubmissionDeadlinePeriod EndDate SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod"
                 priority="1012"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0">
               <xsl:attribute name="id">eSENS-T83-S376</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S376] ParticipationRequestReceptionPeriod SHOULD NOT contain any elements but EndDate and EndTime.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:EndTime" priority="1011" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndTime"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(timezone-from-time(.)) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(timezone-from-time(.)) &gt; 0">
               <xsl:attribute name="id">eSENS-T83-R028</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T83-R028] EndTime MUST include timezone information.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject"
                 priority="1010"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:Name)-count(./cbc:Description)-count(./cbc:ProcurementTypeCode)-count(./cac:MainCommodityClassification)-count(./cac:AdditionalCommodityClassification)-count(./cac:RealizedLocation)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:Name)-count(./cbc:Description)-count(./cbc:ProcurementTypeCode)-count(./cac:MainCommodityClassification)-count(./cac:AdditionalCommodityClassification)-count(./cac:RealizedLocation)=0">
               <xsl:attribute name="id">eSENS-T83-S378</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S378] ProcurementProject SHOULD NOT contain any elements but Name, Description, ProcurementTypeCode, MainCommodityClassification, AdditionalCommodityClassification, RealizedLocation.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cbc:Name) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(./cbc:Name) = 1">
               <xsl:attribute name="id">eSENS-T83-S379</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S379] ProcurementProject Name SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cbc:Description) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./cbc:Description) = 1">
               <xsl:attribute name="id">eSENS-T83-S380</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S380] ProcurementProject Description SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cbc:ProcurementTypeCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cbc:ProcurementTypeCode)">
               <xsl:attribute name="id">eSENS-T83-S382</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S382] ProcurementTypeCode SHOULD be used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cac:MainCommodityClassification) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./cac:MainCommodityClassification) = 1">
               <xsl:attribute name="id">eSENS-T83-S384</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S384] ProcurementProject MainCommodityClassification SHOULD be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cac:RealizedLocation) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./cac:RealizedLocation) &gt; 0">
               <xsl:attribute name="id">eSENS-T83-S388</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S388] ProcurementProject RealizedLocation SHOULD be used at least once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject/cbc:Description"
                 priority="1009"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject/cbc:Description"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S381</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S381] ProcurementProject Description SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject/cbc:ProcurementTypeCode"
                 priority="1008"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject/cbc:ProcurementTypeCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S383</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S383] ProcurementTypeCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification"
                 priority="1007"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ItemClassificationCode)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ItemClassificationCode)=0">
               <xsl:attribute name="id">eSENS-T83-S385</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S385] MainCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification"
                 priority="1006"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ItemClassificationCode)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ItemClassificationCode)=0">
               <xsl:attribute name="id">eSENS-T83-S386</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S386] AdditionalCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:ItemClassificationCode" priority="1005" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:ItemClassificationCode"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T83-S387</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S387] ItemClassificationCode SHOULD NOT have any attributes but listID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation"
                 priority="1004"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)=0">
               <xsl:attribute name="id">eSENS-T83-S389</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S389] RealizedLocation SHOULD NOT contain any elements but ID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/cbc:ID"
                 priority="1003"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/cbc:ID"/>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T83-S390</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S390] cac:RealizedLocation/cbc:ID SHOULD NOT have any attributes but schemeID.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProjectLot"
                 priority="1002"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProjectLot"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)-count(./cac:ProcurementProject)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)-count(./cac:ProcurementProject)=0">
               <xsl:attribute name="id">eSENS-T83-S391</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S391] ProcurementProjectLot SHOULD NOT contain any elements but ID, ProcurementProject.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID"
                 priority="1001"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T83-S392</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T83-S392] ProcurementProjectLot Identifier SHOULD NOT contain any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:Name)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:Name)=0">
               <xsl:attribute name="id">eSENS-T83-S393</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S393] ProcurementProjectLot ProcurementProject SHOULD NOT contain any elements but Name.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./cbc:Name) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(./cbc:Name) = 1">
               <xsl:attribute name="id">eSENS-T83-S394</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T83-S394] ProcurementProjectLot ProcurementProject Name SHOULD   be used exactly once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
</xsl:stylesheet>
