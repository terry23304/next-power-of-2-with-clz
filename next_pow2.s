.data
    list: .word 0, 2, 9

.text
main:
    la s0, list
    add s1, x0, x0
    addi s2, x0, 12
test:
    beq s1, s2, exit
    add s3, s0, s1
    lw a0, 0(s3)

    jal ra, next_pow2
    jal ra, print

    addi s1, s1, 4
    j test

next_pow2:
    bne a0, zero, pass
    li a0, 1
    jr ra

pass:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # t0 = 32 - clz(a0)
    jal ra, clz
    li t0, 32
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

    add s2, zero, a0 # x

    srli t0, s2, 1  # x >> 1
    or s2, s2, t0   # x |= (x >> 1)

    srli t0, s2, 2  # x >> 2
    or s2, s2, t0   # x |= (x >> 2)

    srli t0, s2, 4  # x >> 4
    or s2, s2, t0   # x |= (x >> 4)

    srli t0, s2, 8  # x >> 8
    or s2, s2, t0   # x |= (x >> 8)

    srli t0, s2, 16  # x >> 16
    or s2, s2, t0   # x |= (x >> 1)

    srli t0, s2, 1
    li t1, 1431655765
    and t0, t0, t1
    sub s2, s2, t0

    srli t0, s2, 2
    li t1, 858993459
    and t0, t0, t1
    and t1, s2, t1
    add s2, t0, t1

    srli t0, s2, 4
    add t0, t0, s2
    li t1, 252645135
    and s2, t0, t1

    srli t0, s2, 8
    add s2, t0, s2

    srli t0, s2, 16
    add s2, t0, s2

    li a0, 32
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
    jr ra

exit:
    li a7, 10
    ecall