[org 0x0100]

jmp start							; jump to control panel

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;GLOBAL VARIABLES DECLARATION
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

questions: db 'Vatican City is a country.                        ','Google was initially called BackRub.              ', 'The black box in a plane is black.                '    ,'Tomatoes are fruit.                               '   ,'Coca Cola exists in every country around the world',    'All mammals live on land.                         ',   'Goldfish only have a memory of three seconds.      ',   'The Statue of Liberty was a gift from France.     ',   'Spiders have six legs.                            ',   'An octopus has three hearts.                       $' 
questions_answer: dw 1,1,0,1,0,0,0,1,0,1

player1: db 'Player 1: $'
player2: db 'Player 2: $'

wrongkey: db 'Wrong Key Entered!! Enter Again :  $'
nextquestion: db 'Press Any Key For Next Question $'
statistics: db 'Current Statistics $'

player1choice: dw 0
player2choice: dw 0

player1answer: dw 0
player2answer: dw 0

player1correctstr: db 'Player 1 is correct $'
player2correctstr: db 'Player 2 is correct $'

player1wrongstr: db 'Player 1 is wrong $'
player2wrongstr: db 'Player 2 is wrong $'

bothplayerscorrectstr: db 'You are both correct $'
bothplayerswrongstr: db 'You are both wrong  $'
bothplayersswipestr: db 'You both have Skipped $'

player1swipestr: db 'Player 1 has skipped  $'
player2swipestr: db 'Player 2 has skipped  $'

player1scorestr1: db 'Player 1 score :   $'
player2scorestr1: db 'Player 2 score :   $'
drawstr: db 'Players Have Equal Score $'

player1scorestr2: db 'out of  :   $'
player2scorestr2: db 'out of  :   $'

player1livesstr: db 'Player 1 lives :  $'
player2livesstr: db 'Player 2 lives :  $'

player1score: dw 0
player2score: dw 0

player1lives: dw 3
player2lives: dw 3

player1wincount: dw 0
player2wincount: dw 0

player1winstr: db 'Congratulations!!, Player 1 WON  $'
player2winstr: db 'Congratulations!!, Player 2 WON  $'

player1loselivestr: db 'Player 1 LOST All Lives  $'
player2loselivestr: db 'Player 2 LOST All Lives  $'

player1crtstr: db 'CERTIFICATE!! Awarded to Player no 1 $'
player2crtstr: db 'CERTIFICATE!! Awarded to Player no 2  $'

player1losestr: db 'Sorry!!,Player 1 LOST  $'
player2losestr: db 'Sorry!!, Player 2 LOST  $'

totalquestions: dw 0

true: db 'TRUE $'
false: db 'FALSE $'
swipe: db 'Skipped $'

format: dw 0,0,0,0,0,0,0,0,0,0,0

exitgameflag: dw 0

oldtimer : dw 0,0
tickcount: dw 0

;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
; GLOBAL VARIABLES/STRINGS FOR INTRODUCTION PAGE
;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------

; printimg messages for introduction and end page

introwelcome: db 'Welcome to " QUIZ MANIA " $'
introwelcomesize: db 25
introInstructions: db '<-----INSTRUCTIONS-----> $'
introInstructionssize: db 24

intromove1: db '1- T => TRUE, F => FALSE, S => SKIP  $'
intromovesize1: db 36
intromove2: db '2- Score for : Correct (1), Wrong (0)  $'
intromovesize2: db 37

introscore1: db '3- Player has 3 lives [Skip = -1]  $'
introscoresize1: db 34
introscore2: db '4- Correct 5 Ans in a row for Prize $'
introscoresize2: db 35

intromessage: db '4- ENTER to Continue & ESC to Exit $'
intromessagesize: db 35

gamename: db 'Q_U_I_Z   M_A_N_I_A $'
gamenamesize: db 19
gamedesp: db 'T_R_U_E  /  F_A_L_S_E $'
gamedespsize: db 21

endterminate: db 'G_A_M_E  O_V_E_R  $'
endterminatesize: db 17

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR CLEARING SCREEN
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

clrscr: 			
		push es 			; pushing relevant registers
 		push ax 
 		push cx 
		push di 

 		mov ax, 0xb800 
 		mov es, ax 			; point es to video base 
 		xor di, di 			; point di to top left column 
 		mov ax, 0x0720 		; space char in normal attribute 
 		mov cx, 2000 		; number of screen locations 
 		cld 				; auto increment mode 
 		rep stosw 			; clear the whole screen 

 		pop di			; popping relevant used registers
 		pop cx 
 		pop ax 
 		pop es 
 		ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR DELAY
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

delay:
                  push cx			; pushing relevant registers
                  mov cx,0xFFFF
loop1:					; loops for delay
                  loop loop1
                  mov cx,0xFFFF
loop2:
                  loop loop2
                  pop cx 			; popping relevant used registers
                  ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PRINTING STRING
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

Printing_String:

        push di					; di used here in place of bp because bp used in printing 
        mov di, sp
