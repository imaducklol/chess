extends Control

var board: Board
var board_helper: BoardHelper
var move_generation: MoveGeneration
var minimax: Minimax

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board = Board.new()
	board_helper = BoardHelper.new()
	move_generation = MoveGeneration.new(board.main_board)
	minimax = Minimax.new()
	
	board_helper.initialize_board(board.main_board)
	board_helper.load_from_fen(board.main_board, board.turn, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
	
	for i in range(1, 20):
		var starttime := Time.get_ticks_usec()
		minimax.best_move(board.main_board, i, Piece.Team.WHITE, false)
		var stoptime := Time.get_ticks_usec() - starttime
		starttime = Time.get_ticks_usec()
		minimax.best_move(board.main_board, i, Piece.Team.WHITE, true)
		var prune_stoptime = Time.get_ticks_usec() - starttime
		
		print("Depth: ", i)
		print("Minimax (us): ", stoptime, " With Pruning: ", prune_stoptime)
