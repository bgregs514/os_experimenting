#include "timer.h"
#include "isr.h"
#include "ports.h"
#include "../libc/function.h"

u32 tick = 0;

static void timer_callback(registers_t regs)
{
	tick++;
	UNUSED(regs);
}

void init_timer(u32 freq)
{
	/* install the function */
	register_interrupt_handler(IRQ0, timer_callback);

	/* get the PIT value: hardware clock at 1193180 hz */
	u32 divisor = 1193180 / freq;
	u8 low = (u8)(divisor & 0xff);
	u8 high = (u8)((divisor >> 8) & 0xff);
	/* send the command */
	port_byte_out(0x43, 0x36); /* command port */
	port_byte_out(0x40, low);
	port_byte_out(0x40, high);
}
