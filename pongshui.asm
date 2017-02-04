TITLE        PONGSHUI (EXE)
            .MODEL SMALL
            .STACK 200H
;----------------------------------------------
            .DATA
PADDLE 	    DB   219, '$'                                ;CHARACTER for paddle
BLANK 	    DB   ' ', '$'                                ;BLANK CHARACTER for clearing
INPUT1	    DB   '7'  ,'$'                               ;VAR for storing INPUT of PLAYER 1            
INPUT2 	    DB   50H, '$'                                ;VAR for storing INPUT of PLAYER 2     
DH1 	      DB   10, '$'                                 ;INIT y-position of PLAYER 1
DL1		      DB   37, '$'                                 ;INIT x-position of PLAYER 1
DH2 	      DB   10, '$'                                 ;INIT y-position of PLAYER 2
DL2		      DB   41, '$'                                 ;INIT x-position of PLAYER 2
LENGTH1     DB   6, '$'                                  ;MAX LENGTH for PLAYER 1 paddle
LIMIT1      DB   ?, '$'                                  ;TEMP VAR
LENGTH2     DB   6, '$'                                  ;MAX LENGTH for PLAYER 2 paddle
LIMIT2      DB   ?, '$'                                  ;TEMP VAR
TEMP1    		DB   ?, '$'                                  ;TEMP VAR
TEMP2    		DB   ?, '$'                                  ;TEMP VAR
TEMPC   		DB   ?, '$'                                  ;TEMP VAR
BALL    		DB 	 'o', '$'                                ;CHARACTER for ball
BALLx   		DB   20                                      ;INIT x-position of ball
BALLy   		DB   12                                      ;INIT y-position of ball
SPACE   		DB   ' ', '$'                                ;BLANK CHARACTER for clearing
INC_BALLx 	DB   1                                       ;FLAG if the x-pos of ball will be increased
INC_BALLy 	DB   1                                       ;FLAG if the y-pos of ball will be increased
DELAY_VAL_1 DW 	 003H                                    ;DELAY VAR 1 for ball and paddle
DELAY_VAL_2 DW 	 0D090H                                  ;DELAY VAR 2 for ball and paddle
;DELAY_VAL_2 DW 	 3E80H                                  ;DELAY VAR 2 for ball and paddle
LEAVE_LOOP  DB   0                                       ;FLAG for leaving the loop
PROMPT_1    DB   '		         |    PLAYER 1 WINS!     |      $'           ;STRING for winning the PLAYER 1
PROMPT_2    DB   '		         |    PLAYER 2 WINS!     |      $'           ;STRING for winning the PLAYER 2
BEEPCX      DW   ?
BEEPBX      DB   ?
;-------------------------------------------
HOME	      DB	 'ps-se.txt', 0
GHOST 	    DB 	 'ghost.txt', 0
HOW 	      DB 	 'how.txt', 0
FILE_HANDLE	DW	 ?
ERROR_STR	  DB	 'Error!$'
FILE_BUFFER	DB 	  1896 DUP('$')
LOAD	      DB	 'Loading...$'
COMP	      DB	 'START!....$'
INIT	      DB	  0ah, 0dh, 20 DUP(219), '$'
BAR		      DB	  219, '$'
FLAG	      DB	  0
ARROW	      DB	  175, '$'
EMPTY	      DB	  '$'
ROW		      DB		0
COL		      DB		0
ROWD	 	    DB		6H, '$'
COLD	    	DB		0
;--------------------------------------------
MENU1	 	DB		   '             _____                         ____$'                 
MENU2		DB		   '	    / ____|                       / __ \$'                
MENU3		DB		   '	   | |  __  __ _ _ __ ___   ___  | |  | |    _____ _ __ $'
MENU4		DB		   '	   | | |_ |/ _  | `_ ` _ \ / _ \ | |  | \ \ / / _ \ `__|$'
MENU5		DB		   '	   | |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |$'   
MENU6		DB		   '	    \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|$'   
MENU7		DB			 '		         - - - - - - - - - - - - -$'
MENU8		DB			 '		 	 |                       |$'
MENU10	DB			 '		 	 |                       |$'
MENU11	DB			 '		         - - - - - - - - - - - - -$'
MENU12  DB       '                                             $'
MENU13  DB       '                         Press ENTER to continue...$'

;--------------------------------------------					 
          .CODE
MAIN 		   PROC  FAR
      
				   MOV 	 AX, @DATA
			     MOV   DS, AX 
      
        	 CALL  HIDE_CURSOR
   				 CALL  LOADING
					 CALL   GAME_LOOP
			EXIT:
			    MOV   AX, 4C00H
			    INT   21H
MAIN 			ENDP
;----------------------------------------
L00PM3 		PROC 	NEAR
					JMP 	L00P
