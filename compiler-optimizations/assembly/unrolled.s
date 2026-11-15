	.file	"examples.c"
	.text
	.p2align 4
	.globl	next_unused
	.type	next_unused, @function
next_unused:
.LFB39:
	.cfi_startproc
	endbr64
	leal	1(%rdi), %eax
	ret
	.cfi_endproc
.LFE39:
	.size	next_unused, .-next_unused
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"square = %u\n"
	.text
	.p2align 4
	.globl	next_logged
	.type	next_logged, @function
next_logged:
.LFB40:
	.cfi_startproc
	endbr64
	movl	%edi, %edx
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leaq	.LC0(%rip), %rsi
	movl	%edi, %ebx
	imull	%edi, %edx
	xorl	%eax, %eax
	movl	$2, %edi
	call	__printf_chk@PLT
	leal	1(%rbx), %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE40:
	.size	next_logged, .-next_logged
	.p2align 4
	.globl	sum
	.type	sum, @function
sum:
.LFB41:
	.cfi_startproc
	endbr64
	testq	%rsi, %rsi
	je	.L8
	leaq	-4(,%rsi,4), %rdx
	leaq	(%rdi,%rsi,4), %rcx
	xorl	%eax, %eax
	shrq	$2, %rdx
	addq	$1, %rdx
	andl	$7, %edx
	je	.L7
	cmpq	$1, %rdx
	je	.L31
	cmpq	$2, %rdx
	je	.L32
	cmpq	$3, %rdx
	je	.L33
	cmpq	$4, %rdx
	je	.L34
	cmpq	$5, %rdx
	je	.L35
	cmpq	$6, %rdx
	jne	.L45
.L36:
	addl	(%rdi), %eax
	addq	$4, %rdi
.L35:
	addl	(%rdi), %eax
	addq	$4, %rdi
.L34:
	addl	(%rdi), %eax
	addq	$4, %rdi
.L33:
	addl	(%rdi), %eax
	addq	$4, %rdi
.L32:
	addl	(%rdi), %eax
	addq	$4, %rdi
.L31:
	addl	(%rdi), %eax
	addq	$4, %rdi
	cmpq	%rcx, %rdi
	je	.L46
.L7:
	addl	(%rdi), %eax
	addq	$32, %rdi
	addl	-28(%rdi), %eax
	addl	-24(%rdi), %eax
	addl	-20(%rdi), %eax
	addl	-16(%rdi), %eax
	addl	-12(%rdi), %eax
	addl	-8(%rdi), %eax
	addl	-4(%rdi), %eax
	cmpq	%rcx, %rdi
	jne	.L7
	ret
	.p2align 4,,10
	.p2align 3
.L45:
	movl	(%rdi), %eax
	addq	$4, %rdi
	jmp	.L36
.L46:
	ret
	.p2align 4,,10
	.p2align 3
.L8:
	xorl	%eax, %eax
	ret
	.cfi_endproc
.LFE41:
	.size	sum, .-sum
	.section	.rodata.str1.1
.LC1:
	.string	"%u"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB42:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$10, %edx
	movl	$2, %edi
	xorl	%eax, %eax
	leaq	.LC1(%rip), %rsi
	call	__printf_chk@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE42:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
