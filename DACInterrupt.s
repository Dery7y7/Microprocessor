#include <xc.inc>
    
extrn	LCD_Send_Byte_I,keypadread,keypadcheck,paral,parah,countingofcounting,tone
global	DAC_Setup, DAC_Int_Hisq, DAC_Int_Hitr,DAC_Int_Hisa,DAC_Int_Hinon,counting,isr

psect	udata_acs
delaycount:   ds	1
delaynum:     ds	1
counting:     ds	1

psect	dac_code, class=CODE
isr:
	movlw	0
	cpfsgt	tone
	goto	DAC_Int_Hisq
	movlw	2
	cpfsgt	tone
	goto	DAC_Int_Hitr
	movlw	4
	cpfsgt	tone
	goto	DAC_Int_Hisa
	
DAC_Int_Hisq:	
	
	btfss	TMR0IF	                                                                                                            	; check that this is timer0 interrupt
	retfie	f		; if not then return
	movff	parah,TMR0H
	movff	paral,TMR0L
	movlw	12
	cpfsgt	counting, A;if > 12 skip
	goto	possq
	movlw	23
	cpfsgt	counting, A;if > 24 skip
	goto	negsq
	clrf	counting;if finish one cycle, reset the couner and value(or the LATJ goes up)
	incf	countingofcounting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	
DAC_Int_Hitr:	
	btfss	TMR0IF	                                                                                                            	; check that this is timer0 interrupt
	retfie	f		; if not then return
	movff	parah,TMR0H
	movff	paral,TMR0L
	movlw	11
	cpfsgt	counting, A;if > 12 skip
	goto	increase
	movlw	23
	cpfsgt	counting, A;if > 24 skip
	goto	decrease
	clrf	counting;if finish one cycle, reset the couner and value(or the LATJ goes up)
	incf	countingofcounting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	
	
	
DAC_Int_Hisa:	
	btfss	TMR0IF	                                                                                                            	; check that this is timer0 interrupt
	retfie	f		; if not then return
	movff	parah,TMR0H
	movff	paral,TMR0L
	movlw	24
	cpfseq	counting, A
	goto	increase
	clrf	counting;if finish one cycle, reset the couner and value(or the LATJ goes up)
	incf	countingofcounting
	movlw	50
	movwf	LATJ
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
DAC_Int_Hinon:
	btfss	TMR0IF	                                                                                                            	; check that this is timer0 interrupt
	retfie	f		; if not then return
	clrf	LATJ
	incf	countingofcounting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt

increase:

	clrf	LATH	    ;WR set to low
	call	delayset    ;delay
	incf	LATJ	    ;operation
	incf	LATJ	    ;operation
	incf	LATJ	    ;operation
	call	delayset    ;delay
	movlw	3
	movwf	LATH	    ;WR reset to high
	incf	counting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
decrease:

	clrf	LATH	    ;WR set to low
	call	delayset    ;delay
	decf	LATJ	    ;operation
	decf	LATJ	    ;operation
	decf	LATJ	    ;operation
	call	delayset
	movlw	3
	movwf	LATH	    ;WR reset to high
	incf	counting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
	
possq:

	clrf	LATH	    ;WR set to low
	call	delayset    ;delay
	movlw	50
	movwf	LATJ	    ;operation
	call	delayset    ;delay
	movlw	3
	movwf	LATH	    ;WR reset to high
	incf	counting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt
negsq:

	clrf	LATH	    ;WR set to low
	call	delayset    ;delay
	movlw	0
	movwf	LATJ	    ;operation
	call	delayset
	movlw	3
	movwf	LATH	    ;WR reset to high
	incf	counting
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt




DAC_Setup:
	clrf	TRISJ, A	; Set PORTD as all outputs
	clrf	TRISH, A	; Set PORTD as all outputs
	clrf	LATJ, A		; Clear PORTD outputs
	clrf	LATH, A		; Clear PORTD outputs
	movlw	0
	movwf	counting
	movlw	10001000B	; Set timer0 to 16-bit, Fosc/4/256
	movwf	T0CON, A	; = 62.5KHz clock rate, approx 1sec rollover

	
	bsf	TMR0IE		; Enable timer0 interrupt
	bsf	GIE		; Enable all interrupts
	movlw	0
	clrf	delaycount, A
	return

delayset:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
 	nop
  	return
;delayset:
	;movlw	0x0A
	;movwf	delaycount
delay:	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	decf	delaycount, F,A
	bnz	delay
	return	
	
	end


