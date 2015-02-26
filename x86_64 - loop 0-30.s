.text
.globl  _start


start = 0
max = 31
ten = 10

_start:

        mov     $start,%r15
        mov     $ten,%r14

loop:

        mov     $len,%rdx
        mov     $msg,%rsi
        mov     $1,%rdi
        mov     $1,%rax
        syscall

        inc     %r15
        mov     $0,%rdx
        mov     %r15,%rax
        div     %r14

        mov     $num,%r12
        mov     %rax,%r13
        cmp     $0,%r13
        je      skip
        add     $'0',%r13
        mov     %r13b,(%r12)
skip:
        inc     %r12
        mov     %rdx,%r13
        add     $'0',%r13
        mov     %r13b,(%r12)

        cmp     $max,%r15
        jne     loop

        mov     $0,%rdi
        mov     $60,%rax
        syscall

.section .data
        msg: .ascii  "Loop:  0\n"
        len = . - msg
        num = msg + 6
