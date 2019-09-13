<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
        xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
        xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:TenderReceipt-2"
        queryBinding="xslt2">
  <title>BIIRULES  T45 bound to UBL</title>
  <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:TenderReceipt-2"/>
  <phase id="BIIRULEST45_phase">
      <active pattern="UBL-T45"/>
  </phase>
  <phase id="codelist_phase">
      <active pattern="CodesT45"/>
  </phase>
  
  
  <!--Suppressed abstract pattern T45 was here-->
  
  
  <!--Start pattern based on abstract T45--><pattern id="UBL-T45">
      <rule context="/ubl:TenderReceipt">
         <assert test="(cbc:ID)" flag="fatal" id="BII3-T45-R001">[BII3-T45-R001]-A Tender Receipt Notification MUST have an identifer</assert>
         <assert test="(cbc:IssueDate)" flag="fatal" id="BII3-T45-R002">[BII3-T45-R002]-A Tender Receipt Notification MUST have an issue date</assert>
         <assert test="(cbc:IssueTime)" flag="fatal" id="BII3-T45-R003">[BII3-T45-R003]-A Tender Receipt Notification MUST have an issue time</assert>
         <assert test="count(timezone-from-time(cbc:IssueTime)) &gt; 0"
                 flag="fatal"
                 id="BII3-T45-R004">[BII3-T45-R004]-Issue time MUST include timezone information</assert>
         <assert test="(cac:SenderParty)" flag="fatal" id="BII3-T45-R005">[BII3-T45-R005]-A Tender Receipt Notification MUST have information about the Contracting Authority</assert>
         <assert test="(cac:ReceiverParty)" flag="fatal" id="BII3-T45-R006">[BII3-T45-R006]-A Tender Receipt Notification MUST have information about the Economic Operator</assert>
         <assert test="(cbc:ContractFolderID)" flag="fatal" id="BII3-T45-R007">[BII3-T45-R007]-A Tender Receipt Notification MUST have a procurement project identifier</assert>
         <assert test="(cac:TenderDocumentReference)"
                 flag="fatal"
                 id="BII3-T45-R008">[BII3-T45-R008]-A Tender Receipt Notification MUST have references to the Tender documents received</assert>
         <assert test="(cbc:CustomizationID)" flag="fatal" id="BII3-T45-R009">[BII3-T45-R009]-A Tender Receipt Notification MUST have a customization identifier</assert>
         <assert test="(cbc:ProfileID)" flag="fatal" id="BII3-T45-R010">[BII3-T45-R010]-A Tender Receipt Notification MUST have a profile identifier</assert>
         <assert test="(cbc:RegisteredDate)" flag="fatal" id="BII3-T45-R011">[BII3-T45-R011]-A Tender Receipt Notification MUST state the date the Tender was received</assert>
         <assert test="(cbc:RegisteredTime)" flag="fatal" id="BII3-T45-R012">[BII3-T45-R012]-A Tender Receipt Notification MUST state the time the Tender was received</assert>
         <assert test="count(timezone-from-time(cbc:RegisteredTime)) &gt; 0"
                 flag="fatal"
                 id="BII3-T45-R017">[BII3-T45-R017]-Reception of tender time MUST include timezone information</assert>
      </rule>
      <rule context="//cac:TenderDocumentReference">
         <assert test="(cbc:ID)" flag="fatal" id="BII3-T45-R013">[BII3-T45-R013]-A document reference MUST have a document identifier</assert>
         <assert test="(cbc:DocumentTypeCode)" flag="fatal" id="BII3-T45-R014">[BII3-T45-R014]-A document reference MUST have a document type code</assert>
      </rule>
      <rule context="//cbc:DocumentTypeCode">
         <assert test="(./@listID = 'UNCL1001')" flag="fatal" id="BII3-T45-R016">[BII3-T45-R016]-A document type code MUST have a list identifier attribute 'UNCL1001'</assert>
      </rule>
   </pattern>
  
  
  <pattern id="CodesT45">



      <rule context="cbc:DocumentTypeCode" flag="fatal" id="CL-T45-R001">
         <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">[CL-T45-R001]-DocumentTypeCode  must be from the code list UNCL 1001</assert>
      </rule>

   </pattern>
</schema>
