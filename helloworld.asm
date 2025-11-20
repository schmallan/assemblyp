extern ExitProcess
extern GetStdHandle
extern WriteConsoleA
extern WriteFile



section .data ;variables
;DB automatically allocates space for variables
        newline: db 10
        message: db "Hello World!";

      ;  currentDig: db 0;

section .text           ; code section.
global main		; standard gcc entry point

main:
push rbp
mov rbp, rsp
sub rsp, 10*16

mov rdx, message
call printADR_;

mov rsp, rbp;
pop rbp;
ret

test:
        push rbp
        mov rbp, rsp
        sub rsp, 10*16

        mov rbx, 0
        touterloop:

                mov r13, rsp
                sub r13, msg
                mov [r13], 'h'
                mov rdx, msg
                mov r8, 5
                call printADR_

        inc rbx
        cmp rbx, 5
        jl touterloop

        mov rsp, rbp;
        pop rbp;
        ret

zelensky:	
        push rbp
        mov rbp, rsp
        sub rsp, 10*16;

        mov r13,0
        outerloop:
               mov r14, msg;
               add r14, r13
                mov r15,[r14]
                mov rbx, r15;
                sub rbx, 10;
        ;        add rbx, r14;
            ;    sub rbx, 20
                myloop:      
                        inc rbx;       
                        mov rdx, msg  
                        mov r8, r13
                        call printADR_;

                        
                        mov rdx, rbx
                        mov r8, 1
                        call printVAL_;


                        
                        
                        call endl_
            
                ;mov rcx, 'x';
                cmp rbx, r15;
                jl myloop

        inc r13,
        cmp r13, len
        jl outerloop

                ;call ExitProcess 
                ;add rsp, 48; //return stack space      
                ;mov rax, 99; //return code!! works!! when i do %errorlevel% it shows 99. interesting
                ;if i dont set an exit code myself, the exit code will be the last exit code (in this case from writefile)
              ;  call WriteConsoleA
              
                mov rax, 0;

        mov rsp, rbp;
        pop rbp;
        ret
;

endl_:
        push rbp
        mov rbp, rsp
        sub rsp, 16*4;

                mov r8,1
                mov rdx, newline
                call printADR_
                        
        mov rsp, rbp;
        pop rbp;
        ret;
;

; RDX in: pointer to message 2 be written
; R8  in: number of char to write
printADR_:
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

printVAL_:
        push rbp
        mov rbp, rsp
        sub rsp, 16*4;
        push r13

        
        mov r13, [rdx]
        mov rdx, r13

        call printADR_

        pop r13
        mov rsp, rbp;
        pop rbp;
        ret;
;


        