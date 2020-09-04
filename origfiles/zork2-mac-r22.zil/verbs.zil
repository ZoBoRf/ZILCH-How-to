"VERBS2 for
		      Zork: The Wizard of Frobozz
		 The Great Underground Empire (Part 2)
	(c) Copyright 1981 Infocom, Inc.  All Rights Reserved.
"

"SUBTITLE DESCRIBE THE UNIVERSE"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE <>>
<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSE T>
	 <SETG SUPER-BRIEF <>>
	 <TELL "Maximum verbosity." CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <TELL "Brief descriptions." CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <TELL "Super-brief descriptions." CR>>

\

"SUBTITLE DESCRIBERS"

;<ROUTINE V-RNAME ()
	 <TELL D ,HERE CR>>

;<ROUTINE V-OBJECTS ()
	 <DESCRIBE-OBJECTS T>>

;<ROUTINE V-ROOM ()
	 <DESCRIBE-ROOM T>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF> <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-EXAMINE ()
	 <COND (<GETP ,PRSO ,P?TEXT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,DOORBIT>>
		<V-LOOK-INSIDE>)
	       (ELSE
		<TELL "I see nothing special about the "
		      D ,PRSO "." CR>)>>

<GLOBAL LIT <>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR AV)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT ,LIT>
		<TELL
"It is pitch black.">
		<COND (<NOT ,SPRAYED?>
		       <TELL " You are likely to be eaten by a grue.">)>
		<CRLF>
		<RETURN <>>)>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)>
	 <COND (<IN? ,HERE ,ROOMS> <TELL D ,HERE CR>)>
	 <COND (<OR .LOOK? <NOT ,SUPER-BRIEF>>
		<SET AV <LOC ,WINNER>>
		<COND (<FSET? .AV ,VEHBIT>
		       <TELL "(You are in the " D .AV ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<AND <NOT <==? ,HERE .AV>> <FSET? .AV ,VEHBIT>>
		       <APPLY <GETP .AV ,P?ACTION> ,M-LOOK>)>)>
	 T>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
	 <COND (,LIT
		<COND (<FIRST? ,HERE>
		       <PRINT-CONT ,HERE <SET V? <OR .V? ,VERBOSE>> -1>)>)
	       (ELSE
		<TELL "I can't see anything in the dark." CR>)>>

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."

<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)
	       (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<TELL "There is a " D .OBJ " here.">)
	       (ELSE
		<TELL <GET ,INDENTS .LEVEL>>
		<TELL "A " D .OBJ>)>
	 <COND (<AND <==? .OBJ ,SPELL-VICTIM>
		     <==? ,SPELL-USED ,W?FLOAT>>
		<TELL " (floating in midair)">)>
	 <COND (<AND <0? .LEVEL>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>>
		<TELL " (outside the " D .AV ")">)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? AV STR (PV? <>) (INV? <>))
	 #DECL ((OBJ) OBJECT (LEVEL) FIX)
	 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RTRUE>)>
	 <COND (<AND <SET AV <LOC ,WINNER>> <FSET? .AV ,VEHBIT>>
		T)
	       (ELSE <SET AV <>>)>
	 <SET 1ST? T>
	 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
		<SET INV? T>)
	       (ELSE
		<REPEAT ()
			<COND (<NOT .Y> <RETURN <NOT .1ST?>>)
			      (<==? .Y .AV> <SET PV? T>)
			      (<==? .Y ,WINNER>)
			      (<AND <NOT <FSET? .Y ,INVISIBLE>>
				    <NOT <FSET? .Y ,TOUCHBIT>>
				    <SET STR <GETP .Y ,P?FDESC>>>
			       <COND (<NOT <FSET? .Y ,NDESCBIT>>
				      <TELL .STR CR>)>
			       <COND (<AND <SEE-INSIDE? .Y>
					   <NOT <GETP <LOC .Y> ,P?DESCFCN>>
					   <FIRST? .Y>>
				      <PRINT-CONT .Y .V? 0>)>)>
			<SET Y <NEXT? .Y>>>)>
	 <SET Y <FIRST? .OBJ>>
	 <REPEAT ()
		 <COND (<NOT .Y>
			<COND (<AND <0? .LEVEL>
				    <==? ,SPELL? ,S-FANTASIZE>
				    <PROB 20>>
			       <TELL "There is a "
				     <PICK-ONE ,FANTASIES>
				     " here." CR>
			       <SET 1ST? <>>)>
			<COND (<AND .PV? .AV <FIRST? .AV>>
			       <SET LEVEL <+ .LEVEL 1>>
			       <PRINT-CONT .AV .V? .LEVEL>)>
			<RETURN <NOT .1ST?>>)
		       (<EQUAL? .Y .AV ,ADVENTURER>)
		       (<AND <NOT <FSET? .Y ,INVISIBLE>>
			     <OR .INV?
				 <FSET? .Y ,TOUCHBIT>
				 <NOT <GETP .Y ,P?FDESC>>>>
			<COND (<NOT <FSET? .Y ,NDESCBIT>>
			       <COND (.1ST?
				      <COND (<FIRSTER .OBJ .LEVEL>
					     <COND (<L? .LEVEL 0>
						    <SET LEVEL 0>)>)>
				      <SET LEVEL <+ 1 .LEVEL>>
				      <SET 1ST? <>>)>
			       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
			      (<AND <FIRST? .Y> <SEE-INSIDE? .Y>>
			       <SET LEVEL <+ .LEVEL 1>>
			       <PRINT-CONT .Y .V? .LEVEL>)>)>
		 <SET Y <NEXT? .Y>>>>

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<==? .OBJ ,WINNER>
		<TELL "You are carrying:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL "Sitting on the " D .OBJ
			     " is:" CR>)
		      (ELSE
		       <TELL "The " D .OBJ
			     " contains:" CR>)>)>>

\

"SUBTITLE SCORING"

<GLOBAL MOVES 0>
<GLOBAL SCORE 0>
<GLOBAL BASE-SCORE 0>

<GLOBAL WON-FLAG <>>

<ROUTINE SCORE-UPD (NUM)
	 #DECL ((NUM) FIX)
	 <SETG BASE-SCORE <+ ,BASE-SCORE .NUM>>
	 <SETG SCORE <+ ,SCORE .NUM>>
	 T>

<ROUTINE SCORE-OBJ (OBJ "AUX" TEMP)
	 #DECL ((OBJ) OBJECT (TEMP) FIX)
	 <COND (<AND <FSET? .OBJ ,TREASURE>
		     <G? <SET TEMP <GETP .OBJ ,P?VALUE>> 0>>
		<SCORE-UPD .TEMP>
		<PUTP .OBJ ,P?VALUE 0>)>>

<GLOBAL SCORE-MAX 400>

