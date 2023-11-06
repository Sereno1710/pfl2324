% menu/0
% prints menu and allows users to choose what type of opponent they want to play
menu:-
  print_menu,
  process_menu_input.


% print_menu/0
% prints menu
print_menu:-
  clear_screen,
  write('  _________   __________________________  _   __'), nl,
  write(' /_  __/   | / ____/_  __/  _/ ____/ __ \\/ | / /'), nl,
  write('  / / / /| |/ /     / /  / // / __/ / / /  |/ / '), nl,
  write(' / / / ___ / /___  / / _/ // /_/ / /_/ / /|  /  '), nl,
  write('/_/ /_/  |_\\____/ /_/ /___/\\____/\\____/_/ |_/   '), nl,
  nl,
  write('1. Human vs Human'), nl,
  write('2. Human vs Machine'), nl,
  write('3. Machine vs Human'), nl,
  write('4. Machine vs Machine'), nl.


% process_menu_input/0
% allows user to write the option he wants 
process_menu_input:-
  repeat,
  write('Select an Option: '),
  read(Option),
  process_menu_input(Option).


% process_menu_input(+Option)
% depending on the option chosen, the player will play/see different types of players
process_menu_input(1):- process_board_type(human,human).
process_menu_input(2):- process_board_type(human, machine).
process_menu_input(3):- process_board_type(machine, human).
process_menu_input(4):- process_board_type(machine, machine).

process_board_type(Player1,Player2):-
  
  write('1. Small with 2 golden tiles'), nl,
  write('2. Medium with 1 golden tile'), nl,
  write('3. Big with 3 golden tiles'), nl,
  write('Select a board type: '),
  repeat,
  read(Size),
  process_board_type(Player1,Player2,Size).

process_board_type(Player1,Player2,1):- start_game(Player1, Player2, 1).
process_board_type(Player1,Player2,2):- start_game(Player1, Player2, 2).
process_board_type(Player1,Player2,3):- start_game(Player1, Player2, 3).


