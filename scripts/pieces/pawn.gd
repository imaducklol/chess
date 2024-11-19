class_name Pawn
extends Piece

func _init(piece_team: Team):
	type = Type.PAWN
	team = piece_team

func valid_moves(board: Array) -> Array:
	return []
