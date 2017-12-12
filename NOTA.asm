IDEAL
MODEL small
STACK 0f500h
p186
MAX_BMP_WIDTH = 320 
MAX_BMP_HEIGHT = 200  
SMALL_BMP_HEIGHT = 40 
SMALL_BMP_WIDTH = 40
;----------------------------------------------------------------------
DATASEG

OneBmpLine 	db MAX_BMP_WIDTH dup (0)  			;One Color line read buffer
ScreenLineMax 	db MAX_BMP_WIDTH dup (0)  		;One Color line read buffer

;BMP File data
FileHandle	dw ?
Header 	    db 54 dup(0)
Palette 	db 400h dup (0)

note1 		dw 023A1h 							; 1193180 / -> (hex) do
note2 		dw 01FBEh 							; 1193180 / -> (hex) re
note3 		dw 01C47h 							; 1193180 / -> (hex) mi
note4 		dw 01AB1h 							; 1193180 / -> (hex) fa
note5 		dw 017C7h 							; 1193180 / -> (hex) sol
note6 		dw 0152Fh 							; 1193180 / -> (hex) la
note7 		dw 012DFh 							; 1193180 / -> (hex) si
clock 		equ es:6Ch
note 		dw ? ;note save
sum 		dw ? ;number of times - simon
checker 	db (?)
ready1 		db 'ready1.bmp',0
ready2 		db 'ready2.bmp',0
ready3 		db 'ready3.bmp',0
readygo 	db 'readygo.bmp',0
open10 		db 'open10.bmp',0
open11 		db 'open11.bmp',0
open12 		db 'open12.bmp',0
open13 		db 'open13.bmp',0
open14 		db 'open14.bmp',0
ready 		db 'ready.bmp',0
go 			db 'go.bmp',0
level1 		db 'level1.bmp',0
level2 		db 'level2.bmp',0
level3 		db 'level3.bmp',0
level4 		db 'level4.bmp',0
level5 		db 'level5.bmp',0
fail1 		db 'fail1.bmp',0
fail2 		db 'fail2.bmp',0
fail3 		db 'fail3.bmp',0
fail4 		db 'fail4.bmp',0
fail5 		db 'fail5.bmp',0
exact1 		db 'exact1.bmp',0
exact2 		db 'exact2.bmp',0
exact3 		db 'exact3.bmp',0
exact4 		db 'exact4.bmp',0
exact5 		db 'exact5.bmp',0
score0 		db 'score0.bmp',0
score1 		db 'score1.bmp',0
score2 		db 'score2.bmp',0
score3 		db 'score3.bmp',0
score4 		db 'score4.bmp',0
score5 		db 'score5.bmp',0
petmalu 	db 'petmalu.bmp',0
open 		db 'open.bmp',0
howto 		db 'howto.bmp',0
howto1 		db 'howto1.bmp',0
credits 	db 'credits.bmp', 0
default2 	db 'default2.bmp',0
dos 		db 'dos.bmp',0		
res 		db 'res.bmp',0		
mis 		db 'mis.bmp',0		
fas 		db 'fas.bmp',0		
sols 		db 'sols.bmp',0		
las 		db 'las.bmp',0		
sis 		db 'sis.bmp',0
winner 		db 'winner.bmp',0
songc 		db 'songc.bmp',0
songs 		db 'songs.bmp',0
ErrorFile   db 0
VAR 		db 0
HIGHVAR		DB 0
BmpLeft 	dw ?
BmpTop 		dw ?
BmpColSize 	dw ?
BmpRowSize 	dw ?	

CODESEG
;-----------------------------------------------------------
START:
	MOV 	AX, @data
	MOV 	DS, AX

	CALL 	SetGraphic 
	MOV 	[BmpLeft], 0
	MOV 	[BmpTop], 0
	MOV 	[BmpColSize], 320
	MOV 	[BmpRowSize], 200

	CALL OPEN1
;-----------------------------------------------------------
PROC OPEN1
	
	MOV 	DX, offset open
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer 
	MOV 	DX, offset open10
	CALL 	OpenShowBmp 
	CALL 	Timer
	MOV 	DX, offset open11
	CALL 	OpenShowBmp 
	CALL 	Timer
	MOV 	DX, offset open12
	CALL 	OpenShowBmp 
	CALL 	Timer
	MOV 	DX, offset open13
	CALL 	OpenShowBmp 
	CALL 	Timer

