.text
.globl    _start


start = 0
max = 10

_start:

    mov         $start,%r15

loop:

    mov         $len,%rdx
    mov         $msg,%rsi
    mov         $1,%rdi
    mov         $1,%rax
    syscall

    inc         %r15
    mov         %r15,%r14
    add         $'0',%r14
    mov         $num,%r13
    mov         %r14b,(%r13)
    cmp         $max,%r15
    jne         loop

    mov         $0,%rdi
    mov         $60,%rax
    syscall

.section .data
        msg: .ascii  "Loop: 0\n"
        len = . - msg
        num = msg + 6
