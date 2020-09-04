<PACKAGE "TRACE">

<ENTRY TRACE UNTRACE TRACE-LIST TRACE-PRINTER
       IN-PRINT OUT-PRINT IN-BREAK OUT-BREAK
       TFUNCT TARGS TVALUE>

<USE "NEWSTRUC" "TTY">

<NEWSTRUC TAPPLICABLE LIST
	  TAPP <OR MSUBR FUNCTION>
	  TATOM ATOM
	  IN-PRINT ANY
	  OUT-PRINT ANY
	  IN-BREAK ANY
	  OUT-BREAK ANY
	  TPRINTER ATOM>

<SETG TRACE-PRINTER PRIN1>
<GDECL (TRACE-PRINTER) ATOM>

<DEFINE TRACE ("ARGS" ARGL)
	#DECL ((ARGL) LIST (A) ATOM (VAL) ANY (APP) TAPPLICABLE)
	<COND (<EMPTY? .ARGL> <>)
	      (<TYPE? <1 .ARGL> ATOM>
	       <TRACE-SPEC .ARGL>)
	      (ELSE
	       <MAPF <> ,TRACE-SPEC .ARGL>)>>

<DEFINE TRACE-SPEC (ARGL "AUX" A VAL APP (IP <>) (IB <>) (TEST T))
	#DECL ((ARGL) LIST (A) ATOM (VAL) ANY (APP) TAPPLICABLE)
	<REPEAT ()
		<SET TEST T>
		<COND (<EMPTY? .ARGL>
		       <COND (<OR .IP .IB <OUT-PRINT .APP> <OUT-BREAK .APP>>)
			     (ELSE
			      <IN-PRINT .APP T>
			      <OUT-PRINT .APP T>)>
		       <RETURN <COND (<ASSIGNED? APP> .APP)>>)
		      (<TYPE? <1 .ARGL> ATOM>
		       <SET A <1 .ARGL>>
		       <COND (<AND <NOT <EMPTY? <REST .ARGL>>>
				   <TYPE? <2 .ARGL> FORM LVAL GVAL>>
			      <SET TEST <2 .ARGL>>)>
		       <COND (<=? <SPNAME .A> "BOTH">
			      <COND (<ASSIGNED? APP> <OUT-PRINT .APP .TEST>)
				    (ELSE <SET IP .TEST>)>
			      <COND (<ASSIGNED? APP> <OUT-BREAK .APP .TEST>)
				    (ELSE <SET IB .TEST>)>)
			     (<=? <SPNAME .A> "PRINT">
			      <COND (<ASSIGNED? APP> <OUT-PRINT .APP .TEST>)
				    (ELSE <SET IP .TEST>)>)
			     (<=? <SPNAME .A> "BREAK">
			      <COND (<ASSIGNED? APP> <OUT-BREAK .APP .TEST>)
				    (ELSE <SET IB .TEST>)>)
			     (ELSE 
			      <COND (<GASSIGNED? .A>
				     <COND (<TYPE? <SET VAL ,.A> TAPPLICABLE>
					    <SET APP .VAL>
					    <IN-PRINT .APP .IP>
					    <IN-BREAK .APP .IB>
					    <OUT-PRINT .APP <>>
					    <OUT-BREAK .APP <>>
					    <TPRINTER .APP ,TRACE-PRINTER>
					    <SETG .A .APP>)
					   (<TYPE? .VAL MSUBR FUNCTION>
					    <UNTRACE .A>
					    <SETG .A
						  <SET APP
						       <CHTYPE
							<LIST .VAL
							      .A
							      .IP
							      <>
							      .IB
							      <>
							      ,TRACE-PRINTER>
							TAPPLICABLE>>>
					    <SETG TRACE-LIST
						  (.APP !,TRACE-LIST)>)
					   (ELSE
					    <ERROR CANT-TRACE!-ERRORS .A .VAL>
					    <RETURN <>>)>)
				    (ELSE
				     <ERROR NO-VALUE!-ERRORS .A>
				     <RETURN <>>)>)>)
		      (ELSE
		       <ERROR BAD-TRACE-SPECIFICATION!-ERRORS <1 .ARGL>>
		       <RETURN <>>)>
		<COND (<AND <NOT <EMPTY? <SET ARGL <REST .ARGL>>>>
			    <NOT <TYPE? <1 .ARGL> ATOM>>
			    <==? .TEST <1 .ARGL>>>
		       <SET ARGL <REST .ARGL>>)>>>

