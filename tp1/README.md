# TP1 - PFL 23/24

## Group Information
- **Game**: Tactigon
- **Group**: 2

| Student number | Full name                  | Contribution |
| -------------- | -------------------------- | ------------ |
| 202108791      | Daniel José de Aguiar Gago | 50%          |
| 202108729      | José Miguel Sereno Santos  | 50%          |

## Installation and Execution
To run the game in both Linux and Windows environments, follow these steps:

1. Install [SICStus Prolog 4.8](https://sicstus.sics.se/download4.html).
2. Consult the `main.pl` file located in the `/src` directory by clicking on File -> Consult.
3. If you are using Linux, choose the font `FreeMono` with font size `14` in Settings -> Font. If you are using Windows. choose the font `Cascadia Mono` with font size `14` in Settings -> Font.
4. Use the starting predicate `play/0` to start the program.
```
| ?- play.
```

## Description of the Game

Tactigon is turn-based 2-player board game where each side (Red and Blue) has four types of pieces. They are the Circle, the Triangle, the Square, and the Pentagon. 

### Board Set Up

Each player starts with 6 Circles, 3 Triangles, 3 Squares and 1 Pentagon.

During initial setup, the pieces are placed according to the following diagram:

![Tactigon Board](resources/tactigon-board.png)

### Gameplay

#### Movement

- Usually, Red moves first, but it's up to the players to decide. 

- A turn consists of a player moving one of their pieces, and resolving any combat that may result from that movement.

- Pieces can move in any path and direction up to their maximum spaces (E.g a move does not need to be done in a straight line). The maximum spaces a piece can move is dictated by the following table:

| Piece    | Max spaces per turn |
| -------- | ------------------- |
| Circle   | 1 space             |
| Triangle | 3 spaces            |
| Square   | 4 spaces            |
| Pentagon | 5 spaces            |

- Pieces cannot jump over other pieces.



#### Combat

- Pieces enter combat when a player moves one of their pieces into a tile occupied by an enemy piece.

- Combat ends a player's turn (the piece cannot continue moving afterwards).

- Combat has two potential outcomes:
  1. The defending piece is captured.
  2. Both the atacking and defending pieces are captured.

- When a piece is captured, it is removed from the board and cannot return.

- The outcome of each combat is indicated by the following table:

![Combat Outcomes](resources/combat-outcomes.png)

### Objective

Achieving victory can be done in 2 ways.

1. Capturing the opposing Pentagon: if this piece is captured, the game instantly ends and the player that captured the Pentagon is the winner.

2. Gold Tile Victory: occupying both golden tiles at the **end** of your opponent's turn wins the game.

## Game Logic

### Internal Game State Representation

Gamestate is an essential argument for all main predicates. It is composed by Board and Turn.
The Board is a non-quadratic matrix that contains all board elements: tiles, pieces, and the number -1, meaning non-existent. 
Board tiles are either 1 or 2 followed by unit number. Tile is 10 if it is an empty normal tile, 20 if it is golden.

RedPlayer units are numbered from 1 to 4, so BluePlayer units are numbered between 5 and 8. Being 1 and 5 pentagons, 2 and 6 squares, 3 and 7 triangles and finally 4 and 8 circles.

In the board display, figures are displayed instead of numbers being Red side the black colored figures and Blue side white figures.

Turn decides which player is supposed to move. Red player moves first.

**Initial Game State:**
```
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
```



![Initial Game State](resources/InitialGameState.png)


**Middle Game State:**

```
    Board = [
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,10,-1,10,-1,12,-1,14,-1,20,-1,18,-1,10,-1,18,-1,10,-1,-1],
    [-1,10,-1,10,-1,14,-1,14,-1,10,-1,18,-1,10,-1,17,-1,16,-1,10,-1],
    [10,-1,13,-1,11,-1,12,-1,10,-1,10,-1,10,-1,16,-1,15,-1,17,-1,10],
    [-1,10,-1,10,-1,13,-1,10,-1,10,-1,10,-1,16,-1,10,-1,10,-1,10,-1],
    [-1,-1,10,-1,10,-1,14,-1,12,-1,20,-1,18,-1,10,-1,10,-1,10,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    ],
    Turn = blue.
```

![Middle Game State](resources/MiddleGameState.png)


**Final Game State**

There are two possible end game states:

  1. Capturing Pentagon
  ```
  Board = [
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,10,-1,10,-1,10,-1,14,-1,20,-1,17,-1,10,-1,16,-1,12,-1,-1],
    [-1,10,-1,10,-1,10,-1,13,-1,10,-1,18,-1,10,-1,10,-1,10,-1,10,-1],
    [10,-1,10,-1,11,-1,10,-1,14,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10],
    [-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1],
    [-1,-1,10,-1,10,-1,14,-1,10,-1,28,-1,10,-1,10,-1,10,-1,10,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    ]
  ```
  ![Capturing Pentagon](resources/CapturingPentagon.png)

  2. Occupying both golden tiles after enemy turn
  
  ```
  Board = [
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
    [-1,-1,10,-1,10,-1,12,-1,10,-1,24,-1,18,-1,10,-1,18,-1,10,-1,-1],
    [-1,10,-1,10,-1,14,-1,14,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
    [10,-1,13,-1,11,-1,12,-1,10,-1,10,-1,18,-1,16,-1,15,-1,17,-1,10],
    [-1,10,-1,10,-1,13,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1,10,-1],
    [-1,-1,10,-1,10,-1,14,-1,10,-1,22,-1,18,-1,10,-1,10,-1,16,-1,-1],
    [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    ]
  ```
  ![Golden Tiles EndGame](resources/GoldTilesEnd.png)  

## GameState Visualizer

After executing **play/0** , user(s) will be presented a menu where they can choose the mode they want. <br>

      A- Gamemode(H vs H / H vs M / M vs H / M vs M) 
      B- Bot Difficulty Level 

All these options require user input, therefore, a validation predicate was created.

In menu.pl, mode selection validation in the following way:

```
% process_menu_input/0
process_menu_input:-
  repeat,
  write('Select an Option: '),
  read(Option),
  process_menu_input(Option).

% process_menu_input/0
process_menu_input(1):- start_game(human, human).
process_menu_input(2):- difficulty(human, machine).
process_menu_input(3):- difficulty(machine, human).
process_menu_input(4):- difficulty(machine, machine).  

```

Bot difficulty validation is done in the following way:

```

  Missing code

```

After mode and bot difficulty choice, the game is initiated by the predicate **start_game/2** found in `game.pl`.

```
  % start_game(+CurrPlayer, +NextPlayer)
  start_game(CurrPlayer, NextPlayer):-  
    initial_state( _ , GameState),
    game_loop(GameState, CurrPlayer, NextPlayer).
```

After initializing GameState, the board is drawn for the first time. After each executed move, board is displayed again by the following predicate **display_board/1** found in `display.pl`.

```
  % display_game(+Board)
  display_game(Board):-
    clear_screen,  % clears console
    nl, nl,
    display_x_coords(Board), % displays X axis
    display_lines(Board), % displays Y axis and draws board with pieces
    nl, nl.
```

To display pieces, it was necessary to create a predicate to obtain piece information **get_piece/4** that can be found in `utils.pl`.


```
% get_piece(?Id, ?Piece, ?Colour, ?PieceDisplay)
get_piece(1, pentagon, red, '\x2B1F\').
get_piece(2, square, red, '\x25A0\').
get_piece(3, triangle, red, '\x25B2\').
get_piece(4, circle, red, '\x25CF\').

get_piece(5, pentagon, blue, '\x2B20\').
get_piece(6, square, blue, '\x25A1\').
get_piece(7, triangle, blue, '\x25B3\').
get_piece(8, circle, blue, '\x25CB\').

```
    




## Bibliography
Official Game Website - https://tactigongame.com/how-to-play/

Documentação SICSTUS - https://sicstus.sics.se/sicstus/docs/latest/html/sicstus/index.html#SEC_Contents






