/// @description Insert description here
// You can write your code in this editor
// Game End Event or Server Stop Logic
network_destroy(server); // Destroys the server socket
buffer_delete(server_buffer); // Frees the server buffer
ds_list_destroy(socket_list); // Clears and frees the socket list
