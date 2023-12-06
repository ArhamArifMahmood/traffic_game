import 'package:flutter/material.dart';
import 'Widget/Game.dart';

/*
Main method to run the game.
*/
void main() 
{
  runApp(const mainGame());
}

/*
 This is the main class that executes the game. It builds a MaterialApp using our Game class defined in the other file.
 */
class mainGame extends StatelessWidget 
{
  const mainGame({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return const MaterialApp
    (
      title: 'Traffic Lights Game',
      home: Game(),
    );
  }
}