pusha
        	mov ah, 0x13      		 	; bios print string service
  	mov al, 0					; print on derired location
        	mov bh, 0          			; to print on page 0
        	mov cx, [di+12]      	
	mov bl,cl					; attribute for string
 
  	mov dh, [di+4]				; row
	mov dl, [di+6]				; col

        	push ds       
        	pop es         
        	mov bp, [di + 10] 		 	; putting string's ip in bp
        	mov cx, [di + 8]  			; putting size in cx
        	int 0x10

        popa						; popping all registers
        pop di

        ret 10					; returning with parameters

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR QUESTIONS PRINTING
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

exitgame:					; if condition for exiting game on esc
mov word [cs:exitgameflag],1
jmp nomatch

printQuestions:				; printing question function
push bp
mov bp,sp
pusha					; pushing all registers
						; Printing Question Here
xor bx,bx					; bx = 0
mov bl,0x0e				; attribute
push bx					; pushing as parameter into stack
mov ax, questions 			; string
add ax, [bp+4]				; question number
push ax					; pushing as parameter into stack
mov bx, 50 				; string size
push bx					; pushing as parameter into stack
mov al,20  				; coloumn
push ax					; pushing as parameter into stack
mov ax,6   				; row
push ax					; pushing as parameter into stack
call Printing_String
						; Printing Player 1 str Here
xor bx,bx					; bx = 0
mov bl,0x0f				; attribute
push bx					; pushing as parameter into stack
mov ax, player1 			; string
push ax					; pushing as parameter into stack
mov bx, 9   				; string size
push bx					; pushing as parameter into stack
mov al,20  				; coloumn
push ax					; pushing as parameter into stack
mov ax,8  					 ; row
push ax
call Printing_String

player1againinput:			; loop if player add incorrect input
mov ah,0					; get a key from keyboard
int 0x16

cmp al,0x1B				; if key is escape 
je exitgame 
cmp al,0x54 				; if key is true
jne nextcmp1	
mov word [cs:player1choice],1	; add player 1 choice
mov ax,8
push ax					; pushing as parameter into stack
call true_fun				; print true on screen
jmp exitplayer1choice

nextcmp1:
cmp al,0x46 				; if key is  false
jne nextcmp2
mov  word[cs:player1choice],0	; add player 1 choice
mov ax,8
push ax					; pushing as parameter into stack
call false_fun				; print false
jmp exitplayer1choice

nextcmp2:
cmp al,0x74 				; if key is  true
jne nextcmp3
mov word [cs:player1choice],1	; update choice
mov ax,8
push ax					; pushing as parameter into stack
call true_fun				; print true on screen
jmp exitplayer1choice

nextcmp3:
cmp al,0x66				 ; if choice is false
jne nextcmp4
mov  word[cs:player1choice],0	; update choice
mov ax,8
push ax					; pushing as parameter into stack
call false_fun				; print false on screen
jmp exitplayer1choice

nextcmp4:
cmp al,0x53 				; if key is swipe
jne nextcmp5
mov  word[cs:player1choice],2	; add player choice
mov ax,8
push ax					; pushing as parameter into stack
call swipe_fun				; print swipe on screen
dec word[cs:player1lives]		; dec player 1 live
jmp exitplayer1choice

nextcmp5:
cmp al,0x73 ; swipe			; if key is swipe 
jne nextcmp6
mov  word[cs:player1choice],2	; add player choice
mov ax,8
push ax					; pushing as parameter into stack
call swipe_fun				; print swipe on screen
dec word[cs:player1lives]		; dec player 1 live
jmp exitplayer1choice

nextcmp6:					; else print wrong key entered
xor bx,bx					; Making bx = 0
mov bl,0x0c				; attribute
push bx					; pushing as parameter into stack
mov ax, wrongkey 			; string to print wrong key entered
push ax					; pushing as parameter into stack
mov bx, 35  				; string size
push bx					; pushing as parameter into stack
mov al,20  					; coloumn
push ax					; pushing as parameter into stack
mov ax,9   					; row
push ax					; pushing as parameter into stack
call Printing_String
jmp player1againinput

exitplayer1choice:  			; player 1 choice ends here

;-------------------------------------------------------------------------

							; printing player no 2  str
xor bx,bx						; bx = 0
mov bl,0x0f					; attribute
push bx					; pushing as parameter into stack
mov ax, player2 				; string
push ax					; pushing as parameter into stack
mov bx, 9   					; string size
push bx					; pushing as parameter into stack
mov al,20  					; coloumn
push ax					; pushing as parameter into stack
mov ax,10    					; row
push ax					; pushing as parameter into stack
call Printing_String

player2againinput:				; taking player no 2 choice here
mov ah,0						; get a key from keyboard
int 0x16

cmp al,0x1B					; jump if the key is escape
je exitgame 

cmp al,0x54					 ; if the key is true
jne nextcmp12
mov  word[cs:player2choice],1		; add to player 2 choice
mov ax,10
push ax					; pushing as parameter into stack
call true_fun					; print true
jmp exitplayer2choice

nextcmp12:
cmp al,0x46 					;  if the key is false
jne nextcmp22
mov word [cs:player2choice],0		; add to player 2 choice
mov ax,10
push ax					; pushing as parameter into stack
call false_fun					; print false
jmp exitplayer2choice