<ROUTINE V-SCORE ("OPTIONAL" (ASK? T))
	 #DECL ((ASK?) <OR ATOM FALSE>)
	 <TELL "Your score ">
	 <COND (.ASK? <TELL "would be ">) (ELSE <TELL "is ">)>
	 <TELL N ,SCORE>
	 <TELL " (total of ">
	 <TELL N ,SCORE-MAX>
	 <TELL " points), in ">
	 <TELL N ,MOVES>
	 <COND (<1? ,MOVES> <TELL " move.">) (ELSE <TELL " moves.">)>
	 <CRLF>
	 <TELL "This score gives you the rank of ">
	 <COND (,WON-FLAG <TELL "Superior Adventurer">)
	       (<==? ,SCORE ,SCORE-MAX>
		<TELL
"Master Adventurer, but somehow you don't feel done">)
	       (<G? ,SCORE 360> <TELL "Wizard">)
	       (<G? ,SCORE 320> <TELL "Master">)
	       (<G? ,SCORE 240> <TELL "Adventurer">)
	       (<G? ,SCORE 160> <TELL "Junior Adventurer">)
	       (<G? ,SCORE 80> <TELL "Novice Adventurer">)
	       (<G? ,SCORE 40> <TELL "Amateur Adventurer">)
	       (T <TELL "Beginner">)>
	 <TELL "." CR>
	 ,SCORE>

<ROUTINE FINISH ()
	 <V-SCORE>
	 <QUIT>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR)
	 #DECL ((ASK?) <OR ATOM <PRIMTYPE LIST>> (SCOR) FIX)
	 <V-SCORE>
	 <COND (<OR <AND .ASK?
			 <TELL
"Do you wish to leave the game? (Y is affirmative): ">
			 <YES?>>
		    <NOT .ASK?>>
		<QUIT>)
	       (ELSE <TELL "Ok." CR>)>>

<ROUTINE YES? ()
	 <PRINTI ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<EQUAL? <GET ,P-LEXV 1> ,W?YES ,W?Y>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL COPYRIGHT-YEAR 1981>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	 <TELL 
"ZORK II: The Wizard of Frobozz|
Copyright " N ,COPYRIGHT-YEAR " by Infocom, Inc.|
All rights reserved.|">
	 <COND (<NOT <==? <BAND <GETB 0 1> 8> 0>>
		<TELL "Licensed to Tandy Corporation.|
">)>
	 <TELL "ZORK is a trademark of Infocom, Inc.|
Release ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <TELL " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>

<ROUTINE V-AGAIN ("AUX" OBJ)
	 <COND (<==? ,L-PRSA ,V?WALK>
		<PERFORM ,L-PRSA ,L-PRSO>)
	       (T
		<SET OBJ
		     <COND (<AND ,L-PRSO <NOT <LOC ,L-PRSO>>>
			    ,L-PRSO)
			   (<AND ,L-PRSI <NOT <LOC ,L-PRSI>>>
			    ,L-PRSI)>>
		<COND (.OBJ
		       <TELL "I can't see the " D .OBJ " anymore." CR>
		       <RFATAL>)
		      (T
		       <PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>)>>

\

"SUBTITLE DEATH AND TRANSFIGURATION"

<GLOBAL DEAD <>>
<GLOBAL DEATHS 0>
<GLOBAL LUCKY 1>

<ROUTINE JIGS-UP (DESC "OPTIONAL" (PLAYER? <>))
 	 #DECL ((DESC) STRING (PLAYER?) <OR ATOM FALSE>)
 	 <TELL .DESC CR>
	 <COND (<NOT <==? ,ADVENTURER ,WINNER>>
		<TELL "
|    ****  The " D ,WINNER " has died  ****
|
|">
		<REMOVE ,WINNER>
		<SETG WINNER ,ADVENTURER>
		<SETG HERE <LOC ,WINNER>>
		<RFATAL>)>
	 <PROG ()
	       <SCORE-UPD -10>
	       <TELL "
|    ****  You have died  ****
|
|">
	       <SETG DEAD T>
		 <SETG SPELL? <>>
		 <PUTP ,ADVENTURER ,P?ACTION 0>
		 <SETG DEATHS <+ ,DEATHS 1>>
		 <MOVE ,WINNER ,HERE>
		 <TELL
"Now, let's take a look here...
Well, you probably deserve another chance. I can't quite fix you
up completely, but you can't have everything." CR>
		 <FCLEAR ,DEAD-PALANTIR-1 ,TOUCHBIT>
		 <FCLEAR ,DEAD-PALANTIR-2 ,TOUCHBIT>
		 <FCLEAR ,DEAD-PALANTIR-3 ,TOUCHBIT>
		 <GOTO ,DEAD-PALANTIR-1>
		 <SETG P-CONT <>>
		 <RANDOMIZE-OBJECTS>
		 <KILL-INTERRUPTS>
		 <RFATAL>>>

<ROUTINE RANDOMIZE-OBJECTS ("AUX" (R <>) F N L)
	 <COND (<IN? ,LAMP ,WINNER>
		<MOVE ,LAMP ,INSIDE-BARROW>)>
	 <PUTP ,SWORD ,P?VALUE 0>
	 <SET N <FIRST? ,WINNER>>
	 <REPEAT ()
		 <SET F .N>
		 <COND (<NOT .F> <RETURN>)>
		 <SET N <NEXT? .F>>
		 <COND (<OR <==? .F ,GOLD-KEY>
			    <==? .F ,CANDY>
			    <==? .F ,PALANTIR-1>
			    <==? .F ,PALANTIR-2>
			    <==? .F ,PALANTIR-3>>
			<MOVE .F ,CAROUSEL-ROOM>)
		       (<FSET? .F ,TREASURE>
			<MOVE .F ,WIZARD-CASE>)
		       (ELSE
			<MOVE .F ,GAZEBO-ROOM>)>>>

<ROUTINE KILL-INTERRUPTS ()
	 <DISABLE <INT I-GNOME>>
	 <DISABLE <INT I-NERVOUS>>
	 <DISABLE <INT I-ZGNOME-OUT>>
	 <DISABLE <INT I-ZGNOME>>
	 <DISABLE <INT I-DRAGON>>
	 <RTRUE>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<TELL "Ok." CR>
		<V-FIRST-LOOK>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "Ok." CR>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE T>
	 <TELL "Do you wish to restart? (Y is affirmative): ">
	 <COND (<YES?>
		<TELL "Restarting." CR>
		<RESTART>
		<TELL "Failed." CR>)>>

<CONSTANT REXIT 0>
<CONSTANT UEXIT 1>
<CONSTANT NEXIT 2>
<CONSTANT FEXIT 3>
<CONSTANT CEXIT 4>
<CONSTANT DEXIT 5>

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 1>
<CONSTANT DEXITSTR 1>

<ROUTINE V-WALK-AROUND ()
	 <TELL "Use directions for movement here." CR>>

<ROUTINE V-LAUNCH ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<TELL "You can't launch that by saying \"launch\"!" CR>)
	       (T <TELL "How in blazes does one launch that?" CR>)>>

<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 #DECL ((TBL) TABLE (VAL) ANY)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<GOTO .VAL>)>>

<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 #DECL ((ITM) ANY (TBL) TABLE (CNT LEN) FIX)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<==? <GET .TBL .CNT> .ITM>
			<COND (<==? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 #DECL ((PT) <OR FALSE TABLE> (PTS) FIX (STR) <OR STRING FALSE>
		(OBJ) OBJECT (RM) <OR FALSE OBJECT>)
	 <COND (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "You can't go that way." CR>
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "The " D .OBJ " is closed." CR>
			      <SETG P-IT-OBJECT .OBJ>
			      <SETG P-IT-LOC ,HERE>
			      <RFATAL>)>)>)
	       (<AND <NOT ,LIT> <PROB 75>>
		<COND (,SPRAYED?
		       <TELL
"There are odd noises in the darkness, and there is no exit in that
direction." CR>
		       <RFATAL>)
		      (T
		       <JIGS-UP
"Oh, no! You have walked into the slavering fangs of a lurking grue!">)>)
	       (T
		<TELL "You can't go that way." CR>
		<RFATAL>)>>