L00PM3 		ENDP
;----------------------------------------
WINNER     PROC  NEAR
           CALL  BACKGROUND3
           CALL	 DISP_MENU
WINNER     ENDP
;----------------------------------------
GAME_LOOP  PROC  NEAR
			MAIN_GAME:
				 CALL  DISP_HOME
			     
          RET

GAME_LOOP ENDP
;----------------------------------------
THE_LOOP  PROC  NEAR
          CALL  BACKGROUND2
			    CALL  BACKGROUND1

			    MOV   DH, DH1
				  MOV   DL, DL1
			    CALL  PRINTPADDLE1
			    MOV   DH, DH2
				  MOV   DL, DL2
				  CALL  PRINTPADDLE2
			L00P:
			    CMP   LENGTH1, 0
			    JE    DECLARE_WINNER2
			    CMP   LENGTH2, 0
			    JE    DECLARE_WINNER1
			  	CALL  GETKEY
			  	CMP   TEMP1, 1BH 
				  JE    EXIT
				  CALL  COMPARE

				  CALL  DRAW_BALL
				  CALL  BALL_DELAY
				  CALL  MOVE_BALL
					LOOP  L00P
					
      DECLARE_WINNER1:
          CALL  BACKGROUND4
          CALL	DISP_MENU
          
      DECLARE_WINNER2:
          CALL  BACKGROUND3
          CALL	DISP_MENU
          
THE_LOOP  ENDP
;----------------------------------------
COMPARE 	PROC 	NEAR                        ;PERFORMS comparison on the input of users
					CMP 	INPUT1, '7'                 ;INPUT comparison for PLAYER 1 to GO UP
					JE 		MOVEUP1_temp
					CMP 	INPUT1, '1'                 ;INPUT comparison for PLAYER 1 to GO DOWN
					JE 		MOVEDN1_temp	

					CMP 	INPUT1, '7'
					JNE 	SECOND
					CMP 	INPUT1, '1'
					JNE 	SECOND

			MOVEUP1_temp:
					CALL 	MOVEUP1
					JMP 	SECOND

			MOVEDN1_temp:
					CALL 	MOVEDN1

				SECOND:
					CMP 	INPUT2, 48H                ;INPUT comparison for PLAYER 2 to GO DOWN
					JE 		MOVEUP2_temp
					CMP 	INPUT2, 50H                ;INPUT comparison for PLAYER 2 to GO UP
					JE 		MOVEDN2_temp
					
					JMP   EXIT3

				MOVEUP2_temp:
					CALL  MOVEUP2
					JMP   EXIT3

				MOVEDN2_temp:
					CALL  MOVEDN2

				EXIT3:
					RET
COMPARE 	ENDP
;-------------------------------------------
MOVEUP1 	PROC 	NEAR                           ;MOVES UP the paddle of PLAYER 1
					MOV 	DL, DL1
					MOV 	DH, DH1
					CMP 	DH, 0
					JE 		TURN1
					CALL 	PRINTBLANK1
					DEC 	DH1
					MOV 	DH, DH1
					CALL 	PRINTPADDLE1
					JMP 	l00PUS1
			turn1:
					;mov input1, 's'
					;call movedn1
			L00PUS1:
					RET
MOVEUP1 	ENDP
;-------------------------------------------
MOVEDN1 	PROC 	NEAR                            ;MOVES DOWN the paddle of PLAYER 1
					MOV 	DL, DL1
					MOV 	LIMIT1, 25
					MOV 	CL, LENGTH1
					SUB 	LIMIT1, CL
					MOV 	DH, DH1
					CMP 	DH, LIMIT1
					JE 		TURN2
					CALL 	PRINTBLANK1
					INC 	DH1
					MOV 	DH, DH1
					CALL 	PRINTPADDLE1
					JMP 	l00PUS2
			TURN2:
					;mov input1, 'w'
					;call moveup1
			L00PUS2:
					 RET
MOVEDN1 	 ENDP
;-------------------------------------------
MOVEUP2 	 PROC 	NEAR                           ;MOVES UP the paddle of PLAYER 2
					 MOV 		DL, DL2
					 MOV 		DH, DH2
					 CMP 		DH, 0
					 JE 		TURN3
					 CALL 	PRINTBLANK2
					 DEC 		DH2
					 MOV 		DH, DH2
					 CALL 	PRINTPADDLE2
					 JMP    l00PUS3
			TURN3:
						;mov input2, 50H
						;call movedn2
			L00PUS3:
						RET
MOVEUP2 		ENDP
;-------------------------------------------
MOVEDN2 		PROC 	NEAR                            ;MOVES DOWN the paddle of PLAYER 2
						MOV 	DL, DL2
						MOV 	LIMIT2, 25
						MOV 	CL, LENGTH2
						SUB 	LIMIT2, CL
						MOV 	DH, DH2
						CMP 	DH, LIMIT2
						JE 		TURN4
						CALL 	PRINTBLANK2
						INC 	DH2
						MOV 	DH, DH2
						CALL 	PRINTPADDLE2
						JMP 	l00PUS4
				TURN4:
						;mov input2, 48H
						;call moveup2
				L00PUS4:
						RET
