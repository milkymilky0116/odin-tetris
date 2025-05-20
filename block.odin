package main

import "core:fmt"
import rl "vendor:raylib"
Block :: struct {
	id:             int,
	cells:          map[int][dynamic][2]int,
	cell_size:      int,
	rotation_state: int,
	colors:         [8]rl.Color,
	row_offset:     int,
	col_offset:     int,
}

InitBlock :: proc(block: ^Block) {
	block.cell_size = 30
	block.rotation_state = 0
	block.row_offset = 0
	block.col_offset = 0
	block.colors = GetCellColors()
}

DrawBlock :: proc(block: ^Block, offset_x, offset_y: int) {
	tiles := GetCellPosition(block)
	for position in tiles {
		rl.DrawRectangle(
			i32(position.x * block.cell_size + offset_x),
			i32(position.y * block.cell_size + offset_y),
			i32(block.cell_size - 1),
			i32(block.cell_size - 1),
			block.colors[block.id],
		)
	}
}

MoveBlock :: proc(block: ^Block, rows, cols: int) {
	block.row_offset += rows
	block.col_offset += cols
}

RotateBlock :: proc(block: ^Block) {
	if block.id != 3 {
		block.rotation_state = (block.rotation_state + 1) % len(block.cells)
	}
}

UndoRotateBlock :: proc(block: ^Block) {
	if block.id != 3 {
		block.rotation_state = block.rotation_state - 1
		if block.rotation_state == -1 {
			block.rotation_state = len(block.cells) - 1
		}
	}
}

GetCellPosition :: proc(block: ^Block) -> [dynamic][2]int {
	tiles := block.cells[block.rotation_state]
	moved_tiles: [dynamic][2]int

	for position in tiles {
		new_pos := [2]int{position.x + block.row_offset, position.y + block.col_offset}
		append(&moved_tiles, new_pos)
	}
	return moved_tiles
}
