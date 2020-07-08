#ifndef IDT_H
#define IDT_H

#include "types.h"

/* segment selector */
#define KERNEL_CS 0x08

/* define the interrupt gate (handler) */
typedef struct {
	u16 low_offset; /* lower 16 bits of handler function address */
	u16 sel;	/* kernel segment selector */
	u8 always0;	
	u8 flags;	/* bit 7: "interrupt is present"
			   bits 6-5: privilege level of caller (0=kernel...3=user)
			   bit 4: set to 0 for interrupt gates
			   bits 3-0: bits 1110 = decimal 14 = "32 bit interrupt gate" */
	u16 high_offset;/* higher 16 bits of handler function address */
} __attribute__((packed)) idt_gate_t;

/* a pointer to the array of interrupt handlers,
   assembly instuction "lidt" will read it */
typedef struct {
	u16 limit;
	u32 base;
} __attribute__((packed)) idt_register_t;

#define IDT_ENTRIES 256
idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

/* functions implemented in idt.c */
void set_idt_gate(int n, u32 handler);
void set_idt();

#endif
