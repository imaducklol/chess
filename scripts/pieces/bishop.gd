class_name Bishop
extends Piece

func _init(piece_team: Team):
	type = Type.BISHOP
	team = piece_team

func valid_moves(board: Array) -> Array:
	return []