MOVEDN2 		ENDP
;--------------------------------------------
GETKEY 			PROC 	NEAR                             ;GETS the input from either PLAYER 1 or 2
						MOV		AH, 01H		
						INT		16H

						JZ  	LEAVE

						MOV		AH, 00H		
						INT		16H
						MOV 	TEMP1, AL
						CMP 	AH, 48H                          ;UP Input for PLAYER 2
						JE 		PU2                  
						CMP 	AH, 50H                          ;DOWN input for PLAYER 2
						JE 		PU2
						CMP 	AL, '7'                          ;UP input for PLAYER 1
						JE 		PU3
						CMP 	AL, '1'                          ;DOWN input for PLAYER 1
						JE 		PU3
						JMP   LEAVE
				PU2:
						MOV 	INPUT2, AH
						JMP 	LEAVE
				PU3: 
						MOV 	INPUT1, AL
				LEAVE:
					  SUB  AX, AX
						RET
GETKEY 			ENDP
;----------------------------------------------
PRINTPADDLE1 PROC 	NEAR                              ;PRINTS the paddle of PLAYER 1
            
       
						 CALL 	MOVECURSOR
						 MOV 		TEMPC, DH
						 PUSH 	CX
						 MOV 		CX, 0
						 MOV 		CL, LENGTH1

				L00P3:
						 PUSH 	DX
						 MOV		AH,	09 
						 LEA		DX,	PADDLE
						 INT		21H
						 POP 		DX
						 INC 		DH
						 CALL 	MOVECURSOR
					   LOOP 	L00P3

						 POP 		CX
						 MOV 		DH, TEMPC
						 CALL 	MOVECURSOR
						 RET
PRINTPADDLE1 ENDP
;----------------------------------------------
PRINTBLANK1  PROC		NEAR                               ;CLEARS the paddle of PLAYER 1 to its previous
						                                           ;location and length                                        
						 CALL 	MOVECURSOR
						 MOV 		TEMPC, DH
						 PUSH 	CX
						 MOV 		CX, 0
						 MOV 		CL, LENGTH1

				L00P4:
						 PUSH 	DX
						 MOV		AH,	09 
						 LEA		DX,	BLANK
						 INT		21H
						 POP 		DX
						 INC 		DH
						 CALL 	MOVECURSOR
				     LOOP 	L00P4

						 POP 		CX
						 MOV 		DH, TEMPC
						 CALL 	MOVECURSOR
						 RET
PRINTBLANK1  ENDP
;-----------------------------------------------
PRINTPADDLE2 PROC 	NEAR                                 ;PRINTS the paddle of PLAYER 2
						 CALL 	MOVECURSOR
						 MOV 		TEMPC, DH
						 PUSH 	CX
						 MOV 		CX, 0
						 MOV 		CL, LENGTH2

				L00P5:
						 PUSH 	DX
						 MOV		AH,	09 
						 LEA		DX,	PADDLE
						 INT		21H
						 POP 		DX
						 INC 		DH
						 CALL 	MOVECURSOR
					   LOOP 	L00P5

						 POP 		CX
						 MOV 		DH, TEMPC
						 CALL 	MOVECURSOR
						 RET
PRINTPADDLE2 ENDP
;----------------------------------------------- 
PRINTBLANK2 PROC 		NEAR                                  ;CLEARS the paddle of PLAYER 2 to its previous

						CALL 		MOVECURSOR                            
						MOV 		TEMPC, DH
						PUSH	  CX
						MOV 		CX, 0
						MOV 		CL, LENGTH2
				L00P6:
						PUSH 		DX
						MOV			AH,	09 
						LEA			DX,	BLANK
						INT			21H
						POP		  DX
						INC     DH
						CALL 		MOVECURSOR
						LOOP 		L00P6
						POP 		CX
						MOV 		DH, TEMPC
						CALL 		MOVECURSOR
						RET
PRINTBLANK2 ENDP
;----------------------------------------------
MOVECURSOR 	PROC 		NEAR
						MOV 		AH, 02H
						MOV 		BH, 00
						INT 		10H
						RET
MOVECURSOR 	ENDP
;----------------------------------------------
BACKGROUND1 PROC 		NEAR
						MOV 		AX, 0600H
						MOV 		BH, 0CH
						MOV 		CX, 0027H
						MOV 		DX, 184FH
						INT 		10H
						RET
BACKGROUND1 ENDP
;----------------------------------------------
BACKGROUND2 PROC 		NEAR
						MOV 		AX, 0600H
						MOV 		BH, 09H
						MOV 		CX, 0000H
						MOV 		DX, 184FH
						INT 		10H
						RET