<ROUTINE V-INVENTORY ()
	 <COND (<FIRST? ,WINNER> <PRINT-CONT ,WINNER>)
	       (T <TELL "You are empty handed." CR>)>>

<GLOBAL INDENTS
	<TABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

\

<ROUTINE PRE-TAKE ()
	 <COND (<IN? ,PRSO ,WINNER> <TELL "You already have it." CR>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "I can't reach that." CR>
		<RTRUE>)
	       (,PRSI
		<COND (<==? ,PRSI ,GROUND>
		       <SETG PRSI <>>
		       <RFALSE>)
		      (<NOT <==? ,PRSI <LOC ,PRSO>>>
		       <TELL "It's not in that!" CR>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<==? ,PRSO <LOC ,WINNER>> <TELL "You are in it, loser!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<TELL "Taken." CR>)>>

<GLOBAL FUMBLE-NUMBER 7>
<GLOBAL FUMBLE-PROB 8>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ)
	 #DECL ((VB) <OR ATOM FALSE> (CNT) FIX (OBJ) OBJECT)
	 <COND (,DEAD
		<TELL "Your hand passes through its object." CR>
		<RFALSE>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <TELL <PICK-ONE ,YUKS> CR>)>
		<RFALSE>)
	       (<AND <==? ,PRSO ,SPELL-VICTIM>
		     <EQUAL? ,SPELL-USED ,W?FLOAT ,W?FREEZE>>
		<COND (<==? ,SPELL-USED ,W?FLOAT>
		       <TELL
"You can't reach that. It's floating above your head." CR>)
		      (T
		       <TELL
"It seems rooted to the spot." CR>)>
		<RFALSE>)
	       (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
		<COND (.VB
		       <TELL "Your load is too heavy">
		       <COND (<L? ,LOAD-ALLOWED ,LOAD-MAX>
			      <TELL ", especially in light of your condition.">)
			     (ELSE <TELL ".">)>
		       <CRLF>)>
		<RFATAL>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>>
		<SET OBJ <FIRST? ,WINNER>>
		<SET OBJ <NEXT? .OBJ>>
		;"This must go!  Chomping compiler strikes again"
		<TELL "Oh, no. The " D .OBJ
		      " slips from your arms while taking the "
		      D ,PRSO "
and both tumble to the ground." CR>
		<PERFORM ,V?DROP .OBJ>
		<RFATAL>)
	       (T
		<MOVE ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<COND (<==? ,SPELL? ,S-FILCH>
		       <COND (<RIPOFF ,PRSO ,WIZARD-CASE>
			      <TELL
"When you touch the " D ,PRSO " it immediately disappears!" CR>
			      <RFALSE>)>)>
		<SCORE-OBJ ,PRSO>
		<RTRUE>)>>

<ROUTINE PRE-PUT ()
	 <COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <FSET? ,PRSO ,TAKEBIT>>>
		<TELL "Nice try." CR>)>>

<ROUTINE V-PUT ()
	 <COND (<OR <FSET? ,PRSI ,OPENBIT>
		    <OPENABLE? ,PRSI>
		    <FSET? ,PRSI ,VEHBIT>>)
	       (T
		<TELL "I can't do that." CR>
		<RTRUE>)>
	 <COND (<NOT <FSET? ,PRSI ,OPENBIT>>
		<TELL "The " D ,PRSI " isn't open." CR>)
	       (<==? ,PRSI ,PRSO>
		<TELL "How can you do that?" CR>)
	       (<IN? ,PRSO ,PRSI>
		<TELL "The " D ,PRSO " is already in the " D ,PRSI "." CR>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<SCORE-OBJ ,PRSO>
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>)>>

<ROUTINE PRE-DROP ()
	 <COND (<==? ,PRSO <LOC ,WINNER>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)>>

<ROUTINE PRE-GIVE ()
	 <COND (<NOT <HELD? ,PRSO>>
		<TELL 
"That's easy for you to say since you don't even have it." CR>)>>

<ROUTINE PRE-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-GIVE ()
	 <COND (<NOT <FSET? ,PRSI ,VICBIT>>
		<TELL "You can't give a " D ,PRSO " to a " D ,PRSI "!" CR>)
	       (<IDROP> <TELL "Given." CR>)>>

<ROUTINE V-SGIVE ()
	 <TELL "FOOOO!!" CR>>

<ROUTINE V-DROP () <COND (<IDROP> <TELL "Dropped." CR>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE IDROP
	 ()
	 <COND (<AND <NOT <IN? ,PRSO ,WINNER>> <NOT <IN? <LOC ,PRSO> ,WINNER>>>
		<TELL "You're not carrying the " D ,PRSO "." CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "The " D ,PRSO " is closed." CR>
		<RFALSE>)
	       (T <MOVE ,PRSO <LOC ,WINNER>> <RTRUE>)>>

\

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "You must tell me how to do that to a " D ,PRSO "." CR>)
	       (<NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>
		<COND (<FSET? ,PRSO ,OPENBIT> <TELL "It is already open." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <NOT <FIRST? ,PRSO>> <FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "The " D ,PRSO " opens." CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "Opening the " D ,PRSO " reveals ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <TELL "The " D ,PRSO " fails to open." CR>)>>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T))
	 #DECL ((OBJ) OBJECT (F N) <OR FALSE OBJECT>)
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST? <SET 1ST? <>>)
			      (ELSE
			       <TELL ", ">
			       <COND (<NOT .N> <TELL "and ">)>)>
			<TELL "a " D .F>
			<SET F .N>
			<COND (<NOT .F> <RETURN>)>>)>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "You must tell me how to do that to a " D ,PRSO "." CR>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "Closed." CR>)
		      (T <TELL "It is already closed." CR>)>)
	       (ELSE
		<TELL "You cannot close that." CR>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<SET CNT <+ .CNT 1>>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT
	 (OBJ "AUX" CONT (WT 0))
	 #DECL ((OBJ) OBJECT (CONT) <OR FALSE OBJECT> (WT) FIX)
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<SET WT <+ .WT <WEIGHT .CONT>>>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

<ROUTINE V-BUG ()
	 <TELL
"If there is a problem here, it is unintentional. You may report
your problem to the address provided in your documentation." CR>>

<GLOBAL COPR-NOTICE
" a transcript of interaction with ZORK II.|
ZORK is a trademark of Infocom, Inc.|
Copyright (c) 1981 Infocom, Inc.  All rights reserved.|">

<ROUTINE V-SCRIPT ()
	<PUT 0 8 <BOR <GET 0 8> 1>>
	<TELL "Here begins" ,COPR-NOTICE CR>>

<ROUTINE V-UNSCRIPT ()
	<TELL "Here ends" ,COPR-NOTICE CR>
	<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE PRE-MOVE
	 ()
	 <COND (<HELD? ,PRSO> <TELL "I don't juggle objects!" CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving the " D ,PRSO " reveals nothing." CR>)
	       (T <TELL "You can't move the " D ,PRSO "." CR>)>>

<ROUTINE V-LAMP-ON
	 ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<FSET? ,PRSO ,ONBIT> <TELL "It is already on." CR>)
		      (ELSE
		       <FSET ,PRSO ,ONBIT>
		       <TELL "The " D ,PRSO " is now on." CR>
		       <COND (<NOT ,LIT>
			      <SETG LIT <LIT? ,HERE>>
			      <V-LOOK>)>)>)
	       (T
		<TELL "You can't turn that on." CR>)>
	 <RTRUE>>

