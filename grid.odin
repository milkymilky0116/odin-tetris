package main

import "core:fmt"
import rl "vendor:raylib"

GridColors :: enum (int) {
	DarkGrey,
	Green,
	Red,
	Orange,
	Yellow,
	Purple,
	Cyan,
	Blue,
}

Grid :: struct {
	num_rows:  int,
	num_cols:  int,
	cell_size: int,
	grid:      [20][10]int,
}

GetColor :: proc(index: int) -> rl.Color {
	switch index {
	case 0:
		return {26, 31, 40, 255}
	case 1:
		return {47, 230, 23, 255}
	case 2:
		return {232, 18, 18, 255}
	case 3:
		return {226, 116, 17, 255}
	case 4:
		return {237, 234, 4, 255}
	case 5:
		return {166, 0, 247, 255}
	case 6:
		return {21, 204, 209, 255}
	case 7:
		return {13, 64, 216, 255}
	}

	return {0, 0, 0, 255}
}

InitGrid :: proc(tetris_grid: ^Grid) {
	for row := 0; row < tetris_grid.num_rows; row += 1 {
		for col := 0; col < tetris_grid.num_cols; col += 1 {
			tetris_grid.grid[row][col] = 0
		}
	}
}

PrintGrid :: proc(tetris_grid: ^Grid) {
	for row := 0; row < tetris_grid.num_rows; row += 1 {
		for col := 0; col < tetris_grid.num_cols; col += 1 {
			fmt.printf("%d ", tetris_grid.grid[row][col])
		}
		fmt.print("\n")
	}
}

DrawGrid :: proc(tetris_grid: ^Grid) {
	cell_size := tetris_grid.cell_size
	for row := 0; row < tetris_grid.num_rows; row += 1 {
		for col := 0; col < tetris_grid.num_cols; col += 1 {
			cell_value := tetris_grid.grid[row][col]
			rl.DrawRectangle(
				i32(col * cell_size + 1),
				i32(row * cell_size + 1),
				i32(cell_size - 1),
				i32(cell_size - 1),
				GetColor(cell_value),
			)
		}
	}
}
