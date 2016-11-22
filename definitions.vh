`define W 640
`define H 480

// VGA constants
`define HSYNC_FRONT_PORCH 16
`define HSYNC_PULSE_WIDTH 96
`define HSYNC_BACK_PORCH 48
`define VSYNC_FRONT_PORCH 10
`define VSYNC_PULSE_WIDTH 2
`define VSYNC_BACK_PORCH 33

// Board constants
`define BLOCK_SIZE 28
`define BOARD_BLOCK_W 6
`define BOARD_BLOCK_H 16
`define BOARD_WIDTH (`BOARD_BLOCK_W * `BLOCK_SIZE)
`define BOARD_XSTART (((`W - `BOARD_WIDTH) / 2) - 1)
`define BOARD_HEIGHT (`BOARD_BLOCK_H * `BLOCK_SIZE)
`define BOARD_YSTART (((`H - `BOARD_HEIGHT) / 2) - 1)

// Block constants
`define BLOCK_SINGLE 1
`define BLOCK_I_VERTICAL 2
`define BLOCK_I_HORRIZONTAL 3

// Color constants
`define RED 8'b00000111
`define GREEN 8'b00111000
`define BLUE 8'b11000000
`define ORANGE 8'b00011111
`define BLACK 8'b00000000
`define WHITE 8'b11111111
