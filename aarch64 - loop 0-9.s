.text
.globl    _start
start = 0
max = 10
_start:
        mov     x19, start
loop:
        adr     x1, msg
        mov     x2, len
        mov     x0, 1
        mov     x8, 64
        svc     0
        add     x19, x19, 1
        mov     x20, x19
        add     x20, x20, '0'
        adr     x21, msg
        strb    w20, [x21,6]
        cmp     x19, max
        bne     loop
        mov     x0, 0
        mov     x8, 93
        svc     0
.data
        msg: .ascii  "Loop: 0\n"
        len = . - msg
