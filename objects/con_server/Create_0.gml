port = 5001;
max_client = 20;
playerSpawnX = 100;
playerSpawnY = 100;

enum network {connect, player_joined, player_disconnect, move}



server = network_create_server(network_socket_tcp, port, max_client);                  // Create TCP server

while (server < 0 && port < 65535)
{
    port++
    server = network_create_server(network_socket_tcp, port, max_client);
}
if (server >= 0) {
    show_debug_message("Server started successfully on port " + string(port));
} else {
    show_debug_message("Failed to start server on port " + string(port));
}

server_buffer = buffer_create(1024,buffer_grow, 1);                                    //Create the server buffer


socket_list = ds_list_create();                                                        //Data for client

socket_to_InstanceId = ds_map_create();                                                