inp:
	PUSHA
	POPA
	MOV 	DX, offset open14
	CALL 	OpenShowBmp 

;get input
	MOV 	AH, 7
	INT 	21H
choose1:
	CMP 	AL, 'k'
	JE 		keyboard					;go to keyboard
	JNE 	choose2
choose2:
	CMP 	AL, 'p' 					;COMPLETING SONGS WITH THE ABOVE STRING
	JE 		songcomplete
	JNE 	choose3
choose3:
	CMP 	AL, 'a'
	JNE 	choose4
	JE 		songMenu
choose4:
	CMP  	AL, 'h'
	JNE 	choose5
	inp3:
		MOV 	DX, offset howto
		CALL 	OpenShowBmp
		CALL 	Timer
		MOV 	DX, offset howto1
		CALL 	OpenShowBmp
		CALL 	Timer
		MOV 	DX, offset howto
		CALL 	OpenShowBmp
		CALL 	Timer
		MOV 	DX, offset howto1
		CALL 	OpenShowBmp
		CALL 	Timer
		;get input
			MOV 	AH, 7
			INT 	21H
			CMP 	AL, 'b'
			JE 		creditss
			JNE 	inp3
choose5:
	CMP 	AL, 's'
	JNE 	choose6
	inp5:
		CALL highscore
		;get input
			MOV 	AH, 7
			INT 	21H
			CMP 	AL, 'b'
			JE 		creditss
			JNE 	inp5
choose6:
	CMP 	AL, 'c'
	JNE 	choose7
	inp2:
		MOV 	DX, offset credits
		CALL 	OpenShowBmp
		;get input
			MOV 	AH, 7
			INT 	21H
			CMP 	AL, 'b'
			JE 		creditss
			JNE 	inp2
choose7: 
	CMP 	AL, 'x' 				;EXIT
	JE 		exit2
	JNE 	inp 


songcomplete: 
	CALL 	game1
keyboard:
	CALL 	scp
songMenu:
	CALL 	PlaySongS	
creditss:
	CALL 	OPEN1	
exit2:
	CALL 	exitproc

RET
ENDP OPEN1
;--------------------------------------------------------------
PROC PlaySongs

	inpp:
		MOV 	DX, offset songs
		CALL 	OpenShowBmp
		;get input
			MOV 	AH, 7
			INT 	21H
		p1:
			CMP 	AL, '1'
			JNE 	p2
			JE 		song1
		p2: 
			CMP 	AL, '2'
			JNE		p3
			JE 		song2
		p3:
			CMP 	AL, 'b'
			JE 		creditsss
			JNE 	inpp

song1:
	CALL 	Twinkle
song2:
	CALL 	HBD
creditsss:
	CALL 	OPEN1	

RET
ENDP PlaySongs
;-------------------------
PROC Twinkle

	CALL procdos
	CALL procdos
	CALL procsols
	CALL procsols
	CALL proclas
	CALL proclas
	CALL procsols
	CALL Timer
	CALL procfas
	CALL procfas
	CALL procmis
	CALL procmis
	CALL procres
	CALL procres
	CALL procdos
	CALL Timer
	CALL procsols
	CALL procsols
	CALL procfas
	CALL procfas
	CALL procmis
	CALL procmis
	CALL procres
	CALL Timer
	CALL procsols
	CALL procsols
	CALL procfas
	CALL procfas
	CALL procmis
	CALL procmis
	CALL procres
	CALL Timer
	CALL procdos
	CALL procdos
	CALL procsols
	CALL procsols
	CALL proclas
	CALL proclas
	CALL procsols
	CALL Timer
	CALL procfas
	CALL procfas
	CALL procmis
	CALL procmis
	CALL procres
	CALL procres
	CALL procdos

	CALL PlaySongs

RET 
ENDP Twinkle
;-------------------------
PROC HBD
	
	CALL procdos
	CALL procdos
	CALL procres
	CALL procdos
	CALL procfas
	CALL procmis
	CALL Timer
	CALL procdos
	CALL procdos
	CALL procres
	CALL procdos
	CALL procsols
	CALL procfas
	CALL Timer
	CALL procdos
	CALL procdos
	CALL proclas
	CALL procsols
	CALL procfas
	CALL procmis
	CALL procres
	CALL Timer
	CALL proclas
	CALL proclas
	CALL procsols
	CALL procfas
	CALL procsols
	CALL procfas

	CALL PlaySongs
	