<ROUTINE V-LAMP-OFF
	 ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<NOT <FSET? ,PRSO ,ONBIT>>
		       <TELL "It is already off." CR>)
		      (ELSE
		       <FCLEAR ,PRSO ,ONBIT>
		       <COND (,LIT
			      <SETG LIT <LIT? ,HERE>>)>
		       <TELL "The " D ,PRSO " is now off." CR>
		       <COND (<NOT <SETG LIT <LIT? ,HERE>>>
			      <TELL "It is now pitch black." CR>)>)>)
	       (ELSE <TELL "You can't turn that off." CR>)>
	 <RTRUE>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 #DECL ((NUM) FIX)
	 <TELL "Time passes..." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<CLOCKER> <RETURN>)>
		 <SETG MOVES <+ ,MOVES 1>>>
	 <SETG CLOCK-WAIT T>>

<ROUTINE PRE-BOARD
	 ("AUX" AV)
	 <SET AV <LOC ,WINNER>>
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<COND (<NOT <IN? ,PRSO ,HERE>>
		       <TELL "The "
			     D
			     ,PRSO
			     " must be on the ground to be boarded." CR>)
		      (<FSET? .AV ,VEHBIT>
		       <TELL "You are already in the " D .AV ", cretin!" CR>)
		      (T <RFALSE>)>)
	       (T
		<TELL "I suppose you have a theory on boarding a "
		      D
		      ,PRSO
		      "." CR>)>
	 <RFATAL>>

<ROUTINE V-BOARD
	 ("AUX" AV)
	 #DECL ((AV) OBJECT)
	 <TELL "You are now in the " D ,PRSO "." CR>
	 <MOVE ,WINNER ,PRSO>
	 <APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	 <RTRUE>>

<ROUTINE V-DISEMBARK
	 ()
	 <COND (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL "You're not in that!" CR>
		<RFATAL>)
	       (<FSET? ,HERE ,RLANDBIT>
		<TELL "You are on your own feet again." CR>
		<MOVE ,WINNER ,HERE>)
	       (T
		<TELL
"You realize, just in time, that getting out here would probably be fatal." CR>
		<RFATAL>)>>

<ROUTINE V-BLAST ()
	 <TELL "You can't blast anything by using words." CR>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T)
	       "AUX" (LB <FSET? .RM ,RLANDBIT>) (WLOC <LOC ,WINNER>)
	             (AV <>) OLIT)
	 #DECL ((RM WLOC) OBJECT (LB) <OR ATOM FALSE> (AV) <OR FALSE FIX>)
	 <SET OLIT ,LIT>
	 <COND (<FSET? .WLOC ,VEHBIT>
		<SET AV <GETP .WLOC ,P?VTYPE>>)>
	 <COND (<OR <AND <NOT .LB> <OR <NOT .AV> <NOT <FSET? .RM .AV>>>>
		    <AND <FSET? ,HERE ,RLANDBIT>
			 .LB
			 .AV
			 <NOT <==? .AV ,RLANDBIT>>
			 <NOT <FSET? .RM .AV>>>>
		<COND (.AV <TELL "You can't go there in a " D .WLOC ".">)
		      (T <TELL "You can't go there without a vehicle.">)>
		<CRLF>
		<RFALSE>)
	       (<FSET? .RM ,RMUNGBIT> <TELL <GETP .RM ,P?LDESC> CR> <RFALSE>)
	       (T
		<COND (.AV <MOVE .WLOC .RM>)
		      (T
		       <MOVE ,WINNER .RM>)>
		<SETG HERE .RM>
		<SETG LIT <LIT? ,HERE>>
		<COND (<AND <NOT .OLIT>
			    <NOT ,LIT>
			    <PROB 75>>
		       <COND (,SPRAYED?
			      <TELL
"There are sinister gurgling noises in the darkness behind you!" CR>)
			     (ELSE
			      <JIGS-UP
"Oh, no! A lurking grue slithered into the room and devoured you!">
			      <RTRUE>)>)>
		<COND (<AND <NOT ,LIT> <==? ,WINNER ,ADVENTURER>>
		       <TELL
"You have moved into a dark place." CR>)>
		<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
		<SCORE-OBJ .RM>
		<COND (<NOT <==? ,ADVENTURER ,WINNER>>
		       <TELL "The " D ,WINNER " leaves the room." CR>)
		      (.V? <V-FIRST-LOOK>)>
		<RTRUE>)>>

<ROUTINE V-BACK
	 ()
	 <TELL
"Sorry, my memory isn't that good. You'll have to give a direction." CR>>

<ROUTINE PRE-POUR-ON
	 ()
	 <COND (<==? ,PRSO ,WATER> <RFALSE>)
	       (T <TELL "You can't pour that on anything." CR> <RTRUE>)>>

<ROUTINE V-POUR-ON
	 ()
	 <REMOVE ,PRSO>
	 <COND (<FLAMING? ,PRSI>
		<TELL "The " D ,PRSI " is extinguished." CR>
		<FCLEAR ,PRSI ,ONBIT>
		<FCLEAR ,PRSI ,FLAMEBIT>)
	       (T
		<TELL "The water spills over the "
		      D
		      ,PRSI
		      " and to the floor where it evaporates." CR>)>>

<ROUTINE V-SPRAY () <V-SQUEEZE>>
<ROUTINE V-SSPRAY () <PERFORM ,V?SPRAY ,PRSI ,PRSO>>

<ROUTINE V-SQUEEZE
	 ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<TELL "The " D ,PRSO " does not understand this.">)
	       (ELSE <TELL "How singularly useless.">)>
	 <CRLF>>

<ROUTINE PRE-OIL ()
	 <TELL "You probably put spinach in your gas tank, too." CR>>

<ROUTINE V-OIL () <TELL "That's not very useful." CR>>

<ROUTINE PRE-FILL
	 ("AUX" T)
	 #DECL ((T) <OR FALSE TABLE>)
	 <COND (<AND <NOT ,PRSI> <SET T <GETPT ,HERE ,P?GLOBAL>>>
		<COND (<ZMEMQB ,GLOBAL-WATER .T <PTSIZE .T>>
		       <SETG PRSI ,GLOBAL-WATER>
		       <RFALSE>)
		      (T
		       <TELL "There is nothing to fill it with." CR>
		       <RTRUE>)>)>
	 <COND (<NOT <EQUAL? ,PRSI ,WATER ,GLOBAL-WATER>>
		<PERFORM ,V?PUT ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE V-FILL ()
	 <COND (<NOT ,PRSI>
		<COND (<GLOBAL-IN? ,GLOBAL-WATER ,HERE>
		       <PERFORM ,V?FILL ,PRSO ,GLOBAL-WATER>)
		      (<IN? ,WATER <LOC ,WINNER>>
		       <PERFORM ,V?FILL ,PRSO ,WATER>)
		      (T
		       <TELL "There's nothing to fill it with." CR>)>)
	       (T <TELL "You may know how to do that, but I don't." CR>)>>

<ROUTINE V-ADVENT () <TELL "A hollow voice says \"Fool.\"" CR>>

<ROUTINE V-DRINK ()
	 <V-EAT>>

<ROUTINE V-EAT ("AUX" (EAT? <>) (DRINK? <>) (NOBJ <>))
	 #DECL ((NOBJ) <OR OBJECT FALSE> (EAT? DRINK?) <OR ATOM FALSE>)
	 <COND (<AND <SET EAT? <FSET? ,PRSO ,FOODBIT>> <IN? ,PRSO ,WINNER>>
		<COND (<VERB? DRINK> <TELL "How can I drink that?">)
		      (ELSE
		       <TELL "Thank you very much. It really hit the spot.">
		       <REMOVE ,PRSO>)>
		<CRLF>)
	       (<SET DRINK? <FSET? ,PRSO ,DRINKBIT>>
		<COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
			   <AND <SET NOBJ <LOC ,PRSO>>
				<IN? .NOBJ ,WINNER>
				<FSET? .NOBJ ,OPENBIT>>>
		       <TELL
"Thank you very much. I was rather thirsty (from all this talking,
probably)." CR>
		       <REMOVE ,PRSO>)
		      (T <TELL "I'd like to, but I can't get to it." CR>)>)
	       (<NOT <OR .EAT? .DRINK?>>
		<TELL "I don't think that the "
		      D
		      ,PRSO
		      " would agree with you." CR>)>>

