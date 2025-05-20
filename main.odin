package main

import "base:runtime"
import "core:fmt"
import "core:math/rand"
import "core:mem"
import "core:time"
import rl "vendor:raylib"
SCREEN_WIDTH :: 500
SCREEN_HEIGHT :: 620

last_update_time: f64
EventTriggerd :: proc(interval: f64) -> bool {
	current_time := rl.GetTime()
	if current_time - last_update_time >= interval {
		last_update_time = current_time
		return true
	}
	return false
}

main :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	seed := u64(time.now()._nsec)
	state := rand.create(seed)
	gen := runtime.default_random_generator(&state)
	context.random_generator = gen

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Tetris")
	rl.SetTargetFPS(120)

	font := rl.LoadFontEx("assets/monogram.ttf", 64, nil, 0)


	game := Game{}
	InitGame(&game)
	defer {
		rl.CloseWindow()
		Destroy(&game)
		for _, entry in track.allocation_map {
			fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
		}

		for entry in track.bad_free_array {
			fmt.eprintf("%v bad free\n", entry.location)
		}

		mem.tracking_allocator_destroy(&track)
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(DarkBlue)

		rl.DrawTextEx(font, "Score", {365, 15}, 38, 0, rl.WHITE)

		score_text := fmt.ctprintf("%d", game.score)
		text_size := rl.MeasureTextEx(font, score_text, 38, 2)
		rl.DrawRectangleRounded({320, 55, 170, 60}, 0.3, 6, LightBlue)
		rl.DrawTextEx(font, score_text, {320 + (170 - text_size.x) / 2, 65}, 38, 2, rl.WHITE)

		rl.DrawTextEx(font, "Next", {370, 175}, 38, 0, rl.WHITE)
		rl.DrawRectangleRounded({320, 215, 170, 180}, 0.3, 6, LightBlue)
		rl.UpdateMusicStream(game.music)
		if game.game_over {
			rl.DrawTextEx(font, "GAME OVER", {320, 450}, 38, 0, rl.WHITE)
		}

		defer {
			rl.EndDrawing()
		}
		HandleInput(&game)

		if EventTriggerd(0.2) {
			MoveBlockDown(&game)
		}

		DrawGame(&game)
	}
}