<DEFINE UNTRACE ("TUPLE" AA "AUX" A)
	#DECL ((A) ATOM)
	<COND (<EMPTY? .AA>
	       <MAPF <>
		     <FUNCTION (TA)
			       #DECL ((TA) TAPPLICABLE)
			       <SETG <TATOM .TA> <TAPP .TA>>
			       <DETRACE .TA>>
		     ,TRACE-LIST>
	       <SETG TRACE-LIST ()>)
	      (ELSE
	       <REPEAT ()
		       <COND (<EMPTY? .AA> <RETURN>)>
		       <COND (<GASSIGNED? <SET A <1 .AA>>>
			      <REPEAT ((TL ,TRACE-LIST))
				      #DECL ((TL) <LIST [REST TAPPLICABLE]>)
				      <COND (<EMPTY? .TL>
					     <COND (<TYPE? ,.A TAPPLICABLE>
						    <DETRACE ,.A>
						    <SETG .A <TAPP ,.A>>)>
					     <RETURN>)
					    (<==? .A <TATOM <1 .TL>>>
					     <COND (<TYPE? ,.A TAPPLICABLE>
						    <SETG .A <TAPP <1 .TL>>>)>
					     <DETRACE <1 .TL>>
					     <SETG TRACE-LIST <REST .TL>>
					     <RETURN>)
					    (<LENGTH? .TL 1> ;"not in list"
					     <COND (<TYPE? ,.A TAPPLICABLE>
						    <SETG .A <TAPP ,.A>>
						    <DETRACE ,.A>)>
					     <RETURN>)
					    (<==? .A <TATOM <2 .TL>>>
					     <COND (<TYPE? ,.A TAPPLICABLE>
						    <SETG .A <TAPP <2 .TL>>>)>
					     <DETRACE <2 .TL>>
					     <PUTREST .TL <REST .TL 2>>
					     <RETURN>)
					    (ELSE <SET TL <REST .TL>>)>>)>
		       <SET AA <REST .AA>>>)>>

<DEFINE DETRACE (TAPP)
	#DECL ((TAPP) TAPPLICABLE)
	<IN-PRINT .TAPP <>>
	<OUT-PRINT .TAPP <>>
	<IN-BREAK .TAPP <>>
	<OUT-BREAK .TAPP <>>>

<SETG TRACE-LEVEL 0>
<GDECL (TRACE-LEVEL) FIX>