BACKGROUND2 ENDP
;----------------------------------------------
BACKGROUND3 PROC 		NEAR
						MOV 		AX, 0600H
						MOV 		BH, 0CH
						MOV 		CX, 0000H
						MOV 		DX, 184FH
						INT 		10H
						RET
BACKGROUND3 ENDP
;----------------------------------------------
BACKGROUND4 PROC 		NEAR
						MOV 		AX, 0600H
						MOV 		BH, 09H
						MOV 		CX, 0000H
						MOV 		DX, 184FH
						INT 		10H
						RET
BACKGROUND4 ENDP
;----------------------------------------------
HIDE_CURSOR PROC    NEAR
			      MOV CX, 2000H
			      MOV AH, 01H
			      INT 10H
			      RET
HIDE_CURSOR ENDP
;----------------------------------------------
DRAW_BALL   PROC    NEAR
            PUSH    AX
            PUSH    BX
            PUSH    DX

            MOV 		AH, 02H
						MOV			BH, 00
						MOV     DH, BALLy
						MOV			DL, BALLx
						INT			10H
            


						MOV 	  AH, 09H
						LEA 	  DX, BALL
						INT 	  21H
						POP     DX
            POP     BX
            POP     AX
						RET
DRAW_BALL   ENDP
;----------------------------------------------
MOVE_BALL   PROC    NEAR
            PUSH    AX
            PUSH    BX
            PUSH    DX

            MOV 		AH, 02H
						MOV			BH, 00
						MOV     DH, BALLy
						MOV			DL, BALLx
						INT			10H

						MOV 	  AH, 09H
						LEA 	  DX, SPACE                           ;CLEARS the ball on its previous position 
						INT 	  21H
            
            POP     DX
            POP     BX
            POP     AX

						CALL    CHECK_BORDER
						CMP     INC_BALLx, 1
						JE      INCBALLx
						CMP     INC_BALLx, 0
						JE      DECBALLx
      INCBALLx: 
            INC     BALLx
            CMP     INC_BALLy, 1
            JE      INCBALLy
            CMP     INC_BALLy, 0
            JE      DECBALLy
            RET
      DECBALLx: 
            DEC     BALLx
            CMP     INC_BALLy, 1
            JE      INCBALLy
            CMP     INC_BALLy, 0
            JE      DECBALLy
            RET
      INCBALLy:
            INC     BALLy
            RET
      DECBALLy:
            DEC     BALLy
            RET 

					  RET
MOVE_BALL   ENDP
;----------------------------------------------
BALL_DELAY  PROC    NEAR
	          MOV     CX, 003H
	    DELREP: 
	           PUSH    CX
	           MOV     CX, DELAY_VAL_2
	    DELREC: 
	           DEC     CX
	           JNZ     DELREC
	           POP     CX
	           DEC     CX
	           JNZ     DELREP
             SUB     CX, CX
	           RET
BALL_DELAY  ENDP
;----------------------------------------------
CHECK_BORDER  PROC   NEAR
              CALL   CHECK_LEFT
              CALL   CHECK_RIGHT
              CALL   CHECK_TOP
              CALL   CHECK_DOWN
              RET
CHECK_BORDER  ENDP
;----------------------------------------------
CHECK_TOP    PROC    NEAR
             CMP     BALLy, 00H                    ;CHECKS the y-position of the ball if is on the 
             JE      SET_BALL_DIRECTION1           ;topmost already
             RET

        SET_BALL_DIRECTION1:
             CALL    BEEP_1
             MOV     INC_BALLy, 1                  ;SETS the y-coord of ball to increase or go down
             RET
CHECK_TOP    ENDP
;----------------------------------------------
CHECK_DOWN   PROC    NEAR
             CMP     BALLy, 18H                     ;CHECKS the y-position of the ball if is on the 
             JE      SET_BALL_DIRECTION2            ;bottommost already
             RET

        SET_BALL_DIRECTION2:
             CALL    BEEP_2
             MOV     INC_BALLy, 0                   ;SETS the y-coord of ball to decrease or go up
             RET
CHECK_DOWN   ENDP
;----------------------------------------------
CHECK_LEFT   PROC    NEAR        
             CMP     BALLx, 0                       ;CHECKS if the x-position of ball is zero or on the
             JE      SET_BALL_DIRECTION3            ;leftmost border of the screen
             CMP     BALLx, 38                      ;CHECKS if the x-position of paddle of PLAYER 1 is equal
             JE      BOUNCE_BALL_3AA                ;to the x-position + 1 of the ball 
             CMP     BALLx, 42                      ;CHECKS if the x-position of the paddle of PLAYER 2 is
             JE      BOUNCE_BALL_3AB                ;equal to the x-position + 1 of the ball
             RET

        SET_BALL_DIRECTION3: 
        	   MOV 		 BALLx,  79 										;SETS the x-position of the ball to the rightmost side
             RET
        BOUNCE_BALL_3AA:
            MOV      CL, DH1                        ;CHECKS if the y-position of the ball is above or 
            CMP      BALLy, CL                      ;equal the y-position of the paddle of PLAYER 1
            JAE      FINALBOUNCE_3AA
            RET
        BOUNCE_BALL_3AB:
            MOV      CL, DH2                        ;CHECKS if the y-position of the ball  is above or
            CMP    	 BALLy, CL                      ;equal the y-position of the paddle of PLAYER 2
            JAE      FINALBOUNCE_3AB
            RET
       	FINALBOUNCE_3AA:
	   			  ADD      CL, LENGTH1                    ;CHECKS if the y-position of the ball is within the 
	   			  CMP      BALLy, CL                      ;current length of the paddle of PLAYER 1  
	   			  JB       SET_BALL_DIRECTION3A
          	RET
	      FINALBOUNCE_3AB:
   			    ADD      CL, LENGTH2                    ;CHECKS if the y-position of the ball is within the
   			    CMP      BALLy, CL                      ;current length of the paddle of PLAYER 2
   			    JB       SET_BALL_DIRECTION3b
	          RET
	      SET_BALL_DIRECTION3A:
		         CALL 	 INCPAD1                        ;PLAYER 1 hit the ball so it will be increased by 1
             CALL    BEEP_1
		         MOV     INC_BALLx, 1                   ;SETS the x-position of the ball to increase
		         CMP     DELAY_VAL_2, 2710H
		         JAE     SUB_DELAY1B
		         RET
		    SET_BALL_DIRECTION3B:
		         CALL    INCPAD2                        ;PLAYER 2 hit the ball so it will increased by 1
		         CALL    BEEP_2
		         MOV     INC_BALLx, 1                   ;SETS the x-position of the ball to increase
		         CMP     DELAY_VAL_2, 2710H
		         JAE     SUB_DELAY1B
		         RET
		    SUB_DELAY1B:
              SUB    DELAY_VAL_2, 7D0H
              RET
CHECK_LEFT  ENDP
;----------------------------------------------
CHECK_RIGHT   PROC    NEAR
		         	CMP     BALLx, 80                     ;CHECKS if the x-position of ball is 80 or on the
			        JE      SET_BALL_DIRECTION4           ;rightmost border of the screen
			        CMP     BALLx, 36                     ;CHECKS if the x-position of paddle of PLAYER 1 is equal
			        JE      BOUNCE_BALL_4AA               ;to the x-position - 1 of the ball 
			        CMP 	  BALLX, 40                     ;CHECKS if the x-position of the paddle of PLAYER 2 is
			        JE      BOUNCE_BALL_4AB               ;equal to the x-position - 1 of the ball
			        RET

		        SET_BALL_DIRECTION4:
		        	MOV     BALLx, 1                      ;SETS the x-position of the ball to the leftmost side
		          RET
		        BOUNCE_BALL_4AA:
		          MOV     CL, DH1                       ;CHECKS if the y-position of the ball is above or   
		          CMP     BALLy, CL                     ;equal the y-position of the paddle of PLAYER 1
		          JAE     FINALBOUNCE_4AA
		          RET
		        BOUNCE_BALL_4AB:
		          MOV     CL, DH2                       ;CHECKS if the y-position of the ball  is above or
		          CMP     BALLy, CL                     ;equal the y-position of the paddle of PLAYER 2
		          JAE     FINALBOUNCE_4AB
		          RET
		        FINALBOUNCE_4AA:      		
		       		ADD 		CL, LENGTH1                   ;CHECKS if the y-position of the ball is within the
		       		CMP  		BALLy, CL      						    ;current length of the paddle of PLAYER 1  
		       		JB    	SET_BALL_DIRECTION4A
			        RET
			      FINALBOUNCE_4AB:
		       		ADD     CL, LENGTH2                   ;CHECKS if the y-position of the ball is within the
		       		CMP     BALLy, CL                     ;current length of the paddle of PLAYER 2
		       		JB      SET_BALL_DIRECTION4b
			        RET
		        SET_BALL_DIRECTION4A:
		          CALL    INCPAD1                       ;PLAYER 1 hit the ball so it will be increased by 1
		          CALL    BEEP_1
		          MOV     INC_BALLx, 0                  ;SETS the x-position of the ball to decrease
		          CMP     DELAY_VAL_2, 2710H
		          JAE     SUB_DELAY1A
		          RET
		        SET_BALL_DIRECTION4B:
			  		  CALL    INCPAD2                       ;PLAYER 2 hit the ball so it will be increased by 1
			  		  CALL    BEEP_2
			  		  MOV     INC_BALLx, 0                  ;SETS the x-position of the ball to decrease
			  		  CMP     DELAY_VAL_2, 2710H
		          JAE     SUB_DELAY1A
			  		  RET
            SUB_DELAY1A:
              SUB    DELAY_VAL_2, 7D0H
              RET
