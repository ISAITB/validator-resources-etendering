<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>eSENS business and syntax rules for Tender Receipt Notifciation (TRDM045)</title>
  
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:TenderReceipt-2"/>
    
    <pattern>
        <rule context="*">
            <report id="PEPPOL-T45-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[PEPPOL-T45-S002] A Tender Receipt Notification document MUST NOT contain empty elements.</report>
        </rule>
    </pattern>
    
    <pattern>
        <let name="syntaxError" value="string('[PEPPOL-T45-S003] A Tender Receipt Notification document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
        
        <rule context="ubl:TenderReceipt">
            <assert id="PEPPOL-T006-R001" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T006-R001] A Tender Receipt Notification MUST have a syntax identifier.</assert>
            <report id="PEPPOL-T006-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[PEPPOL-T006-S301] UBLExtensions SHOULD NOT be used.</report>
            <report id="PEPPOL-T006-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>[PEPPOL-T006-S305] ProfileExecutionID SHOULD NOT be used.</report>
            <report id="PEPPOL-T006-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[PEPPOL-T006-S307] CopyIndicator SHOULD NOT be used.</report>
            <report id="PEPPOL-T006-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[PEPPOL-T006-S308] UUID SHOULD NOT be used.</report>
            <report id="PEPPOL-T006-S310" flag="warning" test="count (cbc:ConctractName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T006-S310] ContractName SHOULD NOT be used more than once.</report>
            <report id="PEPPOL-T006-S312" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[PEPPOL-T006-S312] Note SHOULD NOT be used.</report>
            <report id="PEPPOL-T006-S313" flag="warning" test="count (cac:TenderDocumentReference) &gt; 2"><value-of select="$syntaxError"/>[PEPPOL-T006-S313] TenderDocumentReference SHOULD NOT be used more than once.</report>
            <report id="PEPPOL-T006-S322" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[PEPPOL-T006-S322] Signature SHOULD NOT be used.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:UBLVersionID">
            <assert id="PEPPOL-T006-R019" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T006-R019] UBLVersionID value MUST be '2.2'</assert>
            <report id="PEPPOL-T006-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:CustomizationID">
            <assert id="PEPPOL-T006-R002" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t006:1.2'">[PEPPOL-T006-R002] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t006:1.2'</assert>
            <report id="PEPPOL-T006-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S303] CustomizationID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:ProfileID">
            <assert id="PEPPOL-T006-R003" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p003:1.2'">[PEPPOL-T006-R003] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p003:1.2'</assert>
            <report id="PEPPOL-T006-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S304] ProfileID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:ID">
            <assert id="PEPPOL-T006-R004" flag="fatal" test="./@schemeURI">[PEPPOL-T006-R004] A Tender Receipt Notification Identifier MUST have a schemeURI attribute.</assert>
            <assert id="PEPPOL-T006-R005" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T006-R005] schemeURI for Tender Receipt Notification Identifier MUST be 'urn:uuid'.</assert>
            <report id="PEPPOL-T006-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T006-S306] A Tender Receipt Notification Identifier SHOULD NOT have any attributes but schemeURI</report>
            <assert id="PEPPOL-T006-R006" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T006-R006] A Tender Receipt Notification Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        <rule context="ubl:TenderReceipt/cbc:ContractFolderID">
            <report id="PEPPOL-T006-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S309] ContractFolderID SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:IssueTime">
            <assert id="PEPPOL-T006-R007" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T006-R007] IssueTime MUST have a granularity of seconds</assert>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:ContractName">
            <report id="PEPPOL-T006-S311" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S311] ContractName SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cbc:RegisteredTime">
            <assert id="PEPPOL-T006-R012" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T006-R012] Reception of tender time MUST have a granularity of secondsMUST have a granularity of seconds</assert>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference">
            <assert id="PEPPOL-T006-S314" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cac:Attachment)-count(./cac:IssuerParty)=0"><value-of select="$syntaxError"/>[PEPPOL-T006-S314] TenderDocumentReference SHOULD NOT contain any elements but ID, DocumentTypeCode, Attachment, IssuerParty</assert>
        </rule>
                
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cbc:ID">
            <assert id="PEPPOL-T006-R013" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T006-R013] The document reference Identifier MUST reference the Tender ID expressed in a UUID syntax (RFC 4122)</assert>
            <report id="PEPPOL-T006-S315" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T006-S321] TenderDocumentReference SHOULD NOT have any attributes but schemeURI.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cbc:DocumentTypeCode">
            <assert id="PEPPOL-T006-R014" flag="fatal" test="matches(normalize-space(.),'^310|13')">[PEPPOL-T006-R014] The document type code for the document reference (the received tender) MUST be '310' or '13'.</assert>
                <assert flag="fatal" id="CL-T45-R001" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 ',concat(' ',normalize-space(.),' ') ) ) )">DocumentTypeCode must be from the code list UNCL1001</assert>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment">
            <assert id="PEPPOL-T006-S316" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0"><value-of select="$syntaxError"/>[PEPPOL-T006-S316] Attachment SHOULD NOT contain any elements but ExternalReference</assert>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference">
            <assert id="PEPPOL-T006-S317" flag="warning" test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)=0"><value-of select="$syntaxError"/>[PEPPOL-T006-S317] Attachment/ExternalReference SHOULD NOT contain any elements but DocumentHash, HashAlgorithmMethod</assert>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
            <assert id="PEPPOL-T006-R015" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">[PEPPOL-T006-R015] DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)</assert>
            <report id="PEPPOL-T006-S318" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S318] DocumentHash SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
            <assert id="PEPPOL-T006-R016" flag="fatal" test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">[PEPPOL-T006-R016] HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'</assert>
            <report id="PEPPOL-T006-S319" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S319] HashAlgorithmMethod SHOULD NOT contain any attributes.</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty">
            <assert id="PEPPOL-T006-S320" flag="warning" test="count(./*)-count(./cbc:EndpointID)=0"><value-of select="$syntaxError"/>[PEPPOL-T006-S320] IssuerParty SHOULD NOT contain any elements but EndpointID.</assert>
        </rule>
        
        <rule context="cbc:EndpointID">
            <assert id="PEPPOL-T006-R010" flag="fatal" test="./@schemeID">[PEPPOL-T006-R010] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="PEPPOL-T006-R011" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T006-R011] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="PEPPOL-T006-S321" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T006-S321] EndpointID SHOULD NOT have any attributes but schemeID</report>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:SenderParty">
            <assert id="PEPPOL-T006-R017" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T006-R017] A Tender Receipt Notification MUST identify the Contracting Authority by its party and endpoint identifiers.</assert>
        </rule>
        
        <rule context="ubl:TenderReceipt/cac:ReceiverParty">
            <assert id="PEPPOL-T006-R018" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T006-R018] A Tender Receipt Notification MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
        </rule>
        
        
        <rule context="ubl:TenderReceipt/cac:SenderParty | ubl:TenderReceipt/cac:ReceiverParty">
            <assert id="PEPPOL-T006-S323" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>[PEPPOL-T006-S323] ContractingParty Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
            <assert id="PEPPOL-T006-S324" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>[PEPPOL-T006-S324] PartyIdentification SHOULD be used exactly once.</assert>
            <report id="PEPPOL-T006-S326" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T006-S326] PartyName SHOULD NOT be used more than once.</report>
        </rule>
        
        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="PEPPOL-T006-R008" flag="fatal" test="./@schemeID">[PEPPOL-T006-R008] A Party Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="PEPPOL-T006-R009" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T006-R009] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="PEPPOL-T006-S325" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T006-S325] PartyIdentifier SHOULD NOT have any further attributes but schemeID</report>
        </rule>

        <rule context="cbc:Name">
            <report id="PEPPOL-T006-S327" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T006-S327] Name SHOULD NOT contain any attributes.</report>
        </rule>
        
    </pattern>
</schema>