nextcmp22:
cmp al,0x74 					; if the key is true
jne nextcmp32
mov  word[cs:player2choice],1		; add to player 2 choice
mov ax,10
push ax					; pushing as parameter into stack
call true_fun					; print true
jmp exitplayer2choice

nextcmp32:
cmp al,0x66 					; if the key is false
jne nextcmp42
mov word [cs:player2choice],0		; add to player 2 choice
mov ax,10
push ax					; pushing as parameter into stack
call false_fun					; print false
jmp exitplayer2choice

nextcmp42:
cmp al,0x53 					; if the key is swipe
jne nextcmp52
mov  word[cs:player2choice],2		; add to player 2 choice
mov ax,10
push ax					; pushing as parameter into stack
call swipe_fun					; print swipe/skip
dec word[cs:player2lives]			; dec live -1
jmp exitplayer2choice

nextcmp52:
cmp al,0x73 	 				; if the key is swipe
jne nextcmp62
mov  word[cs:player2choice],2		; add to player 2 choice
mov ax,10
push ax					; pushing as parameter into stack
call swipe_fun					; print swipe
dec word[cs:player2lives]			; dec 1 live
jmp exitplayer2choice

nextcmp62:					; else print wrong key entered
xor bx,bx						; bx = 0
mov bl,0x0c					; attribute
push bx					; pushing as parameter into stack
mov ax, wrongkey 				; string
push ax					; pushing as parameter into stack
mov bx, 35   					; string size
push bx					; pushing as parameter into stack
mov al,20  					; coloumn
push ax					; pushing as parameter into stack
mov ax,11   					; row
push ax					; pushing as parameter into stack
call Printing_String
jmp player2againinput

exitplayer2choice:				; player no  2 choice taken here

jmp nomatch
nomatch:

popa							; popping all relavant registers
pop bp
ret 2							; 1 parameter taken i.e qusetion number

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
; SUBROUTINE FOR MAIN PROGRAM
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

main_program:
pusha 					; pushing all registers
mov si,0					; question number indicator

mainfunloop:				; main loop for game
call clrscr					; clearing screen after every question
call playerslives_fun			; display player lives
call gameinterface			; display game inteface

xor bx,bx					; bx = 0
againinput:				; if question already asked then repeat
cli						; disabling interrupts
mov bx,[cs:tickcount]			; getting random num
sti						; enabling interrupts

mov dx,0					; dx = 0
cmp [cs:format+bx],dx		; checking is question not already asked
jne againinput				; if so then get new number

mov word[cs:format + bx],1	; if not asked then ask it and mark is done
inc word[cs:totalquestions]	; inc total asked questions

mov cx,bx					; getting exact location of question in memory
mov ax,bx
mov bx,25
mul bx
push ax					; pushing as parameter into stack
call printQuestions			; ptinting question

cmp word [cs:exitgameflag],1    ; if exit game is called via esc
je exitthegame1

;------------------------------------------------------------
; Checking answer of players form here
;------------------------------------------------------------

push cx 					; cx has the question number
call CheckAnswers			; function to check answers
call statistics_fun			; display there results

call player1score_fun		; display score player 1
call player2score_fun		; display score player 2

cmp word[cs:player1wincount],5	; five correct in row then end
je player1winrow
cmp word[cs:player2wincount],5	; five correct in row then end
je player2winrow

cmp word[cs:player1lives],0		; lives finish then end
je player1lost
cmp word[cs:player2lives],0		; lives finish then end
je player2lost

mov cx,40						; putting a bit of delay between questions
delayloop:
call delay
loop delayloop

call next_fun					; display next fun key 

exitthegame1:
cmp word [cs:exitgameflag],1 		; if exit game is called via esc
je exitthegame

add si,1						; inc questions asked and check with total questions
cmp si,10
jne mainfunloop

call End_Page					; end game inteface display
jmp exitthegame				; function end

player1winrow:					; if payer 1 gets 5 in row
call End_Page					; display end interface
call certificatelayout				; give player 1 a certficate layout
call player1certificate_fun

cmp word[cs:player2wincount],5	; if player 2 also has 5 in row
jne exitthegame
call player2certificate_fun			; award him prize too
jmp exitthegame

player2winrow:					; if player 2 gets 5 in a row
call End_Page					; end page interface
call certificatelayout				; certificate layout
call player2certificate_fun			; award him a certificate
jmp exitthegame				; end the game

player1lost:					; if player 1 lost all lives
call End_Page					; end page layout
call certificatelayout				; print layout
call player1lostlives_fun			; display lost

cmp word[cs:player2lives],0		; check if player 2 also lost
jne exitthegame				
call player2lostlives_fun			; display him too
jmp exitthegame

player2lost:					; if player 2 lost all lives
call End_Page					; end page display
call certificatelayout				; print layout
call player2lostlives_fun			; display he lost
jmp exitthegame

exitthegame:					; end the game label

popa							; pop all registers
ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR TRUE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

true_fun:				; display true on screen

push bp
mov bp,sp
pusha

xor bx,bx				; bx = 0
mov bl,0x0A			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,true			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,5				; size of string
push ax				; Pushing a Parameter into the stack
mov al,31				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,[bp+4]			; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 2

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR FALSE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

