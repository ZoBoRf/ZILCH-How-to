"ZIL Compiler"

;<USE "ZSTR">

<NEWTYPE ZSTR BYTES '<BYTES 5>>

<SETG ZCHRS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789.,!?_#'\"/\\|-:()">
<GDECL (ZCHRS) STRING>

<SETG PADCHR 5>
<MANIFEST PADCHR>

<DEFINE ZSTR-STRING (S "AUX" (ZCHRS ,ZCHRS)
			     (CSTEMP 0)
			     (CSPERM 0)
			     (TEMP? <>)
			     (B1 <>))
	#DECL ((VALUE ZCHRS) STRING
	       (S) ZSTR
	       (CSTEMP CSPERM) FIX
	       (TEMP?) <OR ATOM FALSE>
	       (B1) <OR ATOM FIX FALSE>)
	<MAPF ,STRING
	      <FUNCTION (B "AUX" (CS <COND (.TEMP?
					    <SET TEMP? <>>
					    .CSTEMP)
					   (.CSPERM)>))
			#DECL ((VALUE) CHARACTER
			       (B CS) FIX)
			<COND (.B1
			       <COND (<TYPE? .B1 ATOM> <SET B1 .B> <MAPRET>)
				     (<SET B <+ .B <* .B1 32>>>
				      <SET B1 <>>
				      <ASCII .B>)>)
			      (<AND <==? .CS 2> <==? .B 6>>
			       <SET B1 T>
			       <MAPRET>)
			      (<G? .B 5> <NTH .ZCHRS <+ <* .CS 26> .B -5>>)
			      (<0? .B> <ASCII 32>)
			      (<1? .B> <MAPRET <ASCII 13> <ASCII 10>>)
			      (<L? .B 4>
			       <SET TEMP? T>
			       <SET CSTEMP <MOD <+ .CS .B 2> 3>>
			       <MAPRET>)
			      (<SET CSPERM <MOD <+ .CS .B> 3>>
			       <MAPRET>)>>
	      .S>>

<DEFINE ZCHR-CS (C "AUX" RSTR)
	#DECL ((VALUE) FIX
	       (C) CHARACTER
	       (RSTR) <OR STRING FALSE>)
	<COND (<OR <==? .C <ASCII 32>> <==? .C <ASCII 13>>> 3)
	      (<SET RSTR <MEMQ .C ,ZCHRS>>
	       </ <- 78 <LENGTH .RSTR>> 26>)
	      (2)>>

<DEFINE ZCHR-BYTE (C "AUX" RSTR B)
	#DECL ((VALUE) <OR FIX FALSE>
	       (C) CHARACTER
	       (RSTR) <OR STRING FALSE>
	       (B) FIX)
	<AND <SET RSTR <MEMQ .C ,ZCHRS>>
	     <- 6 <- <* </ <SET B <- 78 <LENGTH .RSTR>>> 26> 26> .B>>>>

<DEFINE STRING-ZSTR (S "AUX" (ZCHRS ,ZCHRS) (CS 0) (SKIP? <>))
	#DECL ((VALUE) ZSTR
	       (S ZCHRS) STRING
	       (CS) FIX
	       (SKIP?) <OR ATOM FALSE>)
	<MAPR <FUNCTION ("TUPLE" BTUP)
			#DECL ((VALUE) ZSTR
			       (BTUP) <TUPLE [REST FIX]>)
			<CHTYPE <BYTES 5 !.BTUP> ZSTR>>
	      <FUNCTION (STR "AUX" (C <1 .STR>)
				   (C2 <AND <NOT <EMPTY? <REST .STR>>>
					    <2 .STR>>)
				   NCS
				   PB
				   B)
			#DECL ((VALUE NCS PB) FIX
			       (STR) STRING
			       (C) CHARACTER
			       (C2) <OR CHARACTER FALSE>
			       (B) <OR FIX FALSE>)
			<COND (.SKIP? <SET SKIP? <>> <MAPRET>)
			      (<==? .C <ASCII 32>> 0)
			      (<AND <==? .C <ASCII 13>>
				    .C2
				    <==? .C2 <ASCII 10>>>
			       <SET SKIP? T>
			       1)
			      (<SET PB 0>
			       <COND (<==? <SET NCS <ZCHR-CS .C>> .CS>)
				     (<AND .C2 <==? .NCS <ZCHR-CS .C2>>>
				      <SET PB <+ <MOD <- .NCS .CS> 3> 3>>
				      <SET CS .NCS>)
				     (<SET PB <+ <MOD <- .NCS .CS> 3> 1>>)>
			       <COND (<SET B <ZCHR-BYTE .C>>
				      <OR <0? .PB> <MAPRET .PB .B>>
				      .B)
				     (<SET B <ASCII .C>>
				      <OR <0? .PB>
					  <MAPRET .PB
						  6
						  </ .B 32>
						  <- .B <* </ .B 32> 32>>>>
				      <MAPRET 6
					      </ .B 32>
					      <- .B <* </ .B 32> 32>>>)>)>>
	      .S>>

<DEFINE ZSTR-PRINT (STR)
	#DECL ((STR) ZSTR)
	<PRINC !\">
	<PRINC <ZSTR-STRING .STR>>
	<PRINC !\">>

<PRINTTYPE ZSTR ,ZSTR-PRINT>


<DEFINE MSETG (ATM VAL) <SETG .ATM .VAL> <MANIFEST .ATM>>

<SETG STR3 <ISTRING 3>>

<SETG STRCNT 0>

<SETG STRS <IVECTOR 1000 "">>

<SETG TBLCNT 0>

<SETG TBLS <IUVECTOR 250 ()>>

<GDECL (TBLCNT STRCNT)
       FIX
       (TBLS)
       <UVECTOR [REST LIST]>
       (STRS)
       <VECTOR [REST STRING]>>

;"***************** OFFSETS INTO 'OBJECTS' ******************"

<MSETG OLOC 1>

<MSETG OFIRST 2>

<MSETG ONEXT 3>

<MSETG ODESC 4>

<MSETG OBIT0-15 5>

<MSETG OBIT16-31 6>

<MSETG OPROP 7>

;"*********************** OBJECT BIT CONSTANTS *****************"

<SETG BITBYTE ,OBIT16-31>

<SETG HIBIT 32>

<SETG HIVAL 0>

<GDECL (BITBYTE HIBIT HIVAL) FIX>

<MSETG BWORD 1>

<MSETG BVAL 2>

<MSETG BNUM 3>

;"******************** VOCABULARY WORD OFFSETS *******************"

<MSETG WTYPES 1>

<MSETG WVAL1 2>

<MSETG WVAL2 3>

<MSETG WSYM 4>

;"******************* VALUES FOR THE WTYPE SLOT ******************"

<SETG TOBJECT ![128 0!]>

<SETG TVERB ![64 1!]>

<SETG TADJ ![32 2!]>

<SETG TDIR ![16 3!]>

<SETG TPREP ![8 0!]>

<SETG TBUZZ ![4 0!]>

<GDECL (TOBJECT TVERB TADJ TDIR TPREP TBUZZ)
       <UVECTOR FIX FIX>
       (WTYPETBL)
       <UVECTOR [REST ATOM]>>

<SETG WTYPETBL ![OBJECT VERB ADJECTIVE DIRECTION PREPOSITION BUZZ-WORD!]>

;"******************** PARTS OF SPEECH TABLES **********************"

<SETG PROPS <REST <IUVECTOR 31 T> 30>>

<SETG ADJS <REST <IUVECTOR 255 T> 254>>

<SETG PREPS <REST <IUVECTOR 255 T> 254>>

<SETG ACTIONS <REST <IUVECTOR 255 T> 254>>

<SETG BUZZES <REST <IUVECTOR 255 T> 254>>

<SETG ACTS <REST <IUVECTOR 255 T> 254>>

<SETG DIRS <REST <IUVECTOR 255 T> 254>>

<SETG VERBS <REST <IUVECTOR 255 T> 254>>

<SETG PROPDEFS <IVECTOR 31 0>>

<GDECL (PROPS ADJS BUZZES VERBS ACTIONS PREPS)
       <UVECTOR [REST ATOM]>
       (PROPDEFS)
       <VECTOR [REST <OR FIX ATOM>]>>

;"******************** VARIOUS CONSTANTS AND TABLES ***************"

<SETG INSERTS ()>

<SETG LEVEL 0>

<SETG INDENTS '["" ">" ">>" ">>>" ">>>>"]>

<GDECL (INSERTS) LIST (LEVEL) FIX (INDENTS) <VECTOR [REST STRING]>>

;"************************* OBLIST DEFINITIONS ********************"

<SETG OBJECTS <MOBLIST OBJECTS 17>>

<SETG FLAGS <MOBLIST FLAGS 17>>

<SETG VERBOBL <MOBLIST VERBOBL 17>>

<SETG VARS <MOBLIST VARS 17>>

<SETG CONST <MOBLIST CONST 17>>

<SETG UCONST <MOBLIST UCONST 17>>

<SETG WORDS <MOBLIST WORDS 17>>

<SETG CNV <MOBLIST CNV 17>>

<SETG OPS <MOBLIST OPS 17>>

<GDECL (OBJECTS FLAGS VARS CONST UCONST WORDS CNV OPS VERBOBL) OBLIST>

;"************************* ZILCH PSEUDO OPERATIONS ******************"

<DEFINE ID (NUM)
	#DECL ((NUM) FIX)
	<SETG ZORK-ID .NUM>>

<DEFINE ENDLOAD ()
	<SETG ENDLOADFLG T>
	<PRINC "
ENDLOD::
" .ZCHN>>

;"PROPDEF - Set property defaults"

<DEFINE PROPDEF (NAME VAL)
	#DECL ((NAME) ATOM (VAL) <OR ATOM FIX>)
	<PUT ,PROPDEFS <ADD-SEQ <PARSE <STRING "P?" <SPNAME .NAME>>>
				PROPS> .VAL>>

;"ITABLE - Create a long empty table"

<DEFINE ITABLE (LEN? LEN "OPTIONAL" (FILL 0) "AUX" L)
	#DECL ((LEN?) ATOM (LEN FILL) FIX (L) <LIST [REST FIX]>)
	<SET L <ILIST .LEN .FILL>>
	<COND (<==? .LEN? WORD>
	       <PUT .L 1 .LEN>)
	      (<==? .LEN? BYTE>
	       <PUT .L 1 <* 256 .LEN>>)>
	<NXTTBL .L>>

;"TABLE - Create arbitrary tables"

<DEFINE LTABLE ("TUPLE" ELEM)
	#DECL ((ELEM) TUPLE)
	<TABLE <LENGTH .ELEM> !.ELEM>>

<DEFINE TABLE ("TUPLE" ELEM "AUX" L)
	#DECL ((ELEM) TUPLE (L) LIST)
	<SET L <MAPF ,LIST ,ZEVAL .ELEM>> <NXTTBL .L>>

;"DIRECTIONS - Create direction properties"

<DEFINE DIRECTIONS ("TUPLE" NAMES)
	#DECL ((NAMES) <TUPLE [REST ATOM]>)
	<MAPF <>
	      <FUNCTION (NAME)
			#DECL ((NAME) ATOM)
			<ADD-SEQ <PARSE <STRING "P?" <SPNAME .NAME>>> PROPS>>
	      .NAMES>
	<GLOBAL LOW-DIRECTION
		<POS <PARSE <STRING "P?"
				    <SPNAME <NTH .NAMES <LENGTH .NAMES>>>>>
		     <TOP ,PROPS>>>>

;" SYNTAX - Create syntax tables for the parser"

<DEFINE SYNTAX ("TUPLE" ARGS
		"AUX" ANY VERB (ACT <>) ATM (PREP 0) (POS 0) (SLOTS ,SLOTS)
		      SLOT L (PREACT 0))
   #DECL ((ARGS) TUPLE (ANY) ANY (VERB) ATOM (ACT ATM) <OR FALSE ATOM>
	  (POS PREP) FIX (SLOT) <UVECTOR [3 FIX]> (L) <LIST [REST VECTOR]>
	  (SLOTS) <UVECTOR [REST <UVECTOR [3 FIX]>]>)
   <MAPR <> <FUNCTION (X) #DECL ((X) UVECTOR) <PUT .X 1 0>> <1 .SLOTS>>
   <MAPR <> <FUNCTION (X) #DECL ((X) UVECTOR) <PUT .X 1 0>> <2 .SLOTS>>
   <COND
    (<EMPTY? .ARGS> <COMPERR TOO-FEW-ARGUMENTS!-ERRORS SYNTAX>)
    (<TYPE? <SET ANY <1 .ARGS>> ATOM>
     <SET VERB <1 .ARGS>>
     <MAPR <>
      <FUNCTION (TUP "AUX" (ITM <1 .TUP>)) 
	      #DECL ((ITM) ANY)
	      <COND (<==? .ITM OBJECT>
		     <COND (<G? <SET POS <+ .POS 1>> 2>
			    <COMPERR TOO-MANY-OBJECTS!-ERRORS SYNTAX>)>
		     <SET SLOT <NTH .SLOTS .POS>>
		     <PUT .SLOT 1 .PREP>
		     <SET PREP 0>)
		    (<==? .ITM =>
		     <COND (<OR <LENGTH? .TUP 1> <NOT <TYPE? <2 .TUP> ATOM>>>
			    <COMPERR BAD-SYNTAX!-ERRORS SYNTAX>)
			   (T
			    <SET ACT <2 .TUP>>
			    <OR <LENGTH? .TUP 2>
				<SET PREACT <3 .TUP>>>
			    <MAPLEAVE>)>)
		    (<TYPE? .ITM ATOM>
		     <SET PREP <ADD-SEQ .ITM PREPS>>
		     <ADD-WORD .ITM TPREP .PREP T>)
		    (<AND <TYPE? .ITM LIST>
			  <NOT <EMPTY? .ITM>>
			  <TYPE? <SET ANY <1 .ITM>> ATOM>>
		     <COND (<==? .ANY FIND>
			    <AND <OR <LENGTH? .ITM 1>
				     <NOT <TYPE? <2 .ITM> ATOM>>>
				 <COMPERR BAD-SYNTAX!-ERRORS SYNTAX>>
			    <BITADD ,PHONYBIT <SET ATM <2 .ITM>>>
			    <PUT .SLOT 2 <3 ,<LOOKUP <SPNAME .ATM> ,FLAGS>>>)
			   (<SBITS .ITM .SLOT>)>)
		    (<ERROR BAD-SYNTAX!-ERRORS SYNTAX>)>>
      <REST .ARGS>>
     <COND
      (.ACT
       <SET L
	    <COND (<SET ATM <LOOKUP <SPNAME .VERB> ,VERBOBL>> ,.ATM)
		  (<SET ATM <INSERT <SPNAME .VERB> ,VERBOBL>> ())>>
       <SETG .ATM
	([.POS
	  <1 <1 .SLOTS>>
	  <1 <2 .SLOTS>>
	  <2 <1 .SLOTS>>
	  <2 <2 .SLOTS>>
	  <3 <1 .SLOTS>>
	  <3 <2 .SLOTS>>
	  <- <GET-ACTION .ACT .PREACT> 2>]
	 !.L)>)
      (<COMPERR NO-ACTION-SPECIFIED!-ERRORS SYNTAX>)>)
    (<COMPERR NON-ATOMIC-VERB!-ERRORS SYNTAX .VERB>)>>

;"CONSTANT - Set up arbitrary constants"

<DEFINE CONSTANT (VAR VAL)
	#DECL ((VAR) ATOM (VAL) ANY)
	<SETG <OR <LOOKUP <SPNAME .VAR> ,UCONST>
		  <INSERT <SPNAME .VAR> ,UCONST>>
	      <ZEVAL .VAL>>>

;"GLOBAL - Set a global variable (at top level)"

<DEFINE GLOBAL (VAR VAL) 
	#DECL ((VAR) ATOM (VAL) ANY)
	<REMOVE <SPNAME .VAR> ,UCONST>
	<SETG <OR <LOOKUP <SPNAME .VAR> ,VARS> <INSERT <SPNAME .VAR> ,VARS>>
	      <ZEVAL .VAL>>>

<DEFINE INSERT-CRUFTY (NAME)
	#DECL ((NAME) STRING)
	<PRINC "
	.INSERT \"" .ZCHN>
	<PRINC .NAME .ZCHN>
	<PRINC "\"

" .ZCHN>>

;"INSERT-FILE - Start compiling from an insert file"