<ROUTINE V-CURSES ()
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,VILLAIN>
		       <TELL "Insults of this nature won't help you." CR>)
		      (T
		       <TELL "What a loony!" CR>)>)
	       (T
		<TELL
"Such language in a high-class establishment like this!" CR>)>>

<ROUTINE V-LISTEN ()
	 <TELL "The " D ,PRSO " makes no sound." CR>>

<ROUTINE V-FOLLOW ()
	 <TELL "You're nuts!" CR>>

<ROUTINE V-PRAY ()
	 <TELL "If you pray enough, your prayers may be answered." CR>>

<ROUTINE V-LEAP
	 ("AUX" T S)
	 #DECL ((T) <OR FALSE TABLE>)
	 <COND (,PRSO
		<COND (<IN? ,PRSO ,HERE>
		       <COND (<FSET? ,PRSO ,VILLAIN>
			      <TELL "The "
				    D
				    ,PRSO
				    " is too big to jump over." CR>)
			     (T <V-SKIP>)>)
		      (T <TELL "That would be a good trick." CR>)>)
	       (<SET T <GETPT ,HERE ,P?DOWN>>
		<SET S <PTSIZE .T>>
		<COND (<OR <==? .S 2>					 ;NEXIT
			   <AND <==? .S 4>				 ;CEXIT
				<NOT <VALUE <GETB .T 1>>>>>
		       <TELL
"This was not a very safe place to try jumping." CR>
		       <JIGS-UP <PICK-ONE ,JUMPLOSS>>)
		      (T <V-SKIP>)>)
	       (ELSE <V-SKIP>)>>

<ROUTINE V-SKIP () <TELL <PICK-ONE ,WHEEEEE> CR>>

<ROUTINE V-LEAVE () <PERFORM ,V?WALK ,P?OUT>>

<GLOBAL HS 0>

<ROUTINE V-HELLO
	 ()
	 <COND (,PRSO
		<COND (<==? ,PRSO ,SAILOR>
		       <SETG HS <+ ,HS 1>>
		       <COND (<0? <MOD ,HS 20>>
			      <TELL "You seem to be repeating yourself." CR>)
			     (<0? <MOD ,HS 10>>
			      <TELL
"I think that phrase is getting a bit worn out." CR>)
			     (ELSE <TELL "Nothing happens here." CR>)>)
		      (<FSET? ,PRSO ,VILLAIN>
		       <TELL "The "
			     D
			     ,PRSO
			     " bows his head to you in greeting." CR>)
		      (ELSE
		       <TELL
"I think that only schizophrenics say \"Hello\" to a "
			     D
			     ,PRSO
			     "." CR>)>)
	       (ELSE <TELL <PICK-ONE ,HELLOS> CR>)>>

<GLOBAL HELLOS
	<LTABLE "Hello."
	       "Good day."
	       "Nice weather we've been having lately."
	       "Goodbye.">>

<GLOBAL WHEEEEE
	<LTABLE "Very good. Now you can go to the second grade."
	       "Have you tried hopping around the dungeon, too?"
	       "Are you enjoying yourself?"
	       "Wheeeeeeeeee!!!!!"
	       "Do you expect me to applaud?">>

<GLOBAL JUMPLOSS
	<LTABLE "You should have looked before you leaped."
	       "I'm afraid that leap was a bit much for your weak frame."
	       "In the movies, your life would be passing in front of your eyes."
	       "Geronimo.....">>

<ROUTINE PRE-READ ()
	 <COND (<NOT ,LIT> <TELL "It is impossible to read in the dark." CR>)
	       (<AND ,PRSI <NOT <FSET? ,PRSI ,TRANSBIT>>>
		<TELL "How does one look through a " D ,PRSI "?" CR>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>>
		<TELL "How can I read a " D ,PRSO "?" CR>)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-LOOK-UNDER () <TELL "There is nothing but dust there." CR>>

<ROUTINE V-LOOK-BEHIND () <TELL "There is nothing behind the " D ,PRSO "." CR>>

<ROUTINE V-LOOK-INSIDE
	 ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "The "
			     D
			     ,PRSO
			     " is open, but I can't tell what's beyond it.">)
		      (ELSE <TELL "The " D ,PRSO " is closed.">)>
		<CRLF>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<FSET? ,PRSO ,VICBIT>
		       <TELL "There is nothing special to be seen." CR>)
		      (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (<FSET? ,PRSO ,SURFACEBIT>
			      <TELL "There is nothing on the " D ,PRSO "." CR>)
			     (T
			      <TELL "The " D ,PRSO " is empty." CR>)>)
		      (ELSE <TELL "The " D ,PRSO " is closed." CR>)>)
	       (ELSE <TELL "I don't know how to look inside a " D ,PRSO "." CR>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT> <FSET? .OBJ ,OPENBIT>>>>

<ROUTINE V-REPENT () <TELL "It could very well be too late!" CR>>

<ROUTINE PRE-BURN ()
	 <COND (<FLAMING? ,PRSI> <RFALSE>)
	       (T <TELL "With a " D ,PRSI "??!?" CR>)>>

<ROUTINE V-BURN
	 ()
	 <COND (<==? <LOC ,PRSO> ,RECEPTACLE>
		<BALLOON-BURN>
		<RTRUE>)
	       (<FSET? ,PRSO ,BURNBIT>
		<COND (<IN? ,PRSO ,WINNER>
		       <REMOVE ,PRSO>
		       <TELL "The " D ,PRSO " catches fire." CR>
		       <JIGS-UP
"Unfortunately, you were holding it at the time.">)
		      (T
		       <REMOVE ,PRSO>
		       <TELL "The " D ,PRSO " catches fire and is consumed." CR>)
		      (ELSE <TELL "You don't have that." CR>)>)
	       (T <TELL "I don't think you can burn a " D ,PRSO "." CR>)>>

<ROUTINE PRE-TURN
	 ()
	 <COND (<NOT <FSET? ,PRSO ,TURNBIT>> <TELL "You can't turn that!" CR>)
	       (<NOT <FSET? ,PRSI ,TOOLBIT>>
		<TELL "You certainly can't turn it with a " D ,PRSI "." CR>)>>

<ROUTINE V-TURN () <TELL "This has no effect." CR>>

<ROUTINE V-PUMP ()
	 <TELL "I really don't see how." CR>>

<ROUTINE V-INFLATE () <TELL "How can you inflate that?" CR>>

<ROUTINE V-DEFLATE () <TELL "Come on, now!" CR>>

<ROUTINE V-LOCK () <TELL "It doesn't seem to work." CR>>

<ROUTINE V-PICK () <TELL "You can't pick that." CR>>

<ROUTINE V-UNLOCK () <TELL "It doesn't seem to work." CR>>

<ROUTINE V-CUT ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<PERFORM ,V?KILL ,PRSO ,PRSI>)
	       (<AND <FSET? ,PRSO ,BURNBIT>
		     <FSET? ,PRSI ,WEAPONBIT>>
		<REMOVE ,PRSO>
		<TELL "Your skillful "
		      D
		      ,PRSI
		      "smanship slices the "
		      D
		      ,PRSO
		      " into innumerable
slivers which evaporate instantaneously."
		      CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL
"I doubt that the \"cutting edge\" of a " D ,PRSI " is adequate." CR>)
	       (T
		<TELL "Strange concept, cutting the " D ,PRSO "...." CR>)>>