RET 
ENDP HBD
;--------------------------------------------------------------
PROC game1

	MOV 	DX, offset ready1
	CALL 	OpenShowBmp
	CALL 	Timer
	MOV 	DX, offset ready2
	CALL 	OpenShowBmp
	CALL 	Timer
	MOV 	DX, offset ready3
	CALL 	OpenShowBmp
	CALL 	Timer

	MOV [var], 0
;LEVEL1PLAY
	MOV 	DX, offset ready
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	;play level 1
		CALL 	procdos	;1
		CALL 	procmis ;3
		CALL 	procdos ;1
		CALL 	procfas ;4
	MOV 	DX, offset go
	CALL 	OpenShowBmp
	CALL 	Timer	
	CALL 	Timer
	CALL 	Timer
	MOV 	DX, offset default2 		;default picture until game starts for piano
	CALL 	OpenShowBmp
		;game
			MOV 	AH, 7		;------------input 1
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel1
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 2
			INT 	21H
			CMP 	AL, '3'
			JNE 	ExitLevel1
			CALL 	procmis		
			MOV 	AH, 7 		;=-----------input 3
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel1
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 4
			INT 	21H
			CMP 	AL, '4'
			JNE 	ExitLevel1
			CALL 	procfas		

		MOV 	DX, offset exact1
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		MOV 	DX, offset level2
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer

CALL 	game2

ExitLevel1:
	MOV 	DX, offset fail1
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	OPEN1
 	
RET
ENDP game1
;-----------------------------------------------------------
PROC game2

	INC [var]
;LEVEL2PLAY
	MOV 	DX, offset ready
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	;play level 2 
		CALL 	procdos ;1
		CALL 	procdos ;1
		CALL 	procres ;2
		CALL 	Timer
		CALL 	procdos ;1
		CALL 	Timer
		CALL 	procfas ;4
		CALL 	procmis ;3
	MOV 	DX, offset go
	CALL 	OpenShowBmp
	CALL 	Timer	
	CALL 	Timer
	CALL 	Timer
	MOV 	DX, offset default2 		;default picture until game starts for piano
	CALL 	OpenShowBmp
		;game
			MOV 	AH, 7		;------------input 1
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel2
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 2
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel2
			CALL 	procdos		
			MOV 	AH, 7 		;=-----------input 3
			INT 	21H
			CMP 	AL, '2'
			JNE 	ExitLevel2
			CALL 	procres
			MOV 	AH, 7 		;=-----------input 4
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel2
			CALL 	procdos		
			MOV 	AH, 7 		;=-----------input 5
			INT 	21H
			CMP 	AL, '4'
			JNE 	ExitLevel2
			CALL 	procfas
			MOV 	AH, 7 		;=-----------input 4
			INT 	21H
			CMP 	AL, '3'
			JNE 	ExitLevel2
			CALL 	procmis			
		MOV 	DX, offset exact2
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		MOV 	DX, offset level3
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer

CALL 	game3			

ExitLevel2:
	MOV 	DX, offset fail2
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	OPEN1

RET
ENDP game2
;-----------------------------------------------------------
PROC game3
	INC [var]
;LEVEL3PLAY
	MOV 	DX, offset ready
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	;play level 3 
		CALL 	procdos ;1
		CALL 	procdos ;1
		CALL 	procsols ;5
		CALL 	procsols ;5
		CALL 	proclas ;6
		CALL 	proclas ;6
		CALL 	procsols ;5
	MOV 	DX, offset go
	CALL 	OpenShowBmp
	CALL 	Timer	
	CALL 	Timer
	CALL 	Timer
	MOV 	DX, offset default2 		;default picture until game starts for piano
	CALL 	OpenShowBmp
		;game
			MOV 	AH, 7 		;=-----------input 1
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel3
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 2
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel3
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 3
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel3
			CALL 	procsols
			MOV 	AH, 7 		;=-----------input 4
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel3
			CALL 	procsols
			MOV 	AH, 7 		;=-----------input 5
			INT 	21H
			CMP 	AL, '6'
			JNE 	ExitLevel3
			CALL 	proclas
			MOV 	AH, 7 		;=-----------input 6
			INT 	21H
			CMP 	AL, '6'
			JNE 	ExitLevel3
			CALL 	proclas
			MOV 	AH, 7 		;=-----------input 7
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel3
			CALL 	procsols		
			
		MOV 	DX, offset exact3
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		MOV 	DX, offset level4
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer

CALL 	game4		

ExitLevel3:
	MOV 	DX, offset fail3
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	OPEN1

RET
ENDP game3
;-----------------------------------------------------------
PROC game4
	
	INC [VAR]
;LEVEL3PLAY
	MOV 	DX, offset ready
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	;play level 3 

		CALL 	procdos ;1
		CALL 	Timer
		CALL 	procdos ;1
		CALL 	procres ;2
		CALL 	procmis ;3
		CALL 	Timer
		CALL 	procmis ;3
		CALL 	procres ;2
		CALL 	procmis ;3
		CALL 	procfas ;4
		CALL 	procsols ;5
	MOV 	DX, offset go
	CALL 	OpenShowBmp
	CALL 	Timer	
	CALL 	Timer
	CALL 	Timer
	MOV 	DX, offset default2 		;default picture until game starts for piano
	CALL 	OpenShowBmp
		;game
			MOV 	AH, 7 		;=-----------input 2
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel4
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 3
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel4
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 4
			INT 	21H
			CMP 	AL, '2'
			JNE 	ExitLevel4
			CALL 	procres
			MOV 	AH, 7 		;=-----------input 5
			INT 	21H
			CMP 	AL, '3'
			JNE 	ExitLevel4
			CALL 	procmis
			MOV 	AH, 7 		;=-----------input 6
			INT 	21H
			CMP 	AL, '3'
			JNE 	ExitLevel4
			CALL 	procmis
			MOV 	AH, 7 		;=-----------input 7
			INT 	21H
			CMP 	AL, '2'
			JNE 	ExitLevel4
			CALL 	procres
			MOV 	AH, 7 		;=-----------input 8
			INT 	21H
			CMP 	AL, '3'
			JNE 	ExitLevel4
			CALL 	procmis		
			MOV 	AH, 7 		;=-----------input 9
			INT 	21H
			CMP 	AL, '4'
			JNE 	ExitLevel4
			CALL 	procfas
			mOV 	AH, 7 		;=-----------input 10
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel4
			CALL 	procsols	
			
		MOV 	DX, offset exact4
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		MOV 	DX, offset level5
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer

CALL 	game5

ExitLevel4:
	MOV 	DX, offset fail4
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	OPEN1

RET
ENDP game4
;-----------------------------------------------------------
PROC game5
	INC [VAR]
;LEVEL3PLAY
	MOV 	DX, offset ready
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	;play level 3 

		CALL 	procfas ;4
		CALL 	procmis ;3
		CALL 	procsols ;5
		CALL 	procfas ;4
		CALL 	procdos ;1
		CALL 	Timer
		CALL 	procsols ;5
		CALL 	proclas ;6
		CALL 	procsis ;7
		CALL 	proclas ;6
		CALL 	procsols ;5
		CALL 	proclas ;6
		CALL 	procfas ;4
	MOV 	DX, offset go
	CALL 	OpenShowBmp
	CALL 	Timer	
	CALL 	Timer
	CALL 	Timer
	MOV 	DX, offset default2 		;default picture until game starts for piano
	CALL 	OpenShowBmp
		;game
			MOV 	AH, 7 		;=-----------input 2
			INT 	21H
			CMP 	AL, '4'
			JNE 	ExitLevel5
			CALL 	procfas
			MOV 	AH, 7 		;=-----------input 3
			INT 	21H
			CMP 	AL, '3'
			JNE 	ExitLevel5
			CALL 	procmis
			MOV 	AH, 7 		;=-----------input 4
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel5
			CALL 	procsols
			MOV 	AH, 7 		;=-----------input 5
			INT 	21H
			CMP 	AL, '4'
			JNE 	ExitLevel5
			CALL 	procfas
			MOV 	AH, 7 		;=-----------input 6
			INT 	21H
			CMP 	AL, '1'
			JNE 	ExitLevel5
			CALL 	procdos
			MOV 	AH, 7 		;=-----------input 7
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel5
			CALL 	procsols
			MOV 	AH, 7 		;=-----------input 8
			INT 	21H
			CMP 	AL, '6'
			JNE 	ExitLevel5
			CALL 	proclas		
			MOV 	AH, 7 		;=-----------input 9
			INT 	21H
			CMP 	AL, '7'
			JNE 	ExitLevel5
			CALL 	procsis

			CALL 	game5a

