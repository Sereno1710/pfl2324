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
3. Choose the font `FreeMono` with font size `14` in Settings -> Font.
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

Turn decides which player is supposed to move. By default, RedPlayer is the first to move.

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




## Bibliography
Official Game Website - https://tactigongame.com/how-to-play/

Documentação SICSTUS - https://sicstus.sics.se/sicstus/docs/latest/html/sicstus/index.html#SEC_Contents






