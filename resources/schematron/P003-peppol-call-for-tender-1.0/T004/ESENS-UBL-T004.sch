<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>eSENS business and syntax rules for Call for Tenders Light (Tansaction 83)</title>
    
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:CallForTenders-2"/>
    
    <pattern>
        <rule context="*">
            <report id="eSENS-T004-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[eSENS-T004-S002] A Call For Tenders document MUST NOT contain empty elements.</report>
        </rule>
    </pattern>

    <pattern>
        <let name="syntaxError" value="string('[eSENS-T004-S003] A Call For Tenders document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
        <rule context="ubl:CallForTenders">
            <report id="eSENS-T004-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[eSENS-T004-S301] UBLExtensions SHOULD NOT be used.</report>
            <report id="eSENS-T004-S305" flag="warning" test="(cbc:ProfileExecutionID)"><value-of select="$syntaxError"/>[eSENS-T004-S305] ProfileExecutionID SHOULD NOT be used.</report>
            <report id="eSENS-T004-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[eSENS-T004-S307] CopyIndicator SHOULD NOT be used.</report>
            <report id="eSENS-T004-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[eSENS-T004-S308] UUID SHOULD NOT be used.</report>
            <assert id="eSENS-T004-R001" flag="fatal" test="exists(cbc:UBLVersionID)">[eSENS-T004-R001] A Call For Tenders MUST have a syntax identifier.</assert>
            <report id="eSENS-T004-S310" flag="warning" test="(cbc:ApprovalDate)"><value-of select="$syntaxError"/>[eSENS-T004-S310] ApprovalDate SHOULD NOT be used.</report>
            <assert id="eSENS-T004-R007" flag="fatal" test="(cbc:IssueTime)">[eSENS-T004-R007] A Call For Tenders MUST have an issue time.</assert>
            <assert id="eSENS-T004-R024" flag="fatal" test="count(distinct-values(cac:AdditionalDocumentReference/cbc:ID)) = count(cac:AdditionalDocumentReference/cbc:ID)">[eSENS-T004-R024] Additional Document Reference Identifiers MUST be unique.</assert>
            <assert id="eSENS-T004-R029" flag="fatal" test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">[eSENS-T004-R029] Lot identifiers MUST be unique.</assert>
            <report id="eSENS-T004-S311" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[eSENS-T004-S311] Note SHOULD NOT be used.</report>
            <assert id="eSENS-T004-R038" flag="fatal" test="(cbc:VersionID)">[eSENS-T004-R038] A Call For Tenders MUST have a version identifier</assert>
            <report id="eSENS-T004-S313" flag="warning" test="(cbc:PreviousVersionID)"><value-of select="$syntaxError"/>[eSENS-T004-S313] PreviousVersionID SHOULD NOT be used.</report>
            <report id="eSENS-T004-S314" flag="warning" test="(cac:LegalDocumentReference)"><value-of select="$syntaxError"/>[eSENS-T004-S314] LegalDocumentReference SHOULD NOT be used.</report>
            <report id="eSENS-T004-S315" flag="warning" test="(cac:TechnicalDocumentReference)"><value-of select="$syntaxError"/>[eSENS-T004-S315] TechnicalDocumentReference SHOULD NOT be used.</report>
            <report id="eSENS-T004-S331" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[eSENS-T004-S331] Signature SHOULD NOT be used.</report>
            <report id="eSENS-T004-S332" flag="warning" test="count(cac:ContractingParty) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S332] ContractingParty SHOULD NOT be used more than once.</report>
            <report id="eSENS-T004-S345" flag="warning" test="(cac:OriginatorCustomerParty)"><value-of select="$syntaxError"/>[eSENS-T004-S345] OriginatorCustomerParty SHOULD NOT be used.</report>
            <assert id="eSENS-T004-S347" flag="warning" test="(cac:TenderingTerms)"><value-of select="$syntaxError"/>[eSENS-T004-S347] TenderingTerms SHOULD be used.</assert>
            <assert id="eSENS-T004-S368" flag="warning" test="(cac:TenderingProcess)"><value-of select="$syntaxError"/>[eSENS-T004-S368] TenderingProcess SHOULD be used.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cbc:UBLVersionID">
           
            <assert id="eSENS-T004-R039" flag="fatal" test="normalize-space(.) = '2.2'">[eSENS-T004-R039] UBLVersionID value MUST be '2.2'</assert>
            <report id="eSENS-T004-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
        </rule>
       
        <rule context="ubl:CallForTenders/cbc:CustomizationID">
            <assert id="eSENS-T004-R002" flag="fatal" test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm083:ver3.0:extended:urn:fdc:peppol.eu:2017:pracc:t004:ver1.0'">[eSENS-T004-R002] CustomizationID value MUST be 'urn:www.cenbii.eu:transaction:biitrdm083:ver3.0:extended:urn:fdc:peppol.eu:2017:pracc:t004:ver1.0'</assert>
            <report id="eSENS-T004-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S303] CustomizationID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cbc:ProfileID">
            <assert id="eSENS-T004-R003" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:2017:pracc:p002:01:1.0'">[eSENS-T004-R003] ProfileID value MUST be 'urn:fdc:peppol.eu:2017:pracc:p002:01:1.0'</assert>
            <report id="eSENS-T004-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S304] ProfileID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cbc:ID">
            <assert id="eSENS-T004-R004" flag="warning" test="./@schemeURI">[eSENS-T004-R004] A Call For Tenders Identifier MUST have a schemeURI attribute.</assert>
            <assert id="eSENS-T004-R005" flag="warning" test="normalize-space(./@schemeURI)='urn:uuid'">[eSENS-T004-R005] schemeURI for Call For Tenders Identifier MUST be 'urn:uuid'.</assert>
            <assert id="eSENS-T004-R006" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[eSENS-T004-R006] A Call For Tenders Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
            <report id="eSENS-T004-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[eSENS-T004-S306] A Call For Tenders Identifier SHOULD NOT have any attributes but schemeURI</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cbc:ContractFolderID">
            <report id="eSENS-T004-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S309] ContractFolderID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cbc:IssueTime">
            <assert id="eSENS-T004-R008" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[eSENS-T004-R008] IssueTime MUST include timezone information.</assert>
            <assert id="eSENS-T004-R009" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[eSENS-T004-R009] IssueTime MUST have a granularity of seconds</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cbc:VersionID">
            <report id="eSENS-T004-S312" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S312] VersionID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='REQ']">
            <assert id="eSENS-T004-S317" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:DocumentStatusCode)=0"><value-of select="$syntaxError"/>[eSENS-T004-S317] AdditionalDocumentReference for a Document with DocumentTypeCode='REQ' SHOULD NOT contain any elements but ID, DocumentTypeCode, DocumentStatusCode</assert>
            <assert id="eSENS-T004-R023" flag="fatal" test="normalize-space(./cbc:DocumentStatusCode) !='NR'">[eSENS-T004-R023] DocumentStatusCode 'NR' is NOT valid for an AdditionalDocumentReference with DocumentType 'REQ'</assert>
            <report id="eSENS-T004-S326" flag="warning" test="count(./cbc:DocumentDescription) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S326] DocumentDescription SHOULD NOT be used more than once when DocumentTypeCode = 'REQ'.</report>
        </rule>

        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PRO']">
            <assert id="eSENS-T004-R036" flag="fatal" test="(./cac:Attachment)">[eSENS-T004-R036] A Provided Document Referernce MUST reference the provided document.</assert>
        </rule>

        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PRO']/cbc:DocumentDescription">
            <assert id="eSENS-T004-R030" flag="fatal" test="/ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID = normalize-space(.)">[eSENS-T004-R030] DocumentDescription MUST be a valid Procurement Project Lot Identifier"/></assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference">
            <assert id="eSENS-T004-S316" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:IssueDate)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentStatusCode)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0"><value-of select="$syntaxError"/>[eSENS-T004-S316] AdditionalDocumentReference SHOULD NOT contain any elements but ID, IssueDate, DocumentTypeCode, LocaleCode, VersionID, DocumentStatusCode, DocumentDescription, Attachment.</assert>
            <assert id="eSENS-T004-S318" flag="warning" test="(./cbc:DocumentTypeCode)"><value-of select="$syntaxError"/>[eSENS-T004-S318] DocumentTypeCode SHOULD be used.</assert>
            <assert id="eSENS-T004-S323" flag="warning" test="(./cbc:DocumentStatusCode)"><value-of select="$syntaxError"/>[eSENS-T004-S323] DocumentStatusCode SHOULD be used.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:ID">
            <report id="eSENS-T004-S319" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S319] Additional Document Reference Identifier SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
            <assert id="eSENS-T004-R017" flag="fatal" test="./@listID">[eSENS-T004-R017] DocumentTypeCode MUST have a list Identifier.</assert>
            <assert id="eSENS-T004-R018" flag="fatal" test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'">[eSENS-T004-R018] listID for DocumentTypeCode MUST be 'urn:eu:esens:cenbii:documentType'.</assert>
            <assert id="eSENS-T004-R019" flag="fatal" test="matches(normalize-space(.),'^(PRO|REQ|916)$')">[eSENS-T004-R019] DocumentTypeCode MUST be one of 'PRO' or 'REQ' or '916'.</assert>
            <report id="eSENS-T004-S320" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S320] DocumentTypeCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:LocaleCode">
            <assert id="eSENS-T004-R014" flag="fatal" test="./@listID">[eSENS-T004-R014] LocaleCode MUST have a list Identifier.</assert>
            <assert id="eSENS-T004-R015" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">[eSENS-T004-R015] listID for LocaleCode MUST be 'ISO639-1'.</assert>
            <assert id="eSENS-T004-R016" flag="fatal" test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">[eSENS-T004-R016] LocalCode MUST be a valid Language Code.</assert>
            <report id="eSENS-T004-S321" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S321] LocaleCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:VersionID">
            <report id="eSENS-T004-S322" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S322] Additional Document Reference VersionIdentifier SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentStatusCode">
            <assert id="eSENS-T004-R020" flag="fatal" test="./@listID">[eSENS-T004-R020] DocumentStatusCode MUST have a list Identifier.</assert>
            <assert id="eSENS-T004-R021" flag="fatal" test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentStatusType'">[eSENS-T004-R021] listID for DocumentStatusCode MUST be 'urn:eu:esens:cenbii:documentStatusType'.</assert>
            <assert id="eSENS-T004-R022" flag="fatal" test="matches(normalize-space(.),'^(NR|RWOS|RWAS|RWQS)$')">[eSENS-T004-R022] DocumentStatusCode MUST be one of NR,RWOS, RWAS ,RWQS</assert>
            <report id="eSENS-T004-S324" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S324] DocumentStatusCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentDescription">
            <report id="eSENS-T004-S325" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S325] DocumentDescription SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment">
            <assert id="eSENS-T004-S328" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0"><value-of select="$syntaxError"/>[eSENS-T004-S328] Attachment SHOULD NOT contain any element but ExternalReference</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
            <assert id="eSENS-T004-S329" flag="warning" test="count(./*)-count(./cbc:URI)-count(./cbc:MimeCode)-count(./cbc:FileName)=0"><value-of select="$syntaxError"/>[eSENS-T004-S329] ExternalReference SHOULD NOT contain any element but URI, MimeCode, FileName</assert>
            <assert id="eSENS-T004-R035" flag="fatal" test="(./cbc:URI) or (./cbc:FileName)">[eSENS-T004-R035] ExternalReference MUST include either URI or FileName</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
            <report id="eSENS-T004-S330" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S330] URI SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
            <report id="eSENS-T004-S395" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S395] MimeCode SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
            <report id="eSENS-T004-S396" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S396] FileName SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ContractingParty">
            <assert id="eSENS-T004-S333" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[eSENS-T004-S333] ContractingParty SHOULD NOT contain any elements but cac:Party.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party">
            <assert id="eSENS-T004-S334" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0"><value-of select="$syntaxError"/>[eSENS-T004-S334] A ContractingParty/cac:Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</assert>
            <assert id="eSENS-T004-S336" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>[eSENS-T004-S336] PartyIdentification SHOULD be used exactly once.</assert>
            <report id="eSENS-T004-S338" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S338] PartyName SHOULD NOT be used more than once.</report>
            <report id="eSENS-T004-S340" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S340] PartyLegalEntity SHOULD NOT be used more than once.</report>
            <assert id="eSENS-T004-R034" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[eSENS-T004-R034] A Call for Tenders MUST identify the Contracting Body by its party and endpoint identifiers.</assert>
        </rule>

        <rule context="ubl:CallForTenders/cac:ReceiverParty">
            <assert id="eSENS-T004-S500" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0"><value-of select="$syntaxError"/>[eSENS-T004-S334] A cac:ReceivingParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</assert>
            <assert id="eSENS-T004-S501" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>[eSENS-T004-500] PartyIdentification SHOULD be used exactly once.</assert>
            <report id="eSENS-T004-S502" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S501] PartyName SHOULD NOT be used more than once.</report>
            <report id="eSENS-T004-S503" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S502] PartyLegalEntity SHOULD NOT be used more than once.</report>
            <assert id="eSENS-T004-R534" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[eSENS-T004-R534] A Call for Tenders MUST identify the Economic Operator / Receiving Party by its party and endpoint identifiers.</assert>
        </rule>
        
        <rule context="cbc:EndpointID">
            <assert id="eSENS-T004-R012" flag="fatal" test="./@schemeID">[eSENS-T004-R012] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="eSENS-T004-R013" flag="fatal" test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">[eSENS-T004-R013] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="eSENS-T004-S335" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T004-S335] EndpointID SHOULD NOT have any further attributes but schemeID</report>
        </rule>
        
        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="eSENS-T004-R010" flag="fatal" test="./@schemeID">[eSENS-T004-R010] A Party Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="eSENS-T004-R011" flag="fatal" test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">[eSENS-T004-R011] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="eSENS-T004-S337" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T004-S337] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
        </rule>
        
        <rule context="cbc:Name">
            <report id="eSENS-T004-S339" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S339] Name SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity">
            <assert id="eSENS-T004-S341" flag="warning" test="count(./*)-count(./cac:RegistrationAddress)=0"><value-of select="$syntaxError"/>[eSENS-T004-S341] PartyLegalEntity SHOULD NOT contain any elements but cac:RegistrationAddress.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
            <assert id="eSENS-T004-S342" flag="warning" test="count(./*)-count(./cac:Country)=0"><value-of select="$syntaxError"/>[eSENS-T004-S342] RegistrationAddress SHOULD NOT contain any elements but cac:Country.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
            <assert id="eSENS-T004-S343" flag="warning" test="count(./*)-count(./cbc:IdentificationCode)=0"><value-of select="$syntaxError"/>[eSENS-T004-S343] Country SHOULD NOT contain any elements but IdentificationCode.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
            <report id="eSENS-T004-S344" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S344] IdentificationCode SHOULD NOT have any attributes but listID,</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms">
            <assert id="eSENS-T004-S348" flag="warning" test="count(./*)-count(./cbc:MaximumVariantQuantity)-count(./cbc:VariantConstraintIndicator)-count(./cbc:Note)-count(./cbc:AdditionalConditions)-count(./cac:ProcurementLegislationDocumentReference)-count(./cac:CallForTendersDocumentReference)-count(./cac:TenderRecipientParty)=0"><value-of select="$syntaxError"/>[eSENS-T004-S348] TenderingTerms SHOULD NOT contain any element but MaximumVariantQuantity, VariantConstraintIndicator, Note, AdditionalConditions, ProcurementLegislationDocumentReference, CallForTendersDocumentReference, TenderRecipientParty.</assert>
            <assert id="eSENS-T004-S353" flag="warning" test="(./cbc:VariantConstraintIndicator)"><value-of select="$syntaxError"/>[eSENS-T004-S353] VariantConstraintIndicator SHOULD be used.</assert>
            <report id="eSENS-T004-S354" flag="warning" test="count(./cbc:Note) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S354] Note SHOULD NOT be used more than once</report>
            <report id="eSENS-T004-S358" flag="warning" test="count(./cbc:AdditionalConditions) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T004-S358] AdditionalConditions SHOULD NOT be used more than once</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity">
            <assert id="eSENS-T004-S349" flag="warning" test="matches(normalize-space(.),'^\d+$')"><value-of select="$syntaxError"/>[eSENS-T004-S349] MaximumVariantQuantity SHOULD be expressed as an integer value.</assert>
            <report id="eSENS-T004-S350" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S350] MaximumVariantQuantity SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='false']">
            <assert id="eSENS-T004-S351" flag="warning" test="count(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)=0 or normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)='0'"><value-of select="$syntaxError"/>[eSENS-T004-S351] MaximumVariantQuantity SHOULD NOT be used or MUST be equal to 0 when VariantConstraintIndicator is set to false.</assert>
        </rule>
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='true']">
            <assert id="eSENS-T004-R032" flag="fatal" test="number(normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)) &gt; 0">[eSENS-T004-R032] MaximumVariantQuantity MUST be greater than 0 when VariantConstraintIndicator is set to true.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:Note">
            <assert id="eSENS-T004-S355" flag="warning" test="matches(normalize-space(.),'^\d+$')"><value-of select="$syntaxError"/>[eSENS-T004-S355] Note SHOULD be expressed as an integer value when used.</assert>
            <report id="eSENS-T004-S357" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S357] Note SHOULD NOT contain any attributes.</report>
            <assert id="eSENS-T004-R031" flag="fatal" test="normalize-space(/ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode)='POSTAL'">[eSENS-T004-R031] Note MUST only be used when Submission Method Code equals to POSTAL</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:AdditionalConditions">
            <assert id="eSENS-T004-R033" flag="fatal" test="matches(normalize-space(.),'^(WOS|WAS|WQS)$')">[eSENS-T004-R033] AdditionalConditions value MUST be one of 'WOS', 'WAS, 'WQS'.</assert>
            <report id="eSENS-T004-S360" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S360] AdditionalConditions SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference">
            <assert id="eSENS-T004-S361" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentDescription)=0"><value-of select="$syntaxError"/>[eSENS-T004-S361] ProcurementLegislationDocumentReference SHOULD NOT contain any elements but ID, DocumentDescription.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID">
            <report id="eSENS-T004-S362" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S362] ProcurementLegislationDocumentReference Identifier SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:DocumentDescription">
            <report id="eSENS-T004-S363" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S363] ProcurementLegislationDocumentReference DocumentDescription SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference">
            <assert id="eSENS-T004-S364" flag="warning" test="count(./*)-count(./cbc:ID)=0"><value-of select="$syntaxError"/>[eSENS-T004-S364] CallForTendersDocumentReference SHOULD NOT contain any elements but ID</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/cbc:ID">
            <assert id="eSENS-T004-R025" flag="fatal" test="./@schemeURI">[eSENS-T004-R025] A Call For Tenders Document Reference Identifier MUST have a schemeURI attribute.</assert>
            <assert id="eSENS-T004-R026" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[eSENS-T004-R026] schemeURI for Call For Tenders Document Reference Identifier MUST be 'urn:uuid'.</assert>
            <assert id="eSENS-T004-R027" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[eSENS-T004-R027] A Call For Tenders Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
            <report id="eSENS-T004-S365" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[eSENS-T004-S365] A Call For Tenders Document Reference Identifier SHOULD NOT have any attributes but schemeURI</report>
        </rule>

        <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty">
            <assert id="eSENS-T004-S367" flag="warning" test="count(./*)-count(./cbc:EndpointID)=0"><value-of select="$syntaxError"/>[eSENS-T004-S367] TenderRecipientParty SHOULD NOT contain any elements but EndpointID</assert>
        </rule>

        <rule context="ubl:CallForTenders/cac:TenderingProcess">
            <assert id="eSENS-T004-S369" flag="warning" test="count(./*)-count(./cbc:ProcedureCode)-count(./cbc:ContractingSystemCode)-count(./cbc:SubmissionMethodCode)-count(./cac:TenderSubmissionDeadlinePeriod)-count(./cac:ParticipationRequestReceptionPeriod)=0"><value-of select="$syntaxError"/>[eSENS-T004-S369] TenderingProcess SHOULD NOT contain any elements but ProcedureCode, ContractingSystemCode, SubmissionMethodCode, TenderSubmissionDeadlinePeriod, ParticipationRequestReceptionPeriod.</assert>
            <assert id="eSENS-T004-S370" flag="warning" test="(./cbc:ProcedureCode)"><value-of select="$syntaxError"/>[eSENS-T004-S370] ProcedureCode SHOULD be used.</assert>
            <assert id="eSENS-T004-S373" flag="warning" test="(./cac:TenderSubmissionDeadlinePeriod)"><value-of select="$syntaxError"/>[eSENS-T004-S373] TenderSubmissionDeadlinePeriod SHOULD be used.</assert>
            <assert id="eSENS-T004-R037" flag="fatal" test="(cbc:ProcedureCode = '1' and not(exists(cac:ParticipationRequestReceptionPeriod))) or (cbc:ProcedureCode!='1')">[eSENS-T004-R037] Participation Request Reception Period MUST not be given for proceduretypes without participation contest.</assert> 
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:ProcedureCode">
            <report id="eSENS-T004-S371" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S371] ProcedureCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:ContractingSystemCode">
            <report id="eSENS-T004-S397" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S397] ContractingSystemCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode">
            <report id="eSENS-T004-S372" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S372] SubmissionMethodCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod">
            <assert id="eSENS-T004-S374" flag="warning" test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0"><value-of select="$syntaxError"/>[eSENS-T004-S374] TenderSubmissionDeadlinePeriod SHOULD NOT contain any elements but EndDate and EndTime.</assert>
            <assert id="eSENS-T004-S375" flag="warning" test="(./cbc:EndDate)"><value-of select="$syntaxError"/>[eSENS-T004-S375] TenderSubmissionDeadlinePeriod EndDate SHOULD be used.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod">
            <assert id="eSENS-T004-S376" flag="warning" test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0"><value-of select="$syntaxError"/>[eSENS-T004-S376] ParticipationRequestReceptionPeriod SHOULD NOT contain any elements but EndDate and EndTime.</assert>
            <!--<assert id="eSENS-T004-S377" flag="warning" test="(./cbc:EndDate)"><value-of select="$syntaxError"/>[eSENS-T004-S377] ParticipationRequestReceptionPeriod EndDate SHOULD be used.</assert>
            -->
        </rule>
        
        <rule context="cbc:EndTime">
            <assert id="eSENS-T004-R028" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[eSENS-T004-R028] EndTime MUST include timezone information.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject">
            <assert id="eSENS-T004-S378" flag="warning" test="count(./*)-count(./cbc:Name)-count(./cbc:Description)-count(./cbc:ProcurementTypeCode)-count(./cac:MainCommodityClassification)-count(./cac:AdditionalCommodityClassification)-count(./cac:RealizedLocation)=0"><value-of select="$syntaxError"/>[eSENS-T004-S378] ProcurementProject SHOULD NOT contain any elements but Name, Description, ProcurementTypeCode, MainCommodityClassification, AdditionalCommodityClassification, RealizedLocation.</assert>
            <assert id="eSENS-T004-S379" flag="warning" test="count(./cbc:Name) = 1"><value-of select="$syntaxError"/>[eSENS-T004-S379] ProcurementProject Name SHOULD be used exactly once.</assert>
            <assert id="eSENS-T004-S380" flag="warning" test="count(./cbc:Description) = 1"><value-of select="$syntaxError"/>[eSENS-T004-S380] ProcurementProject Description SHOULD be used exactly once.</assert>
            <assert id="eSENS-T004-S382" flag="warning" test="(./cbc:ProcurementTypeCode)"><value-of select="$syntaxError"/>[eSENS-T004-S382] ProcurementTypeCode SHOULD be used.</assert>
            <assert id="eSENS-T004-S384" flag="warning" test="count(./cac:MainCommodityClassification) = 1"><value-of select="$syntaxError"/>[eSENS-T004-S384] ProcurementProject MainCommodityClassification SHOULD be used exactly once.</assert>
            <assert id="eSENS-T004-S388" flag="warning" test="count(./cac:RealizedLocation) &gt; 0"><value-of select="$syntaxError"/>[eSENS-T004-S388] ProcurementProject RealizedLocation SHOULD be used at least once.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject/cbc:Description">
            <report id="eSENS-T004-S381" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S381] ProcurementProject Description SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject/cbc:ProcurementTypeCode">
            <report id="eSENS-T004-S383" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S383] ProcurementTypeCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification">
            <assert id="eSENS-T004-S385" flag="warning" test="count(./*)-count(./cbc:ItemClassificationCode)=0"><value-of select="$syntaxError"/>[eSENS-T004-S385] MainCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification">
            <assert id="eSENS-T004-S386" flag="warning" test="count(./*)-count(./cbc:ItemClassificationCode)=0"><value-of select="$syntaxError"/>[eSENS-T004-S386] AdditionalCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</assert>
        </rule>
        
        <rule context="cbc:ItemClassificationCode">
            <report id="eSENS-T004-S387" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T004-S387] ItemClassificationCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation">
            <assert id="eSENS-T004-S389" flag="warning" test="count(./*)-count(./cbc:ID)=0"><value-of select="$syntaxError"/>[eSENS-T004-S389] RealizedLocation SHOULD NOT contain any elements but ID.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/cbc:ID">
            <report id="eSENS-T004-S390" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T004-S390] cac:RealizedLocation/cbc:ID SHOULD NOT have any attributes but schemeID.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProjectLot">
            <assert id="eSENS-T004-S391" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cac:ProcurementProject)=0"><value-of select="$syntaxError"/>[eSENS-T004-S391] ProcurementProjectLot SHOULD NOT contain any elements but ID, ProcurementProject.</assert>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID">
            <report id="eSENS-T004-S392" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T004-S392] ProcurementProjectLot Identifier SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject">
            <assert id="eSENS-T004-S393" flag="warning" test="count(./*)-count(./cbc:Name)=0"><value-of select="$syntaxError"/>[eSENS-T004-S393] ProcurementProjectLot ProcurementProject SHOULD NOT contain any elements but Name.</assert>
            <assert id="eSENS-T004-S394" flag="warning" test="count(./cbc:Name) = 1"><value-of select="$syntaxError"/>[eSENS-T004-S394] ProcurementProjectLot ProcurementProject Name SHOULD   be used exactly once.</assert> 
        </rule>
            
    </pattern>
</schema>