#include <xc.inc>

global	freq,keypadsetup,coor,keypadcheck,keypadread,parah,paral,coorD,lowbitsD,keypressed,pracflag
extrn	LCD_Send_Byte_D,LCD_delay_ms,tone
    
psect	udata_acs
	
freq:   ds	1
highbits:   ds	1
lowbits:    ds	1
highbitsD:   ds	1
lowbitsD:    ds	1
delaycount: ds	1
coor:	    ds	1
coorD:	    ds	1    
parah:	    ds	1
paral:      ds  1
another:    ds	1
keypressed: ds  1
pracflag:   ds	1
    

psect	keypad_code, class=CODE


keypadsetup:
    movlb   15
    bsf	    REPU
    movlb   0
    clrf    LATE
    movlb   15
    bsf	    RDPU
    movlb   0
    clrf    LATD
keypadread:
    
firstread:
    movlw   0x0f
    movwf   TRISE
    movwf   TRISD
    call    delayset
    movff   PORTE, lowbits
    movff   PORTD, lowbitsD
    

secondread:
    movlw   0xf0
    movwf   TRISE
    movwf   TRISD
    call    delayset
    movff   PORTE, highbits
    movff   PORTD, highbitsD
    

combine:
    movf    highbits, W,A
    addwf   lowbits,W,A
    movwf   coor
    movf    highbitsD, W,A
    addwf   lowbitsD,W,A
    movwf   coorD
    return
    
keypadcheck:

checkAOBCnon:
    movlw	11111111B
    cpfseq	coor
    goto	check1
    goto	check12nd
    return
check1:
    movlw	01110111B
    cpfseq	coor
    goto	check2
    movlw	0xF6
    movwf	parah
    movlw	0x71
    movwf	paral
    movlw	'1'	
    movwf	keypressed
    return
check2:
    movlw	10110111B
    cpfseq	coor
    goto	check3
    movlw	0xF6
    movwf	parah
    movlw	0xFA
    movwf	paral
    movlw	'2'
    movwf	keypressed
    return
check3:
    movlw	11010111B
    cpfseq	coor
    goto	checkF
    movlw	0xF7
    movwf	parah
    movlw	0x7C
    movwf	paral
    movlw	'3'
    movwf	keypressed
    return
checkF:
    movlw	11100111B
    cpfseq	coor
    goto	check4
    movlw	0xF7
    movwf	parah
    movlw	0xF6
    movwf	paral
    movlw	'F'
    movwf	keypressed
    return
check4:
    movlw	01111011B
    cpfseq	coor
    goto	check5
    movlw	0xF8
    movwf	parah
    movlw	0x69
    movwf	paral
    movlw	'4'
    movwf	keypressed
    return
check5:
    movlw	10111011B
    cpfseq	coor
    goto	check6
    movlw	0xF8
    movwf	parah
    movlw	0xD6
    movwf	paral
    movlw	'5'
    movwf	keypressed
    return
check6:
    movlw	11011011B
    cpfseq	coor
    goto	checkE
    movlw	0xF9
    movwf	parah
    movlw	0x3D
    movwf	paral
    movlw	'6'
    movwf	keypressed
    return
checkE:
    movlw	11101011B
    cpfseq	coor
    goto	check7
    movlw	0xF9
    movwf	parah
    movlw	0x9E
    movwf	paral
    movlw	'E'
    movwf	keypressed
    return
check7:
    movlw	01111101B
    cpfseq	coor
    goto	check8
    movlw	0xF9
    movwf	parah
    movlw	0xFA
    movwf	paral
    movlw	'7'
    movwf	keypressed
    return
check8:
    movlw	10111101B
    cpfseq	coor
    goto	check9
    movlw	0xFA
    movwf	parah
    movlw	0x50
    movwf	paral
    movlw	'8'
    movwf	keypressed
    return
check9:
    movlw	11011101B
    cpfseq	coor
    goto	checkD
    movlw	0xFA
    movwf	parah
    movlw	0xA2
    movwf	paral
    movlw	'9'
    movwf	keypressed
    return