ExitLevel5:
	MOV 	DX, offset fail5
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	OPEN1

RET
ENDP game5
;-----------CONTINUATION-------
PROC game5a

			MOV 	AH, 7 		;=-----------input 6
			INT 	21H
			CMP 	AL, '6'
			JNE 	ExitLevel6
			CALL 	proclas
			MOV 	AH, 7 		;=-----------input 7
			INT 	21H
			CMP 	AL, '5'
			JNE 	ExitLevel6
			CALL 	procsols
			MOV 	AH, 7 		;=-----------input 8
			INT 	21H
			CMP 	AL, '6'
			JNE 	ExitLevel6
			CALL 	proclas		
			MOV 	AH, 7 		;=-----------input 9
			INT 	21H
			CMP 	AL, '4'
			JNE 	ExitLevel6
			CALL 	procfas

		INC [VAR]
		MOV 	DX, offset exact5
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		MOV 	DX, offset petmalu
		CALL 	OpenShowBmp
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer
		CALL 	Timer

CALL 	OPEN1	

ExitLevel6:
	MOV 	DX, offset fail5
	CALL 	OpenShowBmp
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	Timer
	CALL 	OPEN1

RET
ENDP game5a
;-----------------------------------------------------------
PROC Timer 								;TIMER WITH 2 TICKS
	
	PUSHA
	MOV 	AX, 40H 					;enable Timer
	MOV 	ES, AX
	MOV 	AX, [clock]
	
	FirstTick:
		CMP 	AX, [clock]
		MOV 	CX, 6 					;ticks
		JE 		FirstTick
	
	DelayLoop:
		MOV 	AX, [clock]
	
	Tick:
		CMP 	AX, [clock]
		JE 		Tick
		LOOP DelayLoop
	
	POPA
RET
ENDP Timer
;------------------------------------------------------------------------------------
PROC soundclose 						;soundclose

	IN 		AL, 61H                 
	AND 	AL, 11111100B      
	OUT 	61H, AL

RET
ENDP soundclose
;------------------------------------------------------------------
PROC scp 								

	MOV 	DX, offset default2 		;default picture until game starts for piano
	CALL 	OpenShowBmp

	scpstart:
		PUSHA
		POPA
		MOV 	AH, 7 					;the input of the user which makes noise 
		INT 	21H

	CMP 	AL, '1'  					;do
	JNE 	g
	CALL 	procdos
	JMP 	continue
	;JL		scpstart
g:
	CMP 	AL, '2'		 				;re
	JNE 	g2
	CALL 	procres
	JMP 	continue
g2:	
	CMP 	AL, '3'						;mi
	JNE 	g3
	CALL 	procmis
	JMP 	continue
g3:	
	CMP 	AL, '4'						;fa
	JNE 	g4
	CALL 	procfas
	JMP 	continue
g4:	
	CMP 	AL, '5'						;sol
	JNE 	g5
	CALL 	procsols
	JMP 	continue
g5:
	CMP 	AL, '6'						;la3
	JNE 	g6
	CALL 	proclas
	JMP 	continue
g6:	
	CMP 	AL, '7'						;ti
	JNE 	exit3 						;if the user got it wrong, he will be teleported back up to try again without SI increasing
	CALL 	procsis
	JMP 	continue

exit3:
	CMP 	AL, 'x'
	JNE		scpstart
	CALL 	OPEN1


	continue:
		LOOP 	scpstart 				;DO IT ALL OVER AGAIN UNTIL HE FINISHES THE SONG
RET
ENDP scp