false_fun:				; display false on screen

push bp
mov bp,sp
pusha

xor bx,bx			; bx = 0
mov bl,0x0c			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,false			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,5				; size of string
push ax				; Pushing a Parameter into the stack
mov al,31				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,[bp+4]			; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 2

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR SWIPE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

swipe_fun:			; display swipe on screen

push bp
mov bp,sp
pusha

xor bx,bx			; bx = 0
mov bl,0x01			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,swipe			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Pushing a Parameter into the stack
mov al,8				; size of string
push ax				; Pushing a Parameter into the stack
mov al,31				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,[bp+4]			; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 2

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR HOOK 
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

hook:					; hooking timer interrupt
		pusha			; pushing all registers 
		xor ax,ax			; ax=0
		mov es,ax			; point es to 0
		
		mov ax,[es:8*4]		; placing old timer val
		mov [oldtimer],ax	; in global variable
		mov ax,[es:8*4+2]	; cs too
		mov [oldtimer+2],ax
		cli					; stopping all interrupts
		mov word[es:8*4], timer	; placing new keyborad function
		mov [es:8*4+2], cs		; cs too
		sti			; allowing all interrupts
		popa			; pop all registers
		ret			; return

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR  TIMER
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

updatetickcount:			; if random num exceeds max limit
mov word[cs:tickcount],0		; make it 0
jmp returntimerupdate

timer:					; timer function
pusha

inc word [cs: tickcount]		; inc count 
inc word [cs: tickcount]

cmp word [cs:tickcount],20	; cmp with max limit
je updatetickcount

returntimerupdate:

mov al,0x20				; enable further lower interrupts
out 0x20,al

popa
iret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR NEXT QUESTION
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

next_fun:					; subroutine to display enter any key for next question

pusha

xor bx,bx			; bx = 0
mov bl,0x89				; attriibute
push bx				; Pushing a Parameter into the stack
mov ax,nextquestion			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,31					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,13					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

mov ah,0					; getting a key from keyboard
int 0x16

cmp al,0x1B				; if key is escape
jne nomatchesc
mov word [cs:exitgameflag],1	; make falg to exit
nomatchesc:

popa
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PRINT NUMBER
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

printnum:			; printing numer on screen
 push bp 			; pushing relavant registers
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax 		; point es to video base 
 mov ax, [bp+4] 	; load number in ax 
 mov bx, 10	 	; use base 10 for division 
 mov cx, 0 		; initialize count of digits 
nextdigit: mov dx, 0 	; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 		; convert digit into ascii value 
 push dx 				; save ascii value on stack 
 inc cx 				; increment count of values 
 cmp ax, 0 			; is the quotient zero 
 jnz nextdigit 			; if no divide it again 
 mov di, [bp+6]			; point di to top left column 
nextpos: pop dx 		; remove a digit from the stack 
 mov dh, 0x0f 			; use normal attribute 
 mov [es:di], dx 			; print char on screen 
 add di, 2 				; move to next screen location 
 loop nextpos	 		; repeat for all digits on stack
 pop di 
 pop dx 				; popping registers
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 4

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR ANSWER CHECKING
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1correct:					; if player 1 is correct
mov word[cs:player1answer],1		; mark as correct
inc word[cs:player1score]			; inc score
inc word[cs:player1wincount]		; add wincount
jmp player1correctreturn

player2correct:					; if player 2 is correct
mov word [cs:player2answer],1		; mark as correct
inc word[cs:player2score]			; inc score
inc word[cs:player2wincount]		; add win count
jmp player2correctreturn

 CheckAnswers:			 	; function for checking answers
push bp					; pushing as parameter into stack
mov bp,sp
pusha

mov bx, [bp+4]  				; getting question number
mov ax, [cs:questions_answer+bx] 	; taking answer of that question

cmp ax, [cs:player1choice] 		; comparing the answer with choice of player no 1
je player1correct

mov word[cs:player1wincount],0	; if ans is wrong reset

cmp word [cs:player1choice],2		; check if swipe
jne player1correctnext

mov word [cs:player1answer],2		; mark ans as swipe
jmp player1correctreturn

player1correctnext:				; player 1 is wrong
mov word [cs:player1answer],0		; mark as wrong
player1correctreturn:				; player 1 marking ends here

cmp ax, [cs:player2choice] 		; comparing the answer with choice of player no 2
je player2correct

mov word[cs:player2wincount],0	; reset its wincount

cmp word [cs:player2choice],2		; check if swiped
jne player2correctnext

mov word [cs:player2answer],2		; mark as swipe
jmp player2correctreturn

player2correctnext:				; if player is wrong
mov word [cs:player2answer],0		; mark as wrong
player2correctreturn:				; player 2 marked here

;---------------------------  players answers have been marked till here  ---------------------------

mov ax,[cs:player1answer]		; get player 1 ans
mov bx,[cs:player2answer]		; get player 2 ans

cmp ax,bx						; check if both have same answers
je bothsameanswers				; then pring either both correct/wrong/skipped

cmp ax,1						; check if player 1 is correct
jne nextcmpanswer1		
call player1correct_fun			; print player 1 correct
jmp answerdisplayed1

