;<PACKAGE "SORTX">

;<RENTRY SORT>

<DEFINE SORTEX (PRED S1 "OPTIONAL" (L1 1) (OFFS 0) "TUPLE" T
	      "AUX" L NN S SS E EE (STR? <>) SN)
	 #DECL ((PRED) <OR FALSE APPLICABLE> (S1 S SS) ANY
		(E EE) ANY (STR?) <OR ATOM FALSE> (L1 L OFFS NN SN) FIX)
	 <PROG ()
	       <COND (<EMPTY? .S1>
		      <RETURN .S1>)>
	       <SET NN <+ .OFFS 1>>
	       <COND (<TYPE? .S1 VECTOR>
		      <SET E <NTH .S1 .NN>>
		      <SET S <REST .S1 0>>
		      <SET SS <REST .S .L1>>)
		     (<TYPE? .S1 UVECTOR>
		      <SET E <NTH .S1 .NN>>
		      <SET S <REST .S1 0>>
		      <SET SS <REST .S .L1>>)
		     (<TYPE? .S1 LIST>
		      <SET E <NTH .S1 .NN>>
		      <SET S <REST .S1 0>>
		      <SET SS <REST .S .L1>>)
		     (<TYPE? .S1 TUPLE>
		      <SET E <NTH .S1 .NN>>
		      <SET S <REST .S1 0>>
		      <SET SS <REST .S .L1>>)
		     (ELSE
		      <RETURN <ERROR BAD-SORT-RECORD!-ERRORS>>)>
	       <COND (<NOT <EMPTY? .T>>
		      <SET SN </ <LENGTH .S1> .L1>>
		      <REPEAT ((TT .T) X LX)
			      #DECL ((TT) TUPLE)
			      <COND (<EMPTY? .TT> <RETURN>)>
			      <SET X <1 .TT>>
			      <SET TT <REST .TT>>
			      <COND (<EMPTY? .TT> <SET L 1>)
				    (ELSE
				     <SET L <1 .TT>>
				     <SET TT <REST .TT>>)>
			      <COND (<AND <==? .SN </ <SET LX <LENGTH .X>> .L>>
					  <0? <MOD .LX .L>>>)
				    (ELSE 
				     <ERROR INCONSISTENT-SORT-RECORD!-ERRORS
					    .X>)>>)>
	       <COND (<TYPE? .E STRING> <SET STR? T>)
		     (<TYPE? .E ATOM> <SET STR? T>)>
	       <REPEAT ()
		       <COND (<COND (<TYPE? .SS VECTOR> <EMPTY? .SS>)
				    (<TYPE? .SS UVECTOR> <EMPTY? .SS>)
				    (<TYPE? .SS LIST> <EMPTY? .SS>)
				    (<TYPE? .SS TUPLE> <EMPTY? .SS>)>
			      <COND (<TYPE? .S VECTOR> <SET S <REST .S .L1>>)
				    (<TYPE? .S UVECTOR> <SET S <REST .S .L1>>)
				    (<TYPE? .S LIST> <SET S <REST .S .L1>>)
				    (<TYPE? .S TUPLE> <SET S <REST .S .L1>>)>
			      <COND (<LENGTH? .S .L1> <RETURN .S1>)
				    (<TYPE? .S VECTOR>
				     <SET E <NTH .S .NN>>
				     <SET SS <REST .S .L1>>)
				    (<TYPE? .S UVECTOR>
				     <SET E <NTH .S .NN>>
				     <SET SS <REST .S .L1>>)
				    (<TYPE? .S LIST>
				     <SET E <NTH .S .NN>>
				     <SET SS <REST .S .L1>>)
				    (<TYPE? .S TUPLE>
				     <SET E <NTH .S .NN>>
				     <SET SS <REST .S .L1>>)>)>
		       <COND (<TYPE? .S VECTOR>
			      <SET EE <NTH .SS .NN>>)
			     (<TYPE? .S UVECTOR>
			      <SET EE <NTH .SS .NN>>)
			     (<TYPE? .S LIST>
			      <SET EE <NTH .SS .NN>>)
			     (<TYPE? .S TUPLE>
			      <SET EE <NTH .SS .NN>>)>
		       <COND (<COND (.PRED <APPLY .PRED .E .EE>)
				    (.STR? <G? <SET L <STRCOMP .E .EE>> 0>)
				   (ELSE <G? .E .EE>)>
			     <SET E .EE>
			     <SWITCH .S .SS .L1>
		      <COND (<NOT <EMPTY? .T>>
			     <REPEAT ((TT .T) X)
				     #DECL ((TT) TUPLE)
				     <COND (<EMPTY? .TT> <RETURN>)>
				     <SET X <1 .TT>>
				     <SET TT <REST .TT>>
				     <COND (<EMPTY? .TT> <SET L 1>)
					   (ELSE
					    <SET L <1 .TT>>
					    <SET TT <REST .TT>>)>
				     <SWITCH <REST .X
						   <* .L
						      <- .SN
							 </ <LENGTH .S> .L1>>>>
					     <REST .X
						   <* .L
						      <- .SN
							 </ <LENGTH .SS> .L1>>>>
					     .L>>)>)>
		      <COND (<TYPE? .SS VECTOR>
			     <SET SS <REST .SS .L1>>)
			    (<TYPE? .SS UVECTOR>
			     <SET SS <REST .SS .L1>>)
			    (<TYPE? .SS LIST>
			     <SET SS <REST .SS .L1>>)
			    (<TYPE? .SS TUPLE>
			     <SET SS <REST .SS .L1>>)>>>>

<DEFINE SWITCH (S SS L)
	#DECL ((L) FIX)
	<COND (<AND <TYPE? .S VECTOR> <TYPE? .SS VECTOR>>
	       <MAPR <>
		     <FUNCTION (S SS "AUX" (TMP <1 .S>))
			  <PUT .S 1 <1 .SS>>
			  <PUT .SS 1 .TMP>
			  <COND (<0? <SET L <- .L 1>>>
				 <MAPLEAVE>)>>
		     .S .SS>)
	      (<AND <TYPE? .S UVECTOR> <TYPE? .SS UVECTOR>>
	       <MAPR <>
		     <FUNCTION (S SS "AUX" (TMP <1 .S>))
			  <PUT .S 1 <1 .SS>>
			  <PUT .SS 1 .TMP>
			  <COND (<0? <SET L <- .L 1>>>
				 <MAPLEAVE>)>>
		     .S .SS>)
	      (<AND <TYPE? .S LIST> <TYPE? .SS LIST>>
	       <MAPR <>
		     <FUNCTION (S SS "AUX" (TMP <1 .S>))
			  <PUT .S 1 <1 .SS>>
			  <PUT .SS 1 .TMP>
			  <COND (<0? <SET L <- .L 1>>>
				 <MAPLEAVE>)>>
		     .S .SS>)
	      (<AND <TYPE? .S TUPLE> <TYPE? .SS TUPLE>>
	       <MAPR <>
		     <FUNCTION (S SS "AUX" (TMP <1 .S>))
			  <PUT .S 1 <1 .SS>>
			  <PUT .SS 1 .TMP>
			  <COND (<0? <SET L <- .L 1>>>
				 <MAPLEAVE>)>>
		     .S .SS>)>>

;<ENDPACKAGE>
