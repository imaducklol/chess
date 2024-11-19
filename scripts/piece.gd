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

var type: Type = 0
var team: Team = 0
var has_moved: bool = false

#func get_team(piece: int) -> Team:
	#return piece & 0b011000

## Returns true if Piece is on the same team as other
func is_ally(other: Piece) -> bool:
	return team == other.team
#func is_ally(piece: int, other: int) -> bool:
	#return get_team(piece) == get_team(other)
