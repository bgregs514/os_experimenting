CC 		= gcc
CFLAGS		= -m32 -fno-pie -ffreestanding -g -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
			-nostartfiles -nodefaultlibs -Wall -Wextra -Werror
C_SOURCES	= $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c)
HEADERS		= $(wildcard kernel/*.h drivers/*.h cpu/*.h libc/*.h)
#OBJ		= $(patsubst %.c, %.o, $(C_SOURCES))
OBJ		= $(C_SOURCES:.c=.o cpu/interrupt.o)

# default build
all: os-image

test: $(OBJ)
	cat $^ > temp.txt

# run qemu to simulate booting
run: all
	qemu-system-x86_64 -fda os-image

os-image: boot/boot_sect_simple.bin kernel.bin
	cat $^ > $@

kernel.bin: boot/kernel_entry.o $(OBJ)
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entry.o $(OBJ)
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

debug: os-image kernel.elf

# generic c -> object rule
%.o: %.c ${HEADERS}
	$(CC) $(CFLAGS) -c $< -o $@

# generic assembly -> object rule
%.o: %.asm
	nasm $< -f elf -o $@

# generic assembly -> binary rule
%.bin: %.asm
	nasm $< -f bin -iboot -o $@

clean:
	rm -fr *.bin *.dis *.o os-image *.elf
	rm -fr kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o libc/*.o