checkD:
    movlw	11101101B
    cpfseq	coor
    goto	checkfunction1
    movlw	0xFA
    movwf	parah
    movlw	0xEF
    movwf	paral
    movlw	'D'
    movwf	keypressed
    return
checkfunction1:
    movlw	01111110B
    cpfseq	coor
    goto	checkfunction2
    movlw	4
    cpfslt	tone
    goto	operation1
    goto	operation2
operation1:
    clrf	tone
    goto	rest
operation2:
    incf	tone
    incf	tone
    goto	rest
rest:
    movff	tone,LATF
    return
checkfunction2:
    movlw	10111110B
    cpfseq	coor
    goto	check12nd
    movlw	1
    cpfslt	pracflag
    goto	resetflag
    movwf	pracflag
    return
    
resetflag:
    clrf    pracflag
    return
    
    return	
check12nd:
    movlw	01110111B
    cpfseq	coorD
    goto	check22nd
    movlw	0xFB
    movwf	parah
    movlw	0x4A
    movwf	paral
    ;movlw	'C'	
    movwf	keypressed
    return
check22nd:
    movlw	10110111B
    cpfseq	coorD
    goto	check32nd
    movlw	0xFB
    movwf	parah
    movlw	0x89
    movwf	paral
    ;movlw	'C'
    movwf	keypressed
    return
check32nd:
    movlw	11010111B
    cpfseq	coorD
    goto	checkF2nd
    movlw	0xFB
    movwf	parah
    movlw	0xCD
    movwf	paral
    ;movlw	'D'
    movwf	keypressed
    return
checkF2nd:
    movlw	11100111B
    cpfseq	coorD
    goto	check42nd
    movlw	0xFC
    movwf	parah
    movlw	0x09
    movwf	paral
    ;movlw	'D'
    movwf	keypressed
    return
check42nd:
    movlw	01111011B
    cpfseq	coorD
    goto	check52nd
    movlw	0xFC
    movwf	parah
    movlw	0x43
    movwf	paral
    ;movlw	'E'
    movwf	keypressed
    return
check52nd:
    movlw	10111011B
    cpfseq	coorD
    goto	check62nd
    movlw	0xFC
    movwf	parah
    movlw	0x7A
    movwf	paral
    ;movlw	'F'
    movwf	keypressed
    return
check62nd:
    movlw	11011011B
    cpfseq	coorD
    goto	checkE2nd
    movlw	0xFC
    movwf	parah
    movlw	0xAC
    movwf	paral
    ;movlw	'F'
    movwf	keypressed
    return
checkE2nd:
    movlw	11101011B
    cpfseq	coorD
    goto	check72nd
    movlw	0xFC
    movwf	parah
    movlw	0xDD
    movwf	paral
    ;movlw	'G'
    movwf	keypressed
    return
check72nd:
    movlw	01111101B
    cpfseq	coorD
    goto	check82nd
    movlw	0xFD
    movwf	parah
    movlw	0x0A
    movwf	paral
    ;movlw	'G'
    movwf	keypressed
    return
check82nd:
    movlw	10111101B
    cpfseq	coorD
    goto	check92nd
    movlw	0xFD
    movwf	parah
    movlw	0x38
    movwf	paral
    ;movlw	'A'
    movwf	keypressed
    return
check92nd:
    movlw	11011101B
    cpfseq	coorD
    goto	checkD2nd
    movlw	0xFD
    movwf	parah
    movlw	0x5F
    movwf	paral
    ;movlw	'A'
    movwf	keypressed
    return
checkD2nd:
    movlw	11101101B
    cpfseq	coorD
    goto	checkAOBCnon2nd
    movlw	0xFD
    movwf	parah
    movlw	0x86
    movwf	paral
    ;movlw	'B'
    movwf	keypressed
    return
checkAOBCnon2nd:
    movlw	11111111B
    cpfseq	coorD
    nop
    movlw	0x00
    movwf	parah
    movlw	0x00
    movwf	paral
    movlw	'?'	
    movwf	keypressed
    return

    

delayset:
	movlw	0xA0
	movwf	delaycount
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
