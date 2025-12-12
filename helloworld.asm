extern ExitProcess
extern GetStdHandle
extern WriteConsoleA
extern WriteFile

section .data ;variables
;DB automatically allocates space for variables
        newline: db 10
        speed: equ  300000000

      ;  49*3*10^10 cycles / 156
        tp: db "xxxxxxx"
        m: db 0
        width: equ 40
        height: equ 30
        playW: equ 20
        playH: equ 20
        playX: equ 3
        playY: equ 4
        title: db "TETRIS",0
        tl: equ width*height
        message: db "sybau";

      ;  currentDig: db 0;

section .text           ; code section.
global main		; standard gcc entry point

;250 ·
;176 ░
;177 ▒
;178 ▓ 

cwait:
        push rbp
        mov rbp, rsp
        sub rsp, 4*16

        mov r13, speed
        mov r12, 0
        count:
        inc r12
        cmp r12, r13
        jl count

        mov rsp, rbp;
        pop rbp;
ret

main:
push rbp
mov rbp, rsp
sub rsp, 10*16

mov r14, 0
SupaLoop:

call cwait
inc r14

push r14
call body
pop r14

jmp SupaLoop

mov rax, 8 
mov rsp, rbp;
pop rbp;
ret

body:
        push rbp
        mov rbp, rsp
        sub rsp, 10*16
        push r14
        ;fill canvas
                
                mov rcx, 0 ;bg
                mov rdx, 0
                mov r8, width
                mov r10, height
                mov rbx, 249
                call fill

                mov rcx, playX ;playarea
                mov rdx, playY
                mov r8, playW
                mov r10, playH
                mov rbx, ' '
                call fill

                mov rcx, playX ;leftwall
                dec rcx
                mov rdx, playY
                mov r8, 1
                mov r10, playH
                mov rbx, 186
                call fill
                mov rcx, playX ;rightwall
                add rcx, playW
                mov rdx, playY
                mov r8, 1
                mov r10, playH
                mov rbx, 186
                call fill

                mov rcx, playX ;topwall
                mov rdx, playY
                dec rdx
                mov r8, playW
                mov r10, 1
                mov rbx, 196
                call fill
                mov r13, playX ;upleft
                dec r13
                mov r14, playY
                dec r14
                mov r15, 214
                call setpx
                mov r13, playX ;upright
                add r13, playW
                mov r14, playY
                dec r14
                mov r15, 183
                call setpx
                mov rcx, playX ;bottomwall
                mov rdx, playY
                add rdx, playH
                mov r8, 20
                mov r10, 1
                mov rbx, 196
                call fill
                mov r13, playX ;downleft
                dec r13
                mov r14, playY
                add r14, playH
                mov r15, 211
                call setpx
                mov r13, playX ;downright
                add r13, playW
                mov r14, playY
                add r14, playH
                mov r15, 189
                call setpx

                mov rcx, width
                dec rcx
                mov rdx, 0
                mov r8, 1
                mov r10, height
                mov rbx, 10
                call fill

                mov rcx, 0
                mov rdx, 0
                mov r8, width
                mov r10, 1
                mov rbx, 10
                call fill

                mov r13, 1
                mov r14, 1
                mov rdx, title
                call ptoGrid

        
        ;
        
        pop rcx
        call printNum

        mov r13, 0
        mov r14, 1
        mov rdx, tp
        call ptoGrid

        mov rdx, message
        mov r8, tl
        call print_
        ;call printg_

        mov rax, 8 
        mov rsp, rbp;
        pop rbp;
ret

;rcx in - startx
;rdx in - starty
;r8 in - width
;r10 in - height
;rbx in - tofill
fill:
        push rbp
        mov rbp, rsp
        sub rsp, 10*16


        mov r13, r10
        
        mov r11, rcx
        mov r10, 0

        ml:
        cmp rdx, 0
        jz ol
        add r11, width
        dec rdx
        jmp ml
        
        ol:

        mov r12, 0
        il:

        mov rdx, message
        add rdx, r11
        add rdx, r12
        mov [rdx], bl

        inc r12
        cmp r12, r8
        jl il

        add r11, width
        inc r10
        cmp r10, r13
        jl ol


        mov rsp, rbp;
        pop rbp;
ret

setpx:
  push rbp
  mov rbp, rsp
  sub rsp, 16*4;

  call calcAdr
  mov [r13], r15b
  
  mov rsp, rbp
  pop rbp
ret

;r13, r14 x and y
;rdx zero terminated string
ptoGrid:
  push rbp
  mov rbp, rsp
  sub rsp, 16*4;
  push rdx
  call calcAdr
  pop rdx
  tzLoop:
  mov bl, [rdx]
  cmp bl, 0
  jz esc

  mov [r13], bl

  inc r13
  inc rdx
  jmp tzLoop
  esc:

  mov rsp, rbp
  pop rbp
 ret

;r13 x
;r14 y
;r13 out
calcAdr:
  push rbp
  mov rbp, rsp
  sub rsp, 16*4;

  mloop:
  cmp r14, 0
  jz ae
  add r13, width
  dec r14
  jmp mloop


  ae:

  mov rdx, message
  add r13, rdx

  mov rsp, rbp
  pop rbp
 ret


printg_:
  push rbp
  mov rbp, rsp
  sub rsp, 16*10;

        mov r13, 0
        mov r14, message
        sloop:
        mov rdx, r14
        mov r8, width
        call print_
        call endl_
        inc r13
        add r14, width
        cmp r13, height
        jnz sloop

  mov rsp, rbp;
  pop rbp;
ret;

endl_:
        push rbp
        mov rbp, rsp
        sub rsp, 16*4;

                mov r8,1
                mov rdx, newline
                call print_


        mov rsp, rbp;
        pop rbp;
ret;

; RDX in: pointer to message 2 be written
; R8  in: number of char to write
print_:
        push rbp
        mov rbp, rsp
        sub rsp, 16*4;
                        
                mov rcx, -11;
                ; RCX in: enum for handle to get (-11 for std output handle)
                call GetStdHandle
                ; RAX out: handle
                mov rcx, rax;   
                ;mov rdx, msg;
                ;mov r8, len;
                ; RCX in: handle to output buffer
                ; RDX in: pointer to message 2 be written
                ; R8  in: number of char to write
                call WriteFile;

                ; mov rax, 99

        mov rsp, rbp;
        pop rbp;
        ret;
;

;rcx in - one byte number
printNum:
        push rbp
        mov rbp, rsp
        sub rsp, 32*16

        mov rax, rcx
        mov r13, 0
        nl:
        mov rdx, 0
        mov rbx, 10
        div rbx
        push rdx
        inc r13
        cmp rax,0
        jnz nl

        mov r14, 0
        pl:
        pop r11
        mov rdx, tp
        add rdx, r14
        mov [rdx], '0'
        add [rdx], r11
        dec r13
        inc r14
        cmp r13,0
        jg pl
        mov rdx,tp
        add rdx,r14
        mov [rdx], 0

        mov rax, r12
        mov rsp, rbp;
        pop rbp;
ret