<DEFINE INSERT-FILE (NAME "OPTIONAL" X) 
	#DECL ((NAME) STRING)
	<PRINC "
	.INSERT \"" .ZCHN>
	<PRINC .NAME .ZCHN>
	<PRINC "\"

" .ZCHN>
	<SETG LEVEL <+ ,LEVEL 1>>
	<ZILCH .NAME <COND (<==? .RECCHN ,OUTCHAN> <>) (.RECCHN)>>>

;"BUZZ - Create a buzz-word"

<DEFINE BUZZ ("TUPLE" WRDS) 
	#DECL ((WRDS) <TUPLE [REST ATOM]>)
	<MAPF <>
	      <FUNCTION (WRD) 
		      #DECL ((WRD) ATOM)
		      <ADD-WORD .WRD TBUZZ <ADD-SEQ .WRD BUZZES "B?"> T>>
	      .WRDS>>

;"SYNONYM - Create synonyms for a given vocabulary word"

<SETG SYNLIST ()>

<GDECL (SYNLIST) <LIST [REST FORM]>>

<DEFINE SYNONYM ("CALL" FOO)
	<SETG SYNLIST (<PUT .FOO 1 OSYNONYM> !,SYNLIST)>>

<DEFINE OSYNONYM (WRD "TUPLE" SYNS "AUX" WRDVAL ATM) 
	#DECL ((WRD) ATOM (SYNS) <TUPLE [REST ATOM]> (WRDVAL) VECTOR
	       (ATM) <OR FALSE ATOM>)
        <COND (<SET ATM <LOOKUP <SPNAME .WRD> ,WORDS>> <SET WRDVAL ,.ATM>)
	      (<COMPERR DOES-NOT-EXIST!-ERRORS SYNONYM .WRD>)>
	<MAPF <>
	      <FUNCTION (WRD) 
		      #DECL ((WRD) ATOM)
		      <SETG <GET-ATOM .WRD ,WORDS> .WRDVAL>>
	      .SYNS>>

;"OBJECT - Create an 'object'"

