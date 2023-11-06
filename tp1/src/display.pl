% clear_screen
clear_screen:- write('\33\[2J').

% display_game(+GameState)
% displays GameState.
display_game([Board,Turn]):-
  clear_screen, 
  nl, nl,
  display_x_coords(Board),
  display_lines(Board),
  nl, nl,
  display_turn(Turn),
  nl, nl.

% display_turn(+Turn)
% displays the side that needs to play.
display_turn(Turn):-
  format('It is ~a\'s turn.', [Turn]).

% display_y_coords(+Count)
% displays Y axis.  
display_y_coords:- format('~5|', []).
display_y_coords(Count) :-
  Count >= 10,
  Count1 is Count // 10,
  Count2 is Count rem 10,
  format('~d~d - ', [Count1, Count2]).
display_y_coords(Count) :-
  Count < 10,
  format(' ~d - ', [Count]).

% display_x_coords(+Board)
% displays X axis 
display_x_coords(Board):-
  board_size(Board, [SizeX, _]),
  display_x_coords_tens(SizeX), nl,
  display_x_coords_units(SizeX), nl,
  display_x_coords_arrows(SizeX), nl.

% display_x_coords_tens(+SizeX)
% displays first digit of values that are equal or higher than 10 that belong to X axis. 
display_x_coords_tens(SizeX):-
  format('~26|', []),
  display_x_coords_tens(10, SizeX).
display_x_coords_tens(SizeX, SizeX).
display_x_coords_tens(Count, SizeX):-
  CountTens is Count // 10,
  format(' ~d', [CountTens]),
  Count1 is Count + 1,
  display_x_coords_tens(Count1, SizeX).

% display_x_coords_units(+SizeX)
% displays least significant digit of values that belong to X axis. 
display_x_coords_units(SizeX):-
  format('~6|', []),
  display_x_coords_units(0, SizeX).
display_x_coords_units(SizeX, SizeX).
display_x_coords_units(Count, SizeX):-
  CountUnits is Count rem 10,
  format(' ~d', [CountUnits]),
  Count1 is Count + 1,
  display_x_coords_units(Count1, SizeX).

% display_x_coords_arrows(+SizeX)
% displays '|' below all X axis values
display_x_coords_arrows(SizeX):-
  format('~6|', []),
  display_x_coords_arrows(0, SizeX).
display_x_coords_arrows(SizeX, SizeX).
display_x_coords_arrows(Count, SizeX):-
  write(' |'),
  Count1 is Count + 1,
  display_x_coords_arrows(Count1, SizeX).

% display_lines(+Board)
% displays all lines of the board as well as all pieces and golden tiles.
display_lines(Board):- 
  board_size(Board, [_, SizeY]),
  MiddleY is SizeY // 2,
  display_lines(Board, 0, MiddleY).
display_lines([], _, _).
display_lines([NextLine | RemainingLines], Count, MiddleY):-
  display_line(NextLine, Count, MiddleY),
  Count1 is Count + 1,
  display_lines(RemainingLines, Count1, MiddleY).

% display_line(+Line, +Count, +MiddleY)
display_line(Line, Count, MiddleY):-
  Count < MiddleY, !,
  display_y_coords,
  display_void(Line),
  display_line_upper_border(Line), nl,
  display_y_coords(Count),
  display_void(Line),
  display_line_content(Line), nl.
display_line(Line, Count, MiddleY):-
  Count = MiddleY, !,
  display_y_coords,
  display_void(Line),
  display_line_upper_border(Line), nl,
  display_y_coords(Count),
  display_void(Line),
  display_line_content(Line), nl,
  display_y_coords,
  display_void(Line),
  display_line_lower_border(Line), nl.
display_line(Line, Count, MiddleY):-
  Count > MiddleY, !,
  display_y_coords(Count),
  display_void(Line),
  display_line_content(Line), nl,
  display_y_coords,
  display_void(Line),
  display_line_lower_border(Line), nl.

% display_line_upper_border(+Line)
% displays the upper border of the hexagons.
display_line_upper_border([]).
display_line_upper_border([-1 | LineTail]):-
  display_line_upper_border(LineTail).
display_line_upper_border([_ | LineTail]):-
  write(' / \\'),
  display_line_upper_border(LineTail).

% display_line_content(+Line)
% displays the content of a line, it can be empty, a piece or a golden tile.
display_line_content([]):- write('|').
display_line_content([-1 | LineTail]):-
  display_line_content(LineTail).
display_line_content([LineHead | LineTail]):-
  get_tile_display(LineHead, TileText),
  format('| ~a ', [TileText]),
  display_line_content(LineTail).

% display_line_lower_border(+Line)
% displays the lower border of the hexagons.
display_line_lower_border([]).
display_line_lower_border([-1 | LineTail]):-
  display_line_lower_border(LineTail).
display_line_lower_border([_ | LineTail]):-
  write(' \\ /'),
  display_line_lower_border(LineTail).

% display_void(+Line)
% ignores all -1 values from Board rows
display_void(Line):- display_void(Line, -1).
display_void([-1 | LineTail], -1):-
  write('  '),
  display_void(LineTail, -1).
display_void(_, _):- !.  

% get_tile_display(+TileNum, -TileText)
% obtains tile content
get_tile_display(TileNum, TileText):-
  get_units_tens(TileNum, Units, Tens),
  get_tile_display(Tens, Units, TileText).

% get_tile_display(?TypeOfTile , +Units, +TileText)
% obtains tile text to display. (e.g golden tile is displayed as G).
get_tile_display(2, 0, 'G').
get_tile_display(1, 0, ' ').
get_tile_display(_, Units, TileText):-
  Units >= 1, Units =< 8,
  get_piece(Units, _, _, TileText).
get_tile_display(_, _, '?').

% display_winner(+Winner,+PlayerType)
% displays the winner of the match as well as the type of player he is.
display_winner(Winner, PlayerType):-
  format('The winner is ~a (~a)!', [Winner, PlayerType]).
