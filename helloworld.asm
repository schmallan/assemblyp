extern ExitProcess
extern GetStdHandle
extern WriteConsoleA
extern WriteFile



section .data ;variables
        char: db "x",10,0
        msg: db "Hello world!", 10, 0 ;equ defines a byte (???)
        len: equ $ - msg ; equ defines constant for compiler

section .text           ; code section.

        ; RCX in: enum for handle to get (11 for std output handle)
        ;        call GetStdHandle
        ; RAX out: handle
        ;
        ;        mov rcx, rax;   
        ;        mov rdx, char;
        ;        mov r8, 18;
        ;
        ; RCX in: handle to output buffer
        ; RDX in: pointer to message 2 be written
        ; R8  in: number of char to write
        ;        call WriteFile;


        global main		; standard gcc entry point
        main:	
                push rbp
                mov rbp, rsp
                sub rsp, 48;

                call print_;
                call print_;
                call print_;
                call print_;
                call print_;
                ;call ExitProcess 
                ;add rsp, 48; //return stack space      
                ;mov rax, 99; //return code!! works!! when i do %errorlevel% it shows 99. interesting
                ;if i dont set an exit code myself, the exit code will be the last exit code (in this case from writefile)
              ;  call WriteConsoleA
              
                mov rsp, rbp;
                pop rbp;
                ret


        print_:
                push rbp
                mov rbp, rsp
                sub rsp, 64;
                
                mov rcx, -11;
                ; RCX in: enum for handle to get (-11 for std output handle)
                call GetStdHandle
                ; RAX out: handle
                mov rcx, rax;   
                mov rdx, msg;
                mov r8, len;
                ; RCX in: handle to output buffer
                ; RDX in: pointer to message 2 be written
                ; R8  in: number of char to write
                call WriteFile;

               ; mov rax, 99

                mov rsp, rbp;
                pop rbp;
                ret;
        