CHECK_RIGHT   ENDP
;----------------------------------------------
INCPAD1       PROC    NEAR
             
              CMP     LENGTH2, 0
              JE      LEAVE_NOWb
		        	MOV 		DL, DL2
		       		MOV     DH, DH2
		       		CALL    PRINTBLANK2                   ;CLEARS the paddle of PLAYER 2 on its previous length
		       		DEC     LENGTH2                       ;DECREASES the paddle of PLAYER 2 
		       		CALL    PRINTPADDLE2                  ;PRINTS the paddle of PLAYER 2 to its new length
              
             
              CMP     LENGTH1, 6
              JAE		  JUST_RETURNb
              CMP     DH1, 0
              JE      PRCD1
              DEC     DH1
          PRCD1:
		       	  MOV     DL, DL1                       
		       		MOV     DH, DH1
		       		INC     LENGTH1                       ;INCREASES the paddle of PLAYER 1
		       		CALL    PRINTPADDLE1                  ;PRINTS the paddle of PLAYER 1 to its new length
              RET
          LEAVE_NOWb:
              MOV LEAVE_LOOP, 1
				    	RET
				  JUST_RETURNb:
              RET
INCPAD1       ENDP
;----------------------------------------------
INCPAD2       PROC    NEAR
					   
			        CMP     LENGTH1, 0
              JE      LEAVE_NOWa
			        MOV     DL, DL1
				    	MOV     DH, DH1
				    	CALL    PRINTBLANK1                  ;CLEARS the paddle of PLAYER 1 on its previous length
				    	DEC     LENGTH1                      ;DECREASES the paddle of PLAYER 1
				    	CALL    PRINTPADDLE1                 ;PRINTS the paddle of PLAYER 1 to its new length
              
              
              CMP     LENGTH2, 6
              JAE     JUST_RETURNa
              CMP     DH2, 0
			        JE      PRCD2
			        DEC     DH2
			    PRCD2:
				    	MOV     DL, DL2
				    	MOV     DH, DH2
				    	INC     LENGTH2                      ;INCREASES the paddle of PLAYER 2
				    	CALL    PRINTPADDLE2                 ;PRINTS the paddle of PLAYER 2 to its new length
				    	RET
          LEAVE_NOWa:
              MOV     LEAVE_LOOP, 1
				    	RET
				  JUST_RETURNa:  
              RET
INCPAD2 		  ENDP
;----------------------------------------
FILE_READ			PROC		NEAR
							MOV			AX, 3D02H											;OPEN FILE
							INT			21H
							JC			_ERROR
							MOV			FILE_HANDLE, AX
							
							MOV			AH, 3FH												;READ FILE
							MOV			BX, FILE_HANDLE
							MOV			CX, 1896
							LEA			DX, FILE_BUFFER
							INT			21H
							JC			_ERROR
							
							MOV			DX, 0500H											;DISPLAY FILE
							CALL 		SET_CURS
							LEA			DX, FILE_BUFFER
							CALL 		DISPLAY

							MOV 		AH, 3EH         							;CLOSE FILE
							MOV 		BX, FILE_HANDLE
							INT 		21H
							JC 			_ERROR

							RET

			 _ERROR:		
			        LEA			DX, ERROR_STR									;ERROR IN FILE OPERATION
							CALL 		DISPLAY
							RET
				BK:			
				      RET
FILE_READ			ENDP
;---------------------------------------------
LOADING 			PROC 		NEAR
							CALL 		CLS
							LEA 		DX, GHOST
							CALL 		FILE_READ

							MOV			ROW, 22
							MOV			COL, 23H
				SCRN:		
				      CALL		SET_CURS
							CMP			FLAG, 0		;check flag if done loading or not
							JE			START
							CMP			FLAG, 1
							JE			MENU
							
				START:		
				      LEA			DX, LOAD	;print loading
							JMP			SET
							
				SET:		
				      CALL		SET_SCRN	;loading bar
							CMP			FLAG, 1		;exit if complete
							JE			BACK
							MOV			FLAG, 1		;reset screen if complete
							JMP			SCRN

				MENU:		
				      CALL		SET_CURS	;display if done loading
							LEA			DX, COMP
							CALL		DISPLAY
							
				BACK:		
				      MOV			AH, 00H		;get input
							INT			16H
							RET
LOADING 	    ENDP
;--------------------------------------------------
DISP_HOWTO		PROC		NEAR
							MOV 		ROW, 0
							MOV 		COL, 0
							CALL 		SET_CURS
							CALL		CLS
							LEA			DX, HOW
							CALL		FILE_READ
							MOV			AH, 00H		;get any key input
							INT			16H
							JMP    DISP_HOME
					    RET
DISP_HOWTO		ENDP
;-----------------------------------------
DISP_HOME			PROC		NEAR												;DISPLAY MENU SCREEN
							MOV 		ROW, 0
							MOV 		COL, 0
							CALL 		SET_CURS
							CALL 		CLS
							LEA 		DX, HOME
							CALL 		FILE_READ
							JMP 		MENU_CH
							RET
DISP_HOME			ENDP
;--------------------------------------------------
MENU_CH				PROC	 	NEAR
              
							MOV			ROW, 22
							MOV			COL, 15
							CALL		SET_CURS
							LEA			DX, ARROW
							CALL		DISPLAY

				CHOOSE:		
				      MOV			AH, 00H		;get input
							INT			16H
							CMP 		AL, 0DH 	;ENTER
							JE			CHOICE
							CMP			AH, 4BH		;LEFT
							JE			LEFT
							CMP			AH, 4DH		;RIGHT
							JE			RIGHT

							JMP			CHOOSE

				RIGHT:		
				      CALL    BEEP_1
				      CMP			COL, 49		;IF RIGHT KEY
							JE			CHOOSE
							CALL		SET_CURS
							LEA			DX, SPACE
							CALL 		DISPLAY
							ADD			COL, 17
							CALL		DISP_ARR

				LEFT:	
				      CALL    BEEP_1	
				      CMP			COL, 15 	;IF LEFT KEY
							JE			CHOOSE
							CALL		SET_CURS
							LEA			DX, SPACE
							CALL 		DISPLAY
							SUB			COL, 17

				DISP_ARR:	
				      CALL		SET_CURS	;DISPLAY ARROW
							LEA			DX, ARROW
							CALL		DISPLAY

							JMP			CHOOSE

				CHOICE:		
				      CMP 		COL, 15		;START GAME
							JE			START_GAME
							CMP 		COL, 32
							JE			HOW_PG
							CMP 		COL, 49
							JE			FIN
							JMP 		CHOOSE

				HOW_PG:	
				      CALL    BEEP_2	
              CALL    DISP_HOWTO
              RET
				FIN:		
				      CALL    BEEP_2
				      CALL		EXIT	;EXIT GAME
				      RET
        START_GAME:
              CALL    BEEP_2
              CALL    THE_LOOP
              RET
        CALL_HOWTO:
              
					
MENU_CH				ENDP
;--------------------------------------------------
SET_SCRN			PROC		NEAR
							CALL		DISPLAY
							LEA			DX, INIT	;print initial bar
							CALL 		DISPLAY
							MOV			CX, 60		;set counter
							
				PRGRS:		
				      CMP			FLAG, 1		
							JE			SKIP		;skip delay if complete
							CALL 		DELAY
				SKIP:		
				      LEA			DX, BAR		;display more bars
							CALL		DISPLAY
							LOOP		PRGRS
							
							RET
SET_SCRN			ENDP
;------------------------------------------------------------
DISPLAY 			PROC		NEAR
							MOV			AH, 09H
							INT			21H
							RET
DISPLAY				ENDP
;------------------------------------------------------------
SET_CURS 			PROC		NEAR
							MOV			AH, 02H
							MOV			BH, 00
							MOV			DH, ROW
							MOV			DL, COL
							INT			10H
							RET
SET_CURS 			ENDP
;------------------------------------------------------------
CLS 					PROC		NEAR			
							MOV			AX, 0600H
							MOV			BH, 04H
							MOV			CX, 0000H
							MOV			DX, 184FH
							INT			10H
							RET
CLS 					ENDP
;-----------------------------------------------
DELAY 				PROC 		NEAR
							MOV     BX, 003H
			
				MAINLP: 	
				      PUSH    BX
            	MOV     BX, 0D090H
			
				SUBLP: 		
				     DEC     BX
             JNZ     SUBLP
             POP     BX
             DEC     BX
             JNZ     MAINLP
			
			       RET
DELAY 			 ENDP
;------------------------------------------------------------
DISP_MENU	PROC	NEAR
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU1
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU2
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU3
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU4
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU5
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU6
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU7
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU8
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
      CMP   LENGTH1, 0
      JE    P2_WINS
      CMP   LENGTH2, 0
      JE    P1_WINS
  P1_WINS:
      MOV 	  AH, 09H
			LEA 	  DX, PROMPT_1                         
			INT 	  21H
			JMP     JUMP_HERE
  P2_WINS:
      MOV 	  AH, 09H
			LEA 	  DX, PROMPT_2                        
			INT 	  21H
     
  JUMP_HERE:
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU10
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU11
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU12
			CALL	DISPLAY
			ADD		ROWD, 1H
			CALL	SET_CURSD
			LEA		DX, MENU12
			CALL	DISPLAY
		  ADD		ROWD, 1H
			CALL	SET_CURSD
			CALL  COMBI1  
			LEA		DX, MENU13
			CALL	DISPLAY
			;CALL  COMBI1
	ASK_INPUT:
			MOV   AH, 00H
			INT   16H
      CMP   AL, 0DH
      JE    RET_A
      JMP   ASK_INPUT
			RET

  RET_A:
      CALL  RESET_DATA
      CALL  GAME_LOOP
      RET
