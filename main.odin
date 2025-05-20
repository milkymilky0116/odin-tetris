package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 300
SCREEN_HEIGHT :: 600
main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Tetris")
	rl.SetTargetFPS(120)
	darkBlue := rl.Color{44, 44, 127, 255}

	grid := Grid {
		num_rows  = 20,
		num_cols  = 10,
		cell_size = 30,
	}

	InitGrid(&grid)
	PrintGrid(&grid)

	defer {
		rl.CloseWindow()
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(darkBlue)
		DrawGrid(&grid)
		defer {
			rl.EndDrawing()
		}
	}
}
