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
                              title="&#xA;    Modified by eSENS:&#xA;    * fixed test conditions in BII3-T90-R010 and R11: wrong documentTypeCode (310 instead of 311) and typo in the elements' name &#xA;  "
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
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Tender-2"
                                             prefix="ubl"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UBL-T90</xsl:attribute>
            <xsl:attribute name="name">UBL-T90</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CodesT90</xsl:attribute>
            <xsl:attribute name="name">CodesT90</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BIIRULES  T90 bound to UBL</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
    Modified by eSENS:
    * fixed test conditions in BII3-T90-R010 and R11: wrong documentTypeCode (310 instead of 311) and typo in the elements' name 
  </svrl:text>

   <!--PATTERN UBL-T90-->


	  <!--RULE -->
   <xsl:template match="/ubl:Tender" priority="1004" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Tender"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:CustomizationID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CustomizationID)">
               <xsl:attribute name="id">BII3-T90-R001</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R001]-A Submit Tender MUST have a customization identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ProfileID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileID)">
               <xsl:attribute name="id">BII3-T90-R002</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R002]-A Submit Tender MUST have a profile identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:TendererParty/cac:PartyIdentification/cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:TendererParty/cac:PartyIdentification/cbc:ID)">
               <xsl:attribute name="id">BII3-T90-R003</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R003]-A Submit Tender MUST have an Economic Operator</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:ContractingParty/cac:Party/cac:PartyIdentification/cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:ContractingParty/cac:Party/cac:PartyIdentification/cbc:ID)">
               <xsl:attribute name="id">BII3-T90-R004</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R004]-A Submit Tender MUST have a Contracting Authority</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:IssueDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate)">
               <xsl:attribute name="id">BII3-T90-R005</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R005]-A Submit Tender MUST have the issue date</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:IssueTime)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueTime)">
               <xsl:attribute name="id">BII3-T90-R006</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R006]-A Submit Tender MUST have the issue time</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(count(timezone-from-time(cbc:IssueTime)) &gt; 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(count(timezone-from-time(cbc:IssueTime)) &gt; 0)">
               <xsl:attribute name="id">BII3-T90-R007</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R007]-Issue time MUST include timezone information</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID)">
               <xsl:attribute name="id">BII3-T90-R008</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R008]-A Submit Tender MUST have a tender identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ContractFolderID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ContractFolderID)">
               <xsl:attribute name="id">BII3-T90-R009</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R009]-A Submit Tender MUST have the Procurement Reference identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:DocumentReference[cbc:DocumentTypeCode='311']/cbc:ID) or not(cac:DocumentReference/cbc:DocumentTypeCode = '311')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:DocumentReference[cbc:DocumentTypeCode='311']/cbc:ID) or not(cac:DocumentReference/cbc:DocumentTypeCode = '311')">
               <xsl:attribute name="id">BII3-T90-R010</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R010]-A Submit Tender MUST have the call for tenders reference</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:DocumentReference[cbc:DocumentTypeCode='311']/cbc:VersionID)  or not(cac:DocumentReference/cbc:DocumentTypeCode = '311')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:DocumentReference[cbc:DocumentTypeCode='311']/cbc:VersionID) or not(cac:DocumentReference/cbc:DocumentTypeCode = '311')">
               <xsl:attribute name="id">BII3-T90-R011</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R011]-A Submit Tender MUST have the call for tenders version number</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:DocumentReference)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:DocumentReference)">
               <xsl:attribute name="id">BII3-T90-R012</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R012]-A Submit Tender MUST have attached documents</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:DocumentReference" priority="1003" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:DocumentReference"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID)">
               <xsl:attribute name="id">BII3-T90-R013</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R013]-An attached document MUST have a document identifier</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:DocumentDescription)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cbc:DocumentDescription)">
               <xsl:attribute name="id">BII3-T90-R014</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R014]-An attached document MUST have a document description</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:DocumentTypeCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:DocumentTypeCode)">
               <xsl:attribute name="id">BII3-T90-R015</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R015]-An attached document MUST have a document type code</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:DocumentReference/cac:Attachment"
                 priority="1002"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:DocumentReference/cac:Attachment"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:ExternalReference/cbc:FileName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:ExternalReference/cbc:FileName)">
               <xsl:attribute name="id">BII3-T90-R016</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R016]-An attached document MUST have a file name</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:ExternalReference/cbc:DocumentHash)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:ExternalReference/cbc:DocumentHash)">
               <xsl:attribute name="id">BII3-T90-R017</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R017]-An attached document MUST have a document digest</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:ExternalReference/cbc:HashAlgorithmMethod)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:ExternalReference/cbc:HashAlgorithmMethod)">
               <xsl:attribute name="id">BII3-T90-R018</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R018]-An attached document MUST have a document digest method code</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:Country" priority="1001" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Country"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:IdentificationCode/@listID='ISO3166-1:Alpha2'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="cbc:IdentificationCode/@listID='ISO3166-1:Alpha2'">
               <xsl:attribute name="id">BII3-T90-R020</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R020]-List identifier for country code must be 'ISO3166-1:Alpha2'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:DocumentTypeCode" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cbc:DocumentTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID='UNCL1001'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID='UNCL1001'">
               <xsl:attribute name="id">BII3-T90-R021</xsl:attribute>
               <xsl:attribute name="flag">Fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[BII3-T90-R021]-List identifier for document type code must be 'UNCL1001'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

   <!--PATTERN CodesT90-->


	  <!--RULE -->
   <xsl:template match="cac:Country//cbc:IdentificationCode"
                 priority="1002"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:Country//cbc:IdentificationCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T90-R001]-A country identification code must be coded using ISO 3166, alpha 2 codes</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:MimeCode" priority="1001" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:MimeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( . = 'application/activemessage' or . = 'application/andrew-inset' or . = 'application/applefile' or . = 'application/atom+xml' or . = 'application/atomicmail' or . = 'application/atomcat+xml' or . = 'application/atomsvc+xml' or . = 'application/auth-policy+xml' or . = 'application/batch-SMTP' or . = 'application/beep+xml' or . = 'application/cals-1840' or . = 'application/ccxml+xml' or . = 'application/cellml+xml' or . = 'application/cnrp+xml' or . = 'application/commonground' or . = 'application/conference-info+xml' or . = 'application/cpl+xml' or . = 'application/csta+xml' or . = 'application/CSTAdata+xml' or . = 'application/cybercash' or . = 'application/davmount+xml' or . = 'application/dca-rft' or . = 'application/dec-dx' or . = 'application/dialog-info+xml' or . = 'application/dicom' or . = 'application/dns' or . = 'application/dvcs' or . = 'application/ecmascript' or . = 'application/EDI-Consent' or . = 'application/EDIFACT' or . = 'application/EDI-X12' or . = 'application/epp+xml' or . = 'application/eshop' or . = 'application/example' or . = 'application/fastinfoset' or . = 'application/fastsoap' or . = 'application/fits' or . = 'application/font-tdpfr' or . = 'application/H224' or . = 'application/http' or . = 'application/hyperstudio' or . = 'application/iges' or . = 'application/im-iscomposing+xml' or . = 'application/index' or . = 'application/index.cmd' or . = 'application/index.obj' or . = 'application/index.response' or . = 'application/index.vnd' or . = 'application/iotp' or . = 'application/ipp' or . = 'application/isup' or . = 'application/javascript' or . = 'application/json' or . = 'application/kpml-request+xml' or . = 'application/kpml-response+xml' or . = 'application/mac-binhex40' or . = 'application/macwriteii' or . = 'application/marc' or . = 'application/mathematica' or . = 'application/mbms-associated-procedure-description+xml' or . = 'application/mbms-deregister+xml' or . = 'application/mbms-envelope+xml' or . = 'application/mbms-msk-response+xml' or . = 'application/mbms-msk+xml' or . = 'application/mbms-protection-description+xml' or . = 'application/mbms-reception-report+xml' or . = 'application/mbms-register-response+xml' or . = 'application/mbms-register+xml' or . = 'application/mbms-user-service-description+xml' or . = 'application/mbox' or . = 'application/media_control+xml' or . = 'application/mediaservercontrol+xml' or . = 'application/mikey' or . = 'application/moss-keys' or . = 'application/moss-signature' or . = 'application/mosskey-data' or . = 'application/mosskey-request' or . = 'application/mpeg4-generic' or . = 'application/mpeg4-iod' or . = 'application/mpeg4-iod-xmt' or . = 'application/mp4' or . = 'application/msword' or . = 'application/mxf' or . = 'application/nasdata' or . = 'application/news-message-id' or . = 'application/news-transmission' or . = 'application/nss' or . = 'application/ocsp-request' or . = 'application/ocsp-response' or . = 'application/octet-stream' or . = 'application/oda' or . = 'application/oebps-package+xml' or . = 'application/ogg' or . = 'application/parityfec' or . = 'application/pdf' or . = 'application/pgp-encrypted' or . = 'application/pgp-keys' or . = 'application/pgp-signature' or . = 'application/pidf+xml' or . = 'application/pkcs10' or . = 'application/pkcs7-mime' or . = 'application/pkcs7-signature' or . = 'application/pkix-cert' or . = 'application/pkixcmp' or . = 'application/pkix-crl' or . = 'application/pkix-pkipath' or . = 'application/pls+xml' or . = 'application/poc-settings+xml' or . = 'application/postscript' or . = 'application/prs.alvestrand.titrax-sheet' or . = 'application/prs.cww' or . = 'application/prs.nprend' or . = 'application/prs.plucker' or . = 'application/rdf+xml' or . = 'application/qsig' or . = 'application/reginfo+xml' or . = 'application/relax-ng-compact-syntax' or . = 'application/remote-printing' or . = 'application/resource-lists+xml' or . = 'application/riscos' or . = 'application/rlmi+xml' or . = 'application/rls-services+xml' or . = 'application/rtf' or . = 'application/rtx' or . = 'application/samlassertion+xml' or . = 'application/samlmetadata+xml' or . = 'application/sbml+xml' or . = 'application/scvp-cv-request' or . = 'application/scvp-cv-response' or . = 'application/scvp-vp-request' or . = 'application/scvp-vp-response' or . = 'application/sdp' or . = 'application/set-payment' or . = 'application/set-payment-initiation' or . = 'application/set-registration' or . = 'application/set-registration-initiation' or . = 'application/sgml' or . = 'application/sgml-open-catalog' or . = 'application/shf+xml' or . = 'application/sieve' or . = 'application/simple-filter+xml' or . = 'application/simple-message-summary' or . = 'application/simpleSymbolContainer' or . = 'application/slate' or . = 'application/smil (OBSOLETE)' or . = 'application/smil+xml' or . = 'application/soap+fastinfoset' or . = 'application/soap+xml' or . = 'application/sparql-query' or . = 'application/sparql-results+xml' or . = 'application/spirits-event+xml' or . = 'application/srgs' or . = 'application/srgs+xml' or . = 'application/ssml+xml' or . = 'application/timestamp-query' or . = 'application/timestamp-reply' or . = 'application/tve-trigger' or . = 'application/ulpfec' or . = 'application/vemmi' or . = 'application/vnd.3gpp.bsf+xml' or . = 'application/vnd.3gpp.pic-bw-large' or . = 'application/vnd.3gpp.pic-bw-small' or . = 'application/vnd.3gpp.pic-bw-var' or . = 'application/vnd.3gpp.sms' or . = 'application/vnd.3gpp2.bcmcsinfo+xml' or . = 'application/vnd.3gpp2.sms' or . = 'application/vnd.3gpp2.tcap' or . = 'application/vnd.3M.Post-it-Notes' or . = 'application/vnd.accpac.simply.aso' or . = 'application/vnd.accpac.simply.imp' or . = 'application/vnd.acucobol' or . = 'application/vnd.acucorp' or . = 'application/vnd.adobe.xdp+xml' or . = 'application/vnd.adobe.xfdf' or . = 'application/vnd.aether.imp' or . = 'application/vnd.americandynamics.acc' or . = 'application/vnd.amiga.ami' or . = 'application/vnd.anser-web-certificate-issue-initiation' or . = 'application/vnd.antix.game-component' or . = 'application/vnd.apple.installer+xml' or . = 'application/vnd.audiograph' or . = 'application/vnd.autopackage' or . = 'application/vnd.avistar+xml' or . = 'application/vnd.blueice.multipass' or . = 'application/vnd.bmi' or . = 'application/vnd.businessobjects' or . = 'application/vnd.cab-jscript' or . = 'application/vnd.canon-cpdl' or . = 'application/vnd.canon-lips' or . = 'application/vnd.cendio.thinlinc.clientconf' or . = 'application/vnd.chemdraw+xml' or . = 'application/vnd.chipnuts.karaoke-mmd' or . = 'application/vnd.cinderella' or . = 'application/vnd.cirpack.isdn-ext' or . = 'application/vnd.claymore' or . = 'application/vnd.clonk.c4group' or . = 'application/vnd.commerce-battelle' or . = 'application/vnd.commonspace' or . = 'application/vnd.cosmocaller' or . = 'application/vnd.contact.cmsg' or . = 'application/vnd.crick.clicker' or . = 'application/vnd.crick.clicker.keyboard' or . = 'application/vnd.crick.clicker.palette' or . = 'application/vnd.crick.clicker.template' or . = 'application/vnd.crick.clicker.wordbank' or . = 'application/vnd.criticaltools.wbs+xml' or . = 'application/vnd.ctc-posml' or . = 'application/vnd.ctct.ws+xml' or . = 'application/vnd.cups-pdf' or . = 'application/vnd.cups-postscript' or . = 'application/vnd.cups-ppd' or . = 'application/vnd.cups-raster' or . = 'application/vnd.cups-raw' or . = 'application/vnd.curl' or . = 'application/vnd.cybank' or . = 'application/vnd.data-vision.rdz' or . = 'application/vnd.denovo.fcselayout-link' or . = 'application/vnd.dna' or . = 'application/vnd.dpgraph' or . = 'application/vnd.dreamfactory' or . = 'application/vnd.dvb.esgcontainer' or . = 'application/vnd.dvb.ipdcesgaccess' or . = 'application/vnd.dxr' or . = 'application/vnd.ecdis-update' or . = 'application/vnd.ecowin.chart' or . = 'application/vnd.ecowin.filerequest' or . = 'application/vnd.ecowin.fileupdate' or . = 'application/vnd.ecowin.series' or . = 'application/vnd.ecowin.seriesrequest' or . = 'application/vnd.ecowin.seriesupdate' or . = 'application/vnd.enliven' or . = 'application/vnd.epson.esf' or . = 'application/vnd.epson.msf' or . = 'application/vnd.epson.quickanime' or . = 'application/vnd.epson.salt' or . = 'application/vnd.epson.ssf' or . = 'application/vnd.ericsson.quickcall' or . = 'application/vnd.eszigno3+xml' or . = 'application/vnd.eudora.data' or . = 'application/vnd.ezpix-album' or . = 'application/vnd.ezpix-package' or . = 'application/vnd.fdf' or . = 'application/vnd.ffsns' or . = 'application/vnd.fints' or . = 'application/vnd.FloGraphIt' or . = 'application/vnd.fluxtime.clip' or . = 'application/vnd.framemaker' or . = 'application/vnd.frogans.fnc' or . = 'application/vnd.frogans.ltf' or . = 'application/vnd.fsc.weblaunch' or . = 'application/vnd.fujitsu.oasys' or . = 'application/vnd.fujitsu.oasys2' or . = 'application/vnd.fujitsu.oasys3' or . = 'application/vnd.fujitsu.oasysgp' or . = 'application/vnd.fujitsu.oasysprs' or . = 'application/vnd.fujixerox.ART4' or . = 'application/vnd.fujixerox.ART-EX' or . = 'application/vnd.fujixerox.ddd' or . = 'application/vnd.fujixerox.docuworks' or . = 'application/vnd.fujixerox.docuworks.binder' or . = 'application/vnd.fujixerox.HBPL' or . = 'application/vnd.fut-misnet' or . = 'application/vnd.fuzzysheet' or . = 'application/vnd.genomatix.tuxedo' or . = 'application/vnd.google-earth.kml+xml' or . = 'application/vnd.google-earth.kmz' or . = 'application/vnd.grafeq' or . = 'application/vnd.gridmp' or . = 'application/vnd.groove-account' or . = 'application/vnd.groove-help' or . = 'application/vnd.groove-identity-message' or . = 'application/vnd.groove-injector' or . = 'application/vnd.groove-tool-message' or . = 'application/vnd.groove-tool-template' or . = 'application/vnd.groove-vcard' or . = 'application/vnd.HandHeld-Entertainment+xml' or . = 'application/vnd.hbci' or . = 'application/vnd.hcl-bireports' or . = 'application/vnd.hhe.lesson-player' or . = 'application/vnd.hp-HPGL' or . = 'application/vnd.hp-hpid' or . = 'application/vnd.hp-hps' or . = 'application/vnd.hp-jlyt' or . = 'application/vnd.hp-PCL' or . = 'application/vnd.hp-PCLXL' or . = 'application/vnd.httphone' or . = 'application/vnd.hzn-3d-crossword' or . = 'application/vnd.ibm.afplinedata' or . = 'application/vnd.ibm.electronic-media' or . = 'application/vnd.ibm.MiniPay' or . = 'application/vnd.ibm.modcap' or . = 'application/vnd.ibm.rights-management' or . = 'application/vnd.ibm.secure-container' or . = 'application/vnd.iccprofile' or . = 'application/vnd.igloader' or . = 'application/vnd.immervision-ivp' or . = 'application/vnd.immervision-ivu' or . = 'application/vnd.informedcontrol.rms+xml' or . = 'application/vnd.informix-visionary' or . = 'application/vnd.intercon.formnet' or . = 'application/vnd.intertrust.digibox' or . = 'application/vnd.intertrust.nncp' or . = 'application/vnd.intu.qbo' or . = 'application/vnd.intu.qfx' or . = 'application/vnd.ipunplugged.rcprofile' or . = 'application/vnd.irepository.package+xml' or . = 'application/vnd.is-xpr' or . = 'application/vnd.jam' or . = 'application/vnd.japannet-directory-service' or . = 'application/vnd.japannet-jpnstore-wakeup' or . = 'application/vnd.japannet-payment-wakeup' or . = 'application/vnd.japannet-registration' or . = 'application/vnd.japannet-registration-wakeup' or . = 'application/vnd.japannet-setstore-wakeup' or . = 'application/vnd.japannet-verification' or . = 'application/vnd.japannet-verification-wakeup' or . = 'application/vnd.jcp.javame.midlet-rms' or . = 'application/vnd.jisp' or . = 'application/vnd.joost.joda-archive' or . = 'application/vnd.kahootz' or . = 'application/vnd.kde.karbon' or . = 'application/vnd.kde.kchart' or . = 'application/vnd.kde.kformula' or . = 'application/vnd.kde.kivio' or . = 'application/vnd.kde.kontour' or . = 'application/vnd.kde.kpresenter' or . = 'application/vnd.kde.kspread' or . = 'application/vnd.kde.kword' or . = 'application/vnd.kenameaapp' or . = 'application/vnd.kidspiration' or . = 'application/vnd.Kinar' or . = 'application/vnd.koan' or . = 'application/vnd.kodak-descriptor' or . = 'application/vnd.liberty-request+xml' or . = 'application/vnd.llamagraphics.life-balance.desktop' or . = 'application/vnd.llamagraphics.life-balance.exchange+xml' or . = 'application/vnd.lotus-1-2-3' or . = 'application/vnd.lotus-approach' or . = 'application/vnd.lotus-freelance' or . = 'application/vnd.lotus-notes' or . = 'application/vnd.lotus-organizer' or . = 'application/vnd.lotus-screencam' or . = 'application/vnd.lotus-wordpro' or . = 'application/vnd.macports.portpkg' or . = 'application/vnd.marlin.drm.actiontoken+xml' or . = 'application/vnd.marlin.drm.conftoken+xml' or . = 'application/vnd.marlin.drm.mdcf' or . = 'application/vnd.mcd' or . = 'application/vnd.medcalcdata' or . = 'application/vnd.mediastation.cdkey' or . = 'application/vnd.meridian-slingshot' or . = 'application/vnd.MFER' or . = 'application/vnd.mfmp' or . = 'application/vnd.micrografx.flo' or . = 'application/vnd.micrografx.igx' or . = 'application/vnd.mif' or . = 'application/vnd.minisoft-hp3000-save' or . = 'application/vnd.mitsubishi.misty-guard.trustweb' or . = 'application/vnd.Mobius.DAF' or . = 'application/vnd.Mobius.DIS' or . = 'application/vnd.Mobius.MBK' or . = 'application/vnd.Mobius.MQY' or . = 'application/vnd.Mobius.MSL' or . = 'application/vnd.Mobius.PLC' or . = 'application/vnd.Mobius.TXF' or . = 'application/vnd.mophun.application' or . = 'application/vnd.mophun.certificate' or . = 'application/vnd.motorola.flexsuite' or . = 'application/vnd.motorola.flexsuite.adsi' or . = 'application/vnd.motorola.flexsuite.fis' or . = 'application/vnd.motorola.flexsuite.gotap' or . = 'application/vnd.motorola.flexsuite.kmr' or . = 'application/vnd.motorola.flexsuite.ttc' or . = 'application/vnd.motorola.flexsuite.wem' or . = 'application/vnd.mozilla.xul+xml' or . = 'application/vnd.ms-artgalry' or . = 'application/vnd.ms-asf' or . = 'application/vnd.ms-cab-compressed' or . = 'application/vnd.mseq' or . = 'application/vnd.ms-excel' or . = 'application/vnd.ms-fontobject' or . = 'application/vnd.ms-htmlhelp' or . = 'application/vnd.msign' or . = 'application/vnd.ms-ims' or . = 'application/vnd.ms-lrm' or . = 'application/vnd.ms-playready.initiator+xml' or . = 'application/vnd.ms-powerpoint' or . = 'application/vnd.ms-project' or . = 'application/vnd.ms-tnef' or . = 'application/vnd.ms-wmdrm.lic-chlg-req' or . = 'application/vnd.ms-wmdrm.lic-resp' or . = 'application/vnd.ms-wmdrm.meter-chlg-req' or . = 'application/vnd.ms-wmdrm.meter-resp' or . = 'application/vnd.ms-works' or . = 'application/vnd.ms-wpl' or . = 'application/vnd.ms-xpsdocument' or . = 'application/vnd.multiad.creator' or . = 'application/vnd.multiad.creator.cif' or . = 'application/vnd.musician' or . = 'application/vnd.music-niff' or . = 'application/vnd.muvee.style' or . = 'application/vnd.ncd.control' or . = 'application/vnd.ncd.reference' or . = 'application/vnd.nervana' or . = 'application/vnd.netfpx' or . = 'application/vnd.neurolanguage.nlu' or . = 'application/vnd.noblenet-directory' or . = 'application/vnd.noblenet-sealer' or . = 'application/vnd.noblenet-web' or . = 'application/vnd.nokia.catalogs' or . = 'application/vnd.nokia.conml+wbxml' or . = 'application/vnd.nokia.conml+xml' or . = 'application/vnd.nokia.iptv.config+xml' or . = 'application/vnd.nokia.iSDS-radio-presets' or . = 'application/vnd.nokia.landmark+wbxml' or . = 'application/vnd.nokia.landmark+xml' or . = 'application/vnd.nokia.landmarkcollection+xml' or . = 'application/vnd.nokia.ncd' or . = 'application/vnd.nokia.n-gage.ac+xml' or . = 'application/vnd.nokia.n-gage.data' or . = 'application/vnd.nokia.n-gage.symbian.install' or . = 'application/vnd.nokia.pcd+wbxml' or . = 'application/vnd.nokia.pcd+xml' or . = 'application/vnd.nokia.radio-preset' or . = 'application/vnd.nokia.radio-presets' or . = 'application/vnd.novadigm.EDM' or . = 'application/vnd.novadigm.EDX' or . = 'application/vnd.novadigm.EXT' or . = 'application/vnd.oasis.opendocument.chart' or . = 'application/vnd.oasis.opendocument.chart-template' or . = 'application/vnd.oasis.opendocument.formula' or . = 'application/vnd.oasis.opendocument.formula-template' or . = 'application/vnd.oasis.opendocument.graphics' or . = 'application/vnd.oasis.opendocument.graphics-template' or . = 'application/vnd.oasis.opendocument.image' or . = 'application/vnd.oasis.opendocument.image-template' or . = 'application/vnd.oasis.opendocument.presentation' or . = 'application/vnd.oasis.opendocument.presentation-template' or . = 'application/vnd.oasis.opendocument.spreadsheet' or . = 'application/vnd.oasis.opendocument.spreadsheet-template' or . = 'application/vnd.oasis.opendocument.text' or . = 'application/vnd.oasis.opendocument.text-master' or . = 'application/vnd.oasis.opendocument.text-template' or . = 'application/vnd.oasis.opendocument.text-web' or . = 'application/vnd.obn' or . = 'application/vnd.olpc-sugar' or . = 'application/vnd.oma.bcast.associated-procedure-parameter+xml' or . = 'application/vnd.oma.bcast.drm-trigger+xml' or . = 'application/vnd.oma.bcast.imd+xml' or . = 'application/vnd.oma.bcast.ltkm' or . = 'application/vnd.oma.bcast.notification+xml' or . = 'application/vnd.oma.bcast.sgboot' or . = 'application/vnd.oma.bcast.sgdd+xml' or . = 'application/vnd.oma.bcast.sgdu' or . = 'application/vnd.oma.bcast.simple-symbol-container' or . = 'application/vnd.oma.bcast.smartcard-trigger+xml' or . = 'application/vnd.oma.bcast.sprov+xml' or . = 'application/vnd.oma.bcast.stkm' or . = 'application/vnd.oma.dd2+xml' or . = 'application/vnd.oma.drm.risd+xml' or . = 'application/vnd.oma.group-usage-list+xml' or . = 'application/vnd.oma.poc.detailed-progress-report+xml' or . = 'application/vnd.oma.poc.final-report+xml' or . = 'application/vnd.oma.poc.groups+xml' or . = 'application/vnd.oma.poc.invocation-descriptor+xml' or . = 'application/vnd.oma.poc.optimized-progress-report+xml' or . = 'application/vnd.oma.xcap-directory+xml' or . = 'application/vnd.omads-email+xml' or . = 'application/vnd.omads-file+xml' or . = 'application/vnd.omads-folder+xml' or . = 'application/vnd.omaloc-supl-init' or . = 'application/vnd.oma-scws-config' or . = 'application/vnd.oma-scws-http-request' or . = 'application/vnd.oma-scws-http-response' or . = 'application/vnd.openofficeorg.extension' or . = 'application/vnd.osa.netdeploy' or . = 'application/vnd.osgi.bundle' or . = 'application/vnd.osgi.dp' or . = 'application/vnd.otps.ct-kip+xml' or . = 'application/vnd.palm' or . = 'application/vnd.paos.xml' or . = 'application/vnd.pg.format' or . = 'application/vnd.pg.osasli' or . = 'application/vnd.piaccess.application-licence' or . = 'application/vnd.picsel' or . = 'application/vnd.poc.group-advertisement+xml' or . = 'application/vnd.pocketlearn' or . = 'application/vnd.powerbuilder6' or . = 'application/vnd.powerbuilder6-s' or . = 'application/vnd.powerbuilder7' or . = 'application/vnd.powerbuilder75' or . = 'application/vnd.powerbuilder75-s' or . = 'application/vnd.powerbuilder7-s' or . = 'application/vnd.preminet' or . = 'application/vnd.previewsystems.box' or . = 'application/vnd.proteus.magazine' or . = 'application/vnd.publishare-delta-tree' or . = 'application/vnd.pvi.ptid1' or . = 'application/vnd.pwg-multiplexed' or . = 'application/vnd.pwg-xhtml-print+xml' or . = 'application/vnd.qualcomm.brew-app-res' or . = 'application/vnd.Quark.QuarkXPress' or . = 'application/vnd.rapid' or . = 'application/vnd.recordare.musicxml' or . = 'application/vnd.recordare.musicxml+xml' or . = 'application/vnd.RenLearn.rlprint' or . = 'application/vnd.ruckus.download' or . = 'application/vnd.s3sms' or . = 'application/vnd.sbm.mid2' or . = 'application/vnd.scribus' or . = 'application/vnd.sealed.3df' or . = 'application/vnd.sealed.csf' or . = 'application/vnd.sealed.doc' or . = 'application/vnd.sealed.eml' or . = 'application/vnd.sealed.mht' or . = 'application/vnd.sealed.net' or . = 'application/vnd.sealed.ppt' or . = 'application/vnd.sealed.tiff' or . = 'application/vnd.sealed.xls' or . = 'application/vnd.sealedmedia.softseal.html' or . = 'application/vnd.sealedmedia.softseal.pdf' or . = 'application/vnd.seemail' or . = 'application/vnd.sema' or . = 'application/vnd.semd' or . = 'application/vnd.semf' or . = 'application/vnd.shana.informed.formdata' or . = 'application/vnd.shana.informed.formtemplate' or . = 'application/vnd.shana.informed.interchange' or . = 'application/vnd.shana.informed.package' or . = 'application/vnd.SimTech-MindMapper' or . = 'application/vnd.smaf' or . = 'application/vnd.solent.sdkm+xml' or . = 'application/vnd.spotfire.dxp' or . = 'application/vnd.spotfire.sfs' or . = 'application/vnd.sss-cod' or . = 'application/vnd.sss-dtf' or . = 'application/vnd.sss-ntf' or . = 'application/vnd.street-stream' or . = 'application/vnd.sun.wadl+xml' or . = 'application/vnd.sus-calendar' or . = 'application/vnd.svd' or . = 'application/vnd.swiftview-ics' or . = 'application/vnd.syncml.dm+wbxml' or . = 'application/vnd.syncml.dm+xml' or . = 'application/vnd.syncml.ds.notification' or . = 'application/vnd.syncml+xml' or . = 'application/vnd.tao.intent-module-archive' or . = 'application/vnd.tmobile-livetv' or . = 'application/vnd.trid.tpt' or . = 'application/vnd.triscape.mxs' or . = 'application/vnd.trueapp' or . = 'application/vnd.truedoc' or . = 'application/vnd.ufdl' or . = 'application/vnd.uiq.theme' or . = 'application/vnd.umajin' or . = 'application/vnd.unity' or . = 'application/vnd.uoml+xml' or . = 'application/vnd.uplanet.alert' or . = 'application/vnd.uplanet.alert-wbxml' or . = 'application/vnd.uplanet.bearer-choice' or . = 'application/vnd.uplanet.bearer-choice-wbxml' or . = 'application/vnd.uplanet.cacheop' or . = 'application/vnd.uplanet.cacheop-wbxml' or . = 'application/vnd.uplanet.channel' or . = 'application/vnd.uplanet.channel-wbxml' or . = 'application/vnd.uplanet.list' or . = 'application/vnd.uplanet.listcmd' or . = 'application/vnd.uplanet.listcmd-wbxml' or . = 'application/vnd.uplanet.list-wbxml' or . = 'application/vnd.uplanet.signal' or . = 'application/vnd.vcx' or . = 'application/vnd.vectorworks' or . = 'application/vnd.vd-study' or . = 'application/vnd.vidsoft.vidconference' or . = 'application/vnd.visio' or . = 'application/vnd.visionary' or . = 'application/vnd.vividence.scriptfile' or . = 'application/vnd.vsf' or . = 'application/vnd.wap.sic' or . = 'application/vnd.wap.slc' or . = 'application/vnd.wap.wbxml' or . = 'application/vnd.wap.wmlc' or . = 'application/vnd.wap.wmlscriptc' or . = 'application/vnd.webturbo' or . = 'application/vnd.wfa.wsc' or . = 'application/vnd.wmc' or . = 'application/vnd.wmf.bootstrap' or . = 'application/vnd.wordperfect' or . = 'application/vnd.wqd' or . = 'application/vnd.wrq-hp3000-labelled' or . = 'application/vnd.wt.stf' or . = 'application/vnd.wv.csp+xml' or . = 'application/vnd.wv.csp+wbxml' or . = 'application/vnd.wv.ssp+xml' or . = 'application/vnd.xara' or . = 'application/vnd.xfdl' or . = 'application/vnd.xmpie.cpkg' or . = 'application/vnd.xmpie.dpkg' or . = 'application/vnd.xmpie.plan' or . = 'application/vnd.xmpie.ppkg' or . = 'application/vnd.xmpie.xlim' or . = 'application/vnd.yamaha.hv-dic' or . = 'application/vnd.yamaha.hv-script' or . = 'application/vnd.yamaha.hv-voice' or . = 'application/vnd.yamaha.smaf-audio' or . = 'application/vnd.yamaha.smaf-phrase' or . = 'application/vnd.yellowriver-custom-menu' or . = 'application/vnd.zzazz.deck+xml' or . = 'application/voicexml+xml' or . = 'application/watcherinfo+xml' or . = 'application/whoispp-query' or . = 'application/whoispp-response' or . = 'application/wita' or . = 'application/wordperfect5.1' or . = 'application/wsdl+xml' or . = 'application/wspolicy+xml' or . = 'application/x400-bp' or . = 'application/xcap-att+xml' or . = 'application/xcap-caps+xml' or . = 'application/xcap-el+xml' or . = 'application/xcap-error+xml' or . = 'application/xcap-ns+xml' or . = 'application/xenc+xml' or . = 'application/xhtml-voice+xml (Obsolete)' or . = 'application/xhtml+xml' or . = 'application/xml' or . = 'application/xml-dtd' or . = 'application/xml-external-parsed-entity' or . = 'application/xmpp+xml' or . = 'application/xop+xml' or . = 'application/xv+xml' or . = 'application/zip' or . = 'audio/32kadpcm' or . = 'audio/3gpp' or . = 'audio/3gpp2' or . = 'audio/ac3' or . = 'audio/AMR' or . = 'audio/AMR-WB' or . = 'audio/amr-wb+' or . = 'audio/asc' or . = 'audio/basic' or . = 'audio/BV16' or . = 'audio/BV32' or . = 'audio/clearmode' or . = 'audio/CN' or . = 'audio/DAT12' or . = 'audio/dls' or . = 'audio/dsr-es201108' or . = 'audio/dsr-es202050' or . = 'audio/dsr-es202211' or . = 'audio/dsr-es202212' or . = 'audio/eac3' or . = 'audio/DVI4' or . = 'audio/EVRC' or . = 'audio/EVRC0' or . = 'audio/EVRC1' or . = 'audio/EVRCB' or . = 'audio/EVRCB0' or . = 'audio/EVRCB1' or . = 'audio/EVRC-QCP' or . = 'audio/EVRCWB' or . = 'audio/EVRCWB0' or . = 'audio/EVRCWB1' or . = 'audio/example' or . = 'audio/G722' or . = 'audio/G7221' or . = 'audio/G723' or . = 'audio/G726-16' or . = 'audio/G726-24' or . = 'audio/G726-32' or . = 'audio/G726-40' or . = 'audio/G728' or . = 'audio/G729' or . = 'audio/G7291' or . = 'audio/G729D' or . = 'audio/G729E' or . = 'audio/GSM' or . = 'audio/GSM-EFR' or . = 'audio/iLBC' or . = 'audio/L8' or . = 'audio/L16' or . = 'audio/L20' or . = 'audio/L24' or . = 'audio/LPC' or . = 'audio/mobile-xmf' or . = 'audio/MPA' or . = 'audio/mp4' or . = 'audio/MP4A-LATM' or . = 'audio/mpa-robust' or . = 'audio/mpeg' or . = 'audio/mpeg4-generic' or . = 'audio/parityfec' or . = 'audio/PCMA' or . = 'audio/PCMU' or . = 'audio/prs.sid' or . = 'audio/QCELP' or . = 'audio/RED' or . = 'audio/rtp-enc-aescm128' or . = 'audio/rRFC2045tp-midi' or . = 'audio/rtx' or . = 'audio/SMV' or . = 'audio/SMV0' or . = 'audio/SMV-QCP' or . = 'audio/sp-midi' or . = 'audio/t140c' or . = 'audio/t38' or . = 'audio/telephone-event' or . = 'audio/tone' or . = 'audio/ulpfec' or . = 'audio/VDVI' or . = 'audio/VMR-WB' or . = 'audio/vnd.3gpp.iufp' or . = 'audio/vnd.4SB' or . = 'audio/vnd.audiokoz' or . = 'audio/vnd.CELP' or . = 'audio/vnd.cisco.nse' or . = 'audio/vnd.cmles.radio-events' or . = 'audio/vnd.cns.anp1' or . = 'audio/vnd.cns.inf1' or . = 'audio/vnd.digital-winds' or . = 'audio/vnd.dlna.adts' or . = 'audio/vnd.dolby.mlp' or . = 'audio/vnd.everad.plj' or . = 'audio/vnd.hns.audio' or . = 'audio/vnd.lucent.voice' or . = 'audio/vnd.nokia.mobile-xmf' or . = 'audio/vnd.nortel.vbk' or . = 'audio/vnd.nuera.ecelp4800' or . = 'audio/vnd.nuera.ecelp7470' or . = 'audio/vnd.nuera.ecelp9600' or . = 'audio/vnd.octel.sbc' or . = 'audio/vnd.qcelp - DEPRECATED - Please use audio/qcelp' or . = 'audio/vnd.rhetorex.32kadpcm' or . = 'audio/vnd.sealedmedia.softseal.mpeg' or . = 'audio/vnd.vmx.cvsd' or . = 'image/cgm' or . = 'image/example' or . = 'image/fits' or . = 'image/g3fax' or . = 'image/gif' or . = 'image/ief' or . = 'image/jp2' or . = 'image/jpeg' or . = 'image/jpm' or . = 'image/jpx' or . = 'image/naplps' or . = 'image/png' or . = 'image/prs.btif' or . = 'image/prs.pti' or . = 'image/t38' or . = 'image/tiff' or . = 'image/tiff-fx' or . = 'image/vnd.adobe.photoshop' or . = 'image/vnd.cns.inf2' or . = 'image/vnd.djvu' or . = 'image/vnd.dwg' or . = 'image/vnd.dxf' or . = 'image/vnd.fastbidsheet' or . = 'image/vnd.fpx' or . = 'image/vnd.fst' or . = 'image/vnd.fujixerox.edmics-mmr' or . = 'image/vnd.fujixerox.edmics-rlc' or . = 'image/vnd.globalgraphics.pgb' or . = 'image/vnd.microsoft.icon' or . = 'image/vnd.mix' or . = 'image/vnd.ms-modi' or . = 'image/vnd.net-fpx' or . = 'image/vnd.sealed.png' or . = 'image/vnd.sealedmedia.softseal.gif' or . = 'image/vnd.sealedmedia.softseal.jpg' or . = 'image/vnd.svf' or . = 'image/vnd.wap.wbmp' or . = 'image/vnd.xiff' or . = 'message/CPIM' or . = 'message/delivery-status' or . = 'message/disposition-notification' or . = 'message/example' or . = 'message/external-body' or . = 'message/http' or . = 'message/news' or . = 'message/partial' or . = 'message/rfc822' or . = 'message/s-http' or . = 'message/sip' or . = 'message/sipfrag' or . = 'message/tracking-status' or . = 'message/vnd.si.simp' or . = 'model/example' or . = 'model/iges' or . = 'model/mesh' or . = 'model/vnd.dwf' or . = 'model/vnd.flatland.3dml' or . = 'model/vnd.gdl' or . = 'model/vnd.gs-gdl' or . = 'model/vnd.gtw' or . = 'model/vnd.moml+xml' or . = 'model/vnd.mts' or . = 'model/vnd.parasolid.transmit.binary' or . = 'model/vnd.parasolid.transmit.text' or . = 'model/vnd.vtu' or . = 'model/vrml' or . = 'multipart/alternative' or . = 'multipart/appledouble' or . = 'multipart/byteranges' or . = 'multipart/digest' or . = 'multipart/encrypted' or . = 'multipart/example' or . = 'multipart/form-data' or . = 'multipart/header-set' or . = 'multipart/mixed' or . = 'multipart/parallel' or . = 'multipart/related' or . = 'multipart/report' or . = 'multipart/signed' or . = 'multipart/voice-message' or . = 'text/calendar' or . = 'text/css' or . = 'text/csv' or . = 'text/directory' or . = 'text/dns' or . = 'text/ecmascript (obsolete)' or . = 'text/enriched' or . = 'text/example' or . = 'text/html' or . = 'text/javascript (obsolete)' or . = 'text/parityfec' or . = 'text/plain' or . = 'text/prs.fallenstein.rst' or . = 'text/prs.lines.tag' or . = 'text/RED' or . = 'text/rfc822-headers' or . = 'text/richtext' or . = 'text/rtf' or . = 'text/rtp-enc-aescm128' or . = 'text/rtx' or . = 'text/sgml' or . = 'text/t140' or . = 'text/tab-separated-values' or . = 'text/troff' or . = 'text/ulpfec' or . = 'text/uri-list' or . = 'text/vnd.abc' or . = 'text/vnd.curl' or . = 'text/vnd.DMClientScript' or . = 'text/vnd.esmertec.theme-descriptor' or . = 'text/vnd.fly' or . = 'text/vnd.fmi.flexstor' or . = 'text/vnd.in3d.3dml' or . = 'text/vnd.in3d.spot' or . = 'text/vnd.IPTC.NewsML' or . = 'text/vnd.IPTC.NITF' or . = 'text/vnd.latex-z' or . = 'text/vnd.motorola.reflex' or . = 'text/vnd.ms-mediapackage' or . = 'text/vnd.net2phone.commcenter.command' or . = 'text/vnd.si.uricatalogue' or . = 'text/vnd.sun.j2me.app-descriptor' or . = 'text/vnd.trolltech.linguist' or . = 'text/vnd.wap.si' or . = 'text/vnd.wap.sl' or . = 'text/vnd.wap.wml' or . = 'text/vnd.wap.wmlscript' or . = 'text/xml' or . = 'text/xml-external-parsed-entity' or . = 'video/3gpp' or . = 'video/3gpp2' or . = 'video/3gpp-tt' or . = 'video/BMPEG' or . = 'video/BT656' or . = 'video/CelB' or . = 'video/DV' or . = 'video/example' or . = 'video/H261' or . = 'video/H263' or . = 'video/H263-1998' or . = 'video/H263-2000' or . = 'video/H264' or . = 'video/JPEG' or . = 'video/MJ2' or . = 'video/MP1S' or . = 'video/MP2P' or . = 'video/MP2T' or . = 'video/mp4' or . = 'video/MP4V-ES' or . = 'video/MPV' or . = 'video/mpeg' or . = 'video/mpeg4-generic' or . = 'video/nv' or . = 'video/parityfec' or . = 'video/pointer' or . = 'video/quicktime' or . = 'video/raw' or . = 'video/rtp-enc-aescm128' or . = 'video/rtx' or . = 'video/SMPTE292M' or . = 'video/ulpfec' or . = 'video/vc1' or . = 'video/vnd.dlna.mpeg-tts' or . = 'video/vnd.fvt' or . = 'video/vnd.hns.video' or . = 'video/vnd.iptvforum.1dparityfec-1010' or . = 'video/vnd.iptvforum.1dparityfec-2005' or . = 'video/vnd.iptvforum.2dparityfec-1010' or . = 'video/vnd.iptvforum.2dparityfec-2005' or . = 'video/vnd.iptvforum.ttsavc' or . = 'video/vnd.iptvforum.ttsmpeg2' or . = 'video/vnd.motorola.video' or . = 'video/vnd.motorola.videop' or . = 'video/vnd.mpegurl' or . = 'video/vnd.nokia.interleaved-multimedia' or . = 'video/vnd.nokia.videovoip' or . = 'video/vnd.objectvideo' or . = 'video/vnd.sealed.mpeg1' or . = 'video/vnd.sealed.mpeg4' or . = 'video/vnd.sealed.swf' or . = 'video/vnd.sealedmedia.softseal.mov' or . = 'video/vnd.vivo' ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( . = 'application/activemessage' or . = 'application/andrew-inset' or . = 'application/applefile' or . = 'application/atom+xml' or . = 'application/atomicmail' or . = 'application/atomcat+xml' or . = 'application/atomsvc+xml' or . = 'application/auth-policy+xml' or . = 'application/batch-SMTP' or . = 'application/beep+xml' or . = 'application/cals-1840' or . = 'application/ccxml+xml' or . = 'application/cellml+xml' or . = 'application/cnrp+xml' or . = 'application/commonground' or . = 'application/conference-info+xml' or . = 'application/cpl+xml' or . = 'application/csta+xml' or . = 'application/CSTAdata+xml' or . = 'application/cybercash' or . = 'application/davmount+xml' or . = 'application/dca-rft' or . = 'application/dec-dx' or . = 'application/dialog-info+xml' or . = 'application/dicom' or . = 'application/dns' or . = 'application/dvcs' or . = 'application/ecmascript' or . = 'application/EDI-Consent' or . = 'application/EDIFACT' or . = 'application/EDI-X12' or . = 'application/epp+xml' or . = 'application/eshop' or . = 'application/example' or . = 'application/fastinfoset' or . = 'application/fastsoap' or . = 'application/fits' or . = 'application/font-tdpfr' or . = 'application/H224' or . = 'application/http' or . = 'application/hyperstudio' or . = 'application/iges' or . = 'application/im-iscomposing+xml' or . = 'application/index' or . = 'application/index.cmd' or . = 'application/index.obj' or . = 'application/index.response' or . = 'application/index.vnd' or . = 'application/iotp' or . = 'application/ipp' or . = 'application/isup' or . = 'application/javascript' or . = 'application/json' or . = 'application/kpml-request+xml' or . = 'application/kpml-response+xml' or . = 'application/mac-binhex40' or . = 'application/macwriteii' or . = 'application/marc' or . = 'application/mathematica' or . = 'application/mbms-associated-procedure-description+xml' or . = 'application/mbms-deregister+xml' or . = 'application/mbms-envelope+xml' or . = 'application/mbms-msk-response+xml' or . = 'application/mbms-msk+xml' or . = 'application/mbms-protection-description+xml' or . = 'application/mbms-reception-report+xml' or . = 'application/mbms-register-response+xml' or . = 'application/mbms-register+xml' or . = 'application/mbms-user-service-description+xml' or . = 'application/mbox' or . = 'application/media_control+xml' or . = 'application/mediaservercontrol+xml' or . = 'application/mikey' or . = 'application/moss-keys' or . = 'application/moss-signature' or . = 'application/mosskey-data' or . = 'application/mosskey-request' or . = 'application/mpeg4-generic' or . = 'application/mpeg4-iod' or . = 'application/mpeg4-iod-xmt' or . = 'application/mp4' or . = 'application/msword' or . = 'application/mxf' or . = 'application/nasdata' or . = 'application/news-message-id' or . = 'application/news-transmission' or . = 'application/nss' or . = 'application/ocsp-request' or . = 'application/ocsp-response' or . = 'application/octet-stream' or . = 'application/oda' or . = 'application/oebps-package+xml' or . = 'application/ogg' or . = 'application/parityfec' or . = 'application/pdf' or . = 'application/pgp-encrypted' or . = 'application/pgp-keys' or . = 'application/pgp-signature' or . = 'application/pidf+xml' or . = 'application/pkcs10' or . = 'application/pkcs7-mime' or . = 'application/pkcs7-signature' or . = 'application/pkix-cert' or . = 'application/pkixcmp' or . = 'application/pkix-crl' or . = 'application/pkix-pkipath' or . = 'application/pls+xml' or . = 'application/poc-settings+xml' or . = 'application/postscript' or . = 'application/prs.alvestrand.titrax-sheet' or . = 'application/prs.cww' or . = 'application/prs.nprend' or . = 'application/prs.plucker' or . = 'application/rdf+xml' or . = 'application/qsig' or . = 'application/reginfo+xml' or . = 'application/relax-ng-compact-syntax' or . = 'application/remote-printing' or . = 'application/resource-lists+xml' or . = 'application/riscos' or . = 'application/rlmi+xml' or . = 'application/rls-services+xml' or . = 'application/rtf' or . = 'application/rtx' or . = 'application/samlassertion+xml' or . = 'application/samlmetadata+xml' or . = 'application/sbml+xml' or . = 'application/scvp-cv-request' or . = 'application/scvp-cv-response' or . = 'application/scvp-vp-request' or . = 'application/scvp-vp-response' or . = 'application/sdp' or . = 'application/set-payment' or . = 'application/set-payment-initiation' or . = 'application/set-registration' or . = 'application/set-registration-initiation' or . = 'application/sgml' or . = 'application/sgml-open-catalog' or . = 'application/shf+xml' or . = 'application/sieve' or . = 'application/simple-filter+xml' or . = 'application/simple-message-summary' or . = 'application/simpleSymbolContainer' or . = 'application/slate' or . = 'application/smil (OBSOLETE)' or . = 'application/smil+xml' or . = 'application/soap+fastinfoset' or . = 'application/soap+xml' or . = 'application/sparql-query' or . = 'application/sparql-results+xml' or . = 'application/spirits-event+xml' or . = 'application/srgs' or . = 'application/srgs+xml' or . = 'application/ssml+xml' or . = 'application/timestamp-query' or . = 'application/timestamp-reply' or . = 'application/tve-trigger' or . = 'application/ulpfec' or . = 'application/vemmi' or . = 'application/vnd.3gpp.bsf+xml' or . = 'application/vnd.3gpp.pic-bw-large' or . = 'application/vnd.3gpp.pic-bw-small' or . = 'application/vnd.3gpp.pic-bw-var' or . = 'application/vnd.3gpp.sms' or . = 'application/vnd.3gpp2.bcmcsinfo+xml' or . = 'application/vnd.3gpp2.sms' or . = 'application/vnd.3gpp2.tcap' or . = 'application/vnd.3M.Post-it-Notes' or . = 'application/vnd.accpac.simply.aso' or . = 'application/vnd.accpac.simply.imp' or . = 'application/vnd.acucobol' or . = 'application/vnd.acucorp' or . = 'application/vnd.adobe.xdp+xml' or . = 'application/vnd.adobe.xfdf' or . = 'application/vnd.aether.imp' or . = 'application/vnd.americandynamics.acc' or . = 'application/vnd.amiga.ami' or . = 'application/vnd.anser-web-certificate-issue-initiation' or . = 'application/vnd.antix.game-component' or . = 'application/vnd.apple.installer+xml' or . = 'application/vnd.audiograph' or . = 'application/vnd.autopackage' or . = 'application/vnd.avistar+xml' or . = 'application/vnd.blueice.multipass' or . = 'application/vnd.bmi' or . = 'application/vnd.businessobjects' or . = 'application/vnd.cab-jscript' or . = 'application/vnd.canon-cpdl' or . = 'application/vnd.canon-lips' or . = 'application/vnd.cendio.thinlinc.clientconf' or . = 'application/vnd.chemdraw+xml' or . = 'application/vnd.chipnuts.karaoke-mmd' or . = 'application/vnd.cinderella' or . = 'application/vnd.cirpack.isdn-ext' or . = 'application/vnd.claymore' or . = 'application/vnd.clonk.c4group' or . = 'application/vnd.commerce-battelle' or . = 'application/vnd.commonspace' or . = 'application/vnd.cosmocaller' or . = 'application/vnd.contact.cmsg' or . = 'application/vnd.crick.clicker' or . = 'application/vnd.crick.clicker.keyboard' or . = 'application/vnd.crick.clicker.palette' or . = 'application/vnd.crick.clicker.template' or . = 'application/vnd.crick.clicker.wordbank' or . = 'application/vnd.criticaltools.wbs+xml' or . = 'application/vnd.ctc-posml' or . = 'application/vnd.ctct.ws+xml' or . = 'application/vnd.cups-pdf' or . = 'application/vnd.cups-postscript' or . = 'application/vnd.cups-ppd' or . = 'application/vnd.cups-raster' or . = 'application/vnd.cups-raw' or . = 'application/vnd.curl' or . = 'application/vnd.cybank' or . = 'application/vnd.data-vision.rdz' or . = 'application/vnd.denovo.fcselayout-link' or . = 'application/vnd.dna' or . = 'application/vnd.dpgraph' or . = 'application/vnd.dreamfactory' or . = 'application/vnd.dvb.esgcontainer' or . = 'application/vnd.dvb.ipdcesgaccess' or . = 'application/vnd.dxr' or . = 'application/vnd.ecdis-update' or . = 'application/vnd.ecowin.chart' or . = 'application/vnd.ecowin.filerequest' or . = 'application/vnd.ecowin.fileupdate' or . = 'application/vnd.ecowin.series' or . = 'application/vnd.ecowin.seriesrequest' or . = 'application/vnd.ecowin.seriesupdate' or . = 'application/vnd.enliven' or . = 'application/vnd.epson.esf' or . = 'application/vnd.epson.msf' or . = 'application/vnd.epson.quickanime' or . = 'application/vnd.epson.salt' or . = 'application/vnd.epson.ssf' or . = 'application/vnd.ericsson.quickcall' or . = 'application/vnd.eszigno3+xml' or . = 'application/vnd.eudora.data' or . = 'application/vnd.ezpix-album' or . = 'application/vnd.ezpix-package' or . = 'application/vnd.fdf' or . = 'application/vnd.ffsns' or . = 'application/vnd.fints' or . = 'application/vnd.FloGraphIt' or . = 'application/vnd.fluxtime.clip' or . = 'application/vnd.framemaker' or . = 'application/vnd.frogans.fnc' or . = 'application/vnd.frogans.ltf' or . = 'application/vnd.fsc.weblaunch' or . = 'application/vnd.fujitsu.oasys' or . = 'application/vnd.fujitsu.oasys2' or . = 'application/vnd.fujitsu.oasys3' or . = 'application/vnd.fujitsu.oasysgp' or . = 'application/vnd.fujitsu.oasysprs' or . = 'application/vnd.fujixerox.ART4' or . = 'application/vnd.fujixerox.ART-EX' or . = 'application/vnd.fujixerox.ddd' or . = 'application/vnd.fujixerox.docuworks' or . = 'application/vnd.fujixerox.docuworks.binder' or . = 'application/vnd.fujixerox.HBPL' or . = 'application/vnd.fut-misnet' or . = 'application/vnd.fuzzysheet' or . = 'application/vnd.genomatix.tuxedo' or . = 'application/vnd.google-earth.kml+xml' or . = 'application/vnd.google-earth.kmz' or . = 'application/vnd.grafeq' or . = 'application/vnd.gridmp' or . = 'application/vnd.groove-account' or . = 'application/vnd.groove-help' or . = 'application/vnd.groove-identity-message' or . = 'application/vnd.groove-injector' or . = 'application/vnd.groove-tool-message' or . = 'application/vnd.groove-tool-template' or . = 'application/vnd.groove-vcard' or . = 'application/vnd.HandHeld-Entertainment+xml' or . = 'application/vnd.hbci' or . = 'application/vnd.hcl-bireports' or . = 'application/vnd.hhe.lesson-player' or . = 'application/vnd.hp-HPGL' or . = 'application/vnd.hp-hpid' or . = 'application/vnd.hp-hps' or . = 'application/vnd.hp-jlyt' or . = 'application/vnd.hp-PCL' or . = 'application/vnd.hp-PCLXL' or . = 'application/vnd.httphone' or . = 'application/vnd.hzn-3d-crossword' or . = 'application/vnd.ibm.afplinedata' or . = 'application/vnd.ibm.electronic-media' or . = 'application/vnd.ibm.MiniPay' or . = 'application/vnd.ibm.modcap' or . = 'application/vnd.ibm.rights-management' or . = 'application/vnd.ibm.secure-container' or . = 'application/vnd.iccprofile' or . = 'application/vnd.igloader' or . = 'application/vnd.immervision-ivp' or . = 'application/vnd.immervision-ivu' or . = 'application/vnd.informedcontrol.rms+xml' or . = 'application/vnd.informix-visionary' or . = 'application/vnd.intercon.formnet' or . = 'application/vnd.intertrust.digibox' or . = 'application/vnd.intertrust.nncp' or . = 'application/vnd.intu.qbo' or . = 'application/vnd.intu.qfx' or . = 'application/vnd.ipunplugged.rcprofile' or . = 'application/vnd.irepository.package+xml' or . = 'application/vnd.is-xpr' or . = 'application/vnd.jam' or . = 'application/vnd.japannet-directory-service' or . = 'application/vnd.japannet-jpnstore-wakeup' or . = 'application/vnd.japannet-payment-wakeup' or . = 'application/vnd.japannet-registration' or . = 'application/vnd.japannet-registration-wakeup' or . = 'application/vnd.japannet-setstore-wakeup' or . = 'application/vnd.japannet-verification' or . = 'application/vnd.japannet-verification-wakeup' or . = 'application/vnd.jcp.javame.midlet-rms' or . = 'application/vnd.jisp' or . = 'application/vnd.joost.joda-archive' or . = 'application/vnd.kahootz' or . = 'application/vnd.kde.karbon' or . = 'application/vnd.kde.kchart' or . = 'application/vnd.kde.kformula' or . = 'application/vnd.kde.kivio' or . = 'application/vnd.kde.kontour' or . = 'application/vnd.kde.kpresenter' or . = 'application/vnd.kde.kspread' or . = 'application/vnd.kde.kword' or . = 'application/vnd.kenameaapp' or . = 'application/vnd.kidspiration' or . = 'application/vnd.Kinar' or . = 'application/vnd.koan' or . = 'application/vnd.kodak-descriptor' or . = 'application/vnd.liberty-request+xml' or . = 'application/vnd.llamagraphics.life-balance.desktop' or . = 'application/vnd.llamagraphics.life-balance.exchange+xml' or . = 'application/vnd.lotus-1-2-3' or . = 'application/vnd.lotus-approach' or . = 'application/vnd.lotus-freelance' or . = 'application/vnd.lotus-notes' or . = 'application/vnd.lotus-organizer' or . = 'application/vnd.lotus-screencam' or . = 'application/vnd.lotus-wordpro' or . = 'application/vnd.macports.portpkg' or . = 'application/vnd.marlin.drm.actiontoken+xml' or . = 'application/vnd.marlin.drm.conftoken+xml' or . = 'application/vnd.marlin.drm.mdcf' or . = 'application/vnd.mcd' or . = 'application/vnd.medcalcdata' or . = 'application/vnd.mediastation.cdkey' or . = 'application/vnd.meridian-slingshot' or . = 'application/vnd.MFER' or . = 'application/vnd.mfmp' or . = 'application/vnd.micrografx.flo' or . = 'application/vnd.micrografx.igx' or . = 'application/vnd.mif' or . = 'application/vnd.minisoft-hp3000-save' or . = 'application/vnd.mitsubishi.misty-guard.trustweb' or . = 'application/vnd.Mobius.DAF' or . = 'application/vnd.Mobius.DIS' or . = 'application/vnd.Mobius.MBK' or . = 'application/vnd.Mobius.MQY' or . = 'application/vnd.Mobius.MSL' or . = 'application/vnd.Mobius.PLC' or . = 'application/vnd.Mobius.TXF' or . = 'application/vnd.mophun.application' or . = 'application/vnd.mophun.certificate' or . = 'application/vnd.motorola.flexsuite' or . = 'application/vnd.motorola.flexsuite.adsi' or . = 'application/vnd.motorola.flexsuite.fis' or . = 'application/vnd.motorola.flexsuite.gotap' or . = 'application/vnd.motorola.flexsuite.kmr' or . = 'application/vnd.motorola.flexsuite.ttc' or . = 'application/vnd.motorola.flexsuite.wem' or . = 'application/vnd.mozilla.xul+xml' or . = 'application/vnd.ms-artgalry' or . = 'application/vnd.ms-asf' or . = 'application/vnd.ms-cab-compressed' or . = 'application/vnd.mseq' or . = 'application/vnd.ms-excel' or . = 'application/vnd.ms-fontobject' or . = 'application/vnd.ms-htmlhelp' or . = 'application/vnd.msign' or . = 'application/vnd.ms-ims' or . = 'application/vnd.ms-lrm' or . = 'application/vnd.ms-playready.initiator+xml' or . = 'application/vnd.ms-powerpoint' or . = 'application/vnd.ms-project' or . = 'application/vnd.ms-tnef' or . = 'application/vnd.ms-wmdrm.lic-chlg-req' or . = 'application/vnd.ms-wmdrm.lic-resp' or . = 'application/vnd.ms-wmdrm.meter-chlg-req' or . = 'application/vnd.ms-wmdrm.meter-resp' or . = 'application/vnd.ms-works' or . = 'application/vnd.ms-wpl' or . = 'application/vnd.ms-xpsdocument' or . = 'application/vnd.multiad.creator' or . = 'application/vnd.multiad.creator.cif' or . = 'application/vnd.musician' or . = 'application/vnd.music-niff' or . = 'application/vnd.muvee.style' or . = 'application/vnd.ncd.control' or . = 'application/vnd.ncd.reference' or . = 'application/vnd.nervana' or . = 'application/vnd.netfpx' or . = 'application/vnd.neurolanguage.nlu' or . = 'application/vnd.noblenet-directory' or . = 'application/vnd.noblenet-sealer' or . = 'application/vnd.noblenet-web' or . = 'application/vnd.nokia.catalogs' or . = 'application/vnd.nokia.conml+wbxml' or . = 'application/vnd.nokia.conml+xml' or . = 'application/vnd.nokia.iptv.config+xml' or . = 'application/vnd.nokia.iSDS-radio-presets' or . = 'application/vnd.nokia.landmark+wbxml' or . = 'application/vnd.nokia.landmark+xml' or . = 'application/vnd.nokia.landmarkcollection+xml' or . = 'application/vnd.nokia.ncd' or . = 'application/vnd.nokia.n-gage.ac+xml' or . = 'application/vnd.nokia.n-gage.data' or . = 'application/vnd.nokia.n-gage.symbian.install' or . = 'application/vnd.nokia.pcd+wbxml' or . = 'application/vnd.nokia.pcd+xml' or . = 'application/vnd.nokia.radio-preset' or . = 'application/vnd.nokia.radio-presets' or . = 'application/vnd.novadigm.EDM' or . = 'application/vnd.novadigm.EDX' or . = 'application/vnd.novadigm.EXT' or . = 'application/vnd.oasis.opendocument.chart' or . = 'application/vnd.oasis.opendocument.chart-template' or . = 'application/vnd.oasis.opendocument.formula' or . = 'application/vnd.oasis.opendocument.formula-template' or . = 'application/vnd.oasis.opendocument.graphics' or . = 'application/vnd.oasis.opendocument.graphics-template' or . = 'application/vnd.oasis.opendocument.image' or . = 'application/vnd.oasis.opendocument.image-template' or . = 'application/vnd.oasis.opendocument.presentation' or . = 'application/vnd.oasis.opendocument.presentation-template' or . = 'application/vnd.oasis.opendocument.spreadsheet' or . = 'application/vnd.oasis.opendocument.spreadsheet-template' or . = 'application/vnd.oasis.opendocument.text' or . = 'application/vnd.oasis.opendocument.text-master' or . = 'application/vnd.oasis.opendocument.text-template' or . = 'application/vnd.oasis.opendocument.text-web' or . = 'application/vnd.obn' or . = 'application/vnd.olpc-sugar' or . = 'application/vnd.oma.bcast.associated-procedure-parameter+xml' or . = 'application/vnd.oma.bcast.drm-trigger+xml' or . = 'application/vnd.oma.bcast.imd+xml' or . = 'application/vnd.oma.bcast.ltkm' or . = 'application/vnd.oma.bcast.notification+xml' or . = 'application/vnd.oma.bcast.sgboot' or . = 'application/vnd.oma.bcast.sgdd+xml' or . = 'application/vnd.oma.bcast.sgdu' or . = 'application/vnd.oma.bcast.simple-symbol-container' or . = 'application/vnd.oma.bcast.smartcard-trigger+xml' or . = 'application/vnd.oma.bcast.sprov+xml' or . = 'application/vnd.oma.bcast.stkm' or . = 'application/vnd.oma.dd2+xml' or . = 'application/vnd.oma.drm.risd+xml' or . = 'application/vnd.oma.group-usage-list+xml' or . = 'application/vnd.oma.poc.detailed-progress-report+xml' or . = 'application/vnd.oma.poc.final-report+xml' or . = 'application/vnd.oma.poc.groups+xml' or . = 'application/vnd.oma.poc.invocation-descriptor+xml' or . = 'application/vnd.oma.poc.optimized-progress-report+xml' or . = 'application/vnd.oma.xcap-directory+xml' or . = 'application/vnd.omads-email+xml' or . = 'application/vnd.omads-file+xml' or . = 'application/vnd.omads-folder+xml' or . = 'application/vnd.omaloc-supl-init' or . = 'application/vnd.oma-scws-config' or . = 'application/vnd.oma-scws-http-request' or . = 'application/vnd.oma-scws-http-response' or . = 'application/vnd.openofficeorg.extension' or . = 'application/vnd.osa.netdeploy' or . = 'application/vnd.osgi.bundle' or . = 'application/vnd.osgi.dp' or . = 'application/vnd.otps.ct-kip+xml' or . = 'application/vnd.palm' or . = 'application/vnd.paos.xml' or . = 'application/vnd.pg.format' or . = 'application/vnd.pg.osasli' or . = 'application/vnd.piaccess.application-licence' or . = 'application/vnd.picsel' or . = 'application/vnd.poc.group-advertisement+xml' or . = 'application/vnd.pocketlearn' or . = 'application/vnd.powerbuilder6' or . = 'application/vnd.powerbuilder6-s' or . = 'application/vnd.powerbuilder7' or . = 'application/vnd.powerbuilder75' or . = 'application/vnd.powerbuilder75-s' or . = 'application/vnd.powerbuilder7-s' or . = 'application/vnd.preminet' or . = 'application/vnd.previewsystems.box' or . = 'application/vnd.proteus.magazine' or . = 'application/vnd.publishare-delta-tree' or . = 'application/vnd.pvi.ptid1' or . = 'application/vnd.pwg-multiplexed' or . = 'application/vnd.pwg-xhtml-print+xml' or . = 'application/vnd.qualcomm.brew-app-res' or . = 'application/vnd.Quark.QuarkXPress' or . = 'application/vnd.rapid' or . = 'application/vnd.recordare.musicxml' or . = 'application/vnd.recordare.musicxml+xml' or . = 'application/vnd.RenLearn.rlprint' or . = 'application/vnd.ruckus.download' or . = 'application/vnd.s3sms' or . = 'application/vnd.sbm.mid2' or . = 'application/vnd.scribus' or . = 'application/vnd.sealed.3df' or . = 'application/vnd.sealed.csf' or . = 'application/vnd.sealed.doc' or . = 'application/vnd.sealed.eml' or . = 'application/vnd.sealed.mht' or . = 'application/vnd.sealed.net' or . = 'application/vnd.sealed.ppt' or . = 'application/vnd.sealed.tiff' or . = 'application/vnd.sealed.xls' or . = 'application/vnd.sealedmedia.softseal.html' or . = 'application/vnd.sealedmedia.softseal.pdf' or . = 'application/vnd.seemail' or . = 'application/vnd.sema' or . = 'application/vnd.semd' or . = 'application/vnd.semf' or . = 'application/vnd.shana.informed.formdata' or . = 'application/vnd.shana.informed.formtemplate' or . = 'application/vnd.shana.informed.interchange' or . = 'application/vnd.shana.informed.package' or . = 'application/vnd.SimTech-MindMapper' or . = 'application/vnd.smaf' or . = 'application/vnd.solent.sdkm+xml' or . = 'application/vnd.spotfire.dxp' or . = 'application/vnd.spotfire.sfs' or . = 'application/vnd.sss-cod' or . = 'application/vnd.sss-dtf' or . = 'application/vnd.sss-ntf' or . = 'application/vnd.street-stream' or . = 'application/vnd.sun.wadl+xml' or . = 'application/vnd.sus-calendar' or . = 'application/vnd.svd' or . = 'application/vnd.swiftview-ics' or . = 'application/vnd.syncml.dm+wbxml' or . = 'application/vnd.syncml.dm+xml' or . = 'application/vnd.syncml.ds.notification' or . = 'application/vnd.syncml+xml' or . = 'application/vnd.tao.intent-module-archive' or . = 'application/vnd.tmobile-livetv' or . = 'application/vnd.trid.tpt' or . = 'application/vnd.triscape.mxs' or . = 'application/vnd.trueapp' or . = 'application/vnd.truedoc' or . = 'application/vnd.ufdl' or . = 'application/vnd.uiq.theme' or . = 'application/vnd.umajin' or . = 'application/vnd.unity' or . = 'application/vnd.uoml+xml' or . = 'application/vnd.uplanet.alert' or . = 'application/vnd.uplanet.alert-wbxml' or . = 'application/vnd.uplanet.bearer-choice' or . = 'application/vnd.uplanet.bearer-choice-wbxml' or . = 'application/vnd.uplanet.cacheop' or . = 'application/vnd.uplanet.cacheop-wbxml' or . = 'application/vnd.uplanet.channel' or . = 'application/vnd.uplanet.channel-wbxml' or . = 'application/vnd.uplanet.list' or . = 'application/vnd.uplanet.listcmd' or . = 'application/vnd.uplanet.listcmd-wbxml' or . = 'application/vnd.uplanet.list-wbxml' or . = 'application/vnd.uplanet.signal' or . = 'application/vnd.vcx' or . = 'application/vnd.vectorworks' or . = 'application/vnd.vd-study' or . = 'application/vnd.vidsoft.vidconference' or . = 'application/vnd.visio' or . = 'application/vnd.visionary' or . = 'application/vnd.vividence.scriptfile' or . = 'application/vnd.vsf' or . = 'application/vnd.wap.sic' or . = 'application/vnd.wap.slc' or . = 'application/vnd.wap.wbxml' or . = 'application/vnd.wap.wmlc' or . = 'application/vnd.wap.wmlscriptc' or . = 'application/vnd.webturbo' or . = 'application/vnd.wfa.wsc' or . = 'application/vnd.wmc' or . = 'application/vnd.wmf.bootstrap' or . = 'application/vnd.wordperfect' or . = 'application/vnd.wqd' or . = 'application/vnd.wrq-hp3000-labelled' or . = 'application/vnd.wt.stf' or . = 'application/vnd.wv.csp+xml' or . = 'application/vnd.wv.csp+wbxml' or . = 'application/vnd.wv.ssp+xml' or . = 'application/vnd.xara' or . = 'application/vnd.xfdl' or . = 'application/vnd.xmpie.cpkg' or . = 'application/vnd.xmpie.dpkg' or . = 'application/vnd.xmpie.plan' or . = 'application/vnd.xmpie.ppkg' or . = 'application/vnd.xmpie.xlim' or . = 'application/vnd.yamaha.hv-dic' or . = 'application/vnd.yamaha.hv-script' or . = 'application/vnd.yamaha.hv-voice' or . = 'application/vnd.yamaha.smaf-audio' or . = 'application/vnd.yamaha.smaf-phrase' or . = 'application/vnd.yellowriver-custom-menu' or . = 'application/vnd.zzazz.deck+xml' or . = 'application/voicexml+xml' or . = 'application/watcherinfo+xml' or . = 'application/whoispp-query' or . = 'application/whoispp-response' or . = 'application/wita' or . = 'application/wordperfect5.1' or . = 'application/wsdl+xml' or . = 'application/wspolicy+xml' or . = 'application/x400-bp' or . = 'application/xcap-att+xml' or . = 'application/xcap-caps+xml' or . = 'application/xcap-el+xml' or . = 'application/xcap-error+xml' or . = 'application/xcap-ns+xml' or . = 'application/xenc+xml' or . = 'application/xhtml-voice+xml (Obsolete)' or . = 'application/xhtml+xml' or . = 'application/xml' or . = 'application/xml-dtd' or . = 'application/xml-external-parsed-entity' or . = 'application/xmpp+xml' or . = 'application/xop+xml' or . = 'application/xv+xml' or . = 'application/zip' or . = 'audio/32kadpcm' or . = 'audio/3gpp' or . = 'audio/3gpp2' or . = 'audio/ac3' or . = 'audio/AMR' or . = 'audio/AMR-WB' or . = 'audio/amr-wb+' or . = 'audio/asc' or . = 'audio/basic' or . = 'audio/BV16' or . = 'audio/BV32' or . = 'audio/clearmode' or . = 'audio/CN' or . = 'audio/DAT12' or . = 'audio/dls' or . = 'audio/dsr-es201108' or . = 'audio/dsr-es202050' or . = 'audio/dsr-es202211' or . = 'audio/dsr-es202212' or . = 'audio/eac3' or . = 'audio/DVI4' or . = 'audio/EVRC' or . = 'audio/EVRC0' or . = 'audio/EVRC1' or . = 'audio/EVRCB' or . = 'audio/EVRCB0' or . = 'audio/EVRCB1' or . = 'audio/EVRC-QCP' or . = 'audio/EVRCWB' or . = 'audio/EVRCWB0' or . = 'audio/EVRCWB1' or . = 'audio/example' or . = 'audio/G722' or . = 'audio/G7221' or . = 'audio/G723' or . = 'audio/G726-16' or . = 'audio/G726-24' or . = 'audio/G726-32' or . = 'audio/G726-40' or . = 'audio/G728' or . = 'audio/G729' or . = 'audio/G7291' or . = 'audio/G729D' or . = 'audio/G729E' or . = 'audio/GSM' or . = 'audio/GSM-EFR' or . = 'audio/iLBC' or . = 'audio/L8' or . = 'audio/L16' or . = 'audio/L20' or . = 'audio/L24' or . = 'audio/LPC' or . = 'audio/mobile-xmf' or . = 'audio/MPA' or . = 'audio/mp4' or . = 'audio/MP4A-LATM' or . = 'audio/mpa-robust' or . = 'audio/mpeg' or . = 'audio/mpeg4-generic' or . = 'audio/parityfec' or . = 'audio/PCMA' or . = 'audio/PCMU' or . = 'audio/prs.sid' or . = 'audio/QCELP' or . = 'audio/RED' or . = 'audio/rtp-enc-aescm128' or . = 'audio/rRFC2045tp-midi' or . = 'audio/rtx' or . = 'audio/SMV' or . = 'audio/SMV0' or . = 'audio/SMV-QCP' or . = 'audio/sp-midi' or . = 'audio/t140c' or . = 'audio/t38' or . = 'audio/telephone-event' or . = 'audio/tone' or . = 'audio/ulpfec' or . = 'audio/VDVI' or . = 'audio/VMR-WB' or . = 'audio/vnd.3gpp.iufp' or . = 'audio/vnd.4SB' or . = 'audio/vnd.audiokoz' or . = 'audio/vnd.CELP' or . = 'audio/vnd.cisco.nse' or . = 'audio/vnd.cmles.radio-events' or . = 'audio/vnd.cns.anp1' or . = 'audio/vnd.cns.inf1' or . = 'audio/vnd.digital-winds' or . = 'audio/vnd.dlna.adts' or . = 'audio/vnd.dolby.mlp' or . = 'audio/vnd.everad.plj' or . = 'audio/vnd.hns.audio' or . = 'audio/vnd.lucent.voice' or . = 'audio/vnd.nokia.mobile-xmf' or . = 'audio/vnd.nortel.vbk' or . = 'audio/vnd.nuera.ecelp4800' or . = 'audio/vnd.nuera.ecelp7470' or . = 'audio/vnd.nuera.ecelp9600' or . = 'audio/vnd.octel.sbc' or . = 'audio/vnd.qcelp - DEPRECATED - Please use audio/qcelp' or . = 'audio/vnd.rhetorex.32kadpcm' or . = 'audio/vnd.sealedmedia.softseal.mpeg' or . = 'audio/vnd.vmx.cvsd' or . = 'image/cgm' or . = 'image/example' or . = 'image/fits' or . = 'image/g3fax' or . = 'image/gif' or . = 'image/ief' or . = 'image/jp2' or . = 'image/jpeg' or . = 'image/jpm' or . = 'image/jpx' or . = 'image/naplps' or . = 'image/png' or . = 'image/prs.btif' or . = 'image/prs.pti' or . = 'image/t38' or . = 'image/tiff' or . = 'image/tiff-fx' or . = 'image/vnd.adobe.photoshop' or . = 'image/vnd.cns.inf2' or . = 'image/vnd.djvu' or . = 'image/vnd.dwg' or . = 'image/vnd.dxf' or . = 'image/vnd.fastbidsheet' or . = 'image/vnd.fpx' or . = 'image/vnd.fst' or . = 'image/vnd.fujixerox.edmics-mmr' or . = 'image/vnd.fujixerox.edmics-rlc' or . = 'image/vnd.globalgraphics.pgb' or . = 'image/vnd.microsoft.icon' or . = 'image/vnd.mix' or . = 'image/vnd.ms-modi' or . = 'image/vnd.net-fpx' or . = 'image/vnd.sealed.png' or . = 'image/vnd.sealedmedia.softseal.gif' or . = 'image/vnd.sealedmedia.softseal.jpg' or . = 'image/vnd.svf' or . = 'image/vnd.wap.wbmp' or . = 'image/vnd.xiff' or . = 'message/CPIM' or . = 'message/delivery-status' or . = 'message/disposition-notification' or . = 'message/example' or . = 'message/external-body' or . = 'message/http' or . = 'message/news' or . = 'message/partial' or . = 'message/rfc822' or . = 'message/s-http' or . = 'message/sip' or . = 'message/sipfrag' or . = 'message/tracking-status' or . = 'message/vnd.si.simp' or . = 'model/example' or . = 'model/iges' or . = 'model/mesh' or . = 'model/vnd.dwf' or . = 'model/vnd.flatland.3dml' or . = 'model/vnd.gdl' or . = 'model/vnd.gs-gdl' or . = 'model/vnd.gtw' or . = 'model/vnd.moml+xml' or . = 'model/vnd.mts' or . = 'model/vnd.parasolid.transmit.binary' or . = 'model/vnd.parasolid.transmit.text' or . = 'model/vnd.vtu' or . = 'model/vrml' or . = 'multipart/alternative' or . = 'multipart/appledouble' or . = 'multipart/byteranges' or . = 'multipart/digest' or . = 'multipart/encrypted' or . = 'multipart/example' or . = 'multipart/form-data' or . = 'multipart/header-set' or . = 'multipart/mixed' or . = 'multipart/parallel' or . = 'multipart/related' or . = 'multipart/report' or . = 'multipart/signed' or . = 'multipart/voice-message' or . = 'text/calendar' or . = 'text/css' or . = 'text/csv' or . = 'text/directory' or . = 'text/dns' or . = 'text/ecmascript (obsolete)' or . = 'text/enriched' or . = 'text/example' or . = 'text/html' or . = 'text/javascript (obsolete)' or . = 'text/parityfec' or . = 'text/plain' or . = 'text/prs.fallenstein.rst' or . = 'text/prs.lines.tag' or . = 'text/RED' or . = 'text/rfc822-headers' or . = 'text/richtext' or . = 'text/rtf' or . = 'text/rtp-enc-aescm128' or . = 'text/rtx' or . = 'text/sgml' or . = 'text/t140' or . = 'text/tab-separated-values' or . = 'text/troff' or . = 'text/ulpfec' or . = 'text/uri-list' or . = 'text/vnd.abc' or . = 'text/vnd.curl' or . = 'text/vnd.DMClientScript' or . = 'text/vnd.esmertec.theme-descriptor' or . = 'text/vnd.fly' or . = 'text/vnd.fmi.flexstor' or . = 'text/vnd.in3d.3dml' or . = 'text/vnd.in3d.spot' or . = 'text/vnd.IPTC.NewsML' or . = 'text/vnd.IPTC.NITF' or . = 'text/vnd.latex-z' or . = 'text/vnd.motorola.reflex' or . = 'text/vnd.ms-mediapackage' or . = 'text/vnd.net2phone.commcenter.command' or . = 'text/vnd.si.uricatalogue' or . = 'text/vnd.sun.j2me.app-descriptor' or . = 'text/vnd.trolltech.linguist' or . = 'text/vnd.wap.si' or . = 'text/vnd.wap.sl' or . = 'text/vnd.wap.wml' or . = 'text/vnd.wap.wmlscript' or . = 'text/xml' or . = 'text/xml-external-parsed-entity' or . = 'video/3gpp' or . = 'video/3gpp2' or . = 'video/3gpp-tt' or . = 'video/BMPEG' or . = 'video/BT656' or . = 'video/CelB' or . = 'video/DV' or . = 'video/example' or . = 'video/H261' or . = 'video/H263' or . = 'video/H263-1998' or . = 'video/H263-2000' or . = 'video/H264' or . = 'video/JPEG' or . = 'video/MJ2' or . = 'video/MP1S' or . = 'video/MP2P' or . = 'video/MP2T' or . = 'video/mp4' or . = 'video/MP4V-ES' or . = 'video/MPV' or . = 'video/mpeg' or . = 'video/mpeg4-generic' or . = 'video/nv' or . = 'video/parityfec' or . = 'video/pointer' or . = 'video/quicktime' or . = 'video/raw' or . = 'video/rtp-enc-aescm128' or . = 'video/rtx' or . = 'video/SMPTE292M' or . = 'video/ulpfec' or . = 'video/vc1' or . = 'video/vnd.dlna.mpeg-tts' or . = 'video/vnd.fvt' or . = 'video/vnd.hns.video' or . = 'video/vnd.iptvforum.1dparityfec-1010' or . = 'video/vnd.iptvforum.1dparityfec-2005' or . = 'video/vnd.iptvforum.2dparityfec-1010' or . = 'video/vnd.iptvforum.2dparityfec-2005' or . = 'video/vnd.iptvforum.ttsavc' or . = 'video/vnd.iptvforum.ttsmpeg2' or . = 'video/vnd.motorola.video' or . = 'video/vnd.motorola.videop' or . = 'video/vnd.mpegurl' or . = 'video/vnd.nokia.interleaved-multimedia' or . = 'video/vnd.nokia.videovoip' or . = 'video/vnd.objectvideo' or . = 'video/vnd.sealed.mpeg1' or . = 'video/vnd.sealed.mpeg4' or . = 'video/vnd.sealed.swf' or . = 'video/vnd.sealedmedia.softseal.mov' or . = 'video/vnd.vivo' ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T90-R002]-For Mime code use MIMEMediaType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:DocumentTypeCode" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:DocumentTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T90-R003]-DocumentTypeCode  must be from the code list UNCL 1001</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
</xsl:stylesheet>
