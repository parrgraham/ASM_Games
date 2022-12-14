.global _start
_start:

#good starting point def can do some work on this
	
	.equ HT, 0x7478
	.equ LT, 0x3878
	.equ COOL, 0x393F3F38
	.equ KEY_BASE_ADRESS, 0xFF200050
	.equ S_SEGMENT_BASE_ADRESS, 0xFF200020
	.equ PRIVATE_TIMER, 0xFFFEC600
	
	LDR R0, TRY
	LDR R1, =KEY_BASE_ADRESS
	LDR R2, =S_SEGMENT_BASE_ADRESS
	LDR R3, =PRIVATE_TIMER       // R9 has Private Timer
	MOV R8, #0 // Register that holds the number
	MOV R5, #0// R5 holds the number obtanined from player
	LDR R9, NUMBER
	
	B RANDOM_NUMBER
		
	MAIN:
	B CHECK_KEY0

	SUB_MAIN:	
	CMP R5, R8
	BPL DISPLAY_COOL
	BL DISPLAY_HT
	B MAIN
		
	DISPLAY_COOL:
	PUSH {R4,R2}
	CMP R5, R8
	BNE DISPLAY_LT
	LDR R4, =COOL
	STR R4, [R2]
	POP {R4,R2}
	B LOSE			
	
	DISPLAY_HT:
	PUSH {R4,R2}
	LDR R4, =HT
	STR R4, [R2]
	POP {R4,R2}
	MOV PC, LR
	
	DISPLAY_LT:	
	PUSH {R4,R2}
	LDR R4, =LT
	STR R4, [R2]
	POP {R4,R2}
	B MAIN
			
	CHECK_KEY0:	
	LDR R6, [R1]
	CMP R6, #0x1
	BEQ ADD1
	B CHECK_KEY1

	CHECK_KEY1:
	LDR R6, [R1]
	CMP R6, #0x2
	BEQ SUB1
	B CHECK_KEY2	
	
	CHECK_KEY2:
	LDR R6, [R1]
	CMP R6, #0x4
	BEQ ADD10
	B CHECK_KEY3
	
	CHECK_KEY3:
	LDR R6, [R1]
	CMP R6, #0x8
	BEQ SUB10
	B WAIT
	
	WAIT:
	LDR R6, [R1]
	CMP R6, #0
	BEQ WAIT
	B CHECK_KEY0
		
	ADD1:
	ADD R5, R5, #1
	PUSH {R5}
	POP {R5}
	SUBS R0, R0, #1 // Decrement tries
  	BEQ LOSE
	B CHECK_KEY_RELEASE
	
	SUB1:
	SUB R5, R5, #1
	PUSH {R5}
	POP {R5}
	SUBS R0, R0, #1 // Decrement tries
  	BEQ LOSE
	B CHECK_KEY_RELEASE
	
	ADD10:
	ADD R5, R5, #10
	PUSH {R5}
	POP {R5}
	SUBS R0, R0, #1 // Decrement tries
  	BEQ LOSE
	B CHECK_KEY_RELEASE
	
	SUB10:
	SUB R5, R5, #10
	PUSH {R5}
	POP {R5}
	SUBS R0, R0, #1 // Decrement tries
  	BEQ LOSE
	B CHECK_KEY_RELEASE
	
	CHECK_KEY_RELEASE:
	LDR R6, [R1]
	CMP R6, #0
	BNE CHECK_KEY_RELEASE
	B SUB_MAIN
	
	LOSE:
	LDR R0, TRY
	PUSH {R0}
	POP {R0}
	B RANDOM_NUMBER
	
	RANDOM_NUMBER:
	MOV R5, #0
	LDR R8, [R3]
	LSL R9, R9, #1
	EOR R8, R8, R9
	LSR R8, R8, #24
	PUSH {R8,R9,R5}
	POP {R8,R9,R5}	
	B MAIN
	
	
	NUMBER: .word 0b10110011101010111010011001010100
	TRY: .word 30 // Number of clicks you have to guess the number	
		
	.end