<ROUTINE V-KILL ()
	 <IKILL "kill">>

<ROUTINE IKILL (STR)
	 #DECL ((STR) STRING)
	 <COND (<NOT ,PRSO> <TELL "There is nothing here to " .STR "." CR>)
	       (<AND <NOT <FSET? ,PRSO ,VILLAIN>>
		     <NOT <FSET? ,PRSO ,VICBIT>>>
		<TELL "I've known strange people, but fighting a "
		      D
		      ,PRSO
		      "?" CR>)
	       (<OR <NOT ,PRSI> <==? ,PRSI ,HANDS>>
		<TELL "Trying to "
		      .STR
		      " a "
		      D
		      ,PRSO
		      " with your bare hands is suicidal." CR>)
	       (<NOT <IN? ,PRSI ,WINNER>>
		<TELL "You aren't even holding the " D ,PRSI "." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Trying to "
		      .STR
		      " the "
		      D
		      ,PRSO
		      " with a "
		      D
		      ,PRSI
		      " is suicidal." CR>)
	       (ELSE <TELL "You can't." CR>)>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE V-SWING ()
	 <COND (<NOT ,PRSI>
		<TELL "Whoosh!" CR>)
	       (T <PERFORM ,V?ATTACK ,PRSI ,PRSO>)>>

<ROUTINE V-KICK () <HACK-HACK "Kicking the ">>

<ROUTINE PRE-WAVE ()
	 <COND (<AND <==? ,PRSO ,WAND> <NOT <IN? ,WAND ,WINNER>>>
		<TELL "You don't have the wand!" CR>
		<RTRUE>)>>

<ROUTINE V-WAVE () <HACK-HACK "Waving the ">>

<ROUTINE V-RAISE () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-LOWER () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with the ">>

<ROUTINE V-PUSH () <HACK-HACK "Pushing the ">>

<ROUTINE PRE-MUNG ()
	 <COND (<NOT <FSET? ,PRSO ,VICBIT>>
		<HACK-HACK "Trying to destroy the ">)
	       (<NOT ,PRSI>
		<TELL "Trying to destroy the "
		      D
		      ,PRSO
		      " with your bare hands is suicidal." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Trying to destroy the "
		      D
		      ,PRSO
		      " with a "
		      D
		      ,PRSI
		      " is quite self-destructive." CR>)>>

<ROUTINE V-MUNG () <TELL "You can't." CR>>

<ROUTINE HACK-HACK
	 (STR)
	 #DECL ((STR) STRING)
	 <COND (<AND <IN? ,PRSO ,GLOBAL-OBJECTS> <VERB? WAVE RAISE LOWER>>
		<TELL "The " D ,PRSO " isn't here!" CR>)
	       (T <TELL .STR D ,PRSO <PICK-ONE ,HO-HUM> CR>)>>

<GLOBAL HO-HUM
	<LTABLE
	 " doesn't seem to work."
	 " isn't notably helpful."
	 " doesn't work."
	 " has no effect.">>

<ROUTINE WORD-TYPE
	 (OBJ WORD "AUX" SYNS)
	 #DECL ((OBJ) OBJECT (WORD SYNS) TABLE)
	 <ZMEMQ .WORD
		<SET SYNS <GETPT .OBJ ,P?SYNONYM>>
		<- </ <PTSIZE .SYNS> 2> 1>>>

<ROUTINE V-KNOCK
	 ()
	 <COND (<WORD-TYPE ,PRSO ,W?DOOR>
		<TELL "I don't think that anybody's home." CR>)
	       (ELSE <TELL "Why knock on a " D ,PRSO "?" CR>)>>

<ROUTINE V-CHOMP ()
	 <TELL "I don't know how to do that. I win in all cases!" CR>>

<ROUTINE V-FROBOZZ
	 ()
	 <TELL
"The FROBOZZ Corporation created, owns, and operates this dungeon." CR>>

<ROUTINE V-WIN () <TELL "Naturally!" CR>>

<ROUTINE V-YELL () <TELL "Aarrrrrgggggggghhhhhhhhhhh!" CR>>

<ROUTINE V-PLUG () <TELL "This has no effect." CR>>

<ROUTINE V-EXORCISE () <TELL "What a bizarre concept!" CR>>

\

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<TELL "This seems to have no effect." CR>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<TELL "You can't take it; thus, you can't shake it!" CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL "It sounds like there is something inside the "
		      D ,PRSO "." CR>)
	 (<AND <FSET? ,PRSO ,OPENBIT> <FIRST? ,PRSO>>
	  <REPEAT ()
		  <COND (<SET X <FIRST? ,PRSO>>
			 <MOVE .X
			       <COND (<OR <NOT <FSET? ,HERE ,RLANDBIT>>
					  <EQUAL? .X ,WATER>>
				      ,PSEUDO-OBJECT)
				     (T ,HERE)>>)
			(ELSE <RETURN>)>>
	  <COND (<NOT <FSET? ,HERE ,RLANDBIT>>
		 <TELL
"Its contents spill to the ground and disappear." CR>)
		(T <TELL "Its contents spill to the ground." CR>)>)>>

<ROUTINE PRE-DIG
	 ()
	 <COND (<NOT ,PRSI> <SETG PRSI ,HANDS>)>
	 <COND (<FSET? ,PRSI ,TOOLBIT>
		<TELL "Digging with the " D ,PRSI " is slow and tedious." CR>)
	       (ELSE
		<TELL "Digging with a " D ,PRSI " is silly." CR>)>>

<ROUTINE V-DIG () <TELL "What a silly idea!" CR>>

<ROUTINE V-SMELL () <TELL "It smells just like a " D ,PRSO "." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" T)
	 #DECL ((OBJ1 OBJ2) OBJECT (T) <OR FALSE TABLE>)
	 <COND (<SET T <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .T <- <PTSIZE .T> 1>>)>>

<ROUTINE V-SWIM ()
	 <TELL "Swimming isn't allowed in the ">
	 <COND (,PRSO
	        <TELL D ,PRSO>)
	       (T <TELL "dungeon">)>
	 <TELL "." CR>>

<ROUTINE PRE-UNTIE ()
	 <COND (<NOT <==? ,PRSO ,BRAIDED-WIRE>>
		<TELL "This cannot be tied, so it cannot be untied!" CR>)>>

