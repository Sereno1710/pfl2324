/*
-1 - Ignore

Units:
0 - Empty Tile
1 - Red Pentagon
2 - Red Square
3 - Red Triangle
4 - Red Circle
5 - Blue Pentagon
6 - Blue Square
7 - Blue Triangle
8 - Blue Circle

Tens:
1 - Normal Tile
2 - Gold Tile
*/
% inital_state(+Size, -GameState)
% initiates board as well as which player goes first.
initial_state( 1 , [Board, Turn]):-
  Board = [
    [-1,-1,-1,-1,10,-1,10,-1,10,-1,10,-1,10,-1,-1,-1,-1],
    [-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1],
    [13,-1,11,-1,14,-1,10,-1,20,-1,10,-1,18,-1,15,-1,17],
    [-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1],
    [-1,-1,-1,-1,10,-1,10,-1,10,-1,10,-1,10,-1,-1,-1,-1]
  ],
  Turn = red.

initial_state( 2 , [Board, Turn]):-
  Board = [
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,14,-1,10,-1,14,-1,10,-1,20,-1,10,-1,18,-1,10,-1,18,-1,-1],
    [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
    [14,-1,13,-1,11,-1,12,-1,14,-1,10,-1,18,-1,16,-1,15,-1,17,-1,18],
    [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
    [-1,-1,14,-1,10,-1,14,-1,10,-1,20,-1,10,-1,18,-1,10,-1,18,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
  ],
  Turn = red.

initial_state( 3 , [Board, Turn]):-
  Board = [
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,14,-1,10,-1,14,-1,10,-1,10,-1,10,-1,20,-1,10,-1,10,-1,10,-1,18,-1,10,-1,18,-1,-1],
    [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
    [14,-1,13,-1,11,-1,12,-1,14,-1,10,-1,10,-1,20,-1,10,-1,10,-1,18,-1,16,-1,15,-1,17,-1,18],
    [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
    [-1,-1,14,-1,10,-1,14,-1,10,-1,10,-1,10,-1,20,-1,10,-1,10,-1,10,-1,18,-1,10,-1,18,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
  ],
  Turn = red.

% get_enemy_colour(+Colour, -NewColour)
get_enemy_colour(red, blue).
get_enemy_colour(blue, red).

% obtains player type(human or machine)
get_player_type(red, RedPlayer, _, RedPlayer).
get_player_type(blue, _, BluePlayer, BluePlayer).

% combat_outcome(+Attacker, +Defender, -Outcome)
/*
1 - Defender is captured
2 - Both are captured
*/
combat_outcome(pentagon, pentagon, 1).
combat_outcome(square, pentagon, 1).
combat_outcome(square, square, 1).
combat_outcome(square, triangle, 2).
combat_outcome(triangle, pentagon, 1).
combat_outcome(triangle, square, 1).
combat_outcome(triangle, triangle, 1).
combat_outcome(triangle, circle, 2).
combat_outcome(circle, pentagon, 1).
combat_outcome(circle, square, 1).
combat_outcome(circle, triangle, 1).
combat_outcome(circle, circle, 1).

% get_piece_max_steps(+Piece, -MaxSteps)
get_piece_max_steps(pentagon, 5).
get_piece_max_steps(square, 4).
get_piece_max_steps(triangle, 3).
get_piece_max_steps(circle, 1).

% get_piece(?Id, ?Piece, ?Colour, ?PieceDisplay)
get_piece(1, pentagon, red, '\x2B1F\').
get_piece(2, square, red, '\x25A0\').
get_piece(3, triangle, red, '\x25B2\').
get_piece(4, circle, red, '\x25CF\').
get_piece(5, pentagon, blue, '\x2B20\').
get_piece(6, square, blue, '\x25A1\').
get_piece(7, triangle, blue, '\x25B3\').
get_piece(8, circle, blue, '\x25CB\').


