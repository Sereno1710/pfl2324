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
initial_state( _ , [Board, Turn]):-
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

% board_size(+Board, -SizeX, -SizeY)
board_size(Board, [SizeX, SizeY]):-
  length(Board, SizeY),
  nth0(0, Board, Row),
  length(Row, SizeX).

inside_board(Board, [X, Y]):-
  board_size(Board, [SizeX, SizeY]),
  X >= 0,
  X < SizeX,
  Y >= 0,
  Y < SizeY.

% get_enemy_colour(+Colour, -NewColour)
get_enemy_colour(red, blue).
get_enemy_colour(blue, red).

get_units_tens(TileNum, Units, Tens):-
  Tens is TileNum // 10,
  Units is TileNum rem 10.

get_tile_num(Board, [X, Y], TileNum):-
  nth0(Y, Board, Row),
  nth0(X, Row , TileNum).

% get_max_steps(+TileNum, -MaxSteps)
get_max_steps(TileNum, MaxSteps):-
  get_units_tens(TileNum, Units, _),
  get_piece(Units, Piece, _, _),
  get_piece_max_steps(Piece, MaxSteps).

% get_tile_display(+TileNum, -TileText)
get_tile_display(TileNum, TileText):-
  get_units_tens(TileNum, Units, Tens),
  get_tile_display(Tens, Units, TileText).

% get_tile_display(? , +Units, +TileText)
get_tile_display(2, 0, 'G').
get_tile_display(1, 0, ' ').
get_tile_display(_, Units, TileText):-
  Units >= 1, Units =< 8,
  get_piece(Units, _, _, TileText).
get_tile_display(_, _, '?').

% adj_tile(+[X,Y], -[X1,Y1]) 
adj_tile([X,Y], [X1,Y]):- 
  X1 is X+2.

adj_tile([X,Y], [X1,Y]):- 
  X1 is X-2.

adj_tile([X,Y], [X1,Y1]):- 
  X1 is X+1,
  Y1 is Y+1.

adj_tile([X,Y], [X1,Y1]):- 
  X1 is X+1,
  Y1 is Y-1.
 
adj_tile([X,Y], [X1,Y1]):- 
  X1 is X-1,
  Y1 is Y+1.

adj_tile([X,Y], [X1,Y1]) :- 
  X1 is X-1,
  Y1 is Y-1.

get_move_type(_, DestNum, 1):-
  get_units_tens(DestNum, DestUnits, _),
  DestUnits = 0.
get_move_type(SourceNum, DestNum, MoveType):-
  get_units_tens(SourceNum, SourceUnits, _),
  get_units_tens(DestNum, DestUnits, _),
  get_piece(SourceUnits, SourcePiece, _, _),
  get_piece(DestUnits, DestPiece, _, _),
  combat_outcome(SourcePiece, DestPiece, MoveType).

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


% member+(X, +[X|_], -Result1, -Result2).
member(X,[X|_],_,_).
member(X, [_|T], Result1, Result2):-
        get_units_tens(X, _, Tens),
    (
        Tens =:= 2 -> 
        Result1 = X,
        member(X, T, Result2, _);
        member(X, T, Result1, Result2)
    ).

% get_golden_tiles(+Board, -Golden_Tiles)
get_golden_tiles(Board, [G1,G2]):- 
    member(Row, Board),
    member(_, Row, G1,G2).

% get_piece(?Id, ?Piece, ?Colour, ?PieceDisplay)
get_piece(1, pentagon, red, '\x2B1F\').
get_piece(2, square, red, '\x25A0\').
get_piece(3, triangle, red, '\x25B2\').
get_piece(4, circle, red, '\x25CF\').

get_piece(5, pentagon, blue, '\x2B20\').
get_piece(6, square, blue, '\x25A1\').
get_piece(7, triangle, blue, '\x25B3\').
get_piece(8, circle, blue, '\x25CB\').

% get_pentagon(+Board, -Pentagon)
get_pentagon(Board, 18):-
  member(Row, Board),
  member(18, Row).


get_pentagon(Board, 14):-
  member(Row, Board),
  member(14, Row).