<ROUTINE V-UNTIE () <TELL "Foo!" CR>>

<ROUTINE PRE-TIE
	 ()
	 <COND (<==? ,PRSI ,WINNER>
		<TELL "You can't tie it to yourself." CR>)>>

<ROUTINE V-TIE () <TELL "You can't tie the " D ,PRSO " to that." CR>>

<ROUTINE V-TIE-UP () <TELL "You could certainly never tie it with that!" CR>>

<ROUTINE V-MELT () <TELL "I'm not sure that a " D ,PRSO " can be melted." CR>>

<ROUTINE V-MUMBLE
	 ()
	 <TELL "You'll have to speak up if you expect me to hear you!" CR>>

<ROUTINE V-ALARM ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<TELL "He's wide awake, or haven't you noticed..." CR>)
	       (ELSE
		<TELL "The " D ,PRSO " isn't sleeping." CR>)>>

<ROUTINE V-ZORK () <TELL "At your service!" CR>>

\

<ROUTINE MUNG-ROOM (RM STR)
	 #DECL ((STR) STRING)
	 <FSET .RM ,RMUNGBIT>
	 <PUTP .RM ,P?LDESC .STR>>

<ROUTINE V-COMMAND ()
	 <COND (<FSET? ,PRSO ,VICBIT>
		<TELL "The " D ,PRSO " pays no attention." CR>)
	       (ELSE
		<TELL "You cannot talk to that!" CR>)>>

<ROUTINE V-CLIMB-ON ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<V-CLIMB-UP ,P?UP T>)
	       (T
		<TELL "You can't climb onto the " D ,PRSO "." CR>)>>

<ROUTINE V-CLIMB-FOO () <V-CLIMB-UP ,P?UP T>>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 #DECL ((DIR) FIX (OBJ) <OR ATOM FALSE> (X) TABLE)
	 <COND (<GETPT ,HERE .DIR>
		<PERFORM ,V?WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<TELL "You can't go that way." CR>)
	       (<AND .OBJ
		     <ZMEMQ ,W?WALL
			    <SET X <GETPT ,PRSO ,P?SYNONYM>> <PTSIZE .X>>>
		<TELL "Climbing the walls is to no avail." CR>)
	       (ELSE <TELL "Bizarre!" CR>)>>

<ROUTINE V-CLIMB-DOWN () <V-CLIMB-UP ,P?DOWN>>

<ROUTINE V-SEND ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<TELL "Why would you send for the " D ,PRSO "?" CR>)
	       (ELSE <TELL "That doesn't make sends." CR>)>>

<ROUTINE V-COUNT ("AUX" OBJS CNT)
    #DECL ((CNT) FIX)
    <COND (<==? ,PRSO ,BLESSINGS>
	   <TELL "Well, for one, you are playing ZORK...." CR>)
	  (T
	   <TELL "You have ">
	   <COND (<==? ,PRSO ,MATCH>
		  <SET CNT <- ,MATCH-COUNT 1>>
		  <TELL N .CNT " match">
		  <COND (<NOT <1? .CNT>> <TELL "es.">) (ELSE <TELL ".">)>
		  <CRLF>)
		 (ELSE <TELL "lost your mind." CR>)>)>>

<ROUTINE V-PUT-UNDER ()
    <COND (<AND <EQUAL? ,PRSO ,PLACE-MAT>
		<EQUAL? ,PRSI ,WIZ-DOOR>>	;"ADD MORE DOORS SOMEDAY"
	   <TELL "There's not enough room under this door." CR>)
	  (ELSE <TELL "You can't do that." CR>)>>

<ROUTINE V-PLAY ()
    <COND (<==? ,PRSO ,VIOLIN>
	   <COND (<FSET? ,PRSI ,WEAPONBIT>
		  <TELL "Very good. The violin is now worthless." CR>
		  <FCLEAR ,PRSO ,TREASURE>)
		 (T
		  <TELL "An amazingly offensive noise issues from the violin."
			CR>)>)
	  (T <TELL "That's silly!" CR>)>>

<ROUTINE V-MAKE ()
    	<COND (<==? ,PRSO ,WISH>
	       <COND (<AND <==? ,HERE ,WELL-BOTTOM>
			   <IN? ,COIN ,HERE>>
		      <TELL
"A whispering voice replies: \"Water makes the bucket go.\"
Unfortunately, wishing makes the coins go...." CR>
		      <REMOVE ,COIN>)
		     (T <TELL "No one is listening." CR>)>)
	      (ELSE <TELL "You can't do that." CR>)>>

<ROUTINE V-WISH ()
         <PERFORM ,V?MAKE ,WISH>>

<ROUTINE V-ENTER ()
	<PERFORM ,V?WALK ,P?IN>>

<ROUTINE V-EXIT ()
	 <PERFORM ,V?WALK ,P?OUT>>

<ROUTINE V-CROSS ()
	 <TELL "You can't cross that!" CR>>

<ROUTINE V-SEARCH ()
	 <TELL "You find nothing unusual." CR>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<EQUAL? ,PRSO ,HANDS>
		<TELL
"Within six feet of your head, assuming you haven't left that
somewhere." CR>)
	       (<==? ,PRSO ,ME>
		<TELL "You're around here somewhere..." CR>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<TELL "You find it." CR>)
	       (<IN? ,PRSO ,WINNER>
		<TELL "You have it." CR>)
	       (<OR <IN? ,PRSO ,HERE>
		    <==? ,PRSO ,PSEUDO-OBJECT>>
		<TELL "It's right here." CR>)
	       (<FSET? .L ,VILLAIN>
		<TELL "The " D .L " has it." CR>)
	       (<FSET? .L ,CONTBIT>
		<TELL "It's in the " D .L "." CR>)
	       (ELSE
		<TELL "Beats me." CR>)>>

