# General Application Project

## General Chat - Server  

## Purpose  
The **General Chat** server acts as the central hub for managing player connections, handling real-time communication, and synchronizing game state. It relays movement, chat messages, and sprite data between clients, ensuring a seamless multiplayer experience.  

## Overview  
The server application for **General Chat**, a 2D multiplayer chatroom built in GameMaker Studio 2. It establishes a **TCP socket**, waits for client connections, and processes incoming network traffic to keep all connected players synchronized.  

## Features  
- Handles multiple client connections via TCP/IP  
- Receives and broadcasts real-time player movement and chat messages  
- Manages player states (position, sprite, direction)  
- Detects and handles client disconnections gracefully  

## Networking  
- Uses **TCP sockets** for reliable communication  
- Serializes and deserializes data using buffers (`buffer_write`, `buffer_read`)  
- Implements a structured message protocol (`connect`, `disconnect`, `move`, `chat`)  
- Broadcasts updates to all clients to maintain game state consistency  

## Future Plans  
- Optimize message handling for better performance  
- Implement persistent user data (e.g., saved usernames, profiles)  
- Prepare for deployment on dedicated servers  

## Requirements  
- GameMaker Studio 2  
- Port forwarding enabled (if hosting publicly)  
- A running instance of the **General Chat Client**  
