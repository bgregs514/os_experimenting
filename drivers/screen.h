#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// attribute byte for default color scheme
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

// screen device i/o ports
#define REG_SCREEN_CTL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void clear_screen();
void kprint_at(char *message, int col, int row);
void kprint(char *message);