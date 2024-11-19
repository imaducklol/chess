## Abstract parent class for pieces
class_name Piece
extends Node

## Enum for the type of the piece, NONE is used for blank tiles
enum Type {
	NONE, 
	PAWN, 
	KING, 
	QUEEN, 
	BISHOP, 
	KNIGHT, 
	ROOK,
}

## Enum for the team of the piece, NONE is used for blank tiles
enum Team {
	WHITE, 
	BLACK, 
	NONE,
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