<ROUTINE V-TELL ()
	 <COND (<OR <EQUAL? ,PRSO ,CERBERUS ,DRAGON ,UNICORN>
		    <EQUAL? ,PRSO ,PRINCESS ,GENIE ,WIZARD>
		    <EQUAL? ,PRSO ,ROBOT>>
		<SETG WINNER ,PRSO>)
	       (T
		<TELL "You can't talk to the " D ,PRSO "!" CR>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE V-ANSWER ()
	 <TELL "Nobody seems to be awaiting your answer." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <TELL "It is hardly likely that the " D ,PRSO " is interested." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-IS-IN ()
	 <COND (<IN? ,PRSO ,PRSI>
		<TELL "Yes, it is ">
		<COND (<FSET? ,PRSI ,SURFACEBIT>
		       <TELL "on">)
		      (T <TELL "in">)>
		<TELL " the " D ,PRSI "." CR>)
	       (T <TELL "No, it isn't." CR>)>>

<ROUTINE V-KISS ()
	 <TELL "I'd sooner kiss a pig." CR>>

<ROUTINE V-RAPE ()
	 <TELL "What a (ahem!) strange idea." CR>>

<ROUTINE V-DIAGNOSE ()
	 <COND (,DEAD <TELL "You are dead.">)
	       (<==? ,SPELL? ,S-FERMENT>
		<TELL "You are drunk.">)
	       (<==? ,SPELL? ,S-FEEBLE>
		<TELL "You seem unusually weak right now.">)
	       (<==? ,SPELL? ,S-FLOAT>
		<TELL "You seem somewhat light.">)
	       (<==? ,SPELL? ,S-FREEZE>
		<TELL "You are frozen stiff.">)
	       (ELSE <TELL "You are in perfect health.">)>
	 <CRLF>
	 <COND (<NOT <0? ,DEATHS>>
		<TELL "You have been killed ">
		<COND (<1? ,DEATHS> <TELL "once.">)
		      (T <TELL "twice.">)>
		<CRLF>)>>

<ROUTINE V-SAY ("AUX" V)
	 <COND (<OR ,SPELL-USED ,WAND-ON>
		<PERFORM ,V?INCANT>)
	       (<SET V <FIND-IN ,HERE ,VICBIT>>
		<TELL "You must address the " D .V " directly." CR>)
	       (ELSE
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<TELL
"Talking to yourself is said to be a sign of impending mental
collapse." CR>)>>

<ROUTINE V-INCANT ()
	 <COND (,SPELL-USED
		<TELL "Nothing happens." CR>)
	       (,WAND-ON
		<SETG SPELL-VICTIM ,WAND-ON>
		<SETG SPELL-USED <GET ,P-LEXV ,P-CONT>>
		<TELL "The wand glows very brightly for a moment." CR>
		<ENABLE <QUEUE I-SPELL <+ 10 <RANDOM 10>>>>
		<SETG WAND-ON <>>
		<PERFORM ,V?ENCHANT ,SPELL-VICTIM>)
	       (ELSE
		<TELL
"The incantation echoes back faintly, but nothing else happens." CR>)>
	 <SETG QUOTE-FLAG <>>
	 <SETG P-CONT <>>
	 <RTRUE>>

<ROUTINE V-ENCHANT ()
	 <COND (,WAND-ON <SETG SPELL-VICTIM ,WAND-ON>)>
	 <COND (,SPELL-VICTIM
		<COND (<NOT ,SPELL-USED>
		       <TELL "You must be more specific." CR>
		       <RTRUE>)>
		<COND (<OR <EQUAL? ,SPELL-USED ,W?FEEBLE ,W?FUMBLE ,W?FEAR>
			   <EQUAL? ,SPELL-USED ,W?FREEZE ,W?FALL ,W?FERMENT>
			   <EQUAL? ,SPELL-USED ,W?FIERCE ,W?FENCE ,W?FANTASIZE>>
		       <COND (<FSET? ,PRSO ,VILLAIN>
			      <TELL
"The wand stops glowing, but there is no other obvious effect." CR>)
			     (T
			      <TELL
"I suppose that did something, but I can't tell with a " D ,PRSO "." CR>)>)
		      ;(<EQUAL? ,SPELL-USED ,W?FIREPROOF>
		       <RTRUE>)
		      (<EQUAL? ,SPELL-USED ,W?FUDGE>
		       <TELL
"A strong odor of chocolate permeates the room." CR>)
		      (<==? ,SPELL-USED ,W?FLUORESCE>
		       <FSET ,PRSO ,LIGHTBIT>
		       <FSET ,PRSO ,ONBIT>
		       <SETG LIT T>
		       <TELL
"The " D ,PRSO " begins to glow." CR>)
		      (<==? ,SPELL-USED ,W?FILCH>
		       <SETG SPELL-HANDLED? T>
		       <COND (<FSET? ,PRSO ,TAKEBIT>
			      <MOVE ,PRSO ,WINNER>
			      <SCORE-OBJ ,PRSO>
			      <TELL "Filched!" CR>)
			     (ELSE
			      <TELL "You can't filch the " D ,PRSO "!" CR>)>)
		      (<AND <EQUAL? ,SPELL-USED ,W?FLOAT>
			    <FSET? ,PRSO ,TAKEBIT>>
		       <COND (<AND <==? ,SPELL-VICTIM ,COLLAR>
				   <IN? ,COLLAR ,CERBERUS>>
			      <SETG SPELL-VICTIM ,CERBERUS>)>
		       <TELL
"The " D ,PRSO " floats serenely in mid-air." CR>)
		      (<AND <EQUAL? ,SPELL-USED ,W?FRY>
			    <FSET? ,PRSO ,TAKEBIT>>
		       <SETG SPELL-HANDLED? T>
		       <REMOVE-CAREFULLY ,PRSO>
		       <TELL "The " D ,PRSO " goes up in a puff of smoke." CR>)
		      (ELSE
		       <SETG SPELL-VICTIM <>>
		       <TELL
"The wand stops glowing, but there is no other apparent effect." CR>)>)
	       (ELSE
		<SETG SPELL-VICTIM <>>
		<TELL "Nothing happens." CR>)>>

<ROUTINE V-DISENCHANT ()
	 <COND (<NOT <IN? ,PRSO ,HERE>> <RTRUE>)
	       (<OR <EQUAL? ,SPELL-USED ,W?FEEBLE ,W?FUMBLE ,W?FEAR>
		    <EQUAL? ,SPELL-USED ,W?FREEZE ,W?FALL ,W?FERMENT>
		    <EQUAL? ,SPELL-USED ,W?FIERCE ,W?FENCE ,W?FANTASIZE>>
		<COND (<FSET? ,PRSO ,VILLAIN>
		       <COND (<==? ,SPELL-USED ,W?FEEBLE>
			      <TELL
"The " D ,PRSO " seems stronger now." CR>)
			     (<==? ,SPELL-USED ,W?FUMBLE>
			      <TELL
"The " D ,PRSO " no longer appears clumsy." CR>)
			     (<==? ,SPELL-USED ,W?FEAR>
			      <TELL
"The " D ,PRSO " no longer appears afraid." CR>)
			     ;(<==? ,SPELL-USED ,W?FILCH>)
			     (<==? ,SPELL-USED ,W?FREEZE>
			      <TELL "The " D ,PRSO " moves again." CR>)
			     ;(<==? ,SPELL-USED ,W?FALL>)
			     (<==? ,SPELL-USED ,W?FERMENT>
			      <TELL
"The " D ,PRSO " stops swaying." CR>)
			     (<==? ,SPELL-USED ,W?FIERCE>
			      <TELL
"The " D ,PRSO " appears more peaceful." CR>)>)>)
	       (<==? ,SPELL-USED ,W?FLOAT>
		<TELL "The " D ,PRSO " sinks to the ground." CR>)
	       (<==? ,SPELL-USED ,W?FUDGE>
		<TELL "The sweet smell has dispersed." CR>)
	       ;(<==? ,SPELL-USED ,W?FIREPROOF>)
	       ;(<==? ,SPELL-USED ,W?FRY>)>>

<ROUTINE I-SPELL ()
	 <COND (<AND <NOT ,SPELL-HANDLED?> ,SPELL-VICTIM>
		<PERFORM ,V?DISENCHANT ,SPELL-VICTIM>)>
	 <SETG SPELL-HANDLED? <>>
	 <SETG WAND-ON <>>
	 <SETG SPELL-USED <>>
	 <SETG SPELL-VICTIM <>>>

<GLOBAL FANTASIES
	<LTABLE "pile of jewels" "gold ingot" "basilisk" "huge demon"
		"bulging chest" "yellow sphere" "silver sword" "grue"
		"convention of wizards" "copy of ZORK I">>

<ROUTINE V-$VERIFY ()
	 <TELL "Verifying game..." CR>
	 <COND (<VERIFY> <TELL "Game correct." CR>)
	       (T <TELL CR "** Game File Failure **" CR>)>>