<DEFINE OBJECT (NAME
		"TUPLE" DECLS
		"AUX" (L ()) (MEVEC <ADD-OBJ .NAME>) VEC CONT V)
   #DECL ((NAME CONT) ATOM (DECLS) <TUPLE [REST LIST]> (L) LIST (FLAGS) FIX
	  (MEVEC VEC) <VECTOR <OR ATOM FIX> <OR ATOM FIX>> (V) VECTOR)
   <REMOVE <SPNAME .NAME> ,UCONST>
   <MAPF <>
    <FUNCTION (DECL "AUX" (TYPE <1 .DECL>)) 
	    <COND
	     (<==? .TYPE FLAGS>
	      <MAPF <>
		    <FUNCTION (BITNAME) <BITADD .MEVEC .BITNAME>>
		    <REST .DECL>>)
	     (<==? .TYPE DESC> <PUT .MEVEC ,ODESC <2 .DECL>>)
	     (<==? .TYPE GLOBAL>
	      <SET L
		   (<ADD-SEQ P?GLOBAL PROPS>
		    ("
	.PROP "
		     <- <LENGTH .DECL> 1>
		     ",P?GLOBAL"
		     !<MAPF ,LIST
			    <FUNCTION (WRD)
				    #DECL ((WRD) ATOM)
				    <ADD-OBJ .WRD>
				    <MAPRET "
	.BYTE " <SPNAME .WRD>>>
			    <REST .DECL>>)
		    !.L)>)
	     (<==? .TYPE SYNONYM>
	      <AND <G? <LENGTH .DECL> 5>
		   <COMPERR TOO-MANY-SYNONYMS!-ERRORS .NAME>>
	      <SET L
		   (<ADD-SEQ P?SYNONYM PROPS>
		    ("
	.PROP "
		     <* 2 <LENGTH <REST .DECL>>>
		     ",P?SYNONYM"
		     !<MAPF ,LIST
			    <FUNCTION (WRD) 
				    #DECL ((WRD) ATOM)
				    <ADD-WORD .WRD TOBJECT "O?ANY" T>
				    <MAPRET "
	W?" <SPNAME .WRD>>>
			    <REST .DECL>>)
		    !.L)>)
	     (<==? .TYPE ADJECTIVE>
	      <AND <G? <LENGTH .DECL> 9>
		   <COMPERR TOO-MANY-ADJECTIVES!-ERRORS .NAME>>
	      <SET L
		   (<ADD-SEQ P?ADJECTIVE PROPS>
		    ("
	.PROP "
		     <LENGTH <REST .DECL>>
		     ",P?ADJECTIVE"
		     !<MAPF ,LIST
			    <FUNCTION (WRD) 
				    #DECL ((WRD) ATOM)
				    <ADD-WORD .WRD
					      TADJ
					      <ADD-SEQ .WRD ADJS "A?">>
				    <MAPRET "
	.BYTE A?" <SPNAME .WRD>>>
			    <REST .DECL>>)
		    !.L)>)
	     (<==? .TYPE PSEUDO>
	      <SET L
		   (<ADD-SEQ P?PSEUDO PROPS>
		    ("
	.PROP "
		     <* 2 <LENGTH <REST .DECL>>>
		     ",P?PSEUDO"
		     !<MAPF ,LIST
			    <FUNCTION (WRD) 
				    #DECL ((WRD) <OR STRING ATOM>)
				    <COND (<TYPE? .WRD STRING>
					   <ADD-WORD <PARSE .WRD>
						     TOBJECT "O?ANY" T>
					   <MAPRET "
	W?" .WRD>)
					  (<MAPRET "
	" .WRD>)>>
			    <REST .DECL>>)
		    !.L)>)
	     (<AND <==? .TYPE IN>
		   <N==? <2 .DECL> TO>>
	      <SET CONT <2 .DECL>>
	      <PUT .MEVEC ,OLOC .CONT>
	      <SET VEC <ADD-OBJ .CONT>>
	      <COND (<==? <OFIRST .VEC> 0> <PUT .VEC ,OFIRST .NAME>)
		    (<SET VEC <ADD-OBJ <OFIRST .VEC>>>
		     <PUT .MEVEC ,ONEXT <ONEXT .VEC>>
		     <PUT .VEC ,ONEXT .NAME>)>)
	     (<SET L (<ADD-SEQ <PARSE <STRING "P?" <SPNAME .TYPE>>> PROPS>
		      <ZPROP <REST .DECL> .TYPE .NAME> !.L)>)>>
    .DECLS>
   <SET V <VECTOR !.L>>
   <SORTEX ,L? .V 2>
   <PUT .MEVEC ,OPROP .V>
   T>

<SETG ROOM ,OBJECT>

;"******************** FORMAT UTILITIES ********************"

<DEFINE POS (ATM UVEC "AUX" M) 
	#DECL ((ATM) ATOM (UVEC) <UVECTOR [REST ATOM]>
	       (M) <OR FALSE <UVECTOR [REST ATOM]>>)
	<COND (<SET M <MEMQ .ATM .UVEC>> <- <LENGTH .UVEC> <LENGTH .M> -1>)>>

<DEFINE TBLSTR? (ITEM "AUX" (STR ,STR3)) 
	#DECL ((ITEM) ANY (STR) STRING)
	<AND <TYPE? .ITEM STRING>
	     <NOT <LENGTH? .ITEM 2>>
	     <SET STR <SUBSTRUC .ITEM 0 3 .STR>>
	     <MEMBER "T?" .STR>>>

<DEFINE ZPROP (LST PROP NAME "AUX" (ITEM <1 .LST>) (LEN <LENGTH .LST>) RM OBJ/FLG) 
   #DECL ((LST) LIST (ITEM) ANY (LEN) FIX (PROP RM OBJ/FLG) ATOM)
   <COND
    (<TBLSTR? .ITEM>
     <LIST "
	.PROP 2,P?" .PROP "			; STRING PROPERTY
	" .ITEM>)
    (<TYPE? .ITEM STRING>
     <LIST "
	.PROP 2,P?" .PROP "			; STRING PROPERTY
	" <NXTSTR .ITEM>>)
    (<TYPE? .ITEM FIX>
     <LIST "
	.PROP 2,P?" .PROP "			; INTEGER/CONSTANT PROPERTY

	" .ITEM>)
    (<AND <==? .ITEM PER> <==? .LEN 2>>
     <ADD-DIR .PROP>
     <LIST "
	.PROP 3,P?" .PROP "			; FUNCTION EXIT
	.WORD " <2 .LST> "
	.BYTE 0">)
    (<AND <=? .ITEM TO> <NOT <LENGTH? .LST 1>>>
     <ADD-DIR .PROP>
     <SET RM <2 .LST>>
     <COND
      (<LENGTH? .LST 2>
       <LIST "
	.PROP 1,P?" .PROP "			; UNCONDITIONAL EXIT
	.BYTE " .RM>)
      (<N==? <3 .LST> IF>
       <COMPERR BAD-SYNTAX-IN-PROPERTY-DEFINITION!-ERRORS .NAME .PROP>)
      (<NOT <LENGTH? .LST 3>>
       <SET OBJ/FLG <4 .LST>>
       <COND
	(<AND <G=? .LEN 6> <==? <5 .LST> IS> <==? <6 .LST> OPEN>>
	 <LIST "
	.PROP 5,P?"
	       .PROP
	       "			; DOOR EXIT
	.BYTE "
	       .RM
	       "				; ROOM NAME
	.BYTE "
	       .OBJ/FLG
	       "			; DOOR NAME"
	       <COND (<AND <==? .LEN 8> <==? <7 .LST> ELSE>>
		      <STRING "
	" <NXTSTR <8 .LST>>>)
		     ("
	.WORD 0")>
	       "
	.BYTE 0				; STRING TO PRINT">)
	(<LIST "
	.PROP 4,P?"
	       .PROP
	       "			; CONDITIONAL EXIT
	.BYTE "
	       .RM
	       "				; ROOM NAME
	.BYTE "
	       .OBJ/FLG
	       "				; FLAG NAME"
	       <COND (<AND <==? .LEN 6>
			   <==? <5 .LST> ELSE>
			   <TYPE? <6 .LST> STRING>>
		      <STRING "
	" <NXTSTR <6 .LST>> "			; STRING">)
		     (<==? .LEN 4> "
	0			; NO STRING")
		     (T
		      <COMPERR BAD-SYNTAX-IN-PROPERTY-DEFINITION!-ERRORS
			       .NAME
			       .PROP>)>>)>)
      (T
       <COMPERR BAD-SYNTAX-IN-OBJECT-DEFINITION!-ERRORS
		.NAME
		.PROP>)>)
    (<TYPE? .ITEM ATOM>
     <LIST "
	.PROP 2,P?" .PROP "			; ATOM (CONSTANT) PROPERTY

	" .ITEM>)>>

<DEFINE ADD-DIR (NAM)
	#DECL ((NAM) ATOM)
	<ADD-WORD .NAM
		  TDIR
		  <ADD-SEQ <PARSE <STRING "P?" <SPNAME .NAM>>> PROPS>>>

<DEFINE NXTTBL (L) 
	#DECL ((L) LIST)
	<SETG TBLCNT <+ ,TBLCNT 1>>
	<PUT ,TBLS 1 .L>
	<SETG TBLS <REST ,TBLS>>
	<AND <EMPTY? ,TBLS> <COMPERR TOO-MANY-TABLES!-ERRORS>>
	<STRING "T?" <UNPARSE ,TBLCNT>>>

<SETG STRBYTES 0>
<GDECL (STRBYTES) FIX>

<DEFINE NXTSTR (S "AUX" (CNT 1)) 
	#DECL ((S) STRING (CNT) FIX)
	<REPEAT ((STRS ,STRS) STR)
		#DECL ((STRS) <VECTOR [REST STRING]> (STR) STRING)
		<COND (<EMPTY? <SET STR <1 .STRS>>>
		       <PUT .STRS 1 .S>
		       <SETG STRCNT .CNT>
		       <RETURN>)
		      (<=? .S .STR>
		       <RETURN>)
		      (<EMPTY? <SET STRS <REST .STRS>>>
		       <COMPERR TOO-MANY-TABLES!-ERRORS>)
		      (T
		       <SET CNT <+ .CNT 1>>)>>
	<STRING "STR?" <UNPARSE .CNT>>>

<DEFINE BITADD (VEC NAME "AUX" ATM BIT) 
	#DECL ((VEC) VECTOR (NAME ATM) ATOM (BIT) <VECTOR FIX FIX>)
	<SET ATM <GET-ATOM .NAME ,FLAGS>>
	<SET BIT
	     <COND (<GASSIGNED? .ATM> ,.ATM)
		   (<SETG HIBIT <- ,HIBIT 1>>
		    <SETG HIVAL <COND (<0? ,HIVAL> 1) (<* ,HIVAL 2>)>>
		    <COND (<G? ,HIVAL 35000>
			   <COND (<==? ,BITBYTE ,OBIT16-31>
				  <SETG BITBYTE ,OBIT0-15>
				  <SETG HIVAL 1>)
				 (<COMPERR TOO-MANY-BITS!-ERRORS>)>)>
		    <SETG .ATM [,BITBYTE ,HIVAL ,HIBIT]>)>>
	<PUT .VEC <BWORD .BIT> (.NAME !<NTH .VEC <BWORD .BIT>>)>>

<DEFINE ADD-OBJ (NAME "AUX" ATM) 
	#DECL ((NAME ATM) ATOM)
	<SET ATM <GET-ATOM .NAME ,OBJECTS>>
	<COND (<GASSIGNED? .ATM> ,.ATM) (<SETG .ATM [0 0 0 "" () () []]>)>>

<DEFINE GET-ATOM (NAME OBL) 
	#DECL ((NAME) ATOM (OBL) OBLIST)
	<OR <LOOKUP <SPNAME .NAME> .OBL> <INSERT <SPNAME .NAME> .OBL>>>

<DEFINE ADD-WORD (NAME TYPE VALUE
		  "OPTIONAL" (SYM T)
		  "AUX" ATM VEC (TYPVAL ,.TYPE) TYPES)
	#DECL ((NAME TYPE ATM) ATOM (VALUE) ANY (VEC) VECTOR
	       (TYPVAL) <UVECTOR [REST FIX]> (SYM) <OR ATOM FALSE>
	       (TYPES) <PRIMTYPE WORD>)
	<SET ATM <GET-ATOM .NAME ,WORDS>>
	<SET VEC <COND (<GASSIGNED? .ATM> ,.ATM) (<SETG .ATM [0 0 0 0]>)>>
	<AND .SYM <PUT .VEC ,WSYM -1>>
	<COND (<N==? 0 <CHTYPE <ANDB <SET TYPES <WTYPES .VEC>> <1 .TYPVAL>>
				FIX>>)
	      (<==? <WVAL1 .VEC> 0>
	       <PUT .VEC
		    ,WTYPES
		    <CHTYPE <ORB .TYPES <+ <1 .TYPVAL> <2 .TYPVAL>>> FIX>>
	       <PUT .VEC ,WVAL1 .VALUE>)
	      (<==? <WVAL2 .VEC> 0>
	       <PUT .VEC ,WTYPES <CHTYPE <ORB .TYPES <1 .TYPVAL>> FIX>>
	       <PUT .VEC ,WVAL2 .VALUE>)
	      (<COMPERR TOO-MANY-PARTS-OF-SPEECH!-ERRORS .NAME>)>>

<DEFINE ADD-SEQ (NAME VECNAME
		 "OPTIONAL" (STRVAL <>)
		 "AUX" (VEC ,.VECNAME) (TVEC <TOP .VEC>) VAL)
	#DECL ((NAME VECNAME) ATOM (VEC TVEC) <UVECTOR [REST ATOM]>
	       (STRVAL) <OR FALSE STRING> (VAL) <OR FIX FALSE>)
	<COND (<==? .NAME \,>
	       <SET NAME COMMA>)
	      (<==? .NAME \">
	       <SET NAME QUOTE>)>
	<COND (<SET VAL <POS .NAME .TVEC>>
	       <COND (.STRVAL <STRING .STRVAL <SPNAME .NAME>>) (.VAL)>)
	      (<PUT .VEC 1 .NAME>
	       <COND (<==? .TVEC .VEC> <COMPERR TOO-MANY!-ERRORS .VECNAME>)
		     (<SETG .VECNAME <BACK .VEC>>)>
	       <COND (.STRVAL <STRING .STRVAL <SPNAME .NAME>>)
		     (<SET VAL <POS .NAME .TVEC>>
		      <SETG <OR <LOOKUP <SPNAME .NAME> ,CONST>
				<INSERT <SPNAME .NAME> ,CONST>>
			    .VAL>
		      .VAL)>)>>

<DEFINE ZEVAL (ITEM "AUX" ATM) 
	#DECL ((ITEM) ANY (ATM) <OR FALSE ATOM>)
	<COND (<AND <TYPE? .ITEM STRING> <NOT <TBLSTR? .ITEM>>> <NXTSTR .ITEM>)
	      (<==? .ITEM T> 1)
	      (<TYPE? .ITEM ATOM>
	       <CONSTANT-CHECK .ITEM>
	       <COND (<SET ATM <LOOKUP <SPNAME .ITEM> ,VARS>>
		      ,.ATM)
		     (.ITEM)>)
	      (<NOT .ITEM> 0)
	      (.ITEM)>>

;"********************* ZILCH DATA OUTPUT ROUTINES ******************"


<SETG SLOTS ![![0 0 0!] ![0 0 0!]!]>

<SETG PHONYBIT [0 0 0 0 () ()]>

<SETG ACTION (T)>

<SETG AL ,ACTION>

<SETG PREACTION (T)>

<SETG PREAL ,PREACTION>

<GDECL (ACTION AL)
       <LIST [REST ATOM]>
       (PREAL PREACTION)
       <LIST [REST <OR FIX ATOM>]>>

<GDECL (TEMPS) <LIST [REST LOCAL]>>

<DEFINE GET-ACTION (ACT PREACT)
	#DECL ((ACT) ATOM (PREACT) <OR FIX ATOM>)
	<COND (<LPOS .ACT ,ACTION>)
	      (<SETG AL <REST <PUTREST ,AL (.ACT)>>>
	       <SETG PREAL <REST <PUTREST ,PREAL (.PREACT)>>>
	       <LPOS .ACT ,ACTION>)>>

<DEFINE LPOS (ITM LST "AUX" M)
	#DECL ((ITM) ATOM (LST) <LIST [REST ATOM]> (M) <OR FALSE LIST>)
	<AND <SET M <MEMQ .ITM .LST>>
	     <- <LENGTH .LST> <LENGTH .M> -1>>>
	      

<DEFINE SBITS (LST SLOT "AUX" M) 
   #DECL ((LST) LIST (SLOT) <UVECTOR [REST FIX]>
	  (M) <OR FALSE <VECTOR [REST ATOM FIX]>>)
   <MAPF <>
    <FUNCTION (ANY) 
	    #DECL ((ANY) ANY)
	    <COND (<TYPE? .ANY ATOM>
		   <COND (<SET M <MEMQ .ANY ,SFLAGS>>
			  <PUT .SLOT 3 <+ <3 .SLOT> <2 .M>>>)
			 (<COMPERR UNKNOWN-SYNTAX-FLAG!-ERRORS .ANY>)>)
		  (<COMPERR BAD-SYNTAX!-ERRORS SYNTAX>)>>
    .LST>>

<MSETG SH 128>

<MSETG SC 64>

<MSETG SIR 32>

<MSETG SOG 16>

<MSETG STAKE 8>

<MSETG SMANY 4>

<MSETG SHAVE 2>

<SETG SFLAGS
      [HAVE
       ,SHAVE
       TAKE
       ,STAKE
       MANY
       ,SMANY
       HELD
       ,SH
       CARRIED
       ,SC
       IN-ROOM
       ,SIR
       ON-GROUND
       ,SOG]>

<GDECL (SFLAGS) <VECTOR [REST ATOM FIX]>>

<DEFINE PRINT-VERBNUMS ("AUX" (OUTCHAN .OUTCHAN) (N -1))
	#DECL ((OUTCHAN) CHANNEL (N) FIX)
	<PRINC "

; ACTION IDENTIFIERS ARE ASSIGNED HERE
">
	<MAPF <>
	      <FUNCTION (ATM "AUX" (S <SPNAME .ATM>))
			#DECL ((ATM) ATOM (S) STRING)
			<PRINC "
	V?">
			<COND (<AND <==? <1 .S> !\V>
				    <==? <2 .S> !\->>
			       <PRINC <REST .S 2>>)
			      (<PRINC .S>)>
			<PRINC "=">
			<PRINC <SET N <+ .N 1>>>>
	      <REST ,ACTION>>
	<MAPF <>
	      <FUNCTION (BUCK)
			#DECL ((BUCK) LIST)
			<MAPF <>
			      <FUNCTION (ATM)
					#DECL ((ATM) ATOM)
					<ADD-WORD .ATM
						  TVERB
						  <ADD-SEQ .ATM ACTS "ACT?">>>
			      .BUCK>>
	      ,VERBOBL>
	<MAPF <> ,EVAL ,SYNLIST>>

<DEFINE PRINT-PREPS ("AUX" (OUTCHAN .OUTCHAN) (PREPS <REST ,PREPS>))
	#DECL ((OUTCHAN) CHANNEL (PREPS) UVECTOR)
	<PRINC "

; PREPOSITION TABLE IS DEFINED HERE

PRTBL::	.TABLE
	.WORD ">
	<PRIN1 <LENGTH .PREPS>>
	<MAPF <>
	      <FUNCTION (NAM)
			#DECL ((NAM) ATOM)
			<PRINC "
	W?">
			<PRINC .NAM>
		        <PRINC "
	PR?">
		        <PRINC .NAM>>
	      .PREPS>
	<PRINC "
	.ENDT
">> 
		    
<DEFINE PRINT-VERBS ("AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC "

; VERB TABLE IS DEFINED HERE

VTBL::	.TABLE">
	<MAPF <>
	      <FUNCTION (BUCK) 
		      #DECL ((BUCK) LIST)
		      <MAPF <>
			    <FUNCTION (ATM) 
				    #DECL ((ATM) ATOM)
				    <PRINC "
	ST?">
				    <PRINC .ATM>>
			    .BUCK>>
	      ,VERBOBL>
	<PRINC "
	.ENDT

; SYNTAX DEFINITION TABLES ARE DEFINED HERE
">
	<MAPF <>
	      <FUNCTION (BUCK) 
		      #DECL ((BUCK) LIST)
		      <MAPF <>
			    <FUNCTION (ATM "AUX" LST) 
				    #DECL ((ATM) ATOM (LST) LIST)
				    <PRINC "
ST?">
				    <PRINC .ATM>
				    <PRINC "::	.TABLE">
				    <SET LST ,.ATM>
				    <PRINC "
	.BYTE ">
				    <PRIN1 <LENGTH .LST>>
				    <MAPF <> ,SYNPRINT .LST>
				    <PRINC "
	.BYTE 0
	.ENDT
">>
			    .BUCK>>
	      ,VERBOBL>>

<DEFINE SYNPRINT (VEC "AUX" (OUTCHAN .OUTCHAN))
	#DECL ((VEC) VECTOR (OUTCHAN) CHANNEL)
	<MAPF <>
	      <FUNCTION (FX)
			#DECL ((FX) FIX)
			<PRINC "
	.BYTE ">
			<PRIN1 .FX>>
	      .VEC>>

<DEFINE PRINT-ACTIONS ("AUX" (OUTCHAN .OUTCHAN))
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC "

; THE ACTION CALLING TABLE IS DEFINED HERE

ATBL::	.TABLE">
	<MAPF <>
	      <FUNCTION (ATM)
			#DECL ((ATM) ATOM)
			<PRINC "
	">
			<PRIN1 .ATM>>
	      <REST ,ACTION>>
	<PRINC "
	.ENDT
">
	<PRINC "

; THE PREACTION CALLING TABLE IS DEFINED HERE

PATBL::	.TABLE">
	<MAPF <>
	      <FUNCTION (ATM)
			#DECL ((ATM) ANY)
			<PRINC "
	">
			<PRIN1 .ATM>>
	      <REST ,PREACTION>>
	
	<PRINC "
	.ENDT
">>

<DEFINE LC (STR)
	#DECL ((VALUE STR) STRING)
	<MAPF ,STRING
	      <FUNCTION (C)
			#DECL ((VALUE C) CHARACTER)
			<COND (<AND <G=? <ASCII .C> <ASCII !\A>>
				    <L=? <ASCII .C> <ASCII !\Z>>>
			       <ASCII <+ <ASCII .C> 32>>)
			      (.C)>>
	      .STR>>


<DEFINE PRINT-VOCAB ("AUX" WORDS (OUTCHAN .OUTCHAN) ZSTRS) 
   #DECL ((WORDS) <UVECTOR [REST ATOM]> (ZSTRS) <UVECTOR [REST FIX]>
	  (OUTCHAN) CHANNEL)
   <SET WORDS <MAPF ,UVECTOR <FUNCTION (BUCK) <MAPRET !.BUCK>> ,WORDS>>
   <SET ZSTRS
	<MAPF ,UVECTOR
	      <FUNCTION (ATM "AUX" (NUM 0) (CNT 6)) 
		      #DECL ((ATM) ATOM (VALUE NUM CNT) FIX)
		      <MAPF <>
			    <FUNCTION (COD) 
				    #DECL ((COD) FIX)
				    <SET NUM <+ <* .NUM 32> .COD>>
				    <COND (<0? <SET CNT <- .CNT 1>>>
					   <MAPLEAVE>)>>
			    <STRING-ZSTR <LC <SPNAME .ATM>>>>
		      <REPEAT ()
			      <AND <0? .CNT> <RETURN>>
			      <SET NUM <+ <* .NUM 32> ,PADCHR>>
			      <SET CNT <- .CNT 1>>>
		      .NUM>
	      .WORDS>>
   <SORTEX <> .ZSTRS 1 0 .WORDS>
   <PRINC "

; VOCABULARY TABLE IS HERE

VOCAB::	.TABLE">
   <PRINC "
	.BYTE 3
	.BYTE 44
	.BYTE 46 
	.BYTE 34
	.BYTE 7
	">
   <PRIN1 <LENGTH .WORDS>>
   <MAPF <>
	 <FUNCTION (WRD "AUX" (VAL ,.WRD)) 
		 #DECL ((WRD) ATOM (VAL) VECTOR)
		 <COND (<NOT <0? <WSYM .VAL>>>
			<CRLF>
			<PRINC "W?">
			<COND (<=? <SPNAME .WRD> ","> <PRINC "COMMA">)
			      (<=? <SPNAME .WRD> "\""> <PRINC "QUOTE">)
			      (<PRINC <SPNAME .WRD>>)>
			<PRINC "::	">)
		       (<PRINC "
	">)>
		 <PRINC ".ZWORD ">
		 <ZWORD-PRINT .WRD>
		 <PRINC "
	.BYTE ">
		 <WTYPE-PRINT <WTYPES .VAL>>
		 <PRINC "
	.BYTE ">
		 <PRINC <WVAL1 .VAL>>
		 <PRINC "
	.BYTE ">
		 <PRINC <WVAL2 .VAL>>>
	 .WORDS>
   <PRINC "
	.ENDT
">>

<DEFINE ZWORD-PRINT (ATM "AUX" (SPN <SPNAME .ATM>) (CNT 7) (OUTCHAN .OUTCHAN))
	#DECL ((ATM) ATOM (SPN) STRING (CNT) FIX (OUTCHAN) CHANNEL)
	<PRINC !\">
	<MAPF <>
	      <FUNCTION (CHR "AUX" (NUM <ASCII .CHR>))
			#DECL ((CHR) CHARACTER (NUM) FIX)
			<COND (<0? <SET CNT <- .CNT 1>>>
			       <MAPLEAVE T>)>
			<COND (<AND <G=? .NUM <ASCII !\A>>
				    <L=? .NUM <ASCII !\Z>>>
			       <PRINC <ASCII <+ .NUM 32>>>)
			      (<==? .CHR !\">
			       <PRINC .CHR>
			       <PRINC .CHR>)
			      (T
			       <PRINC .CHR>)>>
	      .SPN>
	<PRINC !\">>

<DEFINE WTYPE-PRINT (WRD "AUX" (TYPES ,WTYPETBL) (FIRST T) (OUTCHAN .OUTCHAN)) 
	#DECL ((WRD) FIX (TYPES) <UVECTOR [REST ATOM]>
	       (FIRST) <OR ATOM FALSE> (OUTCHAN) CHANNEL)
	<REPEAT ((BIT #WORD *000000000200*))
		#DECL ((BIT) WORD)
		<COND (<NOT <==? <ANDB .WRD .BIT> #WORD *000000000000*>>
		       <COND (.FIRST <SET FIRST <>>) (<PRINC "+">)>
		       <PRINC "PS?">
		       <PRIN1 <1 .TYPES>>)>
		<SET BIT <CHTYPE </ <CHTYPE .BIT FIX> 2> WORD>>
		<AND <EMPTY? <SET TYPES <REST .TYPES>>> <RETURN>>>
	<COND (<==? <CHTYPE <ANDB .WRD 4> FIX> 0>
	       <PRINC "+P1?">
	       <PRIN1 <NTH ,WTYPETBL <+ <CHTYPE <ANDB .WRD 3> FIX> 1>>>)>>

<DEFINE PRINT-OBJECTS ("AUX" (OBJ ,OBJECTS) (OUTCHAN .OUTCHAN)) 
	#DECL ((OBJ) OBLIST (OUTCHAN) CHANNEL)
	<PRINC 
"

; PROPERTY DEFAULTS AND OBJECTS ARE DEFINED HERE

OBJECT::.TABLE ">
	<PRIN1 <+ 62 <* 255 9>>>
	<MAPF <>
	      <FUNCTION (VAL PROP)
			#DECL ((VAL) FIX (PROP) ATOM)
			<PRINC "
	">
			<PRIN1 .VAL>
			<PRINC "			;(">
			<PRIN1 <COND (<==? .PROP T> NONE)
				     (.PROP)>>
			<PRINC ")">>
	      ,PROPDEFS
	      <TOP ,PROPS>>
	<MAPF <> <FUNCTION (BUCK)
			   #DECL ((BUCK) LIST)
			   <MAPF <> ,PRINT-OBJECT .BUCK>> .OBJ>
	<PRINC "
	.ENDT

; OBJECT PROPERTY TABLES ARE DEFINED HERE
">
	<MAPF <> <FUNCTION (BUCK) <MAPF <> ,PRINT-OBJTBL .BUCK>> .OBJ>>

<DEFINE PRINT-GLOBALS ("AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC 
"

; THE GLOBAL VARIABLES ARE ALL LOCATED HERE

GLOBAL::.TABLE
	.GVAR HERE=0
	.GVAR SCORE=0
	.GVAR MOVES=0">
	<MAPF <>
	      <FUNCTION (STR) <REMOVE .STR ,VARS>>
	      '["HERE" "SCORE" "MOVES"]>
	<MAPF <>
	      <FUNCTION (BUCK) 
		      #DECL ((BUCK) <LIST [REST ATOM]>)
		      <MAPF <>
			    <FUNCTION (VAR) 
				    #DECL ((VAR) ATOM)
				    <PRINC "
	.GVAR ">
				    <PRINC <SPNAME .VAR>>
				    <PRINC "=">
				    <PRINC ,.VAR>>
			    .BUCK>>
	      ,VARS>
	<PRINC "
	.GVAR PREPOSITIONS=PRTBL
	.GVAR ACTIONS=ATBL
	.GVAR PREACTIONS=PATBL
	.GVAR VERBS=VTBL
	.ENDT
">>

<DEFINE PRINT-FLAGS ("AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC "

; OBJECT FLAGS ARE DEFINED HERE
">
	<MAPF <>
	      <FUNCTION (BUCK) 
		      #DECL ((BUCK) <LIST [REST ATOM]>)
		      <MAPF <>
			    <FUNCTION (FLAG) 
				    #DECL ((FLAG) ATOM)
				    <PRINC "

	FX?">
				    <PRINC .FLAG>
				    <PRINC "=">
				    <PRIN1 <BVAL ,.FLAG>>
				    <PRINC "
	">
				    <PRINC .FLAG>
				    <PRINC "=">
				    <PRIN1 <BNUM ,.FLAG>>>
			    .BUCK>>
	      ,FLAGS>>

<DEFINE OBITPRINT (L "AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((L) <LIST [REST ATOM]> (OUTCHAN) CHANNEL)
	<MAPR <>
	      <FUNCTION (FLAGS) 
		      #DECL ((FLAGS) <LIST ATOM [REST ATOM]>)
		      <PRINC "FX?">
		      <PRINC <1 .FLAGS>>
		      <OR <LENGTH? .FLAGS 1> <PRINC "+">>>
	      .L>
	<AND <EMPTY? .L> <PRIN1 0>>>

<DEFINE PRINT-STRINGS ("AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL)
	<SET ZCHN .OUTCHAN>
	<PRINC "

; STRINGS ARE DEFINED HERE
">
	<REPEAT ((N 0))
		#DECL ((N) FIX)
		<COND (<G? <SET N <+ .N 1>> ,STRCNT> <RETURN>)
		      (T
		       <PRINC "
	.GSTR STR?">
		       <PRIN1 .N>
		       <PRINC ",">
		       <STRING-PRINT <NTH <TOP ,STRS> .N>>)>>>

<DEFINE PRINT-TABLES ("AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC "

; TABLES ARE DEFINED HERE
">
	<REPEAT ((N 0))
		#DECL ((N) FIX)
		<COND (<G? <SET N <+ .N 1>> ,TBLCNT> <RETURN>)
		      (<PRINC "
T?">
		       <PRIN1 .N>
		       <PRINC "::	.TABLE">
		       <MAPF <>
			     <FUNCTION (ITEM) <PRINC "
	"> <PRINC .ITEM>>
			     <NTH <TOP ,TBLS> .N>>
		       <PRINC "
	.ENDT
">)>>>

<DEFINE PRINT-OBJECT (NAME "AUX" (VEC <ADD-OBJ .NAME>) (COMMA ",")
		                 (OUTCHAN .OUTCHAN)) 
	#DECL ((NAME) ATOM (VEC) VECTOR (COMMA) STRING (OUTCHAN) CHANNEL)
	<PRINC "
	.OBJECT ">
	<PRINC .NAME>
	<PRINC .COMMA>
	<OBITPRINT <OBIT0-15 .VEC>>
	<PRINC .COMMA>
	<OBITPRINT <OBIT16-31 .VEC>>
	<PRINC .COMMA>
	<PRINC <OLOC .VEC>>
	<PRINC .COMMA>
	<PRINC <ONEXT .VEC>>
	<PRINC .COMMA>
	<PRINC <OFIRST .VEC>>
	<PRINC ",T?">
	<PRINC .NAME>>

<DEFINE PRINT-OBJTBL (NAME "AUX" (VEC <ADD-OBJ .NAME>) (OUTCHAN .OUTCHAN)) 
	#DECL ((NAME) ATOM (VEC) VECTOR (OUTCHAN) CHANNEL)
	<PRINC "
T?">
	<PRINC .NAME>
	<PRINC "::	.TABLE">
	<PRINC "			; TABLE FOR OBJECT ">
	<PRINC .NAME>
	<PRINC "
	.STRL ">
	<PRIN1 <ODESC .VEC>>
	<COND (<EMPTY? <OPROP .VEC>>)
	      (<REPEAT ((VV <REST <OPROP .VEC>>))
		       <MAPF <> ,PRINC <1 .VV>>
		       <AND <LENGTH? .VV 1> <RETURN>>
		       <SET VV <REST .VV 2>>>)>
	<PRINC "
	.BYTE	0
	.ENDT
">>

<DEFINE PRINT-UCONST ("AUX" (OUTCHAN .OUTCHAN))
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC "

; USER DEFINED CONSTANTS ARE INITIALIZED HERE
">
	<MAPF <>
	      <FUNCTION (BUCK)
			#DECL ((BUCK) LIST)
			<MAPF <>
			      <FUNCTION (ATM)
					#DECL ((ATM) ATOM)
					<PRINC "
	">
					<PRINC .ATM>
					<PRINC "=">
					<PRIN1 ,.ATM>>
			      .BUCK>>
	      ,UCONST>>

<DEFINE PRINT-SEQ (SEQTBL STR PREFIX "AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((SEQTBL) <UVECTOR [REST ATOM]> (STR PREFIX) STRING
	       (OUTCHAN) CHANNEL)
	<PRINC "

; ">
	<PRINC .STR>
	<PRINC " ARE DEFINED HERE
">
	<REPEAT ((N <LENGTH .SEQTBL>))
		#DECL ((N) FIX)
		<COND (<==? <NTH .SEQTBL .N> T> <RETURN>)
		      (<PRINC "
	">
		       <PRINC .PREFIX>
		       <PRINC <NTH .SEQTBL .N>>
		       <PRINC "=">
		       <PRIN1 .N>)>
		<AND <0? <SET N <- .N 1>>> <RETURN>>>>

<DEFINE PRINT-TOP ("AUX" (OUTCHAN .OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL)
	<PRINC 
"

; TOP LEVEL DEFINITIONS

	O?ANY=1
	
	PS?OBJECT=128
	PS?VERB=64
	PS?ADJECTIVE=32
	PS?DIRECTION=16
	PS?PREPOSITION=8
	PS?BUZZ-WORD=4

	P1?OBJECT=0
	P1?VERB=1
	P1?ADJECTIVE=2
	P1?DIRECTION=3
">>

<DEFINE DUMP (OUTCHAN) 
	#DECL ((OUTCHAN) <SPECIAL CHANNEL>)
	<PRINT-TOP>
	<PRINT-FLAGS>
	<PRINT-VERBNUMS>
	<PRINT-SEQ <TOP ,PROPS> "PROPERTIES" "">
	<PRINT-SEQ <TOP ,ADJS> "ADJECTIVES" "A?">
	<PRINT-SEQ <TOP ,BUZZES> "BUZZ WORDS" "B?">
	<PRINT-SEQ <TOP ,PREPS> "PREPOSITIONS" "PR?">
	<PRINT-SEQ <TOP ,DIRS> "DIRECTIONS" "D?">
	<PRINT-SEQ <TOP ,ACTS> "ACTIONS" "ACT?">
	<PRINT-UCONST>
	<PRINT-OBJECTS>
	<PRINT-GLOBALS>
	<PRINT-TABLES>
	<PRINC "

; END OF PURENESS

IMPURE::

">
	<PRINT-VERBS>
	<PRINT-ACTIONS>
	<PRINT-PREPS>
	<PRINT-VOCAB>
	<PRINC "
	.ENDI
">
	<INFO "
Vocabulary: " <OBLCNT ,WORDS>>
	<INFO "
Prepositions: " <- <LENGTH ,PREPS> 1>>
	<COND (<G? <LENGTH ,PREPS> 1>
	       <LIST-VEC ,PREPS>)>
	<INFO "
Objects: " <OBLCNT ,OBJECTS>>
	<LIST-OBL ,OBJECTS>
	<INFO "
Properties: " <- <LENGTH ,PROPS> 1>>
	<LIST-VEC ,PROPS>
	<INFO "
Globals: " <OBLCNT ,VARS>>
	<LIST-OBL ,VARS>>

<DEFINE DUMPSTR (OUTCHAN)
	#DECL ((OUTCHAN) <SPECIAL CHANNEL>)
	<PRINT-STRINGS>
	<PRINC "

	.ENDI
">>

<DEFINE OBLCNT (OBL) #DECL ((OBL) OBLIST) <MAPF ,+ ,LENGTH .OBL>>

<DEFINE LIST-VEC (UVEC)
	#DECL ((UVEC) <UVECTOR [REST ATOM]>)
	<MAPF <> ,LIST-ATOM <SORTEX <> <REST .UVEC>>>>

<DEFINE LIST-OBL (OBL "AUX" UVEC)
	#DECL ((OBL) OBLIST (UVEC) <UVECTOR [REST ATOM]>)
	<SET UVEC
	     <MAPF ,UVECTOR
		   <FUNCTION (BUCK)
			     #DECL ((BUCK) <LIST [REST ATOM]>)
			     <MAPRET !.BUCK>>
	           .OBL>>
	<MAPF <> ,LIST-ATOM <SORTEX <> .UVEC>>>

<DEFINE LIST-ATOM (ATM)
	#DECL ((ATM) ATOM)
	<INFO "
	 " .ATM>>

;"**************** ZILCH - TOP LEVEL COMPILER ROUTINE ***************"

<SETG ERROR-CHECK T>

<DEFINE ZILCH ZA (STR "OPTIONAL" (TTYREC <>) "AUX" C (TIM <TIME>) ZCHN) 
	#DECL ((STR) STRING (C) <OR FALSE CHANNEL> (TIM) FLOAT
	       (ZCHN) <SPECIAL CHANNEL> (TTYREC) <OR FALSE ATOM CHANNEL>
	       (ZA) ACTIVATION)
;<PRINC "Level = ">
;<PRINC ,LEVEL>
;<CRLF>
	<COND (<TYPE? .TTYREC CHANNEL>
	       <PRINC "Compiling ">
	       <PRINC .STR>
	       <PRINC ".ZIL">
	       <CRLF>)
	      (T
	       <SET RECCHN
		    <COND (<NOT .TTYREC> ,OUTCHAN)
			  (<OPEN "PRINT" .STR "RECORD">)
			  (<COMPERR CANT-OPEN-RECORD-CHANNEL!-ERRORS>
			   <RETURN T .ZA>)>>)>
	<COND (<0? ,LEVEL>
	       <SETG ERRS 0>
	       <SETG CODLEN 0>
	       <INFO "
ZIL Debugging Compiler 4.5
--------------------------">)>
	<COND (<AND <SET C <OPEN "READ" .STR "ZIL">>
		    <SET ZCHN <OPEN "PRINT" .STR "ZAP">>>
	       <PUT .ZCHN 13 <CHTYPE <MIN> FIX>>
	       ;<PRINC "*START*" .ZCHN>
	       ;<CRLF .ZCHN>
	       <INFO "
Input file: ">
	       <INFO .STR>
 	       <INFO ".ZIL">
	       <CRLF>
 	       <COND (<0? ,LEVEL>
<SETG ZORK-VERSION 42>
		      ;<ID-GEN .C>
		      <PRINC "
	.INSERT \"" .ZCHN>
		      <PRINC .STR .ZCHN>
		      <PRINC "DAT\"			; DATA IS IN THIS FILE

" .ZCHN>)>
	       <LOAD .C>
	       <CLOSE .C>
	       <COND (<0? ,LEVEL>
		      <PRINC "
	.INSERT \"" .ZCHN>
		      <PRINC .STR .ZCHN>
		      <PRINC "STR\"

	.END
" .ZCHN>)
		     (<PRINC "
	.ENDI
" .ZCHN>)>
	       <CLOSE .ZCHN>
	       <COND (<0? ,LEVEL>
		      <CHECKUP>
		      <COND (<AND <G? ,ERRS 0> ,ERROR-CHECK>
			     <INFO "

Fatal errors: "
				   ,ERRS
				   "
ZILCH failed.">
			     <COND (<AND <0? ,LEVEL>
					 <N==? .RECCHN ,OUTCHAN>>
				    <CLOSE .RECCHN>)>
			     <>)
			    (<SET C <OPEN "PRINT" <STRING .STR "DAT"> "ZAP">>
			     <PUT .C 13 <CHTYPE <MIN> FIX>>
			     <DUMP .C>
			     <CLOSE .C>
			     <SET C <OPEN "PRINT" <STRING .STR "STR"> "ZAP">>
			     <PUT .C 13 <CHTYPE <MIN> FIX>>
			     <DUMPSTR .C>
			     <CLOSE .C>
			     <INFO "
Total code length: "
				   ,CODLEN
				   " bytes.
ZILCH finished in "
				   <- <TIME> .TIM>
				   " seconds.">
			     <CLOSE .C>
			     <COND (<AND <0? ,LEVEL>
					 <N==? .RECCHN ,OUTCHAN>>
				    <CLOSE .RECCHN>)>
			     ,NULL)
			    (<COMPERR CANT-OPEN-DATA-FILE!-ERRORS>
			     <RETURN T .ZA>)>)
		     (<SETG LEVEL <- ,LEVEL 1>>)>)
	      (<COMPERR CANT-OPEN-INPUT-FILE!-ERRORS> <RETURN T .ZA>)>
	,NULL>

<DEFINE ID-GEN (C "AUX" (X <MEMQ !\. <8 .C>>) Y)
	#DECL ((C) CHANNEL (X Y) <STRING CHARACTER [REST CHARACTER]>)
	<SET Y <MEMQ !\; .X>>
	<SETG ZORK-VERSION 
	      <PARSE <SUBSTRUC .X 1 <- <LENGTH .X> <LENGTH .Y>>>>>> 

<DEFINE CHECKUP ()
	<COND (<GASSIGNED? ZORK-ID>
	       <CONSTANT ZORKID <+ <* ,ZORK-ID 1024> ,ZORK-VERSION>>)
	      (<COMPERR NO-GAME-ID!-ERRORS>)>
	<COND (<NOT ,STARTFLG>
	       <COMPERR NO-STARTING-ADDRESS!-ERRORS>)>
	<COND (<NOT ,ENDLOADFLG>
	       <COMPERR NO-ENDLOAD-ADDRESS!-ERRORS>)>
	<MAPF <>
	      <FUNCTION (FREF "AUX" ATM OPDEF) 
			#DECL ((FREF) FREF (ATM) <OR FALSE ATOM> (OPDEF) OPDEF)
			<COND
			 (<SET ATM <LOOKUP <SPNAME <FCALLED .FREF>> ,OPS>>
			  <SET OPDEF ,.ATM>
			  <COND (<OR <G? <FARGS .FREF> <OPMAX .OPDEF>>
				     <L? <FARGS .FREF> <OPMIN .OPDEF>>>
				 <COMPERR WRONG-NUMBER-OF-ARGUMENTS!-ERRORS
					  "Caller:"
					  <FCALLER .FREF>
					  " Called Routine:"
					  <FCALLED .FREF>
					  " Arguments:"
					  <FARGS .FREF>>)>)
			 (<INFO "
 ** Warning, Undefined Routine: " <FCALLED .FREF>>)>>
	      ,FREFS>
	<MAPF <>
	      <FUNCTION (BUCK)
		   #DECL ((BUCK) <LIST [REST ATOM]>)
		   <MAPF <>
			 <FUNCTION (OP "AUX" (OPDEF ,.OP))
				#DECL ((OP) ATOM (OPDEF) OPDEF)
				 <MAPF <>
				       <FUNCTION (ATM)
					    #DECL ((ATM) GLOBAL)
					    <OR <LOOKUP <SPNAME
							 <CHTYPE .ATM ATOM>>
							,VARS>
						<UNDEF .ATM>>>
					 <OPEXT .OPDEF>>>
			 .BUCK>>
	      ,OPS>>

<DEFINE UNDEF (GLOBAL)
	#DECL ((GLOBAL) GLOBAL)
	<INFO "
 ** WARNING Undefined Global: "
	      <CHTYPE .GLOBAL ATOM>
	      " / Initialized to zero.">
	<GLOBAL <CHTYPE .GLOBAL ATOM> 0>>

<DEFINE INFO ("TUPLE" ITMS "AUX" (CHAN .RECCHN)) 
	#DECL ((ITMS) TUPLE (STR) STRING (NUM) FIX (CHAN) CHANNEL)
	<MAPF <>
	      <FUNCTION (X)
			<PRINC .X .CHAN>>
	      .ITMS>>

;" ******************** HERE LIES THE CODE COMPILER **********************"

<NEWTYPE FLBL VECTOR '<<PRIMTYPE VECTOR> <LIST [REST <OR FALSE LABEL>]>
					 SENSE>>

<NEWTYPE LOCAL ATOM>

<NEWTYPE GLOBAL ATOM>

<NEWTYPE LABEL ATOM>

<NEWTYPE RLABEL ATOM>

<NEWTYPE SENSE ATOM>

<NEWTYPE JUMP ATOM>

<NEWTYPE INS ATOM>

<NEWTYPE CALL ATOM>

<NEWTYPE RSTRING STRING>

;" ******************** RANDOM VARIABLES *********************"

<SETG HILBL 0>

<SETG FREFS ()>

<SETG LOCALS ()>

<GDECL (LOCALS) <LIST [REST ATOM]> (FREFS) <LIST [REST FREF]> (HILBL) FIX>

;" ********************** CONSTANTS, OPERATIONS, ETC ******************"

<NEWTYPE OPDEF
	 VECTOR
	 '<<PRIMTYPE VECTOR> FIX
			     FIX
			     <OR ATOM FALSE>
			     <OR ATOM FALSE>
			     <OR ATOM FALSE>
			     LIST>>

<MSETG OPMIN 1>

<MSETG OPMAX 2>

<MSETG OPPRED 3>

<MSETG OPVAL 4>

<MSETG OPUSER 5>

<MSETG OPEXT 6>

<NEWTYPE FREF VECTOR '<<PRIMTYPE VECTOR> ATOM ATOM FIX>>

<MSETG FCALLER 1>

<MSETG FCALLED 2>

<MSETG FARGS 3>

<DEFINE ADD-OP (NAME MIN MAX PRED? VAL?)
    <SETG <INSERT <SPNAME .NAME> ,OPS>
	  <CHTYPE [.MIN .MAX .PRED? .VAL? <> ()] OPDEF>>>

<COND (<NOT <GASSIGNED? OPRED>>
       <SETG OPRED ![AND OR NOT!]>
       <MAPF <>
	     <FUNCTION (LST) <SETG <INSERT <SPNAME <1 .LST>> ,CNV> <2 .LST>>>
	     [[==? EQUAL?]
	      [=? EQUAL?]
	      [L? LESS?]
	      [G? GRTR?]
	      [APPLY CALL]
	      [SETG SET]
	      [0? ZERO?]
	      [* MUL]
	      [/ DIV]
	      [REST ADD]
	      [BACK SUB]
	      [+ ADD]
	      [- SUB]
	      [NTH GET]
	      [NTHB GETB]
	      [ANDB BAND]
	      [ORB BOR]
	      [XORB BCOM]]>
       <SETG PREDS
	     ![#INS EQUAL?
	       #INS LESS?
	       #INS GRTR?
	       #INS DLESS?
	       #INS IGRTR?
	       #INS IN?
	       #INS FSET?
	       #INS ZERO?
	       #INS NEXT?
	       #INS FIRST?
	       #INS LOC!]>
       <ADD-OP EQUAL? 2 4 T <>>
       <ADD-OP LESS? 2 2 T <>>
       <ADD-OP GRTR? 2 2 T <>>
       <ADD-OP DLESS? 2 2 T <>>
       <ADD-OP IGRTR? 2 2 T <>>
       <ADD-OP IN? 2 2 T <>>
       <ADD-OP BTST 2 2 T <>>
       <ADD-OP BAND 2 2 <> T>
       <ADD-OP BOR 2 2 <> T>
       <ADD-OP BCOM 2 2 <> T>
       <ADD-OP FSET? 2 2 T <>>
       <ADD-OP FSET 2 2 <> <>>
       <ADD-OP FCLEAR 2 2 <> <>>
       <ADD-OP SET 2 2 <> <>>
       <ADD-OP MOVE 2 2 <> <>>
       <ADD-OP GET 2 2 <> T>
       <ADD-OP GETB 2 2 <> T>
       <ADD-OP GETP 2 2 <> T>
       <ADD-OP GETPT 2 2 <> T>
       <ADD-OP NEXTP 2 2 <> T>
       <ADD-OP ADD 2 2 <> T>
       <ADD-OP SUB 2 2 <> T>
       <ADD-OP MUL 2 2 <> T>
       <ADD-OP DIV 2 2 <> T>
       <ADD-OP MOD 2 2 <> T>
       <ADD-OP NOT 1 1 <> <>>
       <ADD-OP ZERO? 1 1 T <>>
       <ADD-OP NEXT? 1 1 T T>
       <ADD-OP FIRST? 1 1 T T>
       <ADD-OP LOC 1 1 <> T>
       <ADD-OP PTSIZE 1 1 <> T>
       <ADD-OP INC 1 1 <> <>>
       <ADD-OP DEC 1 1 <> <>>
       <ADD-OP PUSH 1 1 <> <>>
       <ADD-OP POP 1 1 <> <>>
       <ADD-OP REMOVE 1 1 <> <>>
       <ADD-OP CALL 1 4 <> T>
       <ADD-OP RETURN 1 1 <> <>>
       <ADD-OP JUMP 1 1 <> <>>
       <ADD-OP PRINT 1 1 <> <>>
       <ADD-OP RTRUE 0 0 <> <>>
       <ADD-OP RFALSE 0 0 <> <>>
       <ADD-OP PRINTI 1 1 <> <>>
       <ADD-OP PRINTR 1 1 <> <>>
       <ADD-OP CRLF 0 0 <> <>>
       <ADD-OP NOOP 0 0 <> <>>
       <ADD-OP SAVE 0 0 T <>>
       <ADD-OP RESTORE 0 0 T <>>
       <ADD-OP RESTART 0 0 <> <>>
       <ADD-OP QUIT 0 0 <> <>>
       <ADD-OP VERIFY 0 0 T <>>
       <ADD-OP RSTACK 0 0 <> <>>
       <ADD-OP FSTACK 0 0 <> <>>
       <ADD-OP PUT 3 3 <> <>>
       <ADD-OP PUTB 3 3 <> <>>
       <ADD-OP PUTP 3 3 <> <>>
       <ADD-OP READ 2 2 <> <>>
       <ADD-OP PRINTC 1 1 <> <>>
       <ADD-OP PRINTN 1 1 <> <>>
       <ADD-OP PRINTB 1 1 <> <>>
       <ADD-OP PRINTD 1 1 <> <>>
       <ADD-OP VALUE 1 1 <> T>
       <ADD-OP RANDOM 1 1 <> T>
       <ADD-OP AND 1 100 <> <>>
       <ADD-OP OR 1 100 <> <>>
       <ADD-OP DO 1 100 <> <>>)>

<GDECL (OPRED) <UVECTOR [REST ATOM]> (PREDS) <UVECTOR [REST INS]> (CODLEN) FIX>

<DEFINE DEBUG () 
	<SET ZCHN <SET RECCHN ,OUTCHAN>>
	<SETG CODLEN 0>
	<SET REDEFINE T>>

<DEFINE ROUTINE ZDEF ("ARGS" LST
		      "AUX" NAME ARGL LPROG VAL ZNAM (MIN 0) (MAX 0) (OPT <>)
			    (AUX <>) (OPS ,OPS) (EXT ()) TZL (TIM <TIME>) LEN
			    (FORMS (T)) (F .FORMS))
   #DECL ((LST) LIST (NAME) ATOM (ARGL) LIST (MIN MAX LEN) FIX (TIM) FLOAT
	  (TZL FORMS) LIST (LPROG) <SPECIAL RLABEL> (VAL) <OR ATOM SENSE FLBL>
	  (OPT AUX) <OR ATOM FALSE> (ZDEF) <SPECIAL ACTIVATION>
	  (ZNAM) <SPECIAL ATOM> (OPS) OBLIST (EXT) <LIST [REST GLOBAL]>)
   <COND (<NOT <DECL? .LST '<LIST ATOM LIST [REST ANY]>>>
	  <COMPERR BAD-SYNTAX!-ERRORS DEFINE>)
	 (<SET ZNAM <SET NAME <1 .LST>>> <SET ARGL <2 .LST>>)>
   <SET TZL <SETG TZL <SETG ZL (T)>>>
   <SETG HILBL 0>
   <SETG TEMPS ()>
   <SETG LOCALS ()>
   <EMIT "	.FUNCT	">
   <EMIT <CHTYPE .NAME LOCAL>>
   <REMOVE <SPNAME .NAME> ,UCONST>
   <INFO "
Compiling routine: " .NAME>
   <MAPF <>
    <FUNCTION (ARG) 
       #DECL ((ARG) ANY)
       <COND
	(<TYPE? .ARG ATOM>
	 <SETG LOCALS (.ARG !,LOCALS)>
	 <EMIT "," <CHTYPE .ARG LOCAL>>
	 <OR .AUX <SET MAX <+ .MAX 1>>>
	 <OR .OPT <SET MIN <+ .MIN 1>>>)
	(<=? .ARG "OPTIONAL"> <SET OPT T>)
	(<=? .ARG "AUX"> <SET OPT T> <SET AUX T>)
	(<AND <DECL? .ARG '<LIST ATOM <OR ATOM FIX FORM>>> <OR .AUX .OPT>>
	 <SETG LOCALS (<1 .ARG> !,LOCALS)>
	 <EMIT "," <CHTYPE <1 .ARG> LOCAL>>
	 <COND
	  (<AND <TYPE? <2 .ARG> FORM>
		<NOT <EMPTY? <2 .ARG>>>
		<NOT <L/G? <2 .ARG>>>>
	   <SET FORMS <REST <PUTREST .FORMS (<FORM SET <1 .ARG> <2 .ARG>>)>>>)
	  (T
	   <EMIT "="
		 <COND (<==? <2 .ARG> T> 1)
		       (<TYPE? <2 .ARG> ATOM>
			<CONSTANT-CHECK <2 .ARG>>
			<CHTYPE <2 .ARG> LOCAL>)
		       (<TYPE? <2 .ARG> FORM>
			<COND (<EMPTY? <2 .ARG>> 0)
			      (<L/G? <2 .ARG>> <CHTYPE <2 <2 .ARG>> LOCAL>)
			      (<COMPERR BAD-ARG-SYNTAX!-ERRORS .NAME>)>)
		       (<2 .ARG>)>>)>
	 <OR .AUX <SET MAX <+ .MAX 1>>>)
	(<COMPERR BAD-ARG-SYNTAX!-ERRORS .NAME>)>>
    .ARGL>
   <COND (<TYPE? <3 .LST> DECL> <SET LST <REST .LST>>)>
   <AND <==? .NAME GO> <SETG STARTFLG T> <EMIT "
START::
">>
   <EMIT <SET LPROG #RLABEL ?FCN>>
   <MAPF <> ,GENT <REST .F>>
   <SET VAL
	<MAPR <>
	      <FUNCTION (L "AUX" (ITM <1 .L>)) 
		      #DECL ((L) LIST (ITM) ANY)
		      <COND (<LENGTH? .L 1>
			     <MAPLEAVE <GENT .ITM #LOCAL STACK>>)
			    (<GENT .ITM>)>>
	      <REST .LST 2>>>
   <COND (<==? .VAL STACK> <EMIT #INS RSTACK>)
	 (<==? .VAL ?NOVAL> <EMIT #INS RTRUE>)
	 (<TYPE? .VAL SENSE> <EMIT .VAL #JUMP TRUE #INS RFALSE>)
	 (<TYPE? .VAL ATOM> <EMIT #INS RETURN .VAL>)
	 (<ERROR .VAL>)>
   <REPEAT ((LL .TZL) (L <REST .LL>))
	   #DECL ((LL L) LIST)
	   <COND (<TYPE? <1 .L> RLABEL LABEL INS>
		  <MAPF <>
			<FUNCTION (X) 
				<PUTREST .LL <CONS "," .L>>
				<PUTREST <REST .LL> <CONS .X .L>>
				<SET LL <REST .LL 2>>>
			,TEMPS>
		  <RETURN>)
		 (<SET L <REST .L>> <SET LL <REST .LL>>)>>
   <SET LST
	<MAPF ,LIST
	      <FUNCTION (ITM) 
		      #DECL ((ITM) ANY)
		      <COND (<TYPE? .ITM ATOM> <MAPRET .ITM>)
			    (<TYPE? .ITM RLABEL LABEL INS> <MAPSTOP>)
			    (<MAPRET>)>>
	      .TZL>>
   <MAPF <>
	 <FUNCTION (ITM) 
		 #DECL ((ITM) ANY)
		 <COND (<TYPE? .ITM GLOBAL>
			<COND (<MEMQ .ITM .EXT>)
			      (<INFO "
Global reference: " <CHTYPE .ITM ATOM>>
			       <SET EXT (.ITM !.EXT)>)>)
		       (<TYPE? .ITM CALL>
			<INFO "
Routine called: " <CHTYPE .ITM ATOM>>)>>
	 .TZL>
   <INFO "
Code length: "
	 <SET LEN <+ <PEEPH .TZL .ZCHN> <LENGTH ,LOCALS>>>
	 " bytes.
Compilation time: "
	 <- <TIME> .TIM>
	 " seconds.">
   <SET EXT
	<MAPF ,LIST
	      <FUNCTION (ATM) 
		      #DECL ((ATM) GLOBAL)
		      <COND (<LOOKUP <SPNAME <CHTYPE .ATM ATOM>> ,VARS>
			     <MAPRET>)
			    (.ATM)>>
	      .EXT>>
   <COND (<AND <LOOKUP <SPNAME .NAME> .OPS>
	       <OR <NOT <ASSIGNED? REDEFINE>> <NOT .REDEFINE>>>
	  <COMPERR ALREADY-DEFINED!-ERRORS>)
	 (<SETG <OR <LOOKUP <SPNAME .NAME> .OPS> <INSERT <SPNAME .NAME> .OPS>>
		<CHTYPE [.MIN .MAX <> T T .EXT] OPDEF>>)>
   <SETG CODLEN <+ ,CODLEN .LEN>>
   <CRLF .ZCHN>>

<SETG STARTFLG <>>

<SETG ENDLOADFLG <>>

<GDECL (STARTFLG ENDLOADFLG) <OR ATOM FALSE>>

<DEFINE PROGGEN (LST LPROGVAL
		 "OPTIONAL" (RPT <>) (LPROG <CHTYPE <GENLBL "PRG"> RLABEL>)
			    (LRTN <GENLBL "REP">)
		 "AUX" VAL)
	#DECL ((LST) LIST (RPT) <OR FALSE FIX ATOM>
	       (LPROG LRTN) <SPECIAL <PRIMTYPE ATOM>>
	       (LPROGVAL) <SPECIAL <OR LOCAL FALSE>>
	       (VAL) <OR ATOM FLBL SENSE>)
	<AND <==? <1 .LST> ()> <SET LST <REST .LST>>>
	<OR <==? .RPT 0> <EMIT .LPROG>>
	<MAPR <>
	      <FUNCTION (X) <COND (<LENGTH? .X 1> <MAPLEAVE>) (<GENT <1 .X>>)>>
	      .LST>
	<COND (<AND .LPROGVAL <NOT .RPT>>
	       <GENT <NTH .LST <LENGTH .LST>> .LPROGVAL>)
	      (<GENT <NTH .LST <LENGTH .LST>>>)>
	<COND (.RPT
	       <EMIT #INS JUMP <CHTYPE .LPROG JUMP>>)>
	<EMIT .LRTN>
	<OR <AND .LPROGVAL <CHTYPE .LPROGVAL ATOM>> #SENSE TRUE>>

<DEFINE CONDGEN (FRM VAL? "AUX" (CONDEND <GENLBL "CND">) VAL CVT CVF) 
	#DECL ((FRM) LIST (CONDEND CVT CVF) LABEL (VAL) <OR FLBL SENSE ATOM>
	       (VAL?) <OR LOCAL FALSE>)
	<COND (.VAL? <SET CVT <GENLBL "PRD">> <SET CVF <GENLBL "PRD">>)>
	<COND (<NOT <DECL? .FRM '<LIST [REST LIST]>>>
	       <COMPERR BAD-SYNTAX!-ERRORS COND>)>
	<MAPR <>
	      <FUNCTION (LST "AUX" (CLAUSE <1 .LST>)) 
		      #DECL ((LST CLAUSE) LIST)
		      <COND (.VAL?
			     <SET VAL <IFGEN .CLAUSE .CONDEND .CVT .CVF>>)
			    (<SET VAL <IFGEN .CLAUSE .CONDEND>>)>>
	      .FRM>
	<COND (.VAL?
	       <EMIT #INS JUMP <CHTYPE .CVF JUMP>>
	       <EMIT .CVT #INS PUSH 1 #INS JUMP <CHTYPE .CONDEND JUMP>>
	       <EMIT .CVF #INS PUSH 0>
	       <EMIT .CONDEND>
	       <OR <==? .VAL? #LOCAL STACK>
		   <EMIT #INS SET <CHTYPE .VAL? ATOM> "," #LOCAL STACK>>
	       <CHTYPE .VAL? ATOM>)
	      (<EMIT .CONDEND> .VAL)>>

<DEFINE IFGEN (LST COND
	       "OPTIONAL" (CVT <>) CVF
	       "AUX" (THEN <GENLBL "THN">) (ELSE <GENLBL "ELS">) LBL VAL
		     (VAL1 ?NOVAL))
	#DECL ((LST) LIST (CVT) <OR FALSE LABEL>
	       (LBL) <LIST [REST <OR FALSE LABEL>]> (THEN ELSE COND CVF) LABEL
	       (VAL VAL1) <OR ATOM SENSE FLBL>)
	<COND (<EMPTY? .LST> <COMPERR BAD-SYNTAX!-ERRORS COND-CLAUSE>)>
	<COND (<LENGTH? .LST 1> <SET LST (<1 .LST> T)>)>
	<COND (<MEMQ <1 .LST> '[T ELSE]> <SET VAL #SENSE TRUE>)
	      (<SET VAL <PREDGEN <1 .LST>>>)>
	<COND (<TYPE? .VAL FLBL>
	       <SET LBL <1 .VAL>>
	       <SET VAL <2 .VAL>>
	       <OR <LENGTH? .LST 1>
		   <EMIT <ZNOT .VAL> <CHTYPE .ELSE JUMP> .THEN>>
	       <MAPF <>
		     <FUNCTION (LBL) 
			     #DECL ((LBL) <OR FALSE LABEL>)
			     <AND .LBL
				  <MEMBER "THN" <SPNAME <CHTYPE .LBL ATOM>>>
				  <NOT <MEMQ .LBL ,TZL>>
				  <EMIT .LBL>>>
		     .LBL>)>
	<COND (<NOT <LENGTH? .LST 1>>
	       <MAPR <>
		     <FUNCTION (X) 
			     <AND <LENGTH? .X 1> <MAPLEAVE>>
			     <GENT <1 .X>>>
		     <REST .LST>>
	       <SET VAL1
		    <GENT <NTH .LST <LENGTH .LST>> <AND .CVT #LOCAL STACK>>>)
	      (<SET VAL1 .VAL>)>
	<COND (<AND .CVT <TYPE? .VAL1 SENSE>> <EMIT .VAL1 <CHTYPE .CVT JUMP>>)
	      (<AND .CVT <==? .VAL1 ?NOVAL>>
	       <EMIT #INS JUMP <CHTYPE .CVT JUMP>>)
	      (T
	       <COND (.CVT
		      <OR <==? .VAL1 STACK>
			  <EMIT #INS PUSH <CHTYPE .VAL1 LOCAL>>>)>
	       <EMIT #INS JUMP <CHTYPE .COND JUMP>>)>
	<AND <ASSIGNED? LBL>
	     <MAPF <>
		   <FUNCTION (LBL) 
			   #DECL ((LBL) <OR FALSE LABEL>)
			   <AND .LBL
				<MEMBER "ELS" <SPNAME <CHTYPE .LBL ATOM>>>
				<NOT <MEMQ .LBL ,TZL>>
				<EMIT .LBL>>>
		   .LBL>>
	<EMIT .ELSE>
	.VAL1>

<DEFINE XNOT (FRM "AUX" (OP <1 .FRM>))
	#DECL ((FRM) FORM (OP) ATOM)
	<FORM <COND (<==? .OP AND> OR) (AND)>
	      !<MAPF ,LIST
		     <FUNCTION (ITM)
			       #DECL ((ITM) ANY)
			       <FORM NOT .ITM>>
		     <REST .FRM>>>>

<DEFINE PREDGEN TOP (ITM
		     "OPTIONAL" (VAL? <>)
		     "AUX" THEN ELSE ORT (SENSE #SENSE TRUE) (LBL ()) OP
			   (VAL <>) LL L2)
   #DECL ((ITM) <OR ATOM <PRIMTYPE LIST>> (THEN ELSE LL ORT L2) LABEL
	  (LBL) <LIST [REST <OR FALSE LABEL>]> (OP) ATOM (SENSE) SENSE
	  (VAL) <OR FALSE ATOM SENSE FLBL> (VAL?) <OR FALSE LOCAL>)
   <COND (<AND <TYPE? .ITM LIST FORM>
	       <NOT <LENGTH? .ITM 1>>
	       <TYPE? <1 .ITM> ATOM>
	       <GASSIGNED? <1 .ITM>>
	       <TYPE? ,<1 .ITM> MACRO>>
	  <SET ITM <EXPAND <CHTYPE .ITM FORM>>>
	  <AGAIN .TOP>)>
   <COND
    (<L/G? .ITM>
     <EMIT #INS ZERO? <VARCHK .ITM>>
     <CHTYPE [(<GENLBL "THN">) #SENSE FALSE] FLBL>)
    (<AND <TYPE? .ITM LIST FORM> <NOT <EMPTY? .ITM>>>
     <SET OP <1 .ITM>>
     <COND (<==? .OP NOT>
	    <AND <LENGTH? .ITM 1> <COMPERR BAD-SYNTAX!-ERRORS NOT>>
	    <SET ITM <2 .ITM>>
	    <COND (<AND <TYPE? .ITM FORM> <MEMQ <1 .ITM> '![AND OR!]>>
		   <SET OP <1 .ITM>>
		   <SET ITM <XNOT .ITM>>
		   <AGAIN .TOP>)
		  (<SET SENSE <ZNOT .SENSE>>)>)>
     <COND
      (<MEMQ .OP '[AND OR]>
       <SET THEN <GENLBL "THN">>
       <SET ELSE <GENLBL "ELS">>
       <AND <==? .OP OR> .VAL? <SET ORT <GENLBL "ORT">>>
       <MAPR <>
	<FUNCTION (L "AUX" (FOO <1 .L>) VAL SNS) 
	   #DECL ((L) LIST (FOO) ANY (VAL) <OR SENSE ATOM FLBL> (SNS) SENSE)
	   <AND <LENGTH? .L 1> <MAPLEAVE T>>
	   <SET VAL <GEN .FOO>>
	   <COND (<TYPE? .VAL FLBL> <SET LBL <1 .VAL>> <SET SNS <2 .VAL>>)
		 (<SET SNS .SENSE>)>
	   <COND (<AND <==? .OP OR> .VAL?>)
		 (<AND <TYPE? .VAL ATOM> <N==? .VAL ?NOVAL>>
		  <EMIT #INS ZERO? <CHTYPE .VAL LOCAL>>
		  <SET SNS <ZNOT .SNS>>)>
	   <COND
	    (<==? .OP AND> <EMIT <ZNOT .SNS> <CHTYPE .ELSE JUMP>>)
	    (<==? .OP OR>
	     <AND .VAL? <SET LL <GENLBL "ORP">>>
	     <COND (<AND .VAL? <==? .VAL ?NOVAL>>
		    <EMIT #INS PUSH 1>
		    <EMIT #INS JUMP <CHTYPE .THEN JUMP>>)
		   (<AND .VAL? <TYPE? .VAL ATOM>>
		    <SET FOO
			 <COND (<==? .VAL STACK>
				<COND (<NOT <MEMQ #LOCAL ?ORTMP ,TEMPS>>
				       <SETG TEMPS (#LOCAL ?ORTMP !,TEMPS)>)>
				<EMIT #INS POP ?ORTMP>
				#LOCAL ?ORTMP)
			       (<CHTYPE .VAL LOCAL>)>>
		    <EMIT #INS ZERO? .FOO>
		    <EMIT .SNS <CHTYPE .LL JUMP>>
		    <EMIT #INS PUSH .FOO>
		    <EMIT #INS JUMP <CHTYPE .THEN JUMP>>
		    <EMIT .LL>)
		   (<AND .VAL? <TYPE? .VAL SENSE>>
		    <EMIT .SNS <CHTYPE .ORT JUMP>>)
		   (<==? .VAL ?NOVAL>
		    <EMIT #INS JUMP <CHTYPE .THEN JUMP>>
		    <INFO "
 ** WARNING OR clause always true " .ITM>)
		   (<EMIT .SNS <CHTYPE .THEN JUMP>>)>)>
	   <COND (<NOT <EMPTY? .LBL>>
		  <AND <1 .LBL> <EMIT <1 .LBL>>>
		  <MAPF <>
			<FUNCTION (L) 
				#DECL ((L) <OR FALSE LABEL>)
				<AND .L <EMIT .L>>>
			<REST .LBL>>)>>
	<REST .ITM>>
       <COND (<N==? .OP OR> <SET VAL <GEN <NTH .ITM <LENGTH .ITM>> .VAL?>>)
	     (T
	      <SET VAL <GEN <NTH .ITM <LENGTH .ITM>>>>
	      <COND (.VAL?
		     <COND (<TYPE? .VAL SENSE>
			    <EMIT .VAL <CHTYPE .ORT JUMP>>
			    <EMIT #INS PUSH 0>
			    <EMIT #INS JUMP <CHTYPE .THEN JUMP>>)
			   (<==? .VAL ?NOVAL>
			    <EMIT #INS JUMP <CHTYPE .ORT JUMP>>)
			   (<TYPE? .VAL ATOM>
			    <OR <==? .VAL STACK>
				<EMIT #INS PUSH <CHTYPE .VAL LOCAL>>>)>)>)>
       <COND (<TYPE? .VAL ATOM>
	      <COND (<AND .VAL? <N==? .OP OR>>
		     <COND (<==? .VAL? <CHTYPE .VAL LOCAL>>)
			   (<XEMIT .VAL? .VAL>)>)
		    (<AND <==? .OP OR> .VAL?>)
		    (<==? .VAL ?NOVAL>)
		    (<EMIT #INS ZERO? <CHTYPE .VAL LOCAL>>
		     <SET SENSE <ZNOT .SENSE>>)>)>
       <COND (<TYPE? .VAL FLBL> <SET LBL <1 .VAL>> <SET SENSE <2 .VAL>>)
	     (<AND .VAL? <==? .OP AND>>
	      <EMIT #INS JUMP <CHTYPE <SET LL <GENLBL "PRD">> JUMP>>
	      <EMIT .ELSE>
	      <XEMIT .VAL? 0>
	      <EMIT .LL>)
	     (<TYPE? .VAL ATOM>)
	     (<SET SENSE .VAL>)>)
      (T <SET VAL <GEN .ITM>>)>
     <COND (<AND <==? .OP NOT> .VAL?>
	    <SET LL <GENLBL "PRD">>
	    <COND (<TYPE? .VAL SENSE> <EMIT .VAL <CHTYPE .LL JUMP>>)
		  (<N==? .VAL ?NOVAL>
		   <EMIT #INS ZERO?
			 <CHTYPE .VAL LOCAL>
			 #SENSE FALSE
			 <CHTYPE .LL JUMP>>)>
	    <COND (<==? .VAL ?NOVAL> <EMIT #INS PUSH 0>)
		  (T
		   <EMIT #INS PUSH 1>
		   <EMIT #INS JUMP <CHTYPE <SET L2 <GENLBL "PRD">> JUMP>>
		   <EMIT .LL #INS PUSH 0>
		   <EMIT .L2>)>
	    <COND (<N==? .VAL? #LOCAL STACK>
		   <EMIT #INS SET <CHTYPE .VAL? ATOM> "," #LOCAL STACK>)>)
	   (<AND <TYPE? .VAL ATOM>
		 <N==? .VAL ?NOVAL>
		 <NOT <MEMQ .OP '![AND OR!]>>>
	    <EMIT #INS ZERO? <CHTYPE .VAL LOCAL>>
	    <SET SENSE <ZNOT .SENSE>>)>
     <COND (<AND .VAL? <==? .OP OR>>
	    <EMIT #INS JUMP <CHTYPE .THEN JUMP>>
	    <EMIT .ORT>
	    <EMIT #INS PUSH 1>
	    <EMIT .THEN>
	    <COND (<N==? .VAL? #LOCAL STACK>
		   <EMIT #INS POP <CHTYPE .VAL? ATOM>>)>
	    <CHTYPE .VAL? ATOM>)
	   (.VAL? <CHTYPE .VAL? ATOM>)
	   (<CHTYPE [(<COND (<==? .OP AND> .ELSE) (<==? .OP OR> .THEN)> !.LBL)
		     .SENSE]
		    FLBL>)>)
    (<COMPERR BAD-SYNTAX!-ERRORS PREDICATE-CLAUSE>)>>

<DEFINE VARCHK (FRM "AUX" (VAR <2 .FRM>))
	#DECL ((FRM) <FORM ATOM ATOM> (VAR) ATOM)
	<COND (<==? <1 .FRM> LVAL>
	       <COND (<MEMQ .VAR ,LOCALS>)
		     (<COMPERR UNBOUND-VARIABLE!-ERRORS .FRM>)>
	       <CHTYPE .VAR LOCAL>)
	      (T
	       <COND (<MEMQ .VAR ,LOCALS>
		      <COMPERR LOCAL-USED-IN-GLOBAL-REFERENCE!-ERRORS .FRM>)
		     (<CHTYPE .VAR GLOBAL>)>)>>

<DEFINE GENLBL (STR "AUX" (INITIAL <GET INITIAL OBLIST>)) 
	#DECL ((STR) STRING (INITIAL) OBLIST)
	<SET STR <STRING "?" .STR <UNPARSE <SETG HILBL <+ ,HILBL 1>>>>>
	<CHTYPE <OR <LOOKUP .STR .INITIAL> <INSERT .STR .INITIAL>> LABEL>>
       	
<DEFINE EMIT ("TUPLE" TUP) 
	#DECL ((TUP) <TUPLE [REST ANY]>)
	<MAPF <>
	      <FUNCTION (ITM) 
		      #DECL ((ITM) ANY)
		      <SETG ZL <REST <PUTREST ,ZL (.ITM)>>>>
	      .TUP>>

<DEFINE GENT (ITM "OPTIONAL" (VAL? <>) "AUX" VAL) 
	#DECL ((ITM) <OR 'T STRING FIX <PRIMTYPE LIST>> (VAL?) <OR FALSE
								   LOCAL>
	       (VAL) ANY)
	<COND (<==? .ITM T> ?NOVAL)
	      (T
	       <COND (<TYPE? <SET VAL <GEN .ITM .VAL?>> FLBL>
		      <MAPF <>
			    <FUNCTION (LBL) <AND .LBL <EMIT .LBL>>>
			    <1 .VAL>>
		      <2 .VAL>)
		     (.VAL)>)>>

<DEFINE GEN (ARG
	     "OPTIONAL" (VAL <>)
	     "AUX" LEN (FIRST T) OP ATM (NXT <>) (SENSE #SENSE TRUE) OPATM
		   OPDEF ITM L L2)
   #DECL ((ARG) <OR <PRIMTYPE LIST> STRING FIX ATOM>
	  (ITM) <OR STRING LOCAL FIX <PRIMTYPE LIST>>
	  (FIRST VAL ATM OPATM) <OR FALSE <PRIMTYPE ATOM>> (OP) <OR ATOM FIX>
	  (OPDEF) OPDEF (NXT) ANY (SENSE) SENSE (LEN) FIX (L L2) LABEL)
   <COND (<=? .ARG '<>> <SET ARG '<RFALSE>>)>
   <COND
    (<TYPE? .ARG ATOM> .ARG)
    (<L/G? .ARG> <CHTYPE <VARCHK .ARG> ATOM>)
    (T
     <COND (<AND <TYPE? .ARG LIST FORM>
		 <TYPE? <1 .ARG> ATOM>
		 <GASSIGNED? <1 .ARG>>
		 <TYPE? ,<1 .ARG> MACRO>>
	    <SET ARG <EXPAND <CHTYPE .ARG FORM>>>
	    T)>
     <SET ITM .ARG>
     <COND (<NOT <TYPE? .ITM FIX>> <SET LEN <LENGTH .ARG>>) (<SET LEN 0>)>
     <COND (<AND <G? .LEN 2>
		 <MEMQ <1 .ITM> '![SET SETG!]>
		 <TYPE? <3 .ITM> FORM>
		 <NOT <EMPTY? <3 .ITM>>>
		 <NOT <L/G? <3 .ITM>>>>
	    <COND (<TYPE? <2 .ITM> ATOM>
		   <SET VAL <CHTYPE <2 .ITM> LOCAL>>
		   <SET ITM <3 .ITM>>)
		  (<L/G? <SET NXT <2 .ITM>>>
		   ;<PUT .ITM 2 <2 .NXT>>
		   <INFO "
 ** SET/SETG of variable argument noted: " .ITM>)>)>
     <COND
      (<TYPE? .ITM FIX STRING LOCAL>
       <COND (<TYPE? .ITM STRING>
	      <SET ITM <CHTYPE <PARSE <NXTSTR .ITM>> LOCAL>>)>
       <COND (<==? .VAL #LOCAL STACK> <EMIT #INS PUSH .ITM>)
	     (.VAL <EMIT #INS SET <CHTYPE .VAL ATOM> "," .ITM>)>
       <OR <AND .VAL <CHTYPE .VAL ATOM>> .SENSE>)
      (<NOT <TYPE? <SET NXT <1 .ITM>> ATOM FIX>>
       <COMPERR SYNTAX-ERROR!-ERRORS .ITM>)
      (<==? <SET OP .NXT> COND>
       <AND <L? .LEN 2> <COMPERR SYNTAX-ERROR!-ERRORS COND>>
       <CONDGEN <REST .ITM> .VAL>)
      (<==? .OP REPEAT> <PROGGEN <REST .ITM> .VAL T>)
      (<==? .OP PROG> <PROGGEN <REST .ITM> .VAL>)
      (<AND <==? .OP RETURN> <ASSIGNED? LRTN>>
       <COND (.LPROGVAL
	      <COND (<==? .LEN 1> <XEMIT .LPROGVAL 1>)
		    (<TYPE? <2 .ITM> FIX ATOM> <XEMIT .LPROGVAL <2 .ITM>>)
		    (T <XEMIT .LPROGVAL <GEN <2 .ITM> .LPROGVAL>>)>)>
       <EMIT #INS JUMP <CHTYPE .LRTN JUMP>>
       .SENSE)
      (<==? .OP AGAIN> <EMIT #INS JUMP <CHTYPE .LPROG JUMP>> ?NOVAL)
      (<==? .OP TAG> <EMIT <CHTYPE <2 .ITM> RLABEL>> ?NOVAL)
      (T
       <SET ITM <OPFCN .ITM .VAL>>
       <SET VAL <1 .ITM>>
       <SET OP <2 .ITM>>
       <SET ITM <REST .ITM>>
       <SET LEN <LENGTH .ITM>>
       <COND
	(<==? .OP PROG>
	 <SET NXT <PROGGEN <REST .ITM> .VAL>>
	 <COND (.VAL <EMIT " >" .VAL>)>
	 <OR .VAL .NXT>)
	(T
	 <COND
	  (<SET OPATM <LOOKUP <SPNAME .OP> ,OPS>>
	   <SET OPDEF ,.OPATM>
	   <COND (<OR <G? <- .LEN 1> <OPMAX .OPDEF>>
		      <L? <- .LEN 1> <OPMIN .OPDEF>>>
		  <COMPERR WRONG-NUMBER-OF-ARGUMENTS!-ERRORS .ITM>)>
	   <COND
	    (<OPUSER .OPDEF>
	     <SET OP CALL>
	     <AND <G? .LEN 4>
		  <COMPERR MORE-THAN-THREE-ARGUMENTS-TO-ROUTINE!-ERRORS .ITM>>
	     <SET ITM (CALL !.ITM)>)>)
	  (T
	   <AND <G? .LEN 4>
		<COMPERR MORE-THAN-THREE-ARGUMENTS-TO-ROUTINE!-ERRORS .ITM>>
	   <SET ITM (CALL !.ITM)>
	   <SETG FREFS (<CHTYPE [.ZNAM .OP <- .LEN 1>] FREF> !,FREFS)>
	   <SET OP CALL>
	   <SET OPDEF ,CALL!-OPS>)>
	 <COND
	  (<MEMQ .OP '![AND OR NOT!]> <PREDGEN .ITM .VAL>)
	  (T
	   <TMPCHK .ITM>
	   <EMIT <SETG LSTINS <CHTYPE .OP INS>>>
	   <MAPF <>
	    <FUNCTION (ARG) 
		    #DECL ((ARG) ANY)
		    <COND (.FIRST
			   <SET FIRST <>>
			   <AND <==? .OP CALL>
			        <==? <PRIMTYPE .ARG> ATOM>
				<SET ARG <CHTYPE .ARG CALL>>>)
			  (<EMIT ",">)>
		    <COND (<TYPE? .ARG STRING> <SET ARG <CHTYPE .ARG RSTRING>>)
			  (<NOT <TYPE? .ARG ATOM CALL FIX LOCAL GLOBAL>>
			   <COND (<L/G? .ARG>
				  <SET ARG <CHTYPE <2 .ARG> LOCAL>>)
				 (<COMPERR BAD-ARGUMENT!-ERRORS .OP .ARG>)>)
			  (<TYPE? .ARG ATOM>
			   <COND (<OR <LOOKUP <SPNAME .ARG> ,CONST>
				      <LOOKUP <SPNAME .ARG> ,UCONST>>
				  <SET ARG <CHTYPE .ARG LOCAL>>)>)>
		    <EMIT .ARG>>
	    <REST .ITM>>
	   <COND (<AND .VAL <OPVAL .OPDEF>>
		  <OR <==? .VAL #LOCAL STACK> <EMIT " >" .VAL>>)>
	   <COND (<AND <OPVAL .OPDEF> <NOT <OPPRED .OPDEF>>>
		  <OR <AND .VAL <CHTYPE .VAL ATOM>> STACK>)
		 (<NOT <OPPRED .OPDEF>>
		  <COND (.VAL <XEMIT .VAL 1> <CHTYPE .VAL ATOM>) (?NOVAL)>)
		 (<AND .VAL
		       <N==? .VAL #LOCAL STACK>
		       <OPPRED .OPDEF>
		       <OPVAL .OPDEF>>
		  .SENSE)
		 (.VAL
		  <EMIT .SENSE <CHTYPE <SET L <GENLBL "PRD">> JUMP>>
		  <EMIT #INS PUSH 0>
		  <EMIT #INS JUMP <CHTYPE <SET L2 <GENLBL "PRD">> JUMP>>
		  <EMIT .L #INS PUSH 1>
		  <EMIT .L2>
		  <COND (<==? .VAL #LOCAL STACK>)
			(<EMIT #INS SET <CHTYPE .VAL ATOM> "," #LOCAL STACK>)>
		  <CHTYPE .VAL ATOM>)
		 (<==? .OP RFALSE> #SENSE FALSE)
		 (.SENSE)>)>)>)>)>>

<DEFINE XEMIT (WHR WHAT)
	#DECL ((WHR) LOCAL (WHAT) <OR ATOM FIX>)
	<COND (<==? .WHR #LOCAL STACK>
	       <EMIT #INS PUSH
		     .WHAT>)
	      (<EMIT #INS SET
		     <CHTYPE .WHR ATOM>
		     ","
		     <COND (<TYPE? .WHAT FIX> .WHAT)
			   (<CHTYPE .WHAT LOCAL>)>>)>>

<SETG TMPS <REST '![?TMP4 ?TMP3 ?TMP2 ?TMP1 STACK!] 5>>

<GDECL (TMPS) <UVECTOR [REST ATOM]>>

<DEFINE TMPCHK (ITM "AUX" VARS TMPS) 
   #DECL ((ITM) LIST (VARS) FIX (TMPS) <UVECTOR [REST ATOM]>)
   <MAPR <>
    <FUNCTION (X "AUX" (Y <1 .X>)) 
	    <COND (<TYPE? .Y STRING>
		   <COND (<MEMQ <1 .ITM> '![PRINTI PRINTR!]>)
			 (T <PUT .X 1 <CHTYPE <PARSE <NXTSTR .Y>> LOCAL>>)>)
		  (<==? .Y T> <PUT .X 1 1>)
		  (<==? .Y '<>> <PUT .X 1 0>)>>
    .ITM>
   <SET VARS
	<MAPF ,+
	      <FUNCTION (ELEM) 
		      #DECL ((ELEM) ANY)
		      <COND (<OR <L/G? .ELEM> <NOT <TYPE? .ELEM FORM>>> 0)
			    (1)>>
	      .ITM>>
   <SET TMPS <BACK ,TMPS .VARS>>
   <MAPR <>
	 <FUNCTION (L
		    "AUX" (ELEM <1 .L>)
			  (TMP <CHTYPE <OR <EMPTY? .TMPS> <1 .TMPS>> LOCAL>))
		 #DECL ((L) LIST (ELEM) ANY (TMP) LOCAL)
		 <COND (<OR <L/G? .ELEM> <NOT <TYPE? .ELEM FORM>>>)
		       (T
			<PUT .L 1 <CHTYPE <GEN .ELEM .TMP> LOCAL>>
			<OR <==? .TMP #LOCAL STACK>
			    <MEMQ .TMP ,TEMPS>
			    <SETG TEMPS (.TMP !,TEMPS)>>
			<SET TMPS <REST .TMPS>>)>>
	 .ITM>>

<DEFINE L/G? (ELEM)
	#DECL ((ELEM) ANY)
	<AND <TYPE? .ELEM FORM>
	     <NOT <LENGTH? .ELEM 1>>
	     <MEMQ <1 .ELEM> '![LVAL GVAL]>>>

<DEFINE CONSTANT-CHECK (ATM "AUX" (SPN <SPNAME .ATM>)) 
	#DECL ((ATM) ATOM (SPN) STRING)
	<COND (<OR <LOOKUP .SPN ,OBJECTS>
		   <LOOKUP .SPN ,CONST>
		   <LOOKUP .SPN ,UCONST>
		   <LOOKUP .SPN ,VARS>>)
	      (<INFO "
 ** WARNING Unknown Argument: "
		     .ATM
		     " / Assuming CONSTANT for present.">
	       <CONSTANT .ATM 0>)>>

<DEFINE OPFCN (LST VAL "AUX" (OP <1 .LST>) (LEN <LENGTH .LST>) ATM TEMP) 
	#DECL ((LST) <PRIMTYPE LIST> (OP) <OR FIX ATOM> (ATM) <OR ATOM FALSE>
	       (VAL) <OR <PRIMTYPE ATOM> FALSE> (LEN) FIX
	       (TEMP) <LIST ANY ATOM ANY>)
	<COND (<AND <TYPE? .OP ATOM> <SET ATM <LOOKUP <SPNAME .OP> ,CNV>>>
	       <SET OP ,.ATM>
	       <PUT .LST 1 .OP>)>
	<COND (<TYPE? .OP FIX>
	       <COND (<==? .LEN 2> <SET LST (GET <2 .LST> .OP)>)
		     (<==? .LEN 3> <SET LST (PUT <2 .LST> .OP <3 .LST>)>)
		     (<COMPERR SYNTAX-ERROR!-ERRORS .LST>)>)
	      (<AND <MEMQ .OP '![GRTR? LESS?!]>
		    <NOT <LENGTH? .LST 2>>
		    <TYPE? <2 .LST> FORM>
		    <NOT <L/G? <2 .LST>>>
		    <NOT <LENGTH? <2 .LST> 2>>
		    <MEMQ <1 <2 .LST>> '![SET SETG!]>
		    <SET TEMP <OPFCN <3 <2 .LST>> <2 <2 .LST>>>>>
	       <COND (<==? .OP GRTR?>
		      <COND (<==? <2 .TEMP> INC>
			     <SET LST (IGRTR? <3 .TEMP> <3 .LST>)>)>)
		     (<==? .OP LESS?>
		      <COND (<==? <2 .TEMP> DEC>
			     <SET LST (DLESS? <3 .TEMP> <3 .LST>)>)>)>)
	      (<AND <==? .OP SUB> <==? .LEN 2>>
	       <SET LST (SUB 0 <2 .LST>)>)
	      (<AND <==? .OP ADD> <==? .LEN 2>>
	       <SET LST (ADD 1 <2 .LST>)>)
	      (<AND <MEMQ .OP '![ADD SUB!]>
		    <MEMQ 1 .LST>
		    <AND .VAL
			 <OR <MEMBER <FORM LVAL <CHTYPE .VAL ATOM>> .LST>
			     <MEMBER <FORM GVAL <CHTYPE .VAL ATOM>> .LST>>>>
	       <SET VAL <>>
	       <SET LST <INC/DEC .OP .LST>>)
	      (<AND <MEMQ .OP '![IGRTR? DLESS? INC DEC!]>
		    <NOT <LENGTH? .LST 1>>
		    <TYPE? <2 .LST> FORM>>
	       <INFO "
  ** WARNING Variable argument to " .OP ": " <2 .LST>>)
	      (<==? .OP 1?> <SET LST (EQUAL? <2 .LST> 1)>)
	      (<==? .OP L=?>
	       <SET LST (NOT <CHTYPE (GRTR? !<REST .LST>) FORM>)>)
	      (<==? .OP G=?>
	       <SET LST (NOT <CHTYPE (LESS? !<REST .LST>) FORM>)>)
	      (<==? .OP N==?>
	       <SET LST (NOT <CHTYPE (EQUAL? !<REST .LST>) FORM>)>)
	      (<AND <==? .OP EQUAL?> <==? .LEN 3> <==? <3 .LST> 0>>
	       <SET LST (ZERO? <2 .LST>)>)
	      (<AND <MEMQ .OP '![ADD SUB MUL DIV!]> <G? .LEN 3>>
	       <SET LST <CHTYPE <XARITH .OP <REST .LST>> LIST>>)
	      (<AND <MEMQ .OP '![FSET? FSET FCLEAR!]>
		    <NOT <LENGTH? .LST 2>>
		    <TYPE? <3 .LST> ATOM>>
	       <PUT .LST
		    3
		    <CHTYPE <PARSE <STRING "F?" <SPNAME <3 .LST>>>> LOCAL>>)
	      (<AND <MEMQ .OP '![GETP PUTP GETPT NEXTP!]>
		    <NOT <LENGTH? .LST 2>>
		    <TYPE? <3 .LST> ATOM>>
	       <PUT .LST
		    3
		    <CHTYPE <PARSE <STRING "P?" <SPNAME <3 .LST>>>> LOCAL>>)>
	(.VAL !.LST)>

<DEFINE INC/DEC (OP LST)
	#DECL ((OP) ATOM (LST) <<OR LIST FORM> [3 ANY]>)
	<LIST <COND (<==? .OP ADD> INC) (DEC)>
	      <2 <COND (<==? <2 .LST> 1> <3 .LST>)
		       (<2 .LST>)>>>>

<DEFINE XARITH (OP LST) 
	#DECL ((LST) LIST (OP) ATOM)
	<LIST PROG
	      <FORM .OP <1 .LST> <2 .LST>>
	      !<MAPF ,LIST
		     <FUNCTION (ANY) <FORM .OP <FORM LVAL STACK> .ANY>>
		     <REST .LST 2>>>>

<DEFINE PEEPH (LST OUTCHAN "AUX" (TZL ,TZL) (OPT 0) QL) 
   #DECL ((LST TZL) LIST (OUTCHAN) CHANNEL (OPT) FIX)
   <REPEAT ()
     <SET OPT 0>
     <REPEAT ((L .LST) (LL .LST) ITM M (NXT <>))
       #DECL ((L LL QL) LIST (ITM NXT) ANY (M) <OR FALSE LIST>)
       <COND
	(<EMPTY? <SET L <REST .L>>> <RETURN>)
	(<TYPE? <SET ITM <1 .L>> JUMP>
	 <COND
	  (<SET M
		<OR <MEMQ <CHTYPE .ITM LABEL> .L>
		    <MEMQ <CHTYPE .ITM RLABEL> .TZL>>>
	   <AND <NOT <LENGTH? .M 1>>
		<TYPE? <2 .M> LABEL>
		<MAPF <>
		      <FUNCTION (X) 
			      #DECL ((X) ANY)
			      <COND (<TYPE? .X LABEL>
				     <PUT .L 1 <CHTYPE .X JUMP>>
				     <SET OPT <+ .OPT 1>>)
				    (<MAPLEAVE>)>>
		      <REST .M>>>
	   <COND
	    (<=? <SET NXT
		      <1 <SET M
			      <MAPR <>
				    <FUNCTION (L "AUX" (N <1 .L>)) 
					    #DECL ((L) LIST (N) ANY)
					    <COND (<TYPE? .N LABEL>)
						  (<MAPLEAVE .L>)>>
				    .M>>>>
		 #INS JUMP>
	     <PUT .L 1 <2 .M>>
	     <SET OPT <+ .OPT 1>>)
	    (<AND <==? .NXT #INS RETURN> <NOT <TYPE? <1 .QL> SENSE>>>
	     <PUT .QL 1 .NXT>
	     <PUT .L 1 <2 .M>>)
	    (<OR <==? .NXT #INS RFALSE>
		 <AND <==? .NXT #INS RETURN> <MEMQ <2 .M> '[FALSE 0]>>>
	     <SET OPT <+ .OPT 1>>
	     <PUT .L 1 #JUMP FALSE>)
	    (<OR <==? .NXT #INS RTRUE>
		 <AND <==? .NXT #INS RETURN> <MEMQ <2 .M> '[T 1]>>>
	     <SET OPT <+ .OPT 1>>
	     <PUT .L 1 #JUMP TRUE>)>)
	  (<MEMQ .ITM '![#JUMP TRUE #JUMP FALSE!]>)
	  (<COMPERR INTERNAL-INCONSISTENCY!-ERRORS
		    LABEL-NOT-FOUND!-ERRORS
		    <2 .L>>)>
	 <SET LL <REST .LL>>)
	(<AND <SET QL .L>
	      <==? .ITM #INS JUMP>
	      <SET NXT <MEMQ <CHTYPE <2 .L> LABEL> .LST>>
	      <SET NXT <NXTN .NXT INS>>
	      <==? <1 .NXT> #INS RSTACK>>
	 <PUT .L 1 #INS RSTACK>
	 <PUT .L 2 "">
	 <SET LL <REST .LL>>
	 <SET OPT <+ .OPT 1>>)
	(<AND <TYPE? .ITM LABEL RLABEL> <NOT <MEMQ <CHTYPE .ITM JUMP> .LST>>>
	 <PUTREST .LL <REST .L>>
	 <SET OPT <+ .OPT 1>>)
	(T <SET LL <REST .LL>>)>>
     <REPEAT ((L <REST .LST>) (CR <>) XL ITM NXT LBL (CODLEN 0))
       #DECL ((L) LIST (CR) <OR ATOM FALSE> (XL) <OR LIST FALSE> (ITM NXT) ANY
	      (LBL) LABEL (CODLEN) FIX)
       <COND
	(<EMPTY? .L> <RETURN .CODLEN>)
	(<AND <==? <SET ITM <1 .L>> #INS JUMP>
	      <NOT <LENGTH? .L 1>>
	      <==? <2 .L> #JUMP TRUE>>
	 <PUT .L 1 #INS RTRUE>
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS JUMP>
	      <SET NXT <2 .L>>
	      <MAPF <>
		    <FUNCTION (X) 
			    <COND (<AND <NOT <TYPE? .X LABEL>> <N=? .X "">>
				   <MAPLEAVE <>>)
				  (<==? .X <CHTYPE .NXT LABEL>> <MAPLEAVE T>)>>
		    <MAPR <>
			  <FUNCTION (X) 
				  <COND (<TYPE? <1 .X> LABEL> <MAPLEAVE .X>)
					(<=? <1 .X> "">)
					(<MAPLEAVE <>>)>>
			  <REST .L 2>>>>
	 <PUT .L 1 "">
	 <PUT .L 2 "">)
	(<AND <==? .ITM #INS ZERO?> <NOT <TYPE? <3 .L> SENSE>>>
	 <PUT .L 1 "">
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS PUSH> <==? <2 .L> 0> <==? <3 .L> #INS RSTACK>>
	 <PUT .L 1 #INS RFALSE>
	 <PUT .L 2 "">
	 <PUT .L 3 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS PUSH> <==? <2 .L> 1> <==? <3 .L> #INS RSTACK>>
	 <PUT .L 1 #INS RTRUE>
	 <PUT .L 2 "">
	 <PUT .L 3 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS JUMP>
	      <NOT <LENGTH? .L 1>>
	      <==? <2 .L> #JUMP FALSE>>
	 <PUT .L 1 #INS RFALSE>
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS RETURN>
	      <NOT <LENGTH? .L 1>>
	      <MEMQ <SET NXT <2 .L>> '[T TRUE 1]>>
	 <PUT .L 1 #INS RTRUE>
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS ZERO?> <==? <3 .L> #INS JUMP>>
	 <PUT .L 1 "">
	 <PUT .L 2 #INS FSTACK>)
	(<AND <==? .ITM #INS RETURN>
	      <NOT <LENGTH? .L 1>>
	      <==? .NXT #LOCAL STACK>>
	 <PUT .L 1 #INS RSTACK>
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS JUMP>
	      <NOT <LENGTH? .L 2>>
	      <==? <SET NXT <2 .L>>
		   <CHTYPE <1 <NXTN <REST .L 2> LABEL>> JUMP>>>
	 <MAPR <>
	       <FUNCTION (LL) 
		       <COND (<==? <1 .LL> <CHTYPE .NXT LABEL>> <MAPLEAVE T>)
			     (<PUT .LL 1 "">)>>
	       .L>)
	(<AND <==? .ITM #INS RETURN>
	      <NOT <LENGTH? .L 1>>
	      <MEMQ .NXT '[FALSE 0 '<>]>>
	 <PUT .L 1 #INS RFALSE>
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<TYPE? .ITM SENSE>
	 <COND (<AND <NOT <LENGTH? .L 3>>
		     <MEMQ <SET NXT <2 .L>> '![#JUMP TRUE #JUMP FALSE!]>
		     <==? <3 .L> #INS JUMP>>
		<PUT .L 1 <ZNOT .ITM>>
		<PUT .L
		     2
		     <COND (<TYPE? <4 .L> ATOM> <CHTYPE <4 .L> JUMP>)
			   (<4 .L>)>>
		<PUT .L 3 "">
		<PUT .L
		     4
		     <COND (<==? .NXT #JUMP TRUE> #INS RTRUE) (#INS RFALSE)>>)
	       (<AND <NOT <LENGTH? .L 3>>
		     <OR <AND <MEMQ <1 <SET NXT <NXTN <REST .L 2> INS>>>
				    '![#INS RTRUE #INS RFALSE!]>
			      <SET NXT <1 .NXT>>>
			 <AND <==? <1 .NXT> #INS RETURN>
			      <MEMQ <2 .NXT> '[1 T]>
			      <SET NXT #INS RTRUE>>
			 <AND <==? <1 .NXT> #INS RETURN>
			      <MEMQ <2 .NXT> '[0 FALSE]>
			      <SET NXT #INS RFALSE>>
			 <AND <==? <1 .NXT> #INS JUMP>
			      <MEMQ <SET NXT <2 .NXT>>
				    '![#JUMP TRUE #JUMP FALSE!]>
			      <SET NXT
				   <AND <==? .NXT #JUMP TRUE> #INS RTRUE>>>>
		     <NOT <MEMQ <CHTYPE <2 .L> RLABEL> .TZL>>
		     <SET LBL <CHTYPE <2 .L> LABEL>>
		     <MAPF <>
			   <FUNCTION (ITM) 
				   <COND (<TYPE? .ITM LABEL>
					  <AND <==? .ITM .LBL> <MAPLEAVE T>>)
					 (<MAPLEAVE <>>)>>
			   <NXTN <REST .L 2> LABEL T>>>
		<PUT .L 1 <ZNOT .ITM>>
		<PUT .L
		     2
		     <COND (<==? .NXT #INS RTRUE> #JUMP TRUE) (#JUMP FALSE)>>
		<SET NXT <NXTN <REST .L 2> INS>>
		<COND (<MEMQ <1 .NXT> '![#INS RTRUE #INS RFALSE!]>
		       <PUT .NXT 1 "">)
		      (<PUT .NXT 1 ""> <PUT .NXT 2 "">)>)>)
	(<AND <==? .ITM #INS RTRUE> <NOT <LENGTH? .L 1>> <==? <2 .L> .ITM>>
	 <PUT .L 2 "">
	 <SET OPT <+ .OPT 1>>)
	(<AND <==? .ITM #INS PUSH> <==? <3 .L> #INS RSTACK>>
	 <PUT .L 1 #INS RETURN>
	 <PUT .L 3 "">)>
       <SET L <REST .L>>>
     <AND <0? .OPT> <RETURN>>>
   <COUT .LST>>

<SETG PRINTROPT 0>

<DEFINE PRINTR-OPT (LST)
	#DECL ((LST) LIST)
	<MAPR <>
	      <FUNCTION (L)
		   #DECL ((L) LIST)
		   <COND (<AND <==? <1 .L> #INS PRINTI>
			       <NOT <LENGTH? .L 4>>
			       <==? <3 .L> #INS CRLF>
			       <==? <4 .L> #INS RTRUE>>
			  <PUT .L 1 #INS PRINTR>
			  <PUT .L 3 "">
			  <PUT .L 4 "">
			  <SETG PRINTROPT <+ ,PRINTROPT 1>>)>>
	      .LST>>

<DEFINE COUT (LST "AUX" (OUTCHAN .ZCHN) HANDLE) 
   #DECL ((LST HANDLE) LIST (OUTCHAN) CHANNEL)
   <PRINTR-OPT .LST>
   <CRLF>
   <CRLF>
   <REPEAT ((L <REST .LST>) (CR <>) XL ITM (CODLEN 0) (LSTINS #INS NOOP)
	    (LSTLBL #LABEL ??) KLUDGE)
     #DECL ((L) LIST (CR) <OR ATOM FALSE> (XL) <OR LIST FALSE> (ITM) ANY
	    (CODLEN) FIX (LSTINS) INS (LSTLBL KLUDGE) <OR RLABEL LABEL>)
     <COND
      (<EMPTY? .L>
       <COND (<==? .ITM #JUMP FALSE>
	      <PRINC "
	RTRUE">)
	     (<==? .ITM #JUMP TRUE>
	      <PRINC "
	RFALSE">)>
       <RETURN .CODLEN>)
      (<=? <1 .L> "">)
      (<TYPE? <SET ITM <1 .L>> SENSE>
       <COND (<NOT <OPPRED ,<LOOKUP <SPNAME <CHTYPE .LSTINS ATOM>> ,OPS>>>
	      <INFO "
 ** WARNING - Non-predicate jump flushed "
		    <CHTYPE .LSTINS ATOM>>
	      <PUT .L 2 "">)
	     (<==? .ITM #SENSE TRUE> <PRINC " /">)
	     (<PRINC " \\">)>)
      (<AND <MEMQ .ITM '[#INS FIRST? #INS NEXT?]>
	    <COND (<=? <3 .L> " >">
		   <COND (<NOT <TYPE? <5 .L> SENSE>>
			  <SET KLUDGE <GENLBL "KLU">>
			  <SET HANDLE <REST .L 4>>
			  <PUTREST <REST .L 3>
				   <LIST #SENSE TRUE
					 <CHTYPE .KLUDGE JUMP>
					 .KLUDGE>>
			  <PUTREST <REST .L 6> .HANDLE>)>)
		  (<NOT <TYPE? <3 .L> SENSE>>
		   <SET KLUDGE <GENLBL "KLU">>
		   <SET HANDLE <REST .L 2>>
		   <PUTREST <REST .L>
			    <LIST #SENSE TRUE <CHTYPE .KLUDGE JUMP> .KLUDGE>>
		   <PUTREST <REST .L 4> .HANDLE>)>
	    <>>)
      (<TYPE? .ITM INS>
       <SET LSTINS .ITM>
       <COND (<NOT .CR> <CRLF> <PRINC "	">)>
       <SET CR <>>
       <PRIN1 <CHTYPE .ITM ATOM>>
       <PRINC "	">)
      (<TYPE? .ITM LABEL RLABEL>
       <COND (<==? .ITM .LSTLBL>)
	     (<OR <TYPE? .ITM RLABEL> <MEMQ <CHTYPE .ITM JUMP> ,TZL>>
	      <CRLF>
	      <SET CR T>
	      <PRIN1 <CHTYPE .ITM ATOM>>
	      <PRINC ":">
	      <PRINC "	">)>
       <SET LSTLBL .ITM>)
      (<OR <TYPE? .ITM LOCAL GLOBAL>
	   <AND <TYPE? .ITM ATOM>
		<OR <COND (<MEMQ .LSTINS '[#INS CALL #INS PUTP]>
			   <INFO 
"
 ** WARNING Atomic argument to routine assumed constant - "
				 .ITM>
			   T)>
		    <LOOKUP <SPNAME .ITM> ,OPS>
		    <LOOKUP <SPNAME .ITM> ,OBJECTS>>>
	   <SPECIAL-ATOM? .ITM>>
       <PRIN1 <CHTYPE .ITM ATOM>>)
      (<TYPE? .ITM JUMP CALL>
       <PRIN1 <CHTYPE .ITM ATOM>>)
      (<TYPE? .ITM RSTRING>
       <STRING-PRINT <CHTYPE .ITM STRING>>)
      (<TYPE? .ITM ATOM>
       <PRINC !\'>
       <PRINC .ITM>)
      (<PRINC .ITM>)>
     <COND (<AND <TYPE? .ITM INS>
		 <MEMQ .ITM
		       '![#INS RSTACK
			  #INS RTRUE
			  #INS RFALSE
			  #INS RETURN
			  #INS JUMP!
			  #INS PRINTR]>>
	    <COND (<==? .ITM #INS RETURN>
		   <COND (<==? <PRIMTYPE <2 .L>> ATOM>
			  <PRIN1 <CHTYPE <2 .L> ATOM>>)
			 (<PRIN1 <2 .L>>)>)
		  (<==? .ITM #INS PRINTR>
		   <STRING-PRINT <CHTYPE <2 .L> STRING>>
		   <PUT .L 2 "">)
		  (<==? .ITM #INS JUMP>
		   <PRIN1 <CHTYPE <2 .L> ATOM>>)>
	    <SET XL
		 <MAPR <>
		       <FUNCTION (LST) 
			       #DECL ((LST) LIST)
			       <COND (<TYPE? <1 .LST> LABEL> <MAPLEAVE .LST>)>>
		       .L>>
	    <SET L <OR .XL ()>>)
	   (<SET L <REST .L>>)>>>

<DEFINE STRING-PRINT (STR "AUX" (OUTCHAN .ZCHN))
	#DECL ((STR) STRING (OUTCHAN) CHANNEL)
	<PRINC "\"">
        <MAPR <>
	      <FUNCTION (S "AUX" (CHR <1 .S>)) 
		     #DECL ((S) STRING (CHR) CHARACTER)
		     <COND (<==? .CHR !\"> <PRINC .CHR>)
			   (<AND <==? .CHR !\.>
				 <NOT <LENGTH? .S 3>>
				 <==? <2 .S> !\ >
				 <==? <3 .S> !\ >>
			    <PUT .S 2 <ASCII 13>>)>
		     <COND (<==? .CHR <ASCII 13>>)
			   (<==? .CHR !\|>
			    <CRLF>
			    <OR <LENGTH? .S 2> <PUT .S 3 <ASCII 13>>>)
			   (<==? .CHR <ASCII 10>> <PRINC !\ >)
			   (T <PRINC .CHR>)>>
	      .STR>
        <PRINC "\"">>

<DEFINE SPECIAL-ATOM? (ITM "AUX" SPN)
	#DECL ((ITM) ANY (SPN) STRING)
	<AND <TYPE? .ITM ATOM>
	     <OR <MEMBER "PS?" <SET SPN <SPNAME .ITM>>>
		 <MEMBER "P1?" .SPN>
		 <MEMBER "W?" .SPN>>>>

<DEFINE NXTN (LST TYP "OPTIONAL" (DEL <>) "AUX" VAL) 
	#DECL ((LST) LIST (TYP) ATOM (DEL) <OR ATOM FALSE>
	       (VAL) <OR LIST FALSE>)
	<SET VAL
	     <MAPR <>
		   <FUNCTION (L "AUX" (ITM <1 .L>)) 
			   #DECL ((L) LIST (ITM) ANY)
			   <COND (<==? <TYPE .ITM> .TYP> <MAPLEAVE .L>)
				 (<AND .DEL
				       <OR <N==? .L .LST>
					   <NOT <MEMQ <1 .L>
						      '![#INS RFALSE
							 #INS RTRUE
							 #INS RSTACK!]>>>
				       <PUT .L 1 "">>)>>
		   .LST>>
	<OR .VAL '(T)>>

<DEFINE ZNOT (ITM) 
	#DECL ((ITM) <PRIMTYPE ATOM>)
	<COND (<==? <CHTYPE .ITM ATOM> FALSE> #SENSE TRUE) (#SENSE FALSE)>>

<SETG ERRS 0>

<GDECL (ERRS) FIX>

<DEFINE COMPERR ("TUPLE" T) 
	#DECL ((T) TUPLE (VALUE) 'T)
	<SETG ERRS <+ ,ERRS 1>>
	<INFO "

 ** Compilation error: " <1 .T>>
	<OR <LENGTH? .T 1>
	    <INFO "
    Relevant values: ">>
	<MAPF <> <FUNCTION (X) <INFO .X " ">> <REST .T>>
	<AND <ASSIGNED? ZNAM>
	     <INFO "
Compilation of " .ZNAM " aborted.">
	     <RETURN T .ZDEF>>
	T>
