#include "screen.h"
#include "ports.h"
#include "../kernel/util.h"

/* private function declarations */
int get_cursor_offset();
void set_cursor_offset(int offset);
int print_char(char c, int col, int row, char attr);
int get_offset(int col, int row);
int get_offset_row(int offset);
int get_offset_col(int offset);

/************************************
* Public kernel functions          *
************************************/

void kprint_at(char *message, int col, int row)
{
	int offset;
	if (col >= 0 && row >= 0) {
		offset = get_offset(col, row);
	} else {
		offset = get_cursor_offset();
		row = get_offset_row(offset);
		col = get_offset_col(offset);
	}

	int i = 0;
	while (message[i] != 0) {
		offset = print_char(message[i++], col, row, WHITE_ON_BLACK);
		row = get_offset_row(offset);
		col = get_offset_col(offset);
	}
}

void kprint(char *message)
{
	kprint_at(message, -1, -1);
}

/************************************
* Private kernel functions          *
************************************/

/* print a char on the screen at col, row, or at cursor position */
int print_char(char c, int col, int row, char attr)
{
	/* create a byte (char) pointer to the start of video memory */
	unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

	/* if attribute byte is zero, assume default style */
	if (!attr)
		attr = WHITE_ON_BLACK;
	
	/* get video memory offset for the screen location */
	int offset;
	/* if column and row are non-negative, use them for offset */
	if (col >= 0 && row >= 0) {
		offset = get_offset(col, row);
	} else {
		offset = get_cursor_offset();
	}

	/* set offset to end of current row so it will advance to the first col of the next row
	   if new line char present */
	if (c == '\n') {
		row = get_offset_row(offset);
		offset = get_offset(0, row+1);
	} else {
		vidmem[offset] = c;
		vidmem[offset+1] = attr;
		offset += 2;
	}

	/* check if offset is greater than screen size and scroll */
	if (offset >= MAX_ROWS * MAX_COLS * 2) {
		int i;
		for (i = 1; i < MAX_ROWS; i++) {
			memory_copy((char *) get_offset(0, i) + VIDEO_ADDRESS,
					(char *) get_offset(0, i-1) + VIDEO_ADDRESS,
					MAX_COLS * 2);
		}

		/* blank out the last line */
		char *last_line = (char *) get_offset(0, MAX_ROWS-1) + VIDEO_ADDRESS;
		for (i = 0; i < MAX_COLS * 2; i++)
			last_line[i] = 0;

		offset -= 2 * MAX_COLS;
	}

	/* update the offset to the next char cell which is 2 bytes ahead of current cell */
	set_cursor_offset(offset);
	return offset;
}

int get_cursor_offset()
{
	/* use VGA ports to get the current cursor position
	1) get high byte of the cursor offset (data 14)
	2) get low byte (data 15) */
	
	port_byte_out(REG_SCREEN_CTL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	return offset * 2; // position * size of char cell
}

void set_cursor_offset(int offset)
{
	/* similar to get_cursor_offset, but instead of reading this is writing data */

	offset /= 2;
	port_byte_out(REG_SCREEN_CTL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void clear_screen()
{
	int screen_size = MAX_COLS * MAX_ROWS;
	int i;
	char *screen = (unsigned char *) VIDEO_ADDRESS;

	for (i = 0; i < screen_size; i++) {
		screen[i*2] = ' ';
		screen[i*2+1] = WHITE_ON_BLACK;
	}
	set_cursor_offset(get_offset(0, 0));
}

int get_offset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int get_offset_row(int offset) { return offset / (2 * MAX_COLS); }
int get_offset_col(int offset) { return (offset - (get_offset_row(offset)*2*MAX_COLS)) / 2; }
