<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>eSENS business and syntax rules for Submit Tender (TRDM090)</title>
  
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Tender-2"/>
    
    <pattern>
        <rule context="*">
            <report id="PEPPOL-T005-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[PEPPOL-T005-S002] A Submit Tender document MUST NOT contain empty elements.</report>
        </rule>
    </pattern>
    <pattern>
        <let name="syntaxError" value="string('A Submit Tender document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
        
        <rule context="ubl:Tender">
            <assert id="PEPPOL-T005-R001" flag="fatal" test="(cbc:UBLVersionID)">A Tender MUST have a syntax identifier.</assert>
            <report id="PEPPOL-T005-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>UBLExtensions SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>ProfileExecutionID SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>CopyIndicator SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>UUID SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S309" flag="warning" test="(cbc:TenderTypeCode)"><value-of select="$syntaxError"/>TenderTypeCode SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S311" flag="warning" test="(cbc:ConctractName)"><value-of select="$syntaxError"/>ContractName SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S312" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>Note SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S313" flag="warning" test="(cac:ValidityPeriod)"><value-of select="$syntaxError"/>ValidityPeriod SHOULD NOT be used.</report>
            <assert id="PEPPOL-T005-S314" flag="warning" test="count(cac:DocumentReference) &gt; 1"><value-of select="$syntaxError"/>DocumentReference SHOULD be used at least twice.</assert>
            <assert id="PEPPOL-T005-R013" flag="fatal"   test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)">DocumentReference Identifiers MUST be unique.</assert>
            <assert id="PEPPOL-T005-R014" flag="fatal"   test="count(distinct-values(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)) = count(cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName)">FileName values MUST be unique.</assert>
            <report id="PEPPOL-T005-S328" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>Signature SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S350" flag="warning" test="(cac:TendererQualificationDocumentReference)"><value-of select="$syntaxError"/>TendererQualificationDocumentReference SHOULD NOT be used.</report>
            <report id="PEPPOL-T005-S351" flag="warning" test="(cac:SubcontractorParty)"><value-of select="$syntaxError"/>SubcontractorParty SHOULD NOT be used.</report>
            <assert id="PEPPOL-T005-S352" flag="warning" test="count(cac:ContractingParty) = 1"><value-of select="$syntaxError"/>ContractingParty SHOULD be used exactly once.</assert>
            <report id="PEPPOL-T005-S356" flag="warning" test="(cac:OriginatorCustomerParty)"><value-of select="$syntaxError"/>OriginatorCustomerParty SHOULD NOT be used.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:UBLVersionID">
            <assert id="PEPPOL-T005-R021" flag="fatal" test="normalize-space(.) = '2.2'">UBLVersionID value MUST be '2.2'</assert>
            <report id="PEPPOL-T005-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>UBLVersionID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:CustomizationID">
            <assert id="PEPPOL-T005-R002" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t005:1.2'">CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t005:1.2'</assert>
            <report id="PEPPOL-T005-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>CustomizationID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:ProfileID">
            <assert id="PEPPOL-T005-R003" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p003:1.2'">ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p003:1.2'</assert>
            <report id="PEPPOL-T005-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>ProfileID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cbc:ID">
            <assert id="PEPPOL-T005-R004" flag="fatal" test="./@schemeURI">A Submit Tender Identifier MUST have a schemeURI attribute.</assert>
            <assert id="PEPPOL-T005-R005" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">schemeURI for Submit Tender Identifier MUST be 'urn:uuid'.</assert>
            <report id="PEPPOL-T005-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>A Submit Tender Identifier SHOULD NOT have any attributes but schemeURI</report>
            <assert id="PEPPOL-T005-R006" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">A Submit Tender Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        
        <rule context="ubl:Tender/cbc:IssueTime">
            <assert id="PEPPOL-T005-R007" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
        </rule>
        
        
        <rule context="ubl:Tender/cbc:ContractFolderID">
            <report id="PEPPOL-T005-S310" flag="warning" test="./@*"><value-of select="$syntaxError"/>ContractFolderID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference">
            <assert id="PEPPOL-T005-S315" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0"><value-of select="$syntaxError"/>DocumentReference SHOULD NOT contain any elements but ID, DocumentTypeCode, LocaleCode, VersionID, DocumentDescription, Attachment</assert>
            <report id="PEPPOL-T005-S320" flag="warning" test="count(./cbc:DocumentDescription) &gt; 1"><value-of select="$syntaxError"/>DocumentDescription SHOULD NOT be used more than once.</report>
        </rule>
        
        <rule context="cbc:EndpointID">
            <assert id="PEPPOL-T005-R010" flag="fatal" test="./@schemeID">An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="PEPPOL-T005-R011" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="PEPPOL-T005-S316" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>EndpointID SHOULD NOT have any attributes but schemeID</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference[normalize-space(./cbc:DocumentTypeCode)='311']/cbc:ID">
            <assert id="PEPPOL-T005-R012" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">DocumentReference Identifier for a Call for Tender Reference MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode">
            <report id="PEPPOL-T005-S317" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>DocumentTypeCode SHOULD NOT have any attributes but listID</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:LocaleCode">
            <assert id="PEPPOL-T005-R015" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">listID for LocaleCode MUST be 'ISO639-1'.</assert>
            <assert id="PEPPOL-T005-R016" flag="fatal" test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">LocalCode MUST be a valid Language Code.</assert>
            <report id="PEPPOL-T005-S318" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>LocaleCode SHOULD NOT have any attributes but listID.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:VersionID">
            <report id="PEPPOL-T005-S319" flag="warning" test="./@*"><value-of select="$syntaxError"/>VersionID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cbc:DocumentDescription">
            <report id="PEPPOL-T005-S321" flag="warning" test="./@*"><value-of select="$syntaxError"/>DocumentDescription SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment">
            <assert id="PEPPOL-T005-S322" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0"><value-of select="$syntaxError"/>Attachment SHOULD NOT contain any elements but ExternalReference</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference">
            <assert id="PEPPOL-T005-S323" flag="warning" test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)-count(./cbc:MimeCode)-count(./cbc:FileName)=0"><value-of select="$syntaxError"/>Attachment/ExternalReference SHOULD NOT contain any elements but DocumentHash, HashAlgorithmMethod, MimeCode, FileName</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
            <assert id="PEPPOL-T005-R017" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)</assert>
            <report id="PEPPOL-T005-S324" flag="warning" test="./@*"><value-of select="$syntaxError"/>DocumentHash SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
            <assert id="PEPPOL-T005-R018" flag="fatal" test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'</assert>
            <report id="PEPPOL-T005-S325" flag="warning" test="./@*"><value-of select="$syntaxError"/>HashAlgorithmMethod SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
            <report id="PEPPOL-T005-S326" flag="warning" test="./@*"><value-of select="$syntaxError"/>FileNAme SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
            <report id="PEPPOL-T005-S327" flag="warning" test="./@*"><value-of select="$syntaxError"/>MimeCode SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:TendererParty">
            <assert id="PEPPOL-T005-S329" flag="warning" test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)-count(./cac:PartyName)-count(./cac:PostalAddress)-count(./cac:PartyLegalEntity)-count(./cac:Contact)=0"><value-of select="$syntaxError"/>TendererParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PostalAddress, PartyLegalEntity, Contact</assert>
            <assert id="PEPPOL-T005-S332" flag="warning" test="count(./cac:PartyName) = 1"><value-of select="$syntaxError"/>PartyName SHOULD be used exactly once.</assert>
            <report id="PEPPOL-T005-S342" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"><value-of select="$syntaxError"/>PartyLegalEntity SHOULD NOT be used more than once.</report>
            <assert id="PEPPOL-T005-R020" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">A Tender MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
        </rule>
        
        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="PEPPOL-T005-R008" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="PEPPOL-T005-R009" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="PEPPOL-T005-S331" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
        </rule>
        
        <rule context="cbc:Name">
            <report id="PEPPOL-T005-S333" flag="warning" test="./@*"><value-of select="$syntaxError"/>Name SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:Tender/cac:TendererParty/cac:PostalAddress">
            <assert id="PEPPOL-T005-S334" flag="warning" test="count(./*)-count(./cbc:StreetName)-count(./cbc:AdditionalStreetName)-count(./cbc:CityName)-count(./cbc:PostalZone)-count(./cbc:CountrySubentity)-count(./cac:Country)=0"><value-of select="$syntaxError"/>PostalAddress SHOULD NOT contain any elements but StreetName, AdditionalStreetName, CityName, PostalZone, CountrySubentity, Country</assert>
        </rule>
        
        <rule context="cbc:StreetName">
            <report id="PEPPOL-T005-S335" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:StreetName SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:AdditionalStreetName">
            <report id="PEPPOL-T005-S336" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:AdditionalStreetName SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:CityName">
            <report id="PEPPOL-T005-S337" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:CityName SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:PostalZone">
            <report id="PEPPOL-T005-S338" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:PostalZone SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:CountrySubentity">
            <report id="PEPPOL-T005-S339" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:CountrySubentity SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cac:Country">
            <assert id="PEPPOL-T005-S340" flag="warning" test="count(./*)-count(./cbc:IdentificationCode)=0"><value-of select="$syntaxError"/>cac:Country SHOULD NOT contain any elements but IdentificationCode.</assert>
        </rule>
        
        <rule context="cac:Country/cbc:IdentificationCode">
            <report id="PEPPOL-T005-S341" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>Country Identification Code SHOULD NOT contain any attributes but listID</report>
        </rule>
        
        <rule context="cac:PartyLegalEntity">
            <assert id="PEPPOL-T005-S343" flag="warning" test="count(./*)-count(./cbc:CompanyLegalForm)-count(./cac:RegistrationAddress) = 0"><value-of select="$syntaxError"/>cac:PartyLegalEntity SHOULD NOT contain any elements but CompanyLegalForm, RegistrationAddress.</assert>
        </rule>
        
        <rule context="cac:PartyLegalEntity/cbc:CompanyLegalForm">
            <report id="PEPPOL-T005-S344" flag="warning" test="./@*"><value-of select="$syntaxError"/>CompanyLegalForm SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cac:PartyLegalEntity/cac:RegistrationAddress">
            <assert id="PEPPOL-T005-S345" flag="warning" test="count(./*)-count(./cac:Country) = 0"><value-of select="$syntaxError"/>cac:RegistrationAddress SHOULD NOT contain any elements but Country.</assert>
        </rule>
        
        <rule context="cac:Contact">
            <assert id="PEPPOL-T005-S346" flag="warning" test="count(./*)-count(./cbc:Telephone)-count(./cbc:Telefax)-count(./cbc:ElectronicMail)-count(./cbc:Name)= 0"><value-of select="$syntaxError"/>Contact SHOULD NOT contain any elements but Telephone, Telefax, ElectronicMail, Name.</assert>
        </rule>
        
        <rule context="cbc:Telephone">
            <report id="PEPPOL-T005-S347" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:Telephone SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:Telefax">
            <report id="PEPPOL-T005-S348" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:Telefax SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="cbc:ElectronicMail">
            <report id="PEPPOL-T005-S349" flag="warning" test="./@*"><value-of select="$syntaxError"/>cbc:ElectronicMail SHOULD NOT contain any attributes</report>
        </rule>
        
        <rule context="ubl:Tender/cac:ContractingParty">
            <assert id="PEPPOL-T005-S353" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>ContractingParty SHOULD NOT contain any elements but Party.</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:ContractingParty/cac:Party">
            <assert id="PEPPOL-T005-S354" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>ContractingParty Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
            <report id="PEPPOL-T005-S355" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>ContractingParty/Party/PartyName SHOULD NOT be used more than once.</report>
            <assert id="PEPPOL-T005-R019" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">A Tender MUST identify the Contracting Authority by its party and endpoint identifiers.</assert>
        </rule>    
        
        <rule context="ubl:Tender/cac:ContractingParty/cac:Party | ubl:Tender/cac:TendererParty">
            <assert id="PEPPOL-T005-S330" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>PartyIdentification SHOULD be used exactly once.</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:TenderedProject">
            <assert id="PEPPOL-T005-S357" flag="warning" test="count(./*)-count(./cac:ProcurementProjectLot)= 0"><value-of select="$syntaxError"/>TenderedProject SHOULD NOT contain any elements but ProcurementProjectLot</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot">
            <assert id="PEPPOL-T005-S358" flag="warning" test="count(./*)-count(./cbc:ID)= 0"><value-of select="$syntaxError"/>ProcurementProjectLot SHOULD NOT contain any elements but ID</assert>
        </rule>
        
        <rule context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot/cbc:ID">
            <report id="PEPPOL-T005-S359" flag="warning" test="./@*"><value-of select="$syntaxError"/>Procurement Project Lot Identifier SHOULD NOT contain any attributes</report>
        </rule>
        
    </pattern>

    <pattern id="CodesT005">

        <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
            <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                    flag="fatal" id="CL-T90-R001">[CL-T90-R001]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
        </rule>

        <rule context="cbc:DocumentTypeCode" flag="fatal">
            <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 9 13 310 311 916 ',concat(' ',normalize-space(.),' ') ) ) )"
                    flag="fatal" id="CL-T90-R003">DocumentTypeCode  must be from the code list UNCL 1001 9, 13, 310, 311 oder 916.</assert>
        </rule>

    </pattern>
</schema>