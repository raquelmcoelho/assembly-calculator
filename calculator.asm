;
; Dupla: Raquel e Yuri
;


SYS_EXIT      equ 1
SYS_READ      equ 3
SYS_WRITE     equ 4

STDIN         equ 0
STDOUT        equ 1

NUM_BYTE_SIZE equ 2
RES_BYTE_SIZE equ 1

EXIT_OPT      equ '0'
SUM_OPT       equ '1'
SUB_OPT       equ '2'
MUL_OPT       equ '3'
DIV_OPT       equ '4'

section .data ;Data segment
  optMsg db 0xA, 'Escolha a sua operação:', 0xA, '0 - Sair', 0xA, '1 - Adição', 0xA, '2 - Subtração', 0xA, '3 - Multiplicação', 0xA, '4 - Divisão', 0xA
  lenOptMsg equ $-optMsg

  exitMsg db 'Obrigado por usar a calculadora!', 0xA
  lenExitMsg equ $-exitMsg

  invalidMsg db 'Opção inválida!', 0xA, 'Tente novamente...', 0xA
  lenInvalidMsg equ $-invalidMsg

  fstNumberMsg db 'Por favor insira o primeiro número: ', 0xA
  lenFstNumberMsg equ $-fstNumberMsg

  scndNumberMsg db 'Por favor insira o segundo número: ', 0xA
  lenScndNumberMsg equ $-scndNumberMsg

  sumMsg db 'O primeiro número mais o segundo é igual a: ', 0xA
  lenSumMsg equ $-sumMsg

  subMsg db 'O primeiro número menos o segundo é igual a: ', 0xA
  lenSubMsg equ $-subMsg

  minusMsg db '-'
  lenMinusMsg equ $-minusMsg

  mulMsg db 'O primeiro número vezes o segundo é igual a: ', 0xA
  lenMulMsg equ $-mulMsg

  divMsg db 'O primeiro número dividido pelo segundo é igual a: ', 0xA
  lenDivMsg equ $-divMsg

  remainderMsg db 0xA, 'O resto da divisão é igual a: ', 0xA
  lenRemainderMsg equ $-remainderMsg

section .bss ;Uninitialized data
  opt  resb NUM_BYTE_SIZE
  num1 resb NUM_BYTE_SIZE
  num2 resb NUM_BYTE_SIZE
  resp resb RES_BYTE_SIZE
  remd resb RES_BYTE_SIZE

section .text ;Code Segment
  global _start

_start:
  READ_OPT:
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, optMsg
  mov edx, lenOptMsg
  int 0x80

  ;Read and store the user input
  mov eax, SYS_READ
  mov ebx, STDIN
  mov ecx, opt
  mov edx, NUM_BYTE_SIZE
  int 0x80

  mov dl, [opt]
  cmp dl, EXIT_OPT
  je EXIT_PROG
  cmp dl, EXIT_OPT
  jl INVALID
  cmp dl, DIV_OPT
  jg INVALID

  READ_NUMS:
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, fstNumberMsg
  mov edx, lenFstNumberMsg
  int 0x80

  ;Read and store the user input
  mov eax, SYS_READ
  mov ebx, STDIN
  mov ecx, num1
  mov edx, NUM_BYTE_SIZE
  int 0x80

  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, scndNumberMsg
  mov edx, lenScndNumberMsg
  int 0x80

  ;Read and store the user input
  mov eax, SYS_READ
  mov ebx, STDIN
  mov ecx, num2
  mov edx, NUM_BYTE_SIZE
  int 0x80

  mov dl, [opt]
  cmp dl, SUM_OPT
  je SUM
  cmp dl, SUB_OPT
  je SUBTRACT
  cmp dl, MUL_OPT
  je MULTIPLY
  cmp dl, DIV_OPT
  je DIVIDE

  SUM:
  ;performs the sum
  ;convert the numbers to decimal
  mov al, [num1]
  sub al, '0'
  mov bl, [num2]
  sub bl, '0'

  ;add the numbers
  add al, bl
  ;store the number in resp
  mov [resp], al

  ;Output the message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, sumMsg
  mov edx, lenSumMsg
  int 0x80

  jmp PRINT_NUMBER

  SUBTRACT:
  ;performs the sub
  ;convert the numbers to decimal
  mov al, [num1]
  sub al, '0'
  mov bl, [num2]
  sub bl, '0'

  cmp al, bl
  jg FIRST_GREATER

  ;sub the numbers
  sub bl, al
  ;convert the numbers to ascii
  add bl, '0'
  ;store the number in resp
  mov [resp], bl

  ;Output the message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, subMsg
  mov edx, lenSubMsg
  int 0x80

  ;Print the minus
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, minusMsg
  mov edx, lenMinusMsg
  int 0x80

  ;Print the resp
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, resp
  mov edx, RES_BYTE_SIZE
  int 0x80

  jmp READ_OPT

  FIRST_GREATER:
  ;sub the numbers
  sub al, bl
  ;convert the numbers to ascii
  add al, '0'
  ;store the number in resp
  mov [resp], al

  ;Output the message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, subMsg
  mov edx, lenSubMsg
  int 0x80

  ;Print the resp
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, resp
  mov edx, RES_BYTE_SIZE
  int 0x80

  jmp READ_OPT

  MULTIPLY:
  ;performs the multiplay
  ;convert the numbers to decimal
  mov al, [num1]
  sub al, '0'
  mov bl, [num2]
  sub bl, '0'

  ;multiply the numbers
  mul bl
  ;store the number in resp
  mov [resp], al

  ;Output the message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, mulMsg
  mov edx, lenMulMsg
  int 0x80

  jmp PRINT_NUMBER

  DIVIDE:
  ;performs the division
  ;convert the numbers to decimal
  mov bl, [num1]
  sub bl, '0'
  mov ah, 0
  mov al, bl
  mov bl, [num2]
  sub bl, '0'

  ;divide the numbers
  div bl
  ;convert the numbers to ascii
  add al, '0'
  ;convert the numbers to ascii
  add ah, '0'
  ;store the number in resp
  mov [resp], al
  ;store the number in remainder
  mov [remd], ah

  ;Output the message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, divMsg
  mov edx, lenDivMsg
  int 0x80

  ;Print the resp
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, resp
  mov edx, RES_BYTE_SIZE
  int 0x80

  ;Output the message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, remainderMsg
  mov edx, lenRemainderMsg
  int 0x80

  ;Print the remainder
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, remd
  mov edx, RES_BYTE_SIZE
  int 0x80

  jmp READ_OPT

  PRINT_NUMBER:
  ;print the numbers the correct way
  mov ah, 0
  mov al, [resp]
  mov bl, 10

  ;divide the numbers
  div bl
  ;convert the numbers to ascii
  add al, '0'
  ;convert the numbers to ascii
  add ah, '0'
  ;store the first digit in resp
  mov [resp], al
  ;store the second digit in remainder
  mov [remd], ah

  mov dl, [resp]
  cmp dl, '0'
  je SECOND_DIGIT

  ;Print the first digit
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, resp
  mov edx, RES_BYTE_SIZE
  int 0x80

  SECOND_DIGIT:
  ;Print the second digit
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, remd
  mov edx, RES_BYTE_SIZE
  int 0x80

  jmp READ_OPT

  INVALID:
  ;Print invalid message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, invalidMsg
  mov edx, lenInvalidMsg
  int 0x80

  jmp READ_OPT

  EXIT_PROG:
  ;Print exit message
  mov eax, SYS_WRITE
  mov ebx, STDOUT
  mov ecx, exitMsg
  mov edx, lenExitMsg
  int 0x80

  ;Exit code
  mov eax, SYS_EXIT
  mov ebx, 0
  int 0x80
