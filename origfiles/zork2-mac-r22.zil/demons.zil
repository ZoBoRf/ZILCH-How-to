

"SWORD demon"

<ROUTINE I-SWORD ("AUX" (DEM <INT I-SWORD>) (G <GETP ,SWORD ,P?VALUE>)
		        (NG 0) P T L)
	 #DECL ((NG G) FIX)
	 <COND (<IN? ,SWORD ,ADVENTURER>
		<COND (<==? ,SPELL? ,S-FIERCE> <SET NG 3>)
		      (<INFESTED? ,HERE> <SET NG 2>)
		      (ELSE
		       <SET P 0>
		       <REPEAT ()
			       <COND (<0? <SET P <NEXTP ,HERE .P>>>
				      <RETURN>)
				     (<NOT <L? .P ,LOW-DIRECTION>>
				      <SET T <GETPT ,HERE .P>>
				      <SET L <PTSIZE .T>>
				      <COND (<EQUAL? .L ,UEXIT ,CEXIT ,DEXIT>
					     <COND (<INFESTED? <GETB .T 0>>
						    <SET NG 1>
						    <RETURN>)>)>)>>)>
		<COND (<==? .NG .G> <RFALSE>)
		      (<==? .NG 3>
		       <TELL "Your sword is glowing with a dull red glow." CR>)
		      (<==? .NG 2>
		       <TELL "Your sword has begun to glow very brightly." CR>)
		      (<1? .NG>
		       <TELL "Your sword is glowing with a faint blue glow."
			     CR>)
		      (<0? .NG>
		       <TELL "Your sword is no longer glowing." CR>)>
		<PUTP ,SWORD ,P?VALUE .NG>
		<RTRUE>)
	       (ELSE <PUT .DEM ,C-ENABLED? 0> <RFALSE>)>>

<ROUTINE INFESTED? (R "AUX" (F <FIRST? .R>)) 
	 <REPEAT ()
		 <COND (<NOT .F> <RETURN <>>)
		       (<AND <FSET? .F ,VILLAIN> <NOT <FSET? .F ,INVISIBLE>>>
			<RETURN .F>)
		       (<NOT <SET F <NEXT? .F>>> <RETURN <>>)>>>
