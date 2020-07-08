#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"

void main()
{
	isr_install();
	irq_install();

	kprint("Type END to halt the CPU\n"
			"Input:>");
}

void user_input(char *input)
{
	if (strcmp(input, "END") == 0) {
		kprint("\nStopping the CPU");
		asm volatile("hlt");
	}
	kprint("You entered: ");
	kprint(input);
	kprint("\nInput:>");
}