;-----------------------------------------------------------------
PROC OpenShowBmp NEAR
	PUSH 	CX
	PUSH 	BX
	CALL 	OpenBmpFile
	CMP 	[ErrorFile], 1
	JE 	 	@@ExitProc
	CALL 	ReadBmpHeader
	CALL 	ReadBmpPalette
	CALL 	CopyBmpPalette 
	CALL 	ShowBMP 
	CALL 	CloseBmpFile
	
	@@ExitProc:
		POP 	BX
		POP 	CX
RET
ENDP OpenShowBmp
;-----------------------------------------------------------------
PROC OpenBmpFile NEAR						 
	
	MOV 	AH, 3DH
	XOR 	AL, AL
	INT 	21H
	JC 		@@ErrorAtOpen
	MOV 	[FileHandle], AX
	JMP 	@@ExitProc	

@@ErrorAtOpen:
	MOV 	[ErrorFile], 1

@@ExitProc:	

RET
ENDP OpenBmpFile
;-------------------------------------------------------------------
PROC CloseBmpFile NEAR
	MOV 	AH, 3EH
	MOV 	BX, [FileHandle]
	INT 	21H
RET
ENDP CloseBmpFile
;-------------------------------------------------------------------
PROC ReadBmpHeader NEAR					
	PUSH 	CX
	PUSH 	DX
	MOV 	AH, 3FH
	MOV 	BX, [FileHandle]
	MOV  	CX, 54
	MOV 	DX, offset Header
	INT 	21H
	POP 	DX
	POP 	CX
RET
ENDP ReadBmpHeader
;-------------------------------------------------------------------
proc ReadBmpPalette near 	
	push cx
	push dx
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	pop dx
	pop cx
ret
endp ReadBmpPalette
;--------------------------------------------------------------------
PROC CopyBmpPalette	NEAR					
	PUSH 	CX
	PUSH 	DX
	MOV 	SI, offset Palette
	MOV 	CX, 256
	MOV 	DX, 3C8H
	MOV 	AL, 0  							
	OUT 	DX, AL 
	INC 	DX	

	CopyNextColor:
		MOV 	AL, [SI+2] 						
		SHR 	AL, 2 							
		OUT 	DX, AL 						
		MOV 	AL, [SI+1] 						
		SHR 	AL, 2            
		OUT 	DX, AL 							
		MOV 	AL, [SI] 						
		SHR 	AL, 2            
		OUT 	DX, AL 							
		ADD  	SI, 4 						
		LOOP 	CopyNextColor
		POP 	DX
		POP CX
RET
ENDP CopyBmpPalette
;---------------------------------------------------------------------
PROC ShowBMP 
	PUSH 	CX
	MOV 	AX, 0A000H
	MOV 	ES, AX
	MOV 	CX, [BmpRowSize]
	MOV 	AX, [BmpColSize] 				;row size must dived by 4 so if it less we must calculate the extra padding bytes
	XOR 	DX, DX
	MOV 	SI, 4
	DIV 	SI
	MOV 	BP, DX
	MOV 	DX, [BmpLeft]

	@@NextLine:
		PUSH 	CX
		PUSH 	DX
		MOV 	DI, CX  					; Current Row at the small bmp (each time -1)
		ADD 	DI, [BmpTop] 				; add the Y on entire screen
		MOV 	CX, DI
		SHL 	CX, 6
		SHL 	DI, 8
		ADD 	DI, CX
		ADD 	DI, DX
		MOV 	AH, 3fH
		MOV 	CX, [BmpColSize]  
		ADD 	CX, BP  					;extra  bytes to each row must be divided by 4
		MOV 	DX, offset ScreenLineMax
		INT 	21H
		CLD 								;Clear direction flag, for movsb
		MOV 	CX, [BmpColSize]  
		MOV 	SI, offset ScreenLineMax
		REP 	movsb 						; Copy line to the screen
		POP 	DX
		POP 	CX
		LOOP 	@@NextLine
		POP 	CX
RET
ENDP ShowBMP 
;---------------------------------------------------------------------
PROC SetGraphic
	MOV 	AX, 13H   						; 320 X 200 
	INT 	10H
RET
ENDP SetGraphic
;------------------------------------------------------------		
PROC procsols  								;sol	
	PUSHA					
	MOV 	DX, offset sols     
	CALL 	OpenShowBmp		
	MOV 	AX, [note5]			
	MOV 	[note],AX			
	CALL 	sound2				
	POPA					
