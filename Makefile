CC 		= gcc
CFLAGS		= -m32 -fno-pie -ffreestanding
C_SOURCES	= $(wildcard kernel/*.c drivers/*.c)
HEADERS		= $(wildcard kernel/*.h drivers/*.h)
OBJ		= $(patsubst %.c, %.o, $(C_SOURCES))

# default build
all: os-image

test: $(OBJ)
	cat $^ > temp.txt

# run qemu to simulate booting
run: all
	qemu-system-x86_64 -fda os-image

os-image: boot/boot_sect_simple.bin kernel.bin
	cat $^ > $@

kernel.bin: kernel/kernel_entry.o $(OBJ)
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

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
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
