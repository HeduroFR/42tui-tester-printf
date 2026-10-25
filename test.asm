section .note.GNU-stack noalloc noexec nowrite progbits

section .text
global  fake_ft_printf

%define NSTACK 32
%define REGS   (NSTACK*8)

fake_ft_printf:
    push    rbp
    mov     rbp, rsp
    sub     rsp, REGS+48

    mov     r10, rdx
    mov     r11, rsi
    mov     eax, [r11]
    mov     r8,  [r11+16]
    mov     r9,  [r11+8]
    xor     ecx, ecx

.next:
    cmp     eax, 48
    jae     .from_overflow
    mov     rdx, [r8+rax]
    add     eax, 8
    jmp     .store
.from_overflow:
    mov     rdx, [r9]
    add     r9, 8

.store:
    cmp     ecx, 5
    jae     .store_stack
    mov     [rsp+REGS+rcx*8], rdx
    jmp     .inc
.store_stack:
    mov     [rsp+rcx*8-40], rdx
.inc:
    inc     ecx
    cmp     ecx, 5+NSTACK
    jne     .next

    mov     rsi, [rsp+REGS]
    mov     rdx, [rsp+REGS+8]
    mov     rcx, [rsp+REGS+16]
    mov     r8,  [rsp+REGS+24]
    mov     r9,  [rsp+REGS+32]
    xor     eax, eax
    call    r10

    leave
    ret