RET                     
ENDP procsols			
;------------------------------------------------------------								
PROC procfas								;fa			
	PUSHA					
	MOV 	DX, offset fas		
	CALL 	OpenShowBmp		
	MOV 	AX, [note4]			
	MOV 	[note],	AX			
	CALL 	sound2				
	POPA					
RET						
ENDP procfas				
;------------------------------------------------------------					
PROC procmis 								;mi	
	PUSHA					
	MOV 	DX, offset mis 		
	CALL 	OpenShowBmp		
	MOV 	AX, [note3]			
	MOV 	[note], AX			
	CALL 	sound2	
	POPA		           
RET						
ENDP procmis	         
;-------------------------------------------------------------
PROC procres 								;re		
	PUSHA					
	MOV 	DX, offset res		
	CALL 	OpenShowBmp	    		
	MOV 	AX, [note2]			
	MOV 	[note], ax			
	CALL 	sound2				
	POPA					
RET						
ENDP procres
;-------------------------------------------------------------					
PROC procdos 								;do
	PUSHA					
	MOV 	DX, offset dos      
	CALL 	OpenShowBmp        
	MOV 	AX, [note1]         
	MOV 	[note], AX           
	CALL 	sound2  			
	POPA         	
RET                     
ENDP procdos            	
;-------------------------------------------------------------						
PROC proclas 								;la
	PUSHA					
	MOV 	DX, offset las     
	CALL 	OpenShowBmp        
	MOV 	AX, [note6]         
	MOV 	[note], AX           
	CALL 	sound2  			
	POPA         	
RET                     
ENDP proclas              	
;------------------------------------------------------------						
PROC procsis 								;si    
	PUSHA					
	MOV 	DX, offset sis      
	CALL 	OpenShowBmp        
	MOV 	AX, [note7]         
	MOV 	[note], AX           
	CALL 	sound2  			
	POPA         	
RET                     
ENDP procsis
;------------------------------------------------------------	
PROC sound2 								;sound2 for complete songs mode
	PUSHA
	MOV 	BP, SP
	IN 		AL, 61H
	OR 		AL, 00000011B
	OUT 	61H, AL
	MOV 	AL, 0B6H
	OUT 	43H, AL
	MOV 	AX, [note]
	OUT 	42H, AL 						;Sending lower byte
	MOV 	AL, AH
	OUT 	42H, AL 						;Sending upper byte
	CALL 	Timer
	CALL 	soundclose
	MOV 	DX, offset default2
	CALL 	OpenShowBmp
	POPA
RET
ENDP sound2
;------------------------------------------------------------
PROC highscore NEAR
	MOV AL, [VAR]
	CMP AL, [HIGHVAR]
	JG toreplace

	highss:
		CMP     [HIGHVAR], 0
		JE zeroscore

		CMP     [HIGHVAR], 1
		JE onescore

		CMP     [HIGHVAR], 2
		JE twoscore

		CMP     [HIGHVAR], 3
		JE threescore

		CMP     [HIGHVAR], 4
		JE fourscore

		CMP     [HIGHVAR], 5
		JE fivescore

	zeroscore:	
		MOV 	DX, offset score0
		CALL 	OpenShowBmp
		RET
	onescore:	
		MOV 	DX, offset score1
		CALL 	OpenShowBmp
		RET
	twoscore:	
		MOV 	DX, offset score2
		CALL 	OpenShowBmp
		RET
	threescore:	
		MOV 	DX, offset score3
		CALL 	OpenShowBmp
		RET
	fourscore:	
		MOV 	DX, offset score4
		CALL 	OpenShowBmp
		RET
	fivescore:	
		MOV 	DX, offset score5
		CALL 	OpenShowBmp
		RET
		
	toreplace: 
		CALL replace

	RET
ENDP highscore
;--------------------------------------------------------------
PROC replace NEAR				
	MOV AL, [HIGHVAR]			
	MOV AL, [VAR]
	MOV [HIGHVAR], AL
	RET
ENDP replace
;--------------------------------------------------------------

PROC exitproc 								;exit procedure any time
	
	MOV 	AX, 2
	INT 	10H
	MOV 	AX, 4C00H
	INT 	21H

ENDP exitproc
END start