<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>eSENS business and syntax rules for Submit Tender (TRDM090)</title>
  
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Tender-2"/>
    
    <pattern>
        <rule context="*">
            <report id="eSENS-T005-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[eSENS-T005-S002] A Submit Tender document MUST NOT contain empty elements.</report>
        </rule>
    </pattern>
    <pattern>
        <let name="syntaxError" value="string('[eSENS-T005-S003] A Submit Tender document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
        
        <rule context="ubl:Tender">
            <assert id="eSENS-T005-R001" flag="fatal" test="(cbc:UBLVersionID)">[eSENS-T005-R001] A Tender MUST have a syntax identifier.</assert>
            <report id="eSENS-T005-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[eSENS-T005-S301] UBLExtensions SHOULD NOT be used.</report>
            <report id="eSENS-T005-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>[eSENS-T005-S305] ProfileExecutionID SHOULD NOT be used.</report>
            <report id="eSENS-T005-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[eSENS-T005-S307] CopyIndicator SHOULD NOT be used.</report>
            <report id="eSENS-T005-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[eSENS-T005-S308] UUID SHOULD NOT be used.</report>
            <report id="eSENS-T005-S309" flag="warning" test="(cbc:TenderTypeCode)"><value-of select="$syntaxError"/>[eSENS-T005-S309] TenderTypeCode SHOULD NOT be used.</report>
            <report id="eSENS-T005-S311" flag="warning" test="(cbc:ConctractName)"><value-of select="$syntaxError"/>[eSENS-T005-S311] ContractName SHOULD NOT be used.</report>
            <report id="eSENS-T005-S312" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[eSENS-T005-S312] Note SHOULD NOT be used.</report>
            <report id="eSENS-T005-S313" flag="warning" test="(cac:ValidityPeriod)"><value-of select="$syntaxError"/>[eSENS-T005-S313] ValidityPeriod SHOULD NOT be used.</report>
            <assert id="eSENS-T005-S314" flag="warning" test="count(cac:DocumentReference) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T005-S314] DocumentReference SHOULD be used at least twice.</assert>
            <assert id="eSENS-T005-R013" flag="fatal"   test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)">[eSENS-T005-R013] DocumentReference Identifiers MUST be unique.</assert>
            <assert id="eSENS-T005-R014" flag="fatal"   test="count(distinct-values(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)) = count(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)">[eSENS-T005-R014] FileName values MUST be unique.</assert>
            <report id="eSENS-T005-S328" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[eSENS-T005-S328] Signature SHOULD NOT be used.</report>
            <report id="eSENS-T005-S350" flag="warning" test="(cac:TendererQualificationDocumentReference)"><value-of select="$syntaxError"/>[eSENS-T005-S350] TendererQualificationDocumentReference SHOULD NOT be used.</report>
            <report id="eSENS-T005-S351" flag="warning" test="(cac:SubcontractorParty)"><value-of select="$syntaxError"/>[eSENS-T005-S351] SubcontractorParty SHOULD NOT be used.</report>
            <assert id="eSENS-T005-S352" flag="warning" test="count(cac:ContractingParty) = 1"><value-of select="$syntaxError"/>[eSENS-T005-S352] ContractingParty SHOULD be used exactly once.</assert>
            <report id="eSENS-T005-S356" flag="warning" test="(cac:OriginatorCustomerParty)"><value-of select="$syntaxError"/>[eSENS-T005-S356] OriginatorCustomerParty SHOULD NOT be used.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:UBLVersionID">
            <assert id="eSENS-T005-R021" flag="fatal" test="normalize-space(.) = '2.2'">[eSENS-T005-R021] UBLVersionID value MUST be '2.2'</assert>
            <report id="eSENS-T005-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:CustomizationID">
            <assert id="eSENS-T005-R002" flag="fatal" test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm090:ver3.0:extended:urn:fdc:peppol.eu:2017:pracc:t005:ver1.0'">[eSENS-T005-R002] CustomizationID value MUST be 'urn:www.cenbii.eu:transaction:biitrdm090:ver3.0:extended:urn:fdc:peppol.eu:2017:pracc:t005:ver1.0'</assert>
            <report id="eSENS-T005-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S303] CustomizationID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:ProfileID">
            <assert id="eSENS-T005-R003" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:2017:pracc:p003:01:1.0'">[eSENS-T005-R003] ProfileID value MUST be 'urn:fdc:peppol.eu:2017:pracc:p003:01:1.0'</assert>
            <report id="eSENS-T005-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S304] ProfileID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:ID">
            <assert id="eSENS-T005-R004" flag="fatal" test="./@schemeURI">[eSENS-T005-R004] A Submit Tender Identifier MUST have a schemeURI attribute.</assert>
            <assert id="eSENS-T005-R005" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[eSENS-T005-R005] schemeURI for Submit Tender Identifier MUST be 'urn:uuid'.</assert>
            <report id="eSENS-T005-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[eSENS-T005-S306] A Submit Tender Identifier SHOULD NOT have any attributes but schemeURI</report>
            <assert id="eSENS-T005-R006" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[eSENS-T005-R006] A Submit Tender Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        
        <rule context="ubl:Tender/cbc:IssueTime">
            <assert id="eSENS-T005-R007" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[eSENS-T005-R007] IssueTime MUST have a granularity of seconds</assert>
        </rule>
        
        
        <rule context="ubl:Tender/cbc:ContractFolderID">
            <report id="eSENS-T005-S310" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S310] ContractFolderID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference">
            <assert id="eSENS-T005-S315" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0"><value-of select="$syntaxError"/>[eSENS-T005-S315] DocumentReference SHOULD NOT contain any elements but ID, DocumentTypeCode, LocaleCode, VersionID, DocumentDescription, Attachment</assert>
            <report id="eSENS-T005-S320" flag="warning" test="count(./cbc:DocumentDescription) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T005-S320] DocumentDescription SHOULD NOT be used more than once.</report>
        </rule>
        
        <rule context="cbc:EndpointID">
            <assert id="eSENS-T005-R010" flag="fatal" test="./@schemeID">[eSENS-T005-R010] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="eSENS-T005-R011" flag="fatal" test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">[eSENS-T005-R011] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="eSENS-T005-S316" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T005-S316] EndpointID SHOULD NOT have any attributes but schemeID</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference[normalize-space(./cbc:DocumentTypeCode)='311']/cbc:ID">
            <assert id="eSENS-T005-R012" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[eSENS-T005-R012] DocumentReference Identifier for a Call for Tender Reference MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode">
            <report id="eSENS-T005-S317" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T005-S317] DocumentTypeCode SHOULD NOT have any attributes but listID</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:LocaleCode">
            <assert id="eSENS-T005-R015" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">[eSENS-T005-R015] listID for LocaleCode MUST be 'ISO639-1'.</assert>
            <assert id="eSENS-T005-R016" flag="fatal" test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">[eSENS-T005-R016] LocalCode MUST be a valid Language Code.</assert>
            <report id="eSENS-T005-S318" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T005-S318] LocaleCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:VersionID">
            <report id="eSENS-T005-S319" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S319] VersionID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:DocumentDescription">
            <report id="eSENS-T005-S321" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S321] DocumentDescription SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment">
            <assert id="eSENS-T005-S322" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0"><value-of select="$syntaxError"/>[eSENS-T005-S322] Attachment SHOULD NOT contain any elements but ExternalReference</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference">
            <assert id="eSENS-T005-S323" flag="warning" test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)-count(./cbc:MimeCode)-count(./cbc:FileName)=0"><value-of select="$syntaxError"/>[eSENS-T005-S323] Attachment/ExternalReference SHOULD NOT contain any elements but DocumentHash, HashAlgorithmMethod, MimeCode, FileName</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
            <assert id="eSENS-T005-R017" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">[eSENS-T005-R017] DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)</assert>
            <report id="eSENS-T005-S324" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S324] DocumentHash SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
            <assert id="eSENS-T005-R018" flag="fatal" test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">[eSENS-T005-R018] HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'</assert>
            <report id="eSENS-T005-S325" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S325] HashAlgorithmMethod SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
            <report id="eSENS-T005-S326" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S326] FileNAme SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
            <report id="eSENS-T005-S327" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S327] MimeCode SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:TendererParty">
            <assert id="eSENS-T005-S329" flag="warning" test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)-count(./cac:PartyName)-count(./cac:PostalAddress)-count(./cac:PartyLegalEntity)-count(./cac:Contact)=0"><value-of select="$syntaxError"/>[eSENS-T005-S329] TendererParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PostalAddress, PartyLegalEntity, Contact</assert>
            <assert id="eSENS-T005-S332" flag="warning" test="count(./cac:PartyName) = 1"><value-of select="$syntaxError"/>[eSENS-T005-S332] PartyName SHOULD be used exactly once.</assert>
            <report id="eSENS-T005-S342" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T005-S342] PartyLegalEntity SHOULD NOT be used more than once.</report>
            <assert id="eSENS-T005-R020" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[eSENS-T005-R020] A Tender MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
        </rule>
        
        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="eSENS-T005-R008" flag="fatal" test="./@schemeID">[eSENS-T005-R008] A Party Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="eSENS-T005-R009" flag="fatal" test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">[eSENS-T005-R009] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="eSENS-T005-S331" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T005-S331] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
        </rule>
        
        <rule context="cbc:Name">
            <report id="eSENS-T005-S333" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S333] Name SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:TendererParty/cac:PostalAddress">
            <assert id="eSENS-T005-S334" flag="warning" test="count(./*)-count(./cbc:StreetName)-count(./cbc:AdditionalStreetName)-count(./cbc:CityName)-count(./cbc:PostalZone)-count(./cbc:CountrySubentity)-count(./cac:Country)=0"><value-of select="$syntaxError"/>[eSENS-T005-S334] PostalAddress SHOULD NOT contain any elements but StreetName, AdditionalStreetName, CityName, PostalZone, CountrySubentity, Country</assert>
        </rule>
        
        <rule context="cbc:StreetName">
            <report id="eSENS-T005-S335" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S335] cbc:StreetName SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:AdditionalStreetName">
            <report id="eSENS-T005-S336" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S336] cbc:AdditionalStreetName SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:CityName">
            <report id="eSENS-T005-S337" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S337] cbc:CityName SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:PostalZone">
            <report id="eSENS-T005-S338" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S338] cbc:PostalZone SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:CountrySubentity">
            <report id="eSENS-T005-S339" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S339] cbc:CountrySubentity SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cac:Country">
            <assert id="eSENS-T005-S340" flag="warning" test="count(./*)-count(./cbc:IdentificationCode)=0"><value-of select="$syntaxError"/>[eSENS-T005-S340] cac:Country SHOULD NOT contain any elements but IdentificationCode.</assert>
        </rule>
        
        <rule context="cac:Country/cbc:IdentificationCode">
            <report id="eSENS-T005-S341" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[eSENS-T005-S341] Country Identification Code SHOULD NOT contain any attributes but listID</report>
        </rule>
        
        <rule context="cac:PartyLegalEntity">
            <assert id="eSENS-T005-S343" flag="warning" test="count(./*)-count(./cbc:CompanyLegalForm)-count(./cac:RegistrationAddress) = 0"><value-of select="$syntaxError"/>[eSENS-T005-S343] cac:PartyLegalEntity SHOULD NOT contain any elements but CompanyLegalForm, RegistrationAddress.</assert>
        </rule>
        
        <rule context="cac:PartyLegalEntity/cbc:CompanyLegalForm">
            <report id="eSENS-T005-S344" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S344] CompanyLegalForm SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cac:PartyLegalEntity/cac:RegistrationAddress">
            <assert id="eSENS-T005-S345" flag="warning" test="count(./*)-count(./cac:Country) = 0"><value-of select="$syntaxError"/>[eSENS-T005-S345] cac:RegistrationAddress SHOULD NOT contain any elements but Country.</assert>
        </rule>
        
        <rule context="cac:Contact">
            <assert id="eSENS-T005-S346" flag="warning" test="count(./*)-count(./cbc:Telephone)-count(./cbc:Telefax)-count(./cbc:ElectronicMail)-count(./cbc:Name)= 0"><value-of select="$syntaxError"/>[eSENS-T005-S346] Contact SHOULD NOT contain any elements but Telephone, Telefax, ElectronicMail, Name.</assert>
        </rule>
        
        <rule context="cbc:Telephone">
            <report id="eSENS-T005-S347" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S347] cbc:Telephone SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:Telefax">
            <report id="eSENS-T005-S348" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S348] cbc:Telefax SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:ElectronicMail">
            <report id="eSENS-T005-S349" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S349] cbc:ElectronicMail SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="ubl:Tender/cac:ContractingParty">
            <assert id="eSENS-T005-S353" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[eSENS-T005-S353] ContractingParty SHOULD NOT contain any elements but Party.</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:ContractingParty/cac:Party">
            <assert id="eSENS-T005-S354" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>[eSENS-T005-S354] ContractingParty Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
            <report id="eSENS-T005-S355" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T005-S355] ContractingParty/Party/PartyName SHOULD NOT be used more than once.</report>
            <assert id="eSENS-T005-R019" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[eSENS-T005-R019] A Tender MUST identify the Contracting Authority by its party and endpoint identifiers.</assert>
        </rule>    
        
        <rule context="ubl:Tender/cac:ContractingParty/cac:Party | ubl:Tender/cac:TendererParty">
            <assert id="eSENS-T005-S330" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>[eSENS-T005-S330] PartyIdentification SHOULD be used exactly once.</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:TenderedProject">
            <assert id="eSENS-T005-S357" flag="warning" test="count(./*)-count(./cac:ProcurementProjectLot)= 0"><value-of select="$syntaxError"/>[eSENS-T005-S357] TenderedProject SHOULD NOT contain any elements but ProcurementProjectLot</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot">
            <assert id="eSENS-T005-S358" flag="warning" test="count(./*)-count(./cbc:ID)= 0"><value-of select="$syntaxError"/>[eSENS-T005-S358] ProcurementProjectLot SHOULD NOT contain any elements but ID</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot/cbc:ID">
            <report id="eSENS-T005-S359" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T005-S359] Procurement Project Lot Identifier SHOULD NOT contain any attributes</report>
        </rule>
        
        
    </pattern>
</schema>