class_name Piece
extends Node

## Enum for the type of the piece, NONE is used for blank tiles
## WHITE and MOVED bits indicate if the piece is white/black and has moved or hasn't
enum State {
	NONE 	= 0,
	PAWN 	= 1,  
	KING 	= 2,  
	QUEEN 	= 3,  
	BISHOP 	= 4,  
	KNIGHT 	= 5,  
	ROOK 	= 6,
	
	WHITE	= 8,
	MOVED	= 16,
}



#func get_team(piece: int) -> Team:
	#return piece & 0b011000

## Returns true if Piece is on the same team as other
#func is_ally_of(other: Piece) -> bool:
#	return team == other.team

## Returns true if Piece is on the opposite team as other
#func is_enemy_of(other: Piece) -> bool:
#	return ((team == Team.WHITE and other.team == Team.BLACK) or 
#			(team == Team.BLACK and other.team == Team.WHITE))

## Returns true if Piece is the none piece
#func is_none() -> bool:
#	return (team == Team.NONE and type == Type.NONE)