nextcmpanswer1:				; check if player 1 is incorrect
cmp ax,0
jne nextcmpanswer2
call player1wrong_fun			; print incorrect
jmp answerdisplayed1

nextcmpanswer2:				; check if player 1 has skipped
cmp ax,2
jne answerdisplayed1
call player1swipe_fun			; print skip

answerdisplayed1:				; player 1 results displayed here

cmp bx,1						; check if player 2 is correct
jne nextcmpanswer11
call player2correct_fun			; display correct
jmp answerdisplayed2

nextcmpanswer11:				; if player  2 is incorrect
cmp bx,0
jne nextcmpanswer21
call player2wrong_fun			; display wrong
jmp answerdisplayed2

nextcmpanswer21:				; check if player 2 has skipped
cmp bx,2
jne answerdisplayed2
call player2swipe_fun			; display skipped

answerdisplayed2:				; player 2 answers displayed here

returnbothsameanswers:			

popa
pop bp
ret 2							; function ends here

; simple if else for both same answers

bothsameanswers:
cmp ax,1						; if both are correct
jne nextsameanscmp
call bothcorrect_fun				; print both correct
jmp returnbothsameanswers

nextsameanscmp:				; if both are wrong
cmp ax, 0
jne nextsameanscmp1
call bothwrong_fun				; print both wrong
jmp returnbothsameanswers

nextsameanscmp1:				; else both have swipped
call bothswipe_fun
jmp returnbothsameanswers

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 IS CORRECT
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1correct_fun:				; display player 1 is correct

push bp
mov bp,sp
pusha

xor bx,bx			; bx = 0
mov bl,0x0a				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1correctstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,20					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,17					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 IS CORRECT
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2correct_fun: 			; display player 2 is correct

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0a				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2correctstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,20					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,19					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 IS WORNG
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1wrong_fun:			; display player 1 is wrong

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0c				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1wrongstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,18					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,17					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 IS WRONG
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2wrong_fun:			; display player 2 is wrong

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0c				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2wrongstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,18					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,19					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR BOTH PLAYERS CORRECT
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

bothcorrect_fun:			; display both are correct

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0a				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,bothplayerscorrectstr	; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,21					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,17					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR BOTH PLAYERS WRONG
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

bothwrong_fun:				; display both are wrong

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0c				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,bothplayerswrongstr	; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,19					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,17					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR BOTH PLAYERS SWIPPED
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

bothswipe_fun:				; display both players have swipped

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x01				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,bothplayersswipestr	; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,21					; size of string
push ax				; Pushing a Parameter into the stack
mov al,20					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,17					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR CURRENT STATISTICS
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

statistics_fun:				; display statistics of game

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0e				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,statistics			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,18					; size of string
push ax				; Pushing a Parameter into the stack
mov al,30					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,15					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 HAS SWIPPED
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1swipe_fun:				; display player 1 has skipped

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x01					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1swipestr			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,20						; size of string
push ax				; Pushing a Parameter into the stack
mov al,20						; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,17						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 HAS SWIPPED
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2swipe_fun:				; display player 2 has skipped

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x01					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2swipestr			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,20						; size of string
push ax				; Pushing a Parameter into the stack
mov al,20						; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,19						; row
push ax					; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 SCORE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1score_fun:				; display player 1 score

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0f					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1scorestr1			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,17						; size of string
push ax				; Pushing a Parameter into the stack
mov al,20						; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,21						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;-----------------------------------------------
mov dx,3434					; print score loc
push dx
mov dx,[cs:player1score]			; print score
push dx
call printnum
;-----------------------------------------------

xor bx,bx			; Making bx = 0
mov bl,0x0f					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1scorestr2			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,11						; size of string
push ax				; Pushing a Parameter into the stack
mov al,40						; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,21						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;-----------------------------------------------
mov dx,3456					; print total questions loc
push dx
mov dx,[cs:totalquestions]			; print total questions
push dx
call printnum
;-----------------------------------------------

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 SCORE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2score_fun:				; display player 2 score

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x0f					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2scorestr1			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,17						; size of string
push ax				; Pushing a Parameter into the stack
mov al,20						; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,23						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;-----------------------------------------------
mov dx,3754					; player 2 score loc
push dx
mov dx,[cs:player2score]			; player 2 score
push dx	
call printnum
;-----------------------------------------------

xor bx,bx			; Making bx = 0
mov bl,0x0f					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2scorestr2			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,11						; size of string
push ax				; Pushing a Parameter into the stack
mov al,40						; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,23						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;-----------------------------------------------
mov dx,3776					; player 2 total questions loc
push dx
mov dx,[cs:totalquestions]			; player 2 total questions
push dx
call printnum
;-----------------------------------------------

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYERS LIVES
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

playerslives_fun:			; display both players lives

push bp
mov bp,sp
pusha
						; player 1 live display
xor bx,bx			; Making bx = 0
mov bl,0x0f				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1livesstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,17					; size of string
push ax				; Pushing a Parameter into the stack
mov al,10					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,4					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;-----------------------------------------------
mov dx,696				; player 1 lives loc
push dx
mov dx,[cs:player1lives]		; player 1 lives
push dx
call printnum
;-----------------------------------------------
						; display player 2 lives
