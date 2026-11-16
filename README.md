# Compiler Optimizations in C

## Overview

Public repository for COMP-211 Checkoff 3. Exploring compiler optimizations of loop unrolling and dead code elimination with AI. Compiler optimizations are automatic transformations of your code by the compiler such that programs run faster, use less memory, or use less power without changing what the code actually does.

## GCC Optimization Flags

To use compiler optimizations, we can use flags when compiling code in the terminal. The -O flags are default settings provided by GCC, with -O0 being the default, which occurs even with no flag, and -Ofast being the most aggressive optimization setting. -fno-tree-vectorize, -funroll-loops, and -fno-unroll-loops are other optimization flags that are used when compiling the code examples.

## Dead Code Elimination

Dead code elimination removes instructions from a C program that have no impact on its final behavior or output, such as unreachable code or unused variables. It speeds up runtime as it and prevents the CPU from doing useless work. Since the resulting binary and assembly code are smaller, dead code elimination also helps with memory.

### `next_unused` and `next_logged` in [examples.c](compiler-optimizations/program_and_executables/examples.c)

```c
#include <stdio.h>

unsigned next_unused(unsigned x)
{
    unsigned square = x * x;
    (void)square; // Explicitly discard the value.
    return x + 1u;
}

unsigned next_logged(unsigned x)
{
    unsigned square = x * x;
    printf("square = %u\n", square);
    return x + 1u;
}
```

The function next_unused takes in an unsigned integer x, squares it, and assigns the variable square to its value. The value is then explicitly discarded with void to avoid compiler warnings and then returns x plus the unsigned integer 1. Next_logged does the same steps but then uses square by printing it before the function returns.

### Assembly at `-O0` and `-O2`

#### `next_unused` at `-O0` ([excerpt](compiler-optimizations/assembly/examples-O0.s#L14-L19))

```asm
    movl    %edi, -20(%rbp)
    movl    -20(%rbp), %eax
    imull   %eax, %eax
    movl    %eax, -4(%rbp)
    movl    -20(%rbp), %eax
    addl    $1, %eax
```

Looking at the assembly code that we compiled with the default -O0 flag that disables most optimizations, we can see that the imull, or integer multiplication, operation still occurs even though the variable square is never used.

#### `next_unused` at `-O2` ([excerpt](compiler-optimizations/assembly/examples-O2.s#L9-L11))

```asm
    endbr64
    leal    1(%rdi), %eax
    ret
```

However, looking at the resulting assembly code compiled with the -O2 flag, which included optimizations such as dead code elimination, function inlining, and vectorization, we can see that the whole function in assembly instructions does not include the imull call for the unused square variable.

#### `next_logged` at `-O2` ([excerpt](compiler-optimizations/assembly/examples-O2.s#L32-L35))

```asm
    imull   %edi, %edx
    xorl    %eax, %eax
    movl    $2, %edi
    call    __printf_chk@PLT
```

`next_logged` still has the integer multiplication call even at the -O2 optimization level because the variable `square` is used.

## Loop Unrolling

Loop unrolling speeds up programs by repeating the loop body many times in one iteration. This reduces the total number of times the program needs to check loop conditions and update counters. Loop unrolling can be done through specific compiler flags such as -O3 or -funroll-loops or also explicitly added in programs. Higher optimization levels unroll loops more aggressively, or in other words, have a higher unrolling factor, which is the number iterations are unrolled into a singular iteration.

### `sum` in [examples.c](compiler-optimizations/program_and_executables/examples.c)

```c
#include <stddef.h>

unsigned sum(const unsigned *values, size_t count)
{
    unsigned total = 0;
    for (size_t i = 0; i < count; ++i)
    {
        total += values[i];
    }
    return total;
}
```

`sum` takes in a pointer to a unsigned integer array and a unsigned size_t count. We are only reading the elements from values, so we can use const in the parameter declaration. This function uses a for loop to sum up all of the elements in values and returns it.

