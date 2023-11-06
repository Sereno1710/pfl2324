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
process_menu_input(2):- 
  read_machine_level(Player2), 
  process_board_type(human, Player2).
process_menu_input(3):- 
  read_machine_level(Player1),
  process_board_type(Player1, human).
process_menu_input(4):- 
  read_machine_level(Player1),
  read_machine_level(Player2),  
  process_board_type(Player1, Player2).

% read_machine_level(-Player)
% depending on the option chosen, the machine will have a different difficulty
read_machine_level(Player):-
  write('1. Easy'), nl,
  write('2. Hard'), nl,
  repeat,
  write('Select a bot level: '),
  read(Level),
  process_machine_level(Level, Player).

process_machine_level(1, machine1).
process_machine_level(2, machine2).

process_board_type(Player1,Player2):-
  
  write('1. Small with 1 golden tile'), nl,
  write('2. Medium with 2 golden tile'), nl,
  write('3. Big with 3 golden tiles'), nl,
  repeat,
  write('Select a board type: '),
  read(Size),
  start_game(Player1,Player2,Size).

