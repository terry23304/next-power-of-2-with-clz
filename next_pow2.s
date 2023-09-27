.data
    list: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
    ans: .word 1, 2, 4, 4, 8, 8, 8, 8, 16, 16

.text
main:
    li a0, 1
    jal ra, next_pow2
    jal print

next_pow2:
    bne a0, zero, pass
    li a0, 1
    jr ra

pass:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # t0 = 64 - clz(a0)
    jal ra, clz
    li t0, 64
    sub t0, t0, a0
    li a0, 1
    sll a0, a0, t0
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

clz:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    li s0, 32 # loop counter
    li s1, 1
    add s2, zero, a0 # x
Loop:
    beq s0, s1, End
    srl t0, s2, s1  # x >> s1
    or s2, s2, t0   # x |= (x >> s1)
    slli s1, s1, 1   # s1 *= 2
    j Loop
End:
    srli t0, s2, 1
    li t1, 1431655765
    and t0, t0, t1
    sub s2, s2, t0

    slli t0, s2, 2
    li t1, 858993459
    and t0, t0, t1
    and t1, s2, t1
    add s2, t0, t1

    slli t0, s2, 4
    add t0, t0, s2
    li t1, 252645135
    and s2, t0, t1

    slli t0, s2, 8
    add s2, t0, s2

    slli t0, s2, 16
    add s2, t0, s2

    li a0, 64
    andi t0 ,s2, 0x7f
    sub a0, a0, t0

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    jr ra

print:
    li a7, 1
    ecall

exit: