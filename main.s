#include <xc.inc>

extrn	DAC_Setup, DAC_Int_Hisq,DAC_Int_Hitr,DAC_Int_Hisa,DAC_Int_Hinon,isr ;Prepare the part needed
extrn	keypadread,counting,keypadsetup,keypadcheck,pracsetup,pracheck,keypressed
extrn	LCD_delay_x4us,LCD_Send_Byte_I,LCD_Send_Byte_D,LCD_Setup,LCD_delay_ms
global	countingofcounting,tone,loop1

psect	udata_acs   ; named variables in access ram
countingofcounting:	ds 1  
tone:			ds 1
    
psect	code, abs ;set up for code environment
	
	
rst:	org	0x0000	; reset vector
	goto	setup

int_hi:	org	0x0008	; high vector, no low vector
	movlw	'?'
	cpfseq	keypressed
	goto	isr
	goto	DAC_Int_Hinon

	
	

	
setup:	
	call	LCD_Setup
	call	pracsetup;load song
	call	DAC_Setup
	movlw   0
	movwf   tone
	clrf	TRISF, A	; Set tone display    
	clrf	LATF, A
	
start:	
	call	keypadsetup
loop:
	movlw	0
	movwf	countingofcounting
	call	keypadread
	call	keypadcheck
	call	pracheck
	goto	loop1
loop1:
	movlw	1   
	cpfseq	countingofcounting
	goto	loop1
	goto	loop
	
	; Sit in infinite loop
	
	end	rst
