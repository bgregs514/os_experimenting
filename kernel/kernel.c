#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"
#include "../libc/mem.h"

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
	} else if (strcmp(input, "PAGE") == 0) {
		u32 phys_addr;
		u32 page = kmalloc(1000, 1, &phys_addr);
		char page_str[16] = "";
		hex_to_ascii(page, page_str);
		char phys_str[16] = "";
		hex_to_ascii(phys_addr, phys_str);
		kprint("Page: ");
		kprint(page_str);
		kprint(", pysical address: ");
		kprint(phys_str);
		kprint("\n");
	}
	kprint("You entered: ");
	kprint(input);
	kprint("\nInput:>");
}
