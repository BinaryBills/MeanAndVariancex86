;Author: Binary Bills
;Creation Date: February 14,2022
;Modification Date: February 16,2022
;Purpose: Compute the mean and the variance of data at location RAW, 
;defining the raw data as WORD.
INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data
RAW WORD 10, 12, 8, 17, 9, 22, 18, 11, 23, 7, 30, 22, 19, 60, 71
DIFF WORD 15 Dup(?)
SQUARE WORD 15 Dup(?)
MEAN WORD 0
displayMean BYTE "MEAN: ", 0
displayVariance BYTE "Var: ",0

.code
main PROC
 
;   /************************************************************\
;  /      1) Finding the Mean Given a Set of Data                 \
; /****************************************************************\

mov esi,OFFSET RAW ;1st mem address of RAW
mov ecx,(LENGTHOF RAW) ;Loop Counter
mov ebx,(LENGTHOF RAW) ;Divisor
mov ax, 0 ;Arithmetic reg (add, dividend,etc.)

findSum:
add ax,[esi]
movzx eax,ax ;Converts to 32-bit so it can be used by writeDec
add esi,2 ;Increments by 2 bytes to reach next address
loop findSum

xor edx, edx
div ebx ;Divides whatever is stored in eax
mov MEAN, ax

mov edx, OFFSET displayMean
call WriteString
call WriteDec
CALL crlf ;new line


;   /************************************************************\
;  /   2) Finding the variance given the mean and set of data     \
; /****************************************************************\

;2.1) Calculates the diff between each element in RAW with MEAN
mov esi,OFFSET RAW 
mov edi,OFFSET DIFF
mov ecx,(LENGTHOF RAW)

findDiff:
	mov ax,MEAN
	sub ax,[esi]
	mov [edi],ax
	add esi,2
	add edi,2
loop findDiff


;2.2) SQUARES the results from last step
mov esi, OFFSET DIFF
mov edi,OFFSET SQUARE
mov ecx,(LENGTHOF RAW)

findSQUARE:
mov ax,[esi]
mov bx,ax
mul bx 
mov [edi],ax
add edi,2
add esi,2
loop findSQUARE

;Final Step) SUMS UP ALL OF THE SQUARES FROM LAST STEP
mov esi, OFFSET SQUARE
mov ecx,(LENGTHOF RAW)
mov ax,0

findResult:
  mov bx,[esi]
  add ax,bx
  mov [esi],ax
  add esi,2
loop findResult

mov ebx,(LENGTHOF RAW)
xor edx,edx ;Need to clear dx before dividing
div ebx ;Acts as divisor for whatever is stored in eax, which is 339

mov edx, OFFSET displayVariance 
call WriteString 
call WriteDec 
call crlf

INVOKE ExitProcess,0
main ENDP
END main