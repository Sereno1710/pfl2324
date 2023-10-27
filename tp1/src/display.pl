clear_screen:- write('\33\[2J').

print_menu:-
  clear_screen,
  write('  _________   __________________________  _   __'), nl,
  write(' /_  __/   | / ____/_  __/  _/ ____/ __ \\/ | / /'), nl,
  write('  / / / /| |/ /     / /  / // / __/ / / /  |/ / '), nl,
  write(' / / / ___ / /___  / / _/ // /_/ / /_/ / /|  /  '), nl,
  write('/_/ /_/  |_\\____/ /_/ /___/\\____/\\____/_/ |_/   '), nl,
  nl,
  write('1. Player vs Player'), nl,
  write('Select an Option: ').

% print_piece(+Piece, +Colour)
print_piece(Piece, Colour):-
  get_piece(Piece, Colour, PieceText),
  write(PieceText).

% get_piece(+Piece, +Colour, -PieceText)
get_piece(pentagon, red, 'R_P').
get_piece(square, red, 'R_S').
get_piece(triangle, red, 'R_T').
get_piece(circle, red, 'R_C').

get_piece(pentagon, blue, 'B_P').
get_piece(square, blue, 'B_S').
get_piece(triangle, blue, 'B_T').
get_piece(circle, blue, 'B_C').

display_game(GameState):-
  print_piece(pentagon, red), nl,
  print_piece(square, red), nl,
  print_piece(triangle, red), nl,
  print_piece(circle, red), nl,

  print_piece(pentagon, blue), nl,
  print_piece(square, blue), nl,
  print_piece(triangle, blue), nl,
  print_piece(circle, blue).