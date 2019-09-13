<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>eSENS business and syntax rules for Tender Status Request</title>
    
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:TenderStatusRequest-2"/>
    
    <pattern>
        <rule context="*">
            <report id="eSENS-T97-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[eSENS-T97-S002] A Tender Status Inquiry document MUST NOT contain empty elements.</report>
        </rule>
    </pattern>
        
    <pattern>
        <let name="syntaxError" value="string('[eSENS-T97-S003] A Tender Status Inquiry document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
        <rule context="ubl:TenderStatusRequest">
            <assert id="eSENS-T97-R001" flag="fatal" test="(cbc:CustomizationID)">[eSENS-T97-R001] A Tender Status Inquiry MUST have a specification (customization) identifier.</assert>
            <assert id="eSENS-T97-R002" flag="fatal" test="(cbc:ProfileID)">[eSENS-T97-R002] A Tender Status Inquiry MUST have a business process (profile) identifier.</assert>
            <assert id="eSENS-T97-R003" flag="fatal" test="(cbc:ID)">[eSENS-T97-R003] A Tender Status Inquiry MUST have a Tender Status Inquiry identifier.</assert>
            <assert id="eSENS-T97-R004" flag="fatal" test="(cbc:ContractFolderID)">[eSENS-T97-R004] A Tender Status Inquiry MUST have a reference number.</assert>
            <assert id="eSENS-T97-R005" flag="fatal" test="(cbc:IssueDate)">[eSENS-T97-R005] A Tender Status Inquiry MUST have an issue date.</assert>
            <assert id="eSENS-T97-R015" flag="fatal" test="(cbc:IssueTime)">[eSENS-T97-R015] A Tender Status Inquiry MUST have an issue time.</assert>
            <assert id="eSENS-T97-R022" flag="fatal" test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">[eSENS-T97-R022] Lot identifiers MUST be unique.</assert>
            <report id="eSENS-T97-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[eSENS-T97-S301] UBLExtensions SHOULD NOT be used.</report>
            <report id="eSENS-T97-S302" flag="warning" test="(cbc:UBLVersionID)">[eSENS-T97-S302] UBLVersionID SHOULD NOT be used.</report>
            <report id="eSENS-T97-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>[eSENS-T97-S305] ProfileExecutionID SHOULD NOT be used.</report>
            <report id="eSENS-T97-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[eSENS-T97-S307] CopyIndicator SHOULD NOT be used.</report>
            <report id="eSENS-T97-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[eSENS-T97-S308] UUID SHOULD NOT be used.</report>
            <report id="eSENS-T97-S310" flag="warning" test="(cbc:ContractName)"><value-of select="$syntaxError"/>[eSENS-T97-S310] ContractName SHOULD NOT be used.</report>
            <report id="eSENS-T97-S311" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[eSENS-T97-S311] Note SHOULD NOT be used.</report>
            <report id="eSENS-T97-S312" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[eSENS-T97-S312] Signature SHOULD NOT be used.</report>
            <assert id="eSENS-T97-S313" flag="warning" test="count(cac:ContractingParty) = 1"><value-of select="$syntaxError"/>[eSENS-T97-S313] ContractingParty SHOULD be used exactly once.</assert>
            <report id="eSENS-T97-S321" flag="warning" test="(cac:ProcurementProject)"><value-of select="$syntaxError"/>[eSENS-T97-S321] ProcurementProject SHOULD NOT be used.</report>
        </rule>
        
         <rule context="ubl:TenderStatusRequest/cbc:CustomizationID">
            <assert id="eSENS-T97-R010" flag="fatal" test="normalize-space(.) = 'urn:www.cenbii.eu:transaction:biitrdm097:ver3.0:extended:urn:www.esens.eu:bis:esens60a:ver1.0'">[eSENS-T97-R010] CustomizationID value MUST be 'urn:www.cenbii.eu:transaction:biitrdm097:ver3.0:extended:urn:www.esens.eu:bis:esens60a:ver1.0'</assert>
            <report id="eSENS-T97-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T97-S303] CustomizationID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cbc:ProfileID">
            <assert id="eSENS-T97-R011" flag="fatal" test="normalize-space(.) = 'urn:www.cenbii.eu:profile:bii60:ver3.0'">[eSENS-T97-R011] ProfileID value MUST be 'urn:www.cenbii.eu:profile:bii60:ver3.0'</assert>
            <report id="eSENS-T97-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T97-S304] ProfileID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cbc:ID">
            <assert id="eSENS-T97-R012" flag="fatal" test="./@schemeURI">[eSENS-T97-R012] A Tender Status Inquiry Identifier MUST have a schemeURI attribute.</assert>
            <assert id="eSENS-T97-R013" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[eSENS-T97-R013] schemeURI for Tender Status Inquiry Identifier MUST be 'urn:uuid'.</assert>
            <report id="eSENS-T97-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[eSENS-T97-S306] ID SHOULD NOT have any further attributes but schemeURI</report>
            <assert id="eSENS-T97-R014" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[eSENS-T97-R014] A Tender Status Inquiry Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cbc:ContractFolderID">
            <report id="eSENS-T97-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T97-S309] ContractFolderID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cbc:IssueTime">
            <assert id="eSENS-T97-R016" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[eSENS-T97-R016] IssueTime MUST include timezone information.</assert>
            <assert id="eSENS-T97-R017" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[eSENS-T97-R017] IssueTime MUST have a granularity of seconds</assert>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cac:ContractingParty">
            <assert id="eSENS-T97-S314" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[eSENS-T97-S314] ContractingParty SHOULD NOT contain any elements but cac:Party.</assert>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cac:EconomicOperatorParty">
            <assert id="eSENS-T97-S324" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[eSENS-T97-S324] EconomicOperatorParty SHOULD NOT contain any elements but cac:Party.</assert>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cac:ContractingParty/cac:Party">
            <assert id="eSENS-T97-R007" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[eSENS-T97-R007] A Tender Status Inquiry MUST identify the Contracting Body by its party and endpoint identifiers.</assert>
        </rule>

        <rule context="ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party">
            <assert id="eSENS-T97-R008" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[eSENS-T97-R008] A Tender Status Inquiry MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
            <assert id="eSENS-T97-R009" flag="warning" test="(./cac:PartyName)">[eSENS-T97-R009] A Tender Status Inquiry MUST include the name of the Economic Operator.</assert>
        </rule>
        
        <rule context="cac:Party">
            <assert id="eSENS-T97-S315" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>[eSENS-T97-S315] Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
            <report id="eSENS-T97-S317" flag="warning" test="count(./cac:PartyIdentification) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T97-S317] PartyIdentification SHOULD NOT be used more than once</report>
            <report id="eSENS-T97-S319" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[eSENS-T97-S319] PartyName SHOULD NOT be used more than once</report>
        </rule>    
        
        <rule context="cac:Party/cbc:EndpointID">
            <assert id="eSENS-T97-R020" flag="fatal" test="./@schemeID">[eSENS-T97-R020] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="eSENS-T97-R021" flag="fatal" test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">[eSENS-T97-R021] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="eSENS-T97-S316" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T97-S316] EndpointID SHOULD NOT have any attributes but schemeID</report>
        </rule>
        
        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="eSENS-T97-R018" flag="fatal" test="./@schemeID">[eSENS-T97-R018] A Party Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="eSENS-T97-R019" flag="fatal" test="matches(normalize-space(./@schemeID),'^(FR:SIRENE|SE:ORGNR|FR:SIRET|FI:OVT|DUNS|GLN|DK:P|IT:FTI|NL:KVK|IT:SIA|IT:SECETI|DK:CPR|DK:CVR|DK:SE|DK:VANS|IT:VAT|IT:CF|NO:ORGNR|NO:VAT|HU:VAT|EU:REID|AT:VAT|AT:GOV|IS:KT|IBAN|AT:KUR|ES:VAT|IT:IPA|AD:VAT|AL:VAT|BA:VAT|BE:VAT|BG:VAT|CH:VAT|CY:VAT|CZ:VAT|DE:VAT|EE:VAT|GB:VAT|GR:VAT|HR:VAT|IE:VAT|LI:VAT|LT:VAT|LU:VAT|LV:VAT|MC:VAT|ME:VAT|MK:VAT|MT:VAT|NL:VAT|PL:VAT|PT:VAT|RO:VAT|RS:VAT|SI:VAT|SK:VAT|SM:VAT|TR:VAT|VA:VAT|NL:ION|SE:VAT|ZZZ)$')">[eSENS-T97-R019] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="eSENS-T97-S318" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[eSENS-T97-S318] cac:PartyIdentification/cbc:ID SHOULD NOT have any attributes but schemeID</report>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cac:ProcurementProjectLot">
            <assert id="eSENS-T97-S322" flag="warning" test="count(./*)-count(./cbc:ID)= 0"><value-of select="$syntaxError"/>[eSENS-T97-S322] ProcurementProjectLot SHOULD NOT contain any elements but cbc:ID</assert>
        </rule>
        
        <rule context="ubl:TenderStatusRequest/cac:ProcurementProjectLot/cbc:ID">
            <report id="eSENS-T97-S323" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T97-S323] cac:ProcurementProjectLot/cbc:ID SHOULD NOT have any attributes</report>
        </rule>
        
        <rule context="cbc:Name">
            <report id="eSENS-T97-S320" flag="warning" test="./@*"><value-of select="$syntaxError"/>[eSENS-T97-S320] cbc:Name SHOULD NOT have any attributes</report>
        </rule>
    </pattern>
</schema>