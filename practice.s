#include <xc.inc>

global	Table,currentnote,pracsetup,pracheck,index,true
extrn	LCD_Send_Byte_D,LCD_Setup,loop1,keypressed,pracflag,LCD_Send_Byte_I,LCD_delay_ms
    
psect	udata_acs
	
index:   ds	1
currentnote:   ds	1
true:		ds  1
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
    
psect	data 
	
Table:
	db	'1','1','E','E','8','8','E',0x0a
	
	myTable_1	    EQU	    7
	align	2
	
psect	pracode,class=CODE
pracsetup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory	
	movlw	low highword(Table)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(Table)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(Table)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	clrf	index
	clrf	pracflag
	clrf	true
	return
	
pracheck:
	movlw	1
	cpfseq	pracflag
	goto	flagoff
	goto	flagon
flagon:

	return
flagoff:

	cpfseq	true
	goto	false
	goto	pracloop
	return
	
false:	
	movlw	0
	cpfseq	index
	goto	loopifnot
	goto	pracloop
	
pracloop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movlw	7
	cpfslt	index
	goto	songcompleted
	incf	index
loopifnot:
	movlw	00000001B	; display clear
	call	LCD_Send_Byte_I
	movlw	2		; wait 2ms
	call	LCD_delay_ms
	movf	TABLAT, W; move data from TABLAT to (FSR0), inc FSR0
	movwf	currentnote
	call	LCD_Send_Byte_D
	movf	currentnote,W
	cpfseq	keypressed
	goto	wrong;read new key
	goto	correct;load new note

	return

wrong:
	clrf	true
	return
correct:
	movlw	1
	movwf	true
	return
songcompleted:
    	movlw	00000001B	; display clear
	call	LCD_Send_Byte_I
	goto	pracsetup


