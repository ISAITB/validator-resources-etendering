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
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:ExpressionOfInterestResponse-2"
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
                              title="eSENS business and syntax rules for Expression of Interest Response"
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
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:ExpressionOfInterestResponse-2"
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
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">eSENS business and syntax rules for Expression of Interest Response</svrl:text>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*" priority="1000" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*"/>

		    <!--REPORT -->
      <xsl:if test="normalize-space(.) = '' and not(*)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="normalize-space(.) = '' and not(*)">
            <xsl:attribute name="id">eSENS-T82-S002</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T82-S002] An Expression of Interest Confirmation document MUST NOT contain empty elements.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

   <!--PATTERN -->
   <xsl:variable name="syntaxError"
                 select="string('[eSENS-T82-S003] An Expression of Interest Confirmation SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse" priority="1017" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:CustomizationID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CustomizationID)">
               <xsl:attribute name="id">eSENS-T82-R001</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R001] An Expression of Interest Confirmation MUST have a customization identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ProfileID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileID)">
               <xsl:attribute name="id">eSENS-T82-R003</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R003] An Expression of Interest Confirmation MUST have a profile identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID)">
               <xsl:attribute name="id">eSENS-T82-R005</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R005] An Expression of Interest Confirmation MUST have an Expression of Interest Confirmation Identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ContractFolderID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ContractFolderID)">
               <xsl:attribute name="id">eSENS-T82-R009</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R009] An Expression of Interest Confirmation MUST have a ContractFolderID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:IssueDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate)">
               <xsl:attribute name="id">eSENS-T82-R010</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R010] An Expression of Interest Confirmation MUST have an issue date</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:IssueTime)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueTime)">
               <xsl:attribute name="id">eSENS-T82-R011</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R011] An Expression of Interest Confirmation MUST have an issue time</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(cac:ProcurementProjectLotReference/cbc:ID)) = count(cac:ProcurementProjectLotReference/cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(cac:ProcurementProjectLotReference/cbc:ID)) = count(cac:ProcurementProjectLotReference/cbc:ID)">
               <xsl:attribute name="id">eSENS-T82-R023</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R023] Lot identifiers MUST be unique.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="(ext:UBLExtensions)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(ext:UBLExtensions)">
            <xsl:attribute name="id">eSENS-T82-S301</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S301] UBLExtensions SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:UBLVersionID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
            <xsl:attribute name="id">eSENS-T82-S302</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S302] UBLVersionID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:ProfileExectuionID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileExectuionID)">
            <xsl:attribute name="id">eSENS-T82-S305</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S305] ProfileExecutionID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:CopyIndicator)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CopyIndicator)">
            <xsl:attribute name="id">eSENS-T82-S307</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S307] CopyIndicator SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:UUID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UUID)">
            <xsl:attribute name="id">eSENS-T82-S308</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S308] UUID SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:ContractName)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ContractName)">
            <xsl:attribute name="id">eSENS-T82-S310</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S310] ContractName SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cbc:Note)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:Note)">
            <xsl:attribute name="id">eSENS-T82-S312</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S312] Note SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(cac:ExpressionOfInterestDocumentReference) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(cac:ExpressionOfInterestDocumentReference) &gt; 1">
            <xsl:attribute name="id">eSENS-T82-S313</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S313] Expression of Interest Document Reference SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:Signature)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Signature)">
            <xsl:attribute name="id">eSENS-T82-S320</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S320] Signature SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(cac:ContractingParty) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(cac:ContractingParty) &gt; 1">
            <xsl:attribute name="id">eSENS-T82-S331</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S331] ContractingParty SHOULD NOT be used more than once.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="(cac:ProcurementProject)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ProcurementProject)">
            <xsl:attribute name="id">eSENS-T82-S329</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S329] ProcurementProject SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cbc:CustomizationID"
                 priority="1016"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cbc:CustomizationID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm082:ver3.0:extended:urn:www.esens.eu:bis:esens46:ver1.0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm082:ver3.0:extended:urn:www.esens.eu:bis:esens46:ver1.0'">
               <xsl:attribute name="id">eSENS-T82-R002</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R002] CustomizationID value MUST be 'urn:www.cenbii.eu:transaction:biitrdm082:ver3.0:extended:urn:www.esens.eu:bis:esens46:ver1.0'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T82-S303</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S303] CustomizationID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cbc:ProfileID"
                 priority="1015"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cbc:ProfileID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii46:ver3.0'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii46:ver3.0'">
               <xsl:attribute name="id">eSENS-T82-R004</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R004] ProfileID value MUST be 'urn:www.cenbii.eu:profile:bii46:ver3.0'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T82-S304</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S304] ProfileID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cbc:ID"
                 priority="1014"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeURI"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeURI">
               <xsl:attribute name="id">eSENS-T82-R006</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R006] An Expression of Interest Confirmation Identifier MUST have a schemeURI attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@schemeURI)='urn:uuid'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@schemeURI)='urn:uuid'">
               <xsl:attribute name="id">eSENS-T82-R007</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R007] schemeURI for Expression of Interest Confirmation Identifier MUST be 'urn:uuid'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeURI')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeURI')]">
            <xsl:attribute name="id">eSENS-T82-S306</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S306] ID SHOULD NOT have any further attributes but schemeURI</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
               <xsl:attribute name="id">eSENS-T82-R008</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R008] Expression of Interest Confirmation Identifier value MUST be expressed in a UUID syntax (RFC 4122)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cbc:ContractFolderID"
                 priority="1013"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cbc:ContractFolderID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T82-S309</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S309] ContractFolderID SHOULD NOT have any attributes.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cbc:IssueTime"
                 priority="1012"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cbc:IssueTime"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(timezone-from-time(.)) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(timezone-from-time(.)) &gt; 0">
               <xsl:attribute name="id">eSENS-T82-R012</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R012] IssueTime MUST include timezone information.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
               <xsl:attribute name="id">eSENS-T82-R013</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R013] IssueTime MUST have a granularity of seconds</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cbc:TenderLanguageLocaleCode"
                 priority="1011"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cbc:TenderLanguageLocaleCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">
               <xsl:attribute name="id">eSENS-T82-R018</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R018] TenderLanguageLocalCode MUST be a valid Language Code.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@listID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@listID">
               <xsl:attribute name="id">eSENS-T82-R019</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R019] TenderLanguageLocalCode MUST have a list identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@listID)='ISO639-1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@listID)='ISO639-1'">
               <xsl:attribute name="id">eSENS-T82-R020</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R020] listID for TenderLanguageLocaleCode MUST be 'ISO639-1'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='listID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='listID')]">
            <xsl:attribute name="id">eSENS-T82-S311</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S311] TenderLanguageLocaleCode SHOULD NOT have any further attributes but listID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cac:ExpressionOfInterestDocumentReference"
                 priority="1010"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cac:ExpressionOfInterestDocumentReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:ID)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:ID)=0">
               <xsl:attribute name="id">eSENS-T82-S314</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T82-S314] Expression of Interest Document Reference SHOULD NOT contain any other elements but ID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cac:ExpressionOfInterestDocumentReference/cbc:ID"
                 priority="1009"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cac:ExpressionOfInterestDocumentReference/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeURI"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeURI">
               <xsl:attribute name="id">eSENS-T82-R025</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R025] An Expression of Interest Document Reference Identifier MUST have a schemeURI attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(./@schemeURI)='urn:uuid'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(./@schemeURI)='urn:uuid'">
               <xsl:attribute name="id">eSENS-T82-R026</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R026] schemeURI for Expression of Interest Document Reference Identifier SHOULD be 'urn:uuid'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
               <xsl:attribute name="id">eSENS-T82-R027</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R027] Expression of Interest Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeURI')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeURI')]">
            <xsl:attribute name="id">eSENS-T82-S318</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S318] Expression of Interest Document Reference Identifier SHOULD NOT have any further attributes but schemeURI</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="normalize-space(.) = normalize-space(/ubl:ExpressionOfInterestResponse/cbc:ID)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="normalize-space(.) = normalize-space(/ubl:ExpressionOfInterestResponse/cbc:ID)">
            <xsl:attribute name="id">eSENS-T82-R028</xsl:attribute>
            <xsl:attribute name="flag">fatal</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[eSENS-T82-R028] Expression of Interest Document Reference Identifier MUSTS NOT be identical to the Expression of Interest Confirmation Identifier</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cac:EconomicOperatorParty"
                 priority="1008"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cac:EconomicOperatorParty"/>

		    <!--REPORT -->
      <xsl:if test="(cac:EconomicOperatorRole)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(cac:EconomicOperatorRole)">
            <xsl:attribute name="id">eSENS-T82-S321</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S321] EconomicOperatorRole SHOULD NOT be used.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cac:EconomicOperatorParty/cac:Party"
                 priority="1007"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cac:EconomicOperatorParty/cac:Party"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)= 0">
               <xsl:attribute name="id">eSENS-T82-S322</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T82-S322] An EconomicOperatorParty/cac:Party element SHOULD NOT contain any other elements but EndpointID, PartyIdentification</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:PartyIdentification) and (./cbc:EndpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
               <xsl:attribute name="id">eSENS-T82-R015</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R015] An Expression of Interest Confirmation MUST identify the Economic Operator by its party identifier and its endpoint identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cac:ContractingParty"
                 priority="1006"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cac:ContractingParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:Party)=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:Party)=0">
               <xsl:attribute name="id">eSENS-T82-S323</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T82-S323] ContractingParty MUST NOT contain any other elements but cac:Party.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ubl:ExpressionOfInterestResponse/cac:ContractingParty/cac:Party"
                 priority="1005"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:ExpressionOfInterestResponse/cac:ContractingParty/cac:Party"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0">
               <xsl:attribute name="id">eSENS-T82-S324</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="$syntaxError"/>
                  <xsl:text/>[eSENS-T82-S324] A ContractingParty/cac:Party element SHOULD NOT contain any other elements but EndpointID, PartyIdentification, PartyName</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(./cac:PartyIdentification) and (./cbc:EndpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
               <xsl:attribute name="id">eSENS-T82-R014</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R014] An Expression of Interest Confirmation MUST identify the Contracting Body by its party identifier and its endpoint identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Party" priority="1004" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Party"/>

		    <!--REPORT -->
      <xsl:if test="count(./cac:PartyIdentification) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cac:PartyIdentification) &gt; 1">
            <xsl:attribute name="id">eSENS-T82-S325</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S325] PartyIdentification SHOULD NOT be used more than once</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
      <xsl:if test="count(./cac:PartyName) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(./cac:PartyName) &gt; 1">
            <xsl:attribute name="id">eSENS-T82-S326</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S326] PartyName SHOULD NOT be used more than once</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Party/cbc:EndpointID" priority="1003" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:Party/cbc:EndpointID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID">
               <xsl:attribute name="id">eSENS-T82-R021</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R021] An Endpoint Identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">
               <xsl:attribute name="id">eSENS-T82-R022</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R022] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T82-S328</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S328] EndpointID SHOULD NOT have any further attributes but schemeID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyIdentification/cbc:ID" priority="1002" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PartyIdentification/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="./@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID">
               <xsl:attribute name="id">eSENS-T82-R016</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R016] A Party Identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">
               <xsl:attribute name="id">eSENS-T82-R017</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[eSENS-T82-R017] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="./@*[not(name()='schemeID')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="./@*[not(name()='schemeID')]">
            <xsl:attribute name="id">eSENS-T82-S332</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S332] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:Name" priority="1001" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Name"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T82-S327</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S327] cbc:Name SHOULD NOT have any further attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:ProcurementProjectLotReference/cbc:ID"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:ProcurementProjectLotReference/cbc:ID"/>

		    <!--REPORT -->
      <xsl:if test="./@*">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@*">
            <xsl:attribute name="id">eSENS-T82-S330</xsl:attribute>
            <xsl:attribute name="flag">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$syntaxError"/>
               <xsl:text/>[eSENS-T82-S330] cac:ProcurementProjectLotReference/cbc:ID SHOULD NOT have any further attributes</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
</xsl:stylesheet>
