#include "ports.h"

u8 port_byte_in(u16 port)
{
	u8 result;
	// c wrapper that reads a byte from the specified port
	// "=a" (result) means: put AL register in variable "result" when finished
	// "d" (port) means: load edx with port
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

void port_byte_out(u16 port, u8 data)
{
	// "a" (data) means: load eax with data
	// "d" (port) means: load edx with port
	__asm__ __volatile__("out %%al, %%dx" : : "a" (data), "d" (port));
}

u16 port_word_in(u16 port)
{
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
	return result;
}

void port_word_out(u16 port, u16 data)
{
	__asm__ __volatile__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
