% valid_moves(+GameState, +Player, -ListOfMoves)
% returns a list of all valid moves for the current turn
valid_moves(GameState, _ , ListOfMoves):-
  findall([X1,Y1,X2,Y2], valid_move(GameState, [X1,Y1,X2,Y2], _, _, _), ListOfMoves).

% choose_move(+GameState, +Player, +Level, -Move)
% makes the machine choose a move, on level 1 it's a random one, on level 2 it evaluates the position based on the enemy response
choose_move([Board, Turn], _, 1, Move):-
  sleep(1),
  valid_moves([Board, Turn], _, ListOfMoves),
  random_member(Move, ListOfMoves).
choose_move([Board, Turn], _, 2, Move):-
	findall(
    Value-Movement, 
    (
      move([Board, Turn], Movement, NewGameState),
      find_enemy_best_move(NewGameState, Value)
    ),
    MoveValues
  ),
  sort(MoveValues, SortedMoveValues),
  get_best_move_value(SortedMoveValues, Turn, _-Move).

% find_enemy_best_move(+GameState, -Valuation)
% returns the enemy evaluation of the gamestate
find_enemy_best_move(GameState, Valuation):-
  game_over(GameState, Winner),
  get_game_over_value(Winner, Valuation).
find_enemy_best_move([Board, Turn], Valuation):-
  findall(
    Value-Move, 
    (
      move([Board, Turn], Move, NewGameState),
      value(NewGameState, _, Value)
    ),
    MoveValues
  ),
  sort(MoveValues, SortedMoveValues),
  get_best_move_value(SortedMoveValues, Turn, Valuation-_).

% get_best_move_value(+SortedMoveValues, +Colour, -Value-Move)
% given a sorted list of the format Value-Move, it returns the one with highest value
get_best_move_value(SortedMoveValues, red, Value-Move):-
  last(SortedMoveValues, Value-Move).
get_best_move_value([Head | _], blue, Head).

% value(+GameState, +Player, -Value)
% evaluates the gamestate
value(GameState, _, Value):-
  game_over(GameState, Winner),
  get_game_over_value(Winner, Value).
value([Board, _], _, Value):-
  count_board_value(Board, Value).

% count_board_value(+Board, -Value):-
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