<DEFINE TRACER (APP "TUPLE" ARGS
		"AUX" (TFUNCT <TAPP .APP>) (TARGS .ARGS) TVALUE
		(TR ,TRACE-LEVEL))
	#DECL ((APP) TAPPLICABLE (VAL) ANY
	       (TARGS) <SPECIAL TUPLE> (TFUNCT TVALUE) <SPECIAL ANY> (TR) FIX)
	<UNWIND <PROG ()
		      <COND (<EVAL <IN-PRINT .APP>>
			     <PROG LERR!-INTERRUPTS
				   ((RUN 0) (OUTCHAN ,DEBUG-CHANNEL))
				   #DECL ((OUTCHAN) <SPECIAL CHANNEL>
					  (LERR!-INTERRUPTS) <SPECIAL FRAME>)
				   <COND (<==? .RUN 0>
					  <SET RUN 1>
					  <CHANNEL-OP .OUTCHAN FRESH-LINE>
					  <AND <G? .TR 0> <INDENT-TO .TR>>
					  <PRINC "IN:  ">
					  <PRIN1 <TATOM .APP>>
					  <MAPF <>
						<FUNCTION (A)
						     <PRINC !\ >
						     <APPLY ,<TPRINTER .APP> .A>>
						.TARGS>)>>)>
		      <COND (<EVAL <IN-BREAK .APP>>
			     <PROG LERR!-INTERRUPTS ((OUTCHAN ,DEBUG-CHANNEL)
						     (RUN 0))
				   #DECL ((OUTCHAN) <SPECIAL CHANNEL>
					  (LERR!-INTERRUPTS) <SPECIAL FRAME>)
				   <COND (<==? .RUN 0>
					  <SET RUN 1>
					  <LISTEN IN-BREAK <TATOM .APP> .TARGS>)
					 (ELSE
					  <LISTEN IN-BREAK <TATOM .APP>>)>>)>
		      <SETG TRACE-LEVEL <+ .TR 1>>
		      <SET TVALUE <APPLY .TFUNCT !.TARGS>>
		      <SETG TRACE-LEVEL .TR>
		      <COND (<EVAL <OUT-PRINT .APP>>
			     <PROG LERR!-INTERRUPTS
				   ((RUN 0) (OUTCHAN ,DEBUG-CHANNEL))
				   #DECL ((OUTCHAN) <SPECIAL CHANNEL>
					  (LERR!-INTERRUPTS) <SPECIAL FRAME>)
				   <COND (<==? .RUN 0>
					  <SET RUN 1>
					  <CHANNEL-OP .OUTCHAN FRESH-LINE>
					  <AND <G? .TR 0> <INDENT-TO .TR>>
					  <PRINC "OUT: ">
					  <PRIN1 <TATOM .APP>>
					  <PRINC " => ">
					  <APPLY ,<TPRINTER .APP> .TVALUE>
					  <PRINC !\ >)>>)>
		      <COND (<EVAL <OUT-BREAK .APP>>
			     <PROG LERR!-INTERRUPTS ((OUTCHAN ,DEBUG-CHANNEL)
						     (RUN 0))
				   #DECL ((OUTCHAN) <SPECIAL CHANNEL>
					  (LERR!-INTERRUPTS) <SPECIAL FRAME>)
				   <COND (<==? .RUN 0>
					  <SET RUN 1>
					  <LISTEN OUT-BREAK <TATOM .APP> .TVALUE>)
					 (ELSE
					  <LISTEN OUT-BREAK <TATOM .APP>>)>>)>
		      .TVALUE>
		<SETG TRACE-LEVEL .TR>>>

<COND (<NOT <FEATURE? "COMPILER">> <APPLYTYPE TAPPLICABLE ,TRACER>)>

<SETG TRACE-LIST ()>
<GDECL (TRACE-LIST) <LIST [REST TAPPLICABLE]>>

<DEFINE TAPPLICABLE-PRINT (TAPP "OPTIONAL" (OUTCHAN .OUTCHAN))
	#DECL ((TAPP) TAPPLICABLE (OUTCHAN) CHANNEL)
	<PRINC "%<TRACE">
	<COND (<AND <TYPE? <IN-PRINT .TAPP> ATOM>
		    <TYPE? <OUT-PRINT .TAPP> ATOM>
		    <NOT <IN-BREAK .TAPP>>
		    <NOT <OUT-BREAK .TAPP>>>
	       <PRINC !\ >
	       <PRIN1 <TATOM .TAPP>>)
	      (ELSE
	       <COND (<IN-PRINT .TAPP>
		      <PRINC " PRINT">
		      <COND (<NOT <TYPE? <IN-PRINT .TAPP> ATOM>>
			     <PRINC !\ >
			     <PRIN1 <IN-PRINT .TAPP>>)>)>
	       <COND (<IN-BREAK .TAPP>
		      <PRINC " BREAK">
		      <COND (<NOT <TYPE? <IN-BREAK .TAPP> ATOM>>
			     <PRINC !\ >
			     <PRIN1 <IN-BREAK .TAPP>>)>)>
	       <PRINC !\ >
	       <PRIN1 <TATOM .TAPP>>
	       <COND (<OUT-PRINT .TAPP>
		      <PRINC " PRINT">
		      <COND (<NOT <TYPE? <OUT-PRINT .TAPP> ATOM>>
			     <PRINC !\ >
			     <PRIN1 <OUT-PRINT .TAPP>>)>)>
	       <COND (<OUT-BREAK .TAPP>
		      <PRINC " BREAK">
		      <COND (<NOT <TYPE? <OUT-BREAK .TAPP> ATOM>>
			     <PRINC !\ >
			     <PRIN1 <OUT-BREAK .TAPP>>)>)>)>
	<PRINC !\>>>

<COND (<NOT <FEATURE? "COMPILER">> <PRINTTYPE TAPPLICABLE ,TAPPLICABLE-PRINT>)>

<ENDPACKAGE>