### `sum` Tests in [check.c](compiler-optimizations/program_and_executables/check.c)

```c
const unsigned values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

for (size_t n = 0; n <= sizeof values / sizeof values[0]; ++n)
{
    unsigned expected = (unsigned)(n * (n + 1) / 2);
    assert(sum(values, n) == expected);
}
```

### Scalar and Unrolled Assembly

#### Scalar Loop ([excerpt](compiler-optimizations/assembly/scalar.s#L56-L61))

```asm
.L7:
    addl    (%rdi), %eax
    addq    $4, %rdi
    cmpq    %rdx, %rdi
    jne     .L7
    ret
```

`.L7:` is a generic local label in assembly to mark specific memory addresses. We can infer that this snippet refers to a loop because there is a backwards jump instruction, `jne`, to `.L7`. In the loop body there is only one `addl

#### Unrolled Loop ([excerpt](compiler-optimizations/assembly/unrolled.s#L91-L103))

```asm
.L7:
    addl    (%rdi), %eax
    addq    $32, %rdi
    addl    -28(%rdi), %eax
    addl    -24(%rdi), %eax
    addl    -20(%rdi), %eax
    addl    -16(%rdi), %eax
    addl    -12(%rdi), %eax
    addl    -8(%rdi), %eax
    addl    -4(%rdi), %eax
    cmpq    %rcx, %rdi
    jne     .L7
    ret
```

In the loop body, there are 8 addl calls, which add 4-byte data types. We can also see that the addq call that advances the counter now advances 32 bytes instead of 4 bytes. This means that the unrolling factor is 8 since 32/4 = 8, but since there are 9 elements in the values array, we must also clean up the last element, which is an inefficiency of loop unrolling.

### Remainder Handling and Trade-offs

Loop unrolling increases the size of binary and assembly instructions, as we will saw the larger loop body in the unrolled assembly. Unrolling large loops can also exceed the CPU’s L1 instruction cache memory and cause it to get instructions from slower memory, which can actually slow down runtime. Moreover, if the number of iterations in the original loop is not divisible by the unrolling factor, additional code is also required to account for the remaining iterations.

## Reproduce the Experiments

### Compile and Run the Checks

```bash
cd compiler-optimizations/program_and_executables

gcc -O0 examples.c check.c -o check-O0
gcc -O2 examples.c check.c -o check-O2
gcc -O2 -fno-tree-vectorize -funroll-loops examples.c check.c -o check-unrolled

./check-O0
./check-O2
./check-unrolled
```

### Generate the Assembly

```bash
gcc -O0 -S examples.c -o examples-O0.s
gcc -O2 -S examples.c -o examples-O2.s

gcc -O2 -fno-tree-vectorize -fno-unroll-loops -S examples.c -o scalar.s
gcc -O2 -fno-tree-vectorize -funroll-loops -S examples.c -o unrolled.s
```

## What I Learned

I learned that there are many things that go on behind the scenes that help us optimize our code. Specifically, I learned a lot about dead code elimination and loop unrolling through analyzing differences in assembly code. While we need to use specific flags and options in C, most high-level programming languages have built-in optimizations in their compilers or runtime execution. What I found that was extremely interesting is that different higher levels of optimizations can also slow down code because some optimization methods might conflict with each other or increase the size of the assembly and binary executables. Therefore, it is important for developers to know which optimizations to utilize that are suitable for specific situations.

## Presentation Slides and Video

- [COMP-211 Checkoff 3: Compiler Optimizations](https://docs.google.com/presentation/d/17jMmqR0vxBuVcE14MI6_Yzk3vStNgNZeynsNe49c0us/edit?usp=sharing)
- [COMP-211 Checkoff 3 Presentation Video](https://youtu.be/eOzb6raOqQM)

## References

- [GCC optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)
- [GCC loop-specific pragmas](https://gcc.gnu.org/onlinedocs/gcc/Loop-Specific-Pragmas.html)
