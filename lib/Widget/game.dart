import 'package:flutter/material.dart';

/*
This class creates the game state and takes the logic of updating the game board and checking the winning condition, etc.
The class extends StatefulWidget because it has updateable states from user interactions, in our case, the changing 
colors and winning flags.
 */
class Game extends StatefulWidget 
{
  const Game({super.key});

  @override
  GameState createState() => GameState();

}

/*
This class is the state of the game and is the meat of our application. It contains the logic for building the game, updating 
the state of the game, checking if the game is over, updating the player's turn, etc.
 */
class GameState extends State<Game> 
{
  // Instance variables for grid, player, and winning checker flag
  List<List<String>> grid = List.generate(3, (_) => List.generate(4, (_) => 'off'));
  int currentPlayer = 1;
  bool gameOver = false;

  /*
  This method is responsible for updating the string value of the elements of the matrix. This string representation
  is updated when a user clicks on an element, and depending on the previous color, it changes the string to represent
  the next color. This string representation is then later used in setting the actual color state of the element.
   */
  void updateLight(int row, int col) 
  {
    String currentStatus = grid[row][col];
    if (currentStatus != 'red') 
    {
      switch (currentStatus) 
      {
        case 'off':
          grid[row][col] = 'green';
          break;
        case 'green':
          grid[row][col] = 'yellow';
          break;
        case 'yellow':
          grid[row][col] = 'red';
          break;
        default:
          break;
      }
    }
  }


/*
This method is the logic to check if a player has won. It checks if there are 3 conscutive colors horizontally,
then vertically, and lastly, it checks the 4 possible diagonal conditions for a win.
 */
bool checkWin(String color) 
{
  // Horizontal win condition
  for (var row in grid) 
  {
    for (int i = 0; i < 2; i++) 
    { 
      if (row[i] == color && row[i + 1] == color && row[i + 2] == color) 
      {
        return true;
      }
    }
  }

  // Vertical win condition
  for (int col = 0; col < 4; col++) 
  {
    if (grid[0][col] == color && grid[1][col] == color && grid[2][col] == color) 
    {
      return true;
    }
  }

  /*
  Diagonal win conditions
   */

  // Top left case
  if (grid[0][0] == color && grid[1][1] == color && grid[2][2] == color) 
  {
    return true;
  }

  // Second element in top row case
  if (grid[0][1] == color && grid[1][2] == color && grid[2][3] == color) 
  {
    return true;
  }

  // Third element in top row to first element in bottom row
  if (grid[0][2] == color && grid[1][1] == color && grid[2][0] == color) 
  {
    return true;
  }

  // Last element in top row to second element in bottom row
  if (grid[0][3] == color && grid[1][2] == color && grid[2][1] == color) 
  {
    return true;
  }

  return false;
}

/*
 This simple method just resets the board by building a new, fully off board and setting the state of our grid to that, and it
 also resets the state of the player to player 1
 */
void resetGame() 
{
  setState(() 
  {
    grid = List.generate(3, (_) => List.generate(4, (_) => 'off'));
    currentPlayer = 1;
  });
}

  /*
   This is the building logic of our grid. It builds the grid in the desired format, and creates the tiles as buttons, and 
   sets up the clicking logic. Each time a button is clicked, it calls the updateLight method, and the checkWin method.
   It also pops alerts if a victory is reached, and offers a restart option as well, upon which the reset method is called.
   */
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Traffic Lights Game - Player $currentPlayer\'s Turn'), // Title area and player turn indicator
      ),

      body: GridView.builder
      (
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount // Grid builder with spacing in the middle of each tile
        (
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10, 
        ),
        itemCount: 12,
        itemBuilder: (context, index) 
        {
          int row = index ~/ 4;
          int col = index % 4;
          return GridTile(
            child: TextButton // Tile buttons
            (
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, 
                backgroundColor: getColor(grid[row][col]), // Tile color setting
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Tile shape setter
              ),
              // When tile is pressed, if game is still going and tile is not red, set the state of tile which triggers 
              // color change
              onPressed: !gameOver && grid[row][col] != 'red' ? () => setState(() 
              {
                updateLight(row, col);
                if (checkWin(grid[row][col])) // Check win conditions
                {
                  // If player has won
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) 
                    {
                      return AlertDialog
                      (
                        title: const Text("Congratulations!!"),
                        content: Text("Player $currentPlayer wins! Play again?"),
                        actions: <Widget>[
                          TextButton // Play again button to reset game
                          (
                            child: const Text("Yes"),
                            onPressed: () 
                            {
                              Navigator.of(context).pop();
                              resetGame();
                            },
                          ),
                          TextButton // Don't play again button (freeze screen) by setting gameOver flag to true
                          (
                            child: const Text("No"),
                            onPressed: () 
                            {
                              Navigator.of(context).pop();
                              setState(() {
                                gameOver = true;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                } 
                else // If not won yet, move to next player
                {
                  currentPlayer = currentPlayer == 1 ? 2 : 1;
                }

              }) : null,
              child: const Text(''),
            ),
          );
        },
      ),

    );
  }

  /*
  This method takes a string representation of the color and returns the appropriate color object
  */
  Color getColor(String color) 
  {
    switch (color) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}