<SET RECCHN ,OUTCHAN>
<SET ZCHN ,OUTCHAN>

<NEWTYPE NULL LIST>
<SETG NULL #NULL <>>

<DEFINE FILFIL (OUTCHAN)
	#DECL ((OUTCHAN) <SPECIAL CHANNEL>)
	;<PRINC ";\"==================================================\"">
	;<CRLF>
	<PRINC <ISTRING 1000>>>

<DEFINE AGC-HANDLER (SIZE WHAT)
	;<PRINT "DIVERT-AGC SIZE=">
	;<PRINC .SIZE>
	;<PRINC " WHAT=">
	;<PRINC .WHAT>
	;<CRLF>
	<BLOAT .SIZE>>

<DEFINE SETUP-EX ()
	<FLOAD "SORT MUD">
	<FLOAD "ZILCH MUD">
	<FLOAD "MACROS MUD">
	<SETG INSERT-CRUFTY T>
	<ON "DIVERT-AGC" ,AGC-HANDLER 1>>

<DEFINE SAVE-IT ("OPTIONAL"
	(FILE '("PUBLIC" "SAVE" "DSK" "GUEST"))
	"AUX" (SNM ""))
	<SETUP-EX>
	<COND (<=? "SAVED" <SAVE !.FILE>>
	       "Saved.")
	      (T
	       <ON "DIVERT-AGC" ,AGC-HANDLER 1>
	       ;<CRLF>
	       <PRINC "ZILCH ready.">
	       <CRLF>)>>

<SAVE-IT ("Z" "SAVE" "DSK" "Z2")>