xor bx,bx				; Making bx = 0
mov bl,0x0f				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2livesstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,17					; size of string
push ax				; Pushing a Parameter into the stack
mov al,50					; coloumn
push ax					; Pushing a Parameter into the stack
mov ax,4					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;-----------------------------------------------
mov dx,774				; player 2 lives loc
push dx
mov dx,[cs:player2lives]		; player 2 lives
push dx
call printnum
;-----------------------------------------------

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 WON
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1won_fun:			; display player 1 won

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x1a				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1winstr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,32					; size of string
push ax				; Pushing a Parameter into the stack
mov al,104				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,11					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 WON
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2won_fun:		; display player 2 won here

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x1a			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2winstr	; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,32				; size of string
push ax				; Pushing a Parameter into the stack
mov al,104			; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,12				; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 LOST
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1lost_fun:			; display player 2 lost

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x1c				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1losestr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,22					; size of string
push ax				; Pushing a Parameter into the stack
mov al,104				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,11					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 LOST
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2lost_fun: 			; display player 2 lost

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x1c				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2losestr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,22					; size of string
push ax				; Pushing a Parameter into the stack
mov al,104				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,12					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR DRAW GAME
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

draw_fun:					; display both have a draw

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x1e				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,drawstr	; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,24					; size of string
push ax				; Pushing a Parameter into the stack
mov al,106				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,11					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 CERTIFICATE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1certificate_fun:			; display player 1 got a certificate

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x2b					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player1crtstr				; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,36						; size of string
push ax				; Pushing a Parameter into the stack
mov al,102					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,19						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 CERTIFICATE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2certificate_fun:			; display player 2 got a certificate

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x2b					; attribute
push bx				; Pushing a Parameter into the stack
mov ax,player2crtstr				; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,36						; size of string
push ax				; Pushing a Parameter into the stack
mov al,102					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,20						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 1 LOST LIVES
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player1lostlives_fun:				; display player 1 lost all lives

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x2b					; attributes
push bx				; Pushing a Parameter into the stack
mov ax,player1loselivestr			; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,23						; size of string
push ax				; Pushing a Parameter into the stack
mov al,108					; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,19						; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR PLAYER 2 LOST LIVES
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

player2lostlives_fun:			; display player 2 lost all lives

push bp
mov bp,sp
pusha

xor bx,bx			; Making bx = 0
mov bl,0x2b				; attributes
push bx				; Pushing a Parameter into the stack
mov ax,player2loselivestr		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,23					; size of string
push ax				; Pushing a Parameter into the stack
mov al,108				; coloumn
push ax				; Pushing a Parameter into the stack
mov ax,20					; row
push ax				; Pushing a Parameter into the stack
call Printing_String

popa
pop bp
ret 

;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
; SUBROUTINE FOR INTRODUCTION PAGE PRINTING
;--------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
Printing_Intro_page:
pusha

;----------------------------------------
; Printing Welcome Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1f				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,introwelcome		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[introwelcomesize]		; size of string
push ax				; Pushing a Parameter into the stack
mov al,106				; coloumn
push ax				; Pushing a Parameter into the stack
mov al,3					; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Instructions Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1e				; attribute
push bx				; Pushing a Parameter into the stack
mov ax,introInstructions		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[introInstructionssize]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,108				; coloumn
push ax				; Pushing a Parameter into the stack
mov al,6					; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Move Instructions 1 Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1d			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,intromove1		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[intromovesize1]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,102			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,8				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Move Instructions 2 Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1b			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,intromove2		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[intromovesize2]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,102 			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,10				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Score Instructions 1 Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1a			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,introscore1		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[introscoresize1]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,102			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,12				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Score Instructions 2 Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x14			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,introscore2		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[introscoresize2]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,102			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,14				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Score Instructions 2 Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x14			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,introscore2		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[introscoresize2]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,102			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,14				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
;----------------------------------------
; Printing Score Instructions 3 Game
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1b			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,intromessage	; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[intromessagesize]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,102			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,16				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
popa
ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR DELAY INTRODUCTION
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

delayintro:
                  push cx			; pushing relevant registers
                  mov cx,0xFFFF
loopintro:					; loops for delay
                  loop loopintro
                  mov cx,0xFFFF
                  pop cx			; popping all registers
                  ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR INTRODUCTION PAGE LAYOUT
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

Layout:				; layout design of intro page graphics
push bp
mov bp,sp
pusha 

mov ax,0xb800			; setting to video mode
mov es,ax
mov dx,0x01db			; color
mov di,124
mov cx,19

layoutouterloop:		; printing Square Box
add di,70
mov ax,di
add ax,90
layoutinnerloop:		; coordinates of printing a box
mov [es:di],dx
add di,2
cmp di,ax
jne layoutinnerloop
loop layoutouterloop
							; PRINTING CORNERS & EDGES
