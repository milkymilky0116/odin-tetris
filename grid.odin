package main

import "core:fmt"
import rl "vendor:raylib"


Grid :: struct {
	num_rows:  int,
	num_cols:  int,
	cell_size: int,
	grid:      [20][10]int,
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
	for col := 0; col < tetris_grid.num_cols; col += 1 {
		for row := 0; row < tetris_grid.num_rows; row += 1 {
			cell_value := tetris_grid.grid[row][col]
			rl.DrawRectangle(
				i32(col * cell_size + 11),
				i32(row * cell_size + 11),
				i32(cell_size - 1),
				i32(cell_size - 1),
				GetCellColors()[cell_value],
			)
		}
	}
}

ClearFullRows :: proc(grid: ^Grid) -> int {
	completed := 0
	for row := grid.num_rows - 1; row >= 0; row -= 1 {
		if IsRowFull(grid, row) {
			ClearRow(grid, row)
			completed += 1
		} else if (completed > 0) {
			MoveRowDown(grid, row, completed)
		}
	}
	return completed
}

MoveRowDown :: proc(grid: ^Grid, row, num_rows: int) {
	for col := 0; col < grid.num_cols; col += 1 {
		grid.grid[row + num_rows][col] = grid.grid[row][col]
		grid.grid[row][col] = 0
	}
}

ClearRow :: proc(grid: ^Grid, row: int) {
	for col := 0; col < grid.num_cols; col += 1 {
		grid.grid[row][col] = 0
	}
}

IsRowFull :: proc(grid: ^Grid, row: int) -> bool {
	for col := 0; col < grid.num_cols; col += 1 {
		if grid.grid[row][col] == 0 {
			return false
		}
	}
	return true
}

IsCellEmpty :: proc(tetris_grid: ^Grid, row, col: int) -> bool {
	if tetris_grid.grid[col][row] == 0 {
		return true
	}
	return false
}

IsCellOutside :: proc(tetris_grid: ^Grid, row, col: int) -> bool {
	if row >= 0 && row < tetris_grid.num_rows && col >= 0 && col < tetris_grid.num_cols {
		return false
	}
	return true
}
