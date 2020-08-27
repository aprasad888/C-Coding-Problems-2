;;=======================================
;; CS 2110 - Fall 2019
;; Homework 7
;;=======================================
;; Name:
;;=======================================

;; In this file, you must implement the 'gcd' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff:
;; don't run this directly by pressing 'RUN' in complx, since there is nothing
;; put at address x3000. Instead, load it and use 'Debug' -> 'Simulate Subroutine
;; Call' and choose the 'gcd' label.


.orig x3000


Halt

gcd
;; Arguments of GCD: integer n, integer m
;;
;; Psuedocode:
;; GCD(n, m):
;;     if n < m:
;;         return GCD(m,n)
;;     if n > m:
;;         return GCD(n - m, m)
;;     else:
;;         return n

;;buildup of stack 
ADD R6, R6, #-4 ;;stack pointer placement
STR R5, R6, #1 ;;old frame pointer placement 
STR R7, R6, #2 ;;return address placement
ADD R5, R6, #0 ;;current frame pointer placement 
ADD R6, R6, #-5 ;;moves stack pointer to save registers 
STR R0, R5, #-1 ;;save register 0
STR R1, R5, #-2 ;;save register 1
STR R2, R5, #-3 ;;save register 2
STR R3, R5, #-4 ;;save register 3
STR R4, R5, #-5 ;;save register 4



LDR R0, R5, #4 ;;loading argument 1 
LDR R1, R5, #5 ;;loading argument 2 

NOT R2, R1 ;;reversing argument 2 (m)
ADD R2, R2, #1 ;;2's complement for argument 2 (-m)
ADD R3, R0, R2 ;; creating n - m 

ADD R3, R3, #0 ;;checks for where to branch to
BRP LOOP1
BRZ LOOP2
BRN CONTINUE

CONTINUE
ADD R6, R6, #-1 ;;to obtain argument 1 within n (stack pointer) 
STR R0, R6, #0  ;;return value storage update (within stack) 
ADD R6, R6, #-1 ;;to obtain argument 2 within n (stack pointer) 
STR R1, R6, #0  ;;return value storage update (within stack) 

;;jump to gcd program 
JSR gcd

LDR R0, R6, #0 ;;to make sure the return value into answer  
STR R0, R5, #3 ;;storing value within frame reference 
ADD R6, R6, #3 ;;for popping  
BRNZP END ;;goes to tearing down stack 


LOOP1
ADD R6, R6, #-1 ;;going up within stack 
STR R1, R6, #0 ;;for obtaining argument 2 in stack 
ADD R6, R6, #-1 ;;going up within stack 
STR R3, R6, #0 ;;storing argument 1 (a - b in stack) 

;;jumping to gcd program 
JSR gcd     

LDR R0, R6, #0 ;;obtaining return value (moved in stack) 
STR R0, R5, #3 ;;frame reference 
ADD R6, R6, #3 ;;for popping return value in stack 
BRNZP END 

LOOP2 
STR R0, R5, 3 ;;for storing the return value frame pointer change 
BRNZP END 

END 
 
;;teardown of stack 
LDR R0, R5, #-1 ;;restoring register 0
LDR R1, R5, #-2 ;;restoring register 1
LDR R2, R5, #-3 ;;restoring register 2
LDR R3, R5, #-4 ;;restoring register 3
LDR R4, R5, #-5 ;;restoring register 4
ADD R6, R5, #0 ;;matching frame and stack pointer 
LDR R5, R6, #1 ;;restoring frame pointer
LDR R7, R6, #2 ;;restoring return address
ADD R6, R6, #3 ;;restoring return value

RET 


; Needed by Simulate Subroutine Call in complx
STACK .fill xF000
.end
