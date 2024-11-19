## Abstract parent class for pieces
class_name Piece
extends Node

## Enum for the type of the piece, NONE is used for blank tiles
enum Type {
	NONE 	= 0,
	PAWN 	= 1,  
	KING 	= 2,  
	QUEEN 	= 3,  
	BISHOP 	= 4,  
	KNIGHT 	= 5,  
	ROOK 	= 6,
}

## Enum for the team of the piece, NONE is used for blank tiles
enum Team {
	NONE 	= 0,
	WHITE 	= 8,
	BLACK 	= 16,
}

## Type of the piece
var type := Type.NONE
## Team of the piece
var team := Team.NONE

## Returns true if Piece is on the same team as other
func is_ally(other: Piece) -> bool:
	return team == other.team

func valid_moves(board: Array) -> Array:
	return []
