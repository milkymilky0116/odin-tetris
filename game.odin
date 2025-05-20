#+feature dynamic-literals

package main

import "core:math/rand"
import rl "vendor:raylib"

Game :: struct {
	grid:          Grid,
	blocks:        [dynamic]Block,
	current_block: Block,
	next_block:    Block,
	game_over:     bool,
	score:         int,
	music:         rl.Music,
	rotate_sound:  rl.Sound,
	clear_sound:   rl.Sound,
}

Destroy :: proc(game: ^Game) {
	rl.UnloadSound(game.rotate_sound)
	rl.UnloadSound(game.clear_sound)
	rl.UnloadMusicStream(game.music)
	rl.CloseAudioDevice()
}

InitGame :: proc(game: ^Game) {
	rl.InitAudioDevice()
	game.grid = {
		num_rows  = 20,
		num_cols  = 10,
		cell_size = 30,
	}
	InitGrid(&game.grid)
	game.blocks = GetAllBlocks(game)
	game.current_block = GetRandomBlock(game)
	game.next_block = GetRandomBlock(game)
	game.game_over = false
	game.music = rl.LoadMusicStream("assets/music.mp3")
	rl.PlayMusicStream(game.music)

	game.rotate_sound = rl.LoadSound("assets/rotate.mp3")
	game.clear_sound = rl.LoadSound("assets/clear.mp3")
}

GetRandomBlock :: proc(game: ^Game) -> Block {
	if (len(game.blocks) == 0) {
		game.blocks = GetAllBlocks(game)
	}
	random_index := rand.int_max(len(game.blocks))
	block := game.blocks[random_index]
	ordered_remove(&game.blocks, random_index)
	return block
}

GetAllBlocks :: proc(game: ^Game) -> [dynamic]Block {
	iblock := IBlock{}
	InitBlock(&iblock)
	InitIBlock(&iblock)

	jblock := JBlock{}
	InitBlock(&jblock)
	InitJBlock(&jblock)

	lblock := LBlock{}
	InitBlock(&lblock)
	InitLBlock(&lblock)

	oblock := OBlock{}
	InitBlock(&oblock)
	InitOBlock(&oblock)

	sblock := SBlock{}
	InitBlock(&sblock)
	InitSBlock(&sblock)

	tblock := TBlock{}
	InitBlock(&tblock)
	InitTBlock(&tblock)

	zblock := ZBlock{}
	InitBlock(&zblock)
	InitZBlock(&zblock)

	return {iblock, jblock, lblock, oblock, sblock, tblock, zblock}
}

DrawGame :: proc(game: ^Game) {
	DrawGrid(&game.grid)
	DrawBlock(&game.current_block, 11, 11)
	switch game.next_block.id {
	case 2:
		DrawBlock(&game.next_block, 255, 290)
	case 3:
		DrawBlock(&game.next_block, 255, 280)
	case:
		DrawBlock(&game.next_block, 270, 270)
	}
}

HandleInput :: proc(game: ^Game) {
	keypressed := rl.GetKeyPressed()
	if game.game_over && keypressed != nil {
		Reset(game)
		game.game_over = false
	}
	#partial switch keypressed {
	case .LEFT:
		MoveBlockLeft(game)
	case .RIGHT:
		MoveBlockRight(game)
	case .UP:
		RotateCurrentBlock(game)
	case .DOWN:
		MoveBlockDown(game)
		UpdateScore(game, 0, 1)
	}
}

Reset :: proc(game: ^Game) {
	InitGrid(&game.grid)
	game.blocks = GetAllBlocks(game)
	game.current_block = GetRandomBlock(game)
	game.next_block = GetRandomBlock(game)
	game.score = 0
}

IsBlockOutside :: proc(game: ^Game) -> bool {
	tiles := GetCellPosition(&game.current_block)
	for position in tiles {
		if IsCellOutside(&game.grid, position.y, position.x) {
			return true
		}
	}
	return false
}

RotateCurrentBlock :: proc(game: ^Game) {
	if !game.game_over {
		RotateBlock(&game.current_block)
		if IsBlockOutside(game) || !BlockFits(game) {
			UndoRotateBlock(&game.current_block)
		} else {
			rl.PlaySound(game.rotate_sound)
		}
	}
}

MoveBlockLeft :: proc(game: ^Game) {
	if !game.game_over {
		MoveBlock(&game.current_block, -1, 0)
		if IsBlockOutside(game) || !BlockFits(game) {
			MoveBlock(&game.current_block, 1, 0)
		}
	}
}

MoveBlockRight :: proc(game: ^Game) {
	if !game.game_over {
		MoveBlock(&game.current_block, 1, 0)
		if IsBlockOutside(game) || !BlockFits(game) {
			MoveBlock(&game.current_block, -1, 0)
		}
	}
}

MoveBlockUp :: proc(game: ^Game) {
	MoveBlock(&game.current_block, 0, -1)
	if IsBlockOutside(game) {
		MoveBlock(&game.current_block, 0, 1)
	}
}

MoveBlockDown :: proc(game: ^Game) {
	if !game.game_over {
		MoveBlock(&game.current_block, 0, 1)
		if IsBlockOutside(game) || !BlockFits(game) {
			MoveBlock(&game.current_block, 0, -1)
			LockBlock(game)
		}
	}
}

BlockFits :: proc(game: ^Game) -> bool {
	tiles := GetCellPosition(&game.current_block)
	for position in tiles {
		if !IsCellEmpty(&game.grid, position.x, position.y) {
			return false
		}
	}
	return true
}

LockBlock :: proc(game: ^Game) {
	tiles := GetCellPosition(&game.current_block)

	for position in tiles {
		game.grid.grid[position.y][position.x] = game.current_block.id
	}

	game.current_block = game.next_block
	if !BlockFits(game) {
		game.game_over = true
		game.current_block = Block{}
	} else {
		game.next_block = GetRandomBlock(game)
	}
	row_cleared := ClearFullRows(&game.grid)
	if (row_cleared > 0) {
		rl.PlaySound(game.clear_sound)
		UpdateScore(game, row_cleared, 0)
	}
}

UpdateScore :: proc(game: ^Game, lines_cleared, move_down_points: int) {
	switch lines_cleared {
	case 1:
		game.score += 100
	case 2:
		game.score += 300
	case 3:
		game.score += 500
	}
	game.score += move_down_points
}