mov di,194				; top-left corner	
mov word[es:di],0x1fc9		; coordinates of printing a box
layouttop:
add di,2
mov word[es:di],0x1fcd		; coordinates of printing a box
cmp di,282
jne layouttop
mov di,282				; top-right  corner	
mov word[es:di],0x1fbb		; coordinates of printing a box
layoutright:
add di,160
mov word[es:di],0x1fba		; coordinates of printing a box
cmp di,3162
jne layoutright
mov di,3162				; bottom-right  corner	
mov word[es:di],0x1fbc		; coordinates of printing a box
layoutbottom:
sub di,2
mov word[es:di],0x1fcd		; coordinates of printing a box
cmp di,3074
jne layoutbottom
mov di,3074				; bottom-left  corner	
mov word[es:di],0x1fc8		; coordinates of printing a box
layoutleft:
sub di,160
mov word[es:di],0x1fba		; coordinates of printing a box
cmp di,354
jne layoutleft
mov di,356				; top-left  corner	
mov word[es:di],0x9ac9		; coordinates of printing a box
layouttop1:
add di,2
mov word[es:di],0x9acd		; coordinates of printing a box
cmp di,440
jne layouttop1
mov di,440				; top-right  corner	
mov word[es:di],0x9abb		; coordinates of printing a box
layoutright1:
add di,160
mov word[es:di],0x9aba		; coordinates of printing a box
cmp di,3000
jne layoutright1
mov di,3000				; bottom-right  corner	
mov word[es:di],0x9abc		; coordinates of printing a box
layoutbottom1:
sub di,2
mov word[es:di],0x9acd		; coordinates of printing a box
cmp di,2916
jne layoutbottom1
mov di,2916				; bottom-left  corner	
mov word[es:di],0x9ac8
layoutleft1:
sub di,160
mov word[es:di],0x9aba		; coordinates of printing a box
cmp di,516
jne layoutleft1
mov di,996
mov word[es:di],0x9ac8		; coordinates of printing a box
layoutmid1:
add di,2
mov word[es:di],0x9acd		; coordinates of printing a box
cmp di,1080
jne layoutmid1
mov word[es:di],0x9abc		; coordinates of printing a box
mov di,1156
mov word[es:di],0x9ac9		; coordinates of printing a box
layoutmid2:
add di,2
mov word[es:di],0x9acd		; coordinates of printing a box
cmp di,1240
jne layoutmid2
mov word[es:di],0x9abb		; coordinates of printing a box

popa
pop bp
ret						; returning function intro layout

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
; SUBROUTINE FOR INTRODUCTION PAGE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

exitintro:
mov word [cs:exitgameflag],1		; is esc is pressed exit
je returnexitintro

Introduction_Page:				; function introduction called first
pusha

call clrscr						; clear screen
call Layout					; layout display
call Printing_Intro_page			; print introduction page

repeatinput:

mov ah,0					; get a key from keyboard
int 0x16
cmp al,0x1B 				; check if its escape
je exitintro

cmp al,0x0d 				; any key other than enter
jne repeatinput				; input again

returnexitintro:

popa
ret 

;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR GAME INTERFACE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

gameinterface:					; display game interface
pusha

 	mov ax,0xb800				; setting video mode
	mov es,ax
	mov di,0
	mov word[es:di],0x0fc9		; printing border  top
	add di,2

	loopscreen1:
	mov word[es:di],0x0fcd		; printing border 
	add di,2
	cmp di,158
	jne loopscreen1

	mov word[es:di],0x0fbb		; printing border right

	add di,160
	loopscreen2:
	mov word[es:di],0x0fba		; printing border 
	add di,160
	cmp di,3998
	jne loopscreen2

	mov word[es:di],0x0fbc		; printing border bottom
	sub di,2
	loopscreen3:
	mov word[es:di],0x0fcd		; printing border 
	sub di,2
	cmp di,3840
	jne loopscreen3

	mov word[es:di],0x0fc8		; printing border left
	sub di,160

	loopscreen4:
	mov word[es:di],0x0fba		; printing border 
	sub di,160
	cmp di,0
	jne loopscreen4

;----------------------------------------
; Printing Game Name
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x0f			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,gamename		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[gamenamesize]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,30				; coloumn
push ax				; Pushing a Parameter into the stack
mov al,1				; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;----------------------------------------
; Printing Game descripton
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x0f			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,gamedesp		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[gamedespsize]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,29				; coloumn
push ax				; Pushing a Parameter into the stack
mov al,2				; row
push ax				; Pushing a Parameter into the stack
call Printing_String
popa
ret

;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
; SUBROUTINE FOR END PAGE LAYOUT
;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------

End_PageLayout:				; displaying end page layout

pusha
mov ax,0xb800					; setting video mode
mov es,ax

mov dx,0x01db					; color
							; starting from 34 coordinate
mov di,1234					; loc
mov cx,7

layoutouterloopep:				; layout box printing
add di,90
mov ax,di
add ax,70
layoutinnerloopep:				; printing edge
mov [es:di],dx
add di,2
cmp di,ax
jne layoutinnerloopep
loop layoutouterloopep
;--------------------------------------- Layout corners & edges printing-------------------------------------------------

