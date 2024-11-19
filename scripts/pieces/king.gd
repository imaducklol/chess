class_name King
extends Piece

func _init(piece_team: Team):
	type = Type.KING
	team = piece_team

func valid_moves(board: Array) -> Array:
	return []
