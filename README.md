# AsteroiDE2
An interpretation of the classic cabinet arcade game Asteroids. In Asteroids, the player controls a ship that starts in the middle of the screen. Around them are asteroids that move across the screen along a linear path. If the player collides with one of these asteroids, they lose their ship and the game. The player has the capability to turn their ship, move it around the screen, and for the ship to destroy asteroids.


###### You will need:
- Altera DE2 Board with the USB Blaster and Power Cord
- Keyboard with a ps2 connector
- VGA display, preferably set to a 160x120 resolution
- Computer (to run Quartus)

###### To assemble:
1. Plug in the DE2 Board (usb blaster to connect it to the computer and power cord)
2. Plug in the VGA Displau (the port is on the top side of the board, towards the right)
  NOTE: There are two display ports, the one on the left is the VGA
3. Plug in the keyboard (the port is on the right side of the board, towards the top)

###### To run on an Altera DE2 Board:
1. Load a project named "Working" into Quartus (Quartus Prime 16.1 Lite Edition)
2. Load in the key assignments (de2.qsf)
3. Compile the project
4. Open the Programmer and add the compiled file
5. Program it (hit "Start" in the Programmer window) onto the DE2 Board (make sure the run setting is on)
6. Assure Switch 17 is up and have fun!

###### Controls:
SW[1] to SW[8] inclusive activate asteroids (1-8)
WASD controls the ship's direction
KEY[1] to KEY[4] fires the bullet (only one bullet on screen at a time!)
SW[17] turns the screen on and off

###### Displays:
The VGA Display shows the game
The left-most two hex displays (HEX7 and HEX6) are how many times the ship has been hit by an asteroid
The middle two hex displays (HEX5 and HEX4) are how many asteroids have been hit
The right-most four hex displays (HEX3, HEX2, HEX1, and HEX0) are how long you've been alive (in seconds)

###### Have fun birdies~
