;<PACKAGE "NEWSTRUC">

;<RENTRY MSETG NEWSTRUC>

"Does SETG and MANIFEST"
<DEFINE MSETG ("TUPLE" DEFS)
   <COND (<NOT <0? <MOD <LENGTH .DEFS> 2>>>
          <ERROR BAD-ARGUMENT-LIST!-ERRORS MSETG>)
         (T
          <REPEAT ((EXPSPLICE <AND <ASSIGNED? EXPSPLICE> .EXPSPLICE>)
                   (REDEFINE <AND <ASSIGNED? REDEFINE> .REDEFINE>)
                   (HEAD (T)) (TAIL .HEAD) DEF VAL)
             <SET VAL <2 .DEFS>>
             <COND (<GASSIGNED? <SET DEF <1 .DEFS>>>
                    <COND (<OR .REDEFINE <=? .VAL ,.DEF>
                               <ERROR MSETG .DEF ALREADY-GASSIGNED ,.DEF>>
                           <GUNASSIGN .DEF>
                           <UNMANIFEST .DEF>
                           <AGAIN>)>)
                   (.EXPSPLICE
                    <PUTREST .TAIL
                             (<FORM SETG .DEF .VAL> <FORM MANIFEST .DEF>)>
                    <SET TAIL <REST .TAIL 2>>)
                   (T
                    <SETG .DEF .VAL>
                    <MANIFEST .DEF>)>
             <COND (<EMPTY? <SET DEFS <REST .DEFS 2>>>
                    <COND (.EXPSPLICE
                           <MAPF <> ,EVAL <REST .HEAD>>
                           <RETURN <CHTYPE <REST .HEAD> SPLICE>>)
                          (<RETURN>)>)>>)>>

"Set up structure definitions.  Takes name, primtype, pairs (sort of)
 of name & type for slots in structure"
<DEFINE NEWSTRUC (NAM PRIM
		  "ARGS" ELEM
		  "AUX" (RPRIM <COND (<TYPE? .PRIM LIST><1 .PRIM>)
		                     (.PRIM)>)
			(LL <FORM <FORM PRIMTYPE .RPRIM>>)
                        (L .LL) OFFS DEC
			R RR (CNT 1)
			(EXPSPLICE <AND <ASSIGNED? EXPSPLICE> .EXPSPLICE>))
   <REPEAT ((HEAD (T)) (TAIL .HEAD))
      <COND 
       (<EMPTY? .ELEM>
        <COND (<ASSIGNED? RR> <PUTREST .R (<VECTOR !.RR>)>)>
        <COND 
         (<TYPE? .NAM ATOM>
          <COND (<TYPE? .PRIM LIST>
                 <COND (.EXPSPLICE
                        <SET TAIL
                             <REST <PUTREST .TAIL
                                            (<FORM PUT-DECL .NAM
                                                   <FORM QUOTE .LL>>)>>>)>
                 <PUT-DECL .NAM .LL>)
                (T
                 <COND (.EXPSPLICE
                        <SET TAIL
                             <REST <PUTREST .TAIL
                                            (<FORM NEWTYPE .NAM .RPRIM
                                                   <FORM QUOTE .LL>>)>>>
                        <NEWTYPE .NAM .RPRIM .LL>)
                       (T
                        <NEWTYPE .NAM .RPRIM .LL>)>)>)
         (T
          <1  .LL .RPRIM>
          <EVAL <FORM GDECL .NAM .LL>>
          <SET NAM <1 .NAM>>)>
        <COND (.EXPSPLICE
               <RETURN <CHTYPE <REST .HEAD> SPLICE>>)
              (<RETURN .NAM>)>)
       (<LENGTH? .ELEM 1> <ERROR NEWSTRUC>)>
      <SET OFFS <1 .ELEM>>
      <SET DEC <2 .ELEM>>
      <COND (<OR <NOT .OFFS> <TYPE? .OFFS FORM>>
             <SET CNT <+ .CNT 1>>
             <SET ELEM <REST .ELEM>>
             <AGAIN>)>
      <COND (<AND <TYPE? .OFFS STRING> <=? .OFFS "REST">>
             <AND <ASSIGNED? RR> <ERROR NEWSTRUC TWO-RESTS>>
             <SET R .L>
             <SET RR <SET L <LIST REST>>>
             <SET ELEM <REST .ELEM>>
             <AGAIN>)
            (<TYPE? .OFFS ATOM>
             <SETG .OFFS <OFFSET .CNT .NAM ;.DEC>>
             <MANIFEST .OFFS>
             <COND (.EXPSPLICE
                    <PUTREST .TAIL 
                             (<FORM SETG .OFFS ,.OFFS>
                              <FORM MANIFEST .OFFS>)>
                    <SET TAIL <REST .TAIL 2>>)>)
            (<TYPE? .OFFS LIST>
             <MAPF <>
                   <FUNCTION (A)
                      <SETG .A <OFFSET .CNT .NAM ;.DEC>>
                      <MANIFEST .A>
                      <COND (.EXPSPLICE
                             <PUTREST .TAIL
                                      (<FORM SETG .A ,.A>
                                       <FORM MANIFEST .OFFS>)>
                             <SET TAIL <REST .TAIL 2>>)>>
                   .OFFS>)
            (T <ERROR NEWSTRUC>)>
      <SET CNT <+ .CNT 1>>
      <SET L <REST <PUTREST .L (.DEC)>>>
      <SET ELEM <REST .ELEM 2>>>>

;<ENDPACKAGE>
