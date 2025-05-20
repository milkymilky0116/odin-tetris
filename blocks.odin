#+feature dynamic-literals

package main

LBlock :: struct {
	using block: Block,
}

JBlock :: struct {
	using block: Block,
}

IBlock :: struct {
	using block: Block,
}

OBlock :: struct {
	using block: Block,
}

SBlock :: struct {
	using block: Block,
}

TBlock :: struct {
	using block: Block,
}

ZBlock :: struct {
	using block: Block,
}

InitLBlock :: proc(block: ^LBlock) {
	InitBlock(block)
	block.id = 1
	block.cells[0] = {{2, 0}, {0, 1}, {1, 1}, {2, 1}}
	block.cells[1] = {{1, 0}, {1, 1}, {1, 2}, {2, 2}}
	block.cells[2] = {{0, 0}, {0, 1}, {1, 1}, {2, 1}}
	block.cells[3] = {{1, 0}, {1, 1}, {1, 2}, {0, 0}}
	MoveBlock(block, 3, 0)
}

InitIBlock :: proc(block: ^IBlock) {
	InitBlock(block)
	block.id = 2
	block.cells[0] = {{0, 1}, {1, 1}, {2, 1}, {3, 1}}
	block.cells[1] = {{2, 0}, {2, 1}, {2, 2}, {2, 3}}
	block.cells[2] = {{0, 2}, {1, 2}, {2, 2}, {3, 2}}
	block.cells[3] = {{1, 0}, {1, 1}, {1, 2}, {1, 3}}
	MoveBlock(block, 3, -1)
}

InitOBlock :: proc(block: ^OBlock) {
	InitBlock(block)
	block.id = 3
	block.cells[0] = {{0, 0}, {1, 0}, {0, 1}, {1, 1}}
	MoveBlock(block, 4, 0)
}

InitSBlock :: proc(block: ^SBlock) {
	InitBlock(block)
	block.id = 4
	block.cells[0] = {{1, 0}, {2, 0}, {0, 1}, {1, 1}}
	block.cells[1] = {{1, 0}, {1, 1}, {2, 1}, {2, 2}}
	block.cells[2] = {{1, 1}, {2, 1}, {0, 2}, {1, 2}}
	block.cells[3] = {{0, 0}, {0, 1}, {1, 1}, {1, 2}}
	MoveBlock(block, 3, 0)
}


InitTBlock :: proc(block: ^TBlock) {
	InitBlock(block)
	block.id = 5
	block.cells[0] = {{1, 0}, {0, 1}, {1, 1}, {2, 1}}
	block.cells[1] = {{1, 0}, {1, 1}, {2, 1}, {1, 2}}
	block.cells[2] = {{0, 1}, {1, 1}, {2, 1}, {1, 2}}
	block.cells[3] = {{1, 0}, {0, 1}, {1, 1}, {1, 2}}
	MoveBlock(block, 3, 0)
}

InitJBlock :: proc(block: ^JBlock) {
	InitBlock(block)
	block.id = 6
	block.cells[0] = {{0, 0}, {0, 1}, {1, 1}, {2, 1}}
	block.cells[1] = {{2, 0}, {2, 1}, {1, 2}, {2, 2}}
	block.cells[2] = {{0, 1}, {1, 1}, {2, 1}, {2, 2}}
	block.cells[3] = {{0, 0}, {0, 1}, {0, 2}, {1, 0}}
	MoveBlock(block, 3, 0)
}

InitZBlock :: proc(block: ^ZBlock) {
	InitBlock(block)
	block.id = 7
	block.cells[0] = {{0, 0}, {1, 0}, {1, 1}, {2, 1}}
	block.cells[1] = {{2, 0}, {1, 1}, {2, 1}, {1, 2}}
	block.cells[2] = {{0, 1}, {1, 1}, {1, 2}, {2, 2}}
	block.cells[3] = {{0, 1}, {1, 0}, {1, 1}, {0, 2}}
	MoveBlock(block, 3, 0)
}
