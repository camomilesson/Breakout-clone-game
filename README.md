# Breakout-clone-game

BREAKOUT50
Video Demo: https://www.youtube.com/watch?v=iED5bZVFfPI

Description:
Breakout50 is a videogame coded in Lua and Love2d. The player controls the bumper using arrow keys to prevent the ball(s) from falling off the screen. Balls collide with bricks that sometimes spawn powerups. The player collects powerups that spawn more balls, increase bumper speed or width, and attract other powerups towards the bumper. The goal of the game is to break all of the bricks without losing all of the balls. The player can choose between two level configurations: Hearts or Random.

All the objects on the screen are coded as Objects using OOP and Classic library. Subclasses extend basic Entities to provide them with additional properties and functionality.

main.lua combines all the code together and establishes rules for object interactions. First the program loads all the assets and spawns the level based on player choice. Then simultaneously updates the objects and draws them according to a game state currently enabled.

entity.lua creates a basic Object for use by different subclasses.

ball.lua is arguably the most important of all the files because it houses the collision resolution functions. Coding them from scratch was a tough but very interesting task. In short, at any point of the game any ball instance calculates its distance from the bumper and all the other bricks. The more complex and computing power-demanding collision detection function kicks in only when the object is close enough. Then the ball figures out in which of the octants it is regarding the object (N, NE, E, SE, etc.). Depending on the octant it either bounces off at a mirrored angle (if the collision surface is flat) or quasi-realistically bounces off a corner based on the angle of approach. Additionally, whenever collision with a brick occurs, the brick's health goes down and it might be destroyed.

bumper.lua determines the player's control over the bumper. The functions are pretty simple: initialisation, movement, visualisation.

brick.lua is used to spawn and manage all the bricks. They are initialised, saved into a table for usage in main.lua and other files, and drawn, but not updated. In addition, whenever a brick is destroyed there is a chance to spawn a powerup of random type.

poweup.lua creates, moves and pops powerups when they are collected by the bumper. Activate funtion checks the type of the poweup upon collection and triggers a variety of effects, for example makes all the other existing powerups move towards the bumper for a while. Afterwards the status of the powerup is switched to "used" and it is removed from the powerup table to save memory space.

button.lua determines button creation, visualisation and behavior.

