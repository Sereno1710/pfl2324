% valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves(GameState, _ , ListOfMoves):-
  findall([X1,Y1,X2,Y2], valid_move(GameState, [X1,Y1,X2,Y2], _, _, _), ListOfMoves).

% choose_move(+GameState, +Player, +Level, -Move)
choose_move([Board, Turn], _, 1, Move):-
  sleep(1),
  valid_moves([Board, Turn], _, ListOfMoves),
  random_member(Move, ListOfMoves).

choose_move([Board, Turn], _, 2, Move):-
	findall(
    Value-Movement, 
    (
      move([Board, Turn], Movement, NewGameState),
      find_enemy_best_move(NewGameState, 1, Value)
    ),
    MoveValues
  ),
  sort(MoveValues, SortedMoveValues),
  get_best_move_value(SortedMoveValues, Turn, _-Move).

find_enemy_best_move(GameState, 0, Value):- value(GameState, _, Value).
find_enemy_best_move([Board, Turn], Depth, Valuation):-
  Depth > 0,
  Depth1 is Depth - 1,
  findall(
    Value-Move, 
    (
      move([Board, Turn], Move, NewGameState),
      find_enemy_best_move(NewGameState, Depth1, Value)
    ),
    MoveValues
  ),
  sort(MoveValues, SortedMoveValues),
  get_best_move_value(SortedMoveValues, Turn, Valuation-_).

get_best_move_value(SortedMoveValues, red, Value-Move):-
  last(SortedMoveValues, Value-Move).
get_best_move_value([Head | _], blue, Head).

value(GameState, _, Value):-
  game_over(GameState, Winner),
  get_game_over_value(Winner, Value).

value([Board, _], _, Value):-
  count_board_value(Board, Value).

count_board_value([], 0).
count_board_value([Head|Tail], Value):-
  count_row_value(Head, HeadValue),
  count_board_value(Tail, TailValue),
  Value is HeadValue + TailValue.

count_row_value([], 0).
count_row_value([Head|Tail], Value):-
  get_tile_value(Head, HeadValue),
  count_row_value(Tail, TailValue),
  Value is HeadValue + TailValue.

get_game_over_value(red, 9999).
get_game_over_value(blue, -9999).

get_tile_value(-1, 0).
get_tile_value(10, 0).
get_tile_value(20, 0).
get_tile_value(11, 0).
get_tile_value(12, 4).
get_tile_value(13, 5).
get_tile_value(14, 10).
get_tile_value(15, 0).
get_tile_value(16, -4).
get_tile_value(17, -5).
get_tile_value(18, -10).
get_tile_value(21, -50).
get_tile_value(22, 8).
get_tile_value(23, 10).
get_tile_value(24, 25).
get_tile_value(25, 50).
get_tile_value(26, -8).
get_tile_value(27, -10).
get_tile_value(28, -25).