mov di,1162						; top-left			
mov word[es:di],0x1ec9				; printing corner
layouttopep:					
add di,2
mov word[es:di],0x1ecd				; printing egde
cmp di,1234
jne layouttopep
mov di,1234						; top-right
mov word[es:di],0x1ebb				; printing corner
layoutrightep:
add di,160
mov word[es:di],0x1eba				; printing egde
cmp di,2514
jne layoutrightep
mov di,2514						; bottom-right
mov word[es:di],0x1ebc				; printing corner
layoutbottomep:
sub di,2
mov word[es:di],0x1ecd				; printing egde
cmp di,2442
jne layoutbottomep
mov di,2442	 					; bottom-left
mov word[es:di],0x1ec8				; printing corner
layoutleftep:
sub di,160
mov word[es:di],0x1eba				; printing egde
cmp di,1322
jne layoutleftep
;------------------------------------BLINKING GAME OVER WITH RED LAYOUT-------------------------------------------
mov di,1324						; top-left
mov word[es:di],0x94c9				; printing corner
layouttopep1:
add di,2
mov word[es:di],0x94cd				; printing egde
cmp di,1392
jne layouttopep1
mov di,1392						; top-right
mov word[es:di],0x94bb				; printing corner
layoutrightep1:
add di,160
mov word[es:di],0x94ba				; printing egde
cmp di,2352
jne layoutrightep1
mov di,2352						; bottom-right
mov word[es:di],0x94bc				; printing corner
layoutbottomep1:
sub di,2
mov word[es:di],0x94cd				; printing egde
cmp di,2284
jne layoutbottomep1
mov di,2284						; bottom-left
mov word[es:di],0x94c8				; printing corner
layoutleftep1:
sub di,160
mov word[es:di],0x94ba				; printing egde
cmp di,1484
jne layoutleftep1
popa
ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR END DISPLAY
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

End_Display:					; display end page content
call End_PageLayout			; display layout
pusha
;----------------------------------------
; Printing Header GAME NAME
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x1f			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,gamename		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[gamenamesize]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,110			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,8				; row
push ax				; Pushing a Parameter into the stack
call Printing_String

;----------------------------------------
; Printing Header EXIT GAME OVER
;----------------------------------------
xor bx,bx			; Making bx = 0
mov bl,0x9c			; attribute
push bx				; Pushing a Parameter into the stack
mov ax,endterminate		; string
push ax				; Pushing a Parameter into the stack
xor ax,ax				; Making Ax = 0
mov al,[endterminatesize]	; size of string
push ax				; Pushing a Parameter into the stack
mov al,112			; coloumn
push ax				; Pushing a Parameter into the stack
mov al,9				; row
push ax				; Pushing a Parameter into the stack
call Printing_String

mov ax,[cs:player1score]		; get scores
mov bx,[cs:player2score]

cmp ax,bx					; comparing both players score

jc player2winend
ja player1winend

call draw_fun				; if its a draw

jmp endend
player1winend:				; if player 1 win

call player1won_fun			; player 1 win
call player2lost_fun			; player 2 lose

jmp endend				; end game

player2winend:				; if player 2 win

call player2won_fun			; player 2 win
call player1lost_fun			; player 1 lost

endend:					; end game

popa
ret

;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
; SUBROUTINE FOR END PAGE
;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------

End_Page:			; display end page
pusha

call clrscr				; clear screen
call End_PageLayout	; display layout
call End_Display		; display end page layout

popa
ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;SUBROUTINE FOR CERTIFICATE
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

certificatelayout:			; display certfictae layout

pusha

mov ax,0xb800				; video mode
mov es,ax

;-------------------------LAYOUT PRINTING-----------------------------------
mov dx,0x02db	; color
mov di,3002				; Printing Box of developer
mov cx,4
layoutouterloop2:			; printing edge line
add di,76
mov ax,di
add ax,84
layoutinnerloop2:			; printing edge line
mov [es:di],dx
add di,2
cmp di,ax
jne layoutinnerloop2
loop layoutouterloop2
;--------------------------------------------------; Printing Corners and edges

mov di,3078					; top-left
mov word[es:di],0xaec9			; printing corner
layouttop2:
add di,2
mov word[es:di],0xaecd			; printing edge
cmp di,3160
jne layouttop2
mov di,3160					; top-right
mov word[es:di],0xaebb			; printing corner
layoutright2:
add di,160
mov word[es:di],0xaeba			; printing edge
cmp di,3640
jne layoutright2
mov di,3640					; bottom-right
mov word[es:di],0xaebc			; printing corner
layoutbottom2:
sub di,2
mov word[es:di],0xaecd			; printing edge
cmp di,3558
jne layoutbottom2
mov di,3558					; bottom-left
mov word[es:di],0xaec8			; printing corner
layoutleft2:
sub di,160
mov word[es:di],0xaeba			; printing edge
cmp di,3238
jne layoutleft2

popa
ret

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;                               MAIN CONTROL PANEL
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

start: 				; MAIN CONTROL PANEL

call hook				; Hook timer 
call clrscr				; clear screen
call delay				; get a bit deley
call Introduction_Page	; call introduction page

cmp word [cs:exitgameflag],1		; check if ESC key is pressed
je terminateprogram

call main_program		; main prgram run
terminateprogram:		; terminate program

mov ax,0x4c00			; termination
int 0x21
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