DISP_MENU	ENDP
;------------------------------------------------------------
SET_CURSD PROC	NEAR
			MOV		AH, 02H
			MOV		BH, 00
			MOV		DH, ROWD
			MOV		DL, COLD
			INT		10H
			RET
SET_CURSD ENDP
;------------------------------------------------------------
RESET_DATA   PROC    NEAR                                                ;RESETS the data for next game                  
             MOV     DH1, 10
             MOV     DL1, 37
             MOV     DH2, 10
             MOV     DL2, 41
             MOV     LENGTH1, 6
             MOV     LENGTH2, 6
             MOV     BALLx, 20
             MOV     BALLy, 12
             MOV     INC_BALLx, 1
             MOV     INC_BALLy, 1
             MOV     LEAVE_LOOP, 0
             MOV     INPUT1, '7'
             MOV     INPUT2, 50H
             MOV     FLAG, 0
             MOV     ROWD, 6H
             MOV     COLD, 0
             MOV     ROW, 0
             MOV     COL, 0
             MOV     DELAY_VAL_2, 0D090H 
             RET
RESET_DATA   ENDP
;------------------------------------------------------------
BEEP_1       PROC    NEAR                                               ;PRODUCES beep for each bounce of the ball
             MOV	AL, 182
						 OUT 43H, AL
						 MOV AX, 4304
						;MOV AX, 3224


						 OUT	42H, AL
						 MOV AL, AH
						 OUT 42H, AL
						 IN AL, 61H

						 OR AL, 00000011B
						 OUT 61H, AL
						 MOV BEEPBX, 25

						.PAUSE1a:
						 MOV BEEPCX, 2900
						.PAUSE2a:
						 DEC BEEPCX
						 JNE .PAUSE2a
						 DEC BEEPBX
						 JNE .PAUSE1a
						 IN AL, 61H

						 AND AL, 11111100B
						 OUT 61H, AL
						 RET
BEEP_1       ENDP
;--------------------------------------------------------------
BEEP_2       PROC     NEAR                                          ;PRODUCES beep for each bounce of the ball
             MOV	AL, 182
						 OUT 43H, AL
						;MOV AX, 4304
						 MOV AX, 3224


						 OUT	42H, AL
						 MOV AL, AH
						 OUT 42H, AL
						 IN AL, 61H

						 OR AL, 00000011B
						 OUT 61H, AL
						 MOV BEEPBX, 25

						.PAUSE1b:
						 MOV BEEPCX, 2900
						.PAUSE2b:
						 DEC BEEPCX
						 JNE .PAUSE2b
						 DEC BEEPBX
						 JNE .PAUSE1b
						 IN AL, 61H

						 AND AL, 11111100B
						 OUT 61H, AL
						 RET
BEEP_2       ENDP
;--------------------------------------------------------------
MUSIC       PROC   NEAR                                             ;PRODUCES music for the gameover screen
						MOV   AL, 182
						OUT 43H, AL

						OUT	42H, AL
						MOV AL, AH
						OUT 42H, AL
						IN AL, 61H

						OR AL, 00000011B
						OUT 61H, AL
						MOV BEEPBX, 25

						;-DELAY TO MAKE THE BEEP LONGER
						.PAUSE1:
						.PAUSE2:
						DEC BEEPCX
						JNE .PAUSE2
						DEC BEEPBX
						JNE .PAUSE1
						IN AL, 61H

						AND AL, 11111100B
						OUT 61H, AL
						RET
MUSIC       ENDP
;--------------------------------------------------------------
COMBI1     PROC   NEAR                                        ;MUSIC COMBINATION 1
		       MOV   AX, 2152
					 MOV   BEEPCX, 500
					 CALL  MUSIC 
					 MOV   AX, 3403
					 MOV   BEEPCX, 10
					 CALL  MUSIC  
					 MOV   AX, 3224
					 MOV   BEEPCX, 1
					 CALL  MUSIC 
					 MOV   AX, 3416
					 MOV   BEEPCX, 10	 
					 CALL  MUSIC  
					 MOV   AX, 3834
					 MOV   BEEPCX, 10	 
					 CALL  MUSIC 
					 RET
COMBI1     ENDP
;--------------------------------------------------------------
COMBI2    PROC    NEAR                                       ;MUSIC COMBINATION 2
				  MOV     AX, 3043
				  MOV     BEEPCX, 1
				  CALL    MUSIC 		
				  RET
COMBI2    ENDP
;--------------------------------------------------------------
          END 				 MAIN
