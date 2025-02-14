//when the client sends information to the server, this event will trigger

if (ds_map_exists(async_load, "type")) {                    //Creates a DS map "Async Load" with key of "type"
    var type_event = ds_map_find_value(async_load, "type");
    show_debug_message("Network Event Triggered: Type = " + string(type_event));

    var socket;
    var buffer;

    switch (type_event) {
        
        case network_type_connect:
            socket = ds_map_find_value(async_load, "socket");
            ds_list_add(socket_list, socket);
            show_debug_message("Client Connected: Socket " + string(socket));
			
			//create player on server, tell other clients of connection
			var player = instance_create_depth(playerSpawnX,playerSpawnY,depth, obj_player);
            ds_map_add(socket_to_InstanceId, socket, player);
			
            buffer_seek(server_buffer,buffer_seek_start,0);
            buffer_write(server_buffer, buffer_u8, network.connect);
            buffer_write(server_buffer, buffer_u8, socket);
        //u16's for x, y coordinates
            buffer_write(server_buffer, buffer_u16, player.x);
            buffer_write(server_buffer, buffer_u16, player.y);
            network_send_packet(socket, server_buffer, buffer_tell(server_buffer));
        //This block of code will allow clients to see the other clients when they connect
        for (var i = 0; i < ds_list_size(socket_list); i++){
            var _sock = ds_list_find_value(socket_list,i);
            if _sock != socket
            {
                var _mock = ds_map_find_value(socket_to_InstanceId, _sock)
                buffer_seek(server_buffer,buffer_seek_start,0);
                buffer_write(server_buffer, buffer_u8, network.player_joined);
                buffer_write(server_buffer, buffer_u8, _sock);
                buffer_write(server_buffer, buffer_u16, _mock.x);
                buffer_write(server_buffer, buffer_u16, _mock.y);
                network_send_packet(socket, server_buffer, buffer_tell(server_buffer));   
            }
        }
            

        for( var i = 0; i < ds_list_size(socket_list); i++)
        {
            var _sock = ds_list_find_value(socket_list,i);
            if _sock != socket
            {
                buffer_seek(server_buffer,buffer_seek_start,0);
                buffer_write(server_buffer, buffer_u8, network.player_joined);
                buffer_write(server_buffer, buffer_u8, socket);
                buffer_write(server_buffer, buffer_u16, player.x);
                buffer_write(server_buffer, buffer_u16, player.y);
                network_send_packet(_sock, server_buffer, buffer_tell(server_buffer));   
            }
        }
        break;

        
        
        case network_type_disconnect:
            socket = ds_map_find_value(async_load, "socket");
            if (ds_list_find_index(socket_list, socket) != -1)
            {
                ds_list_delete(socket_list, ds_list_find_index(socket_list, socket));
            }
            with(ds_map_find_value(socket_to_InstanceId, socket)){instance_destroy();}
            show_debug_message("Client Disconnected: Socket " + string(socket)); // will this throw an error if socket is desotryed? Be on the look out
            break;

        case network_type_data:                                             //Runs on packet exchanges, each time
            buffer = ds_map_find_value(async_load, "buffer");                   
            socket = ds_map_find_value(async_load, "id");
            buffer_seek(buffer, buffer_seek_start, 0);
            show_debug_message("Data Received from Socket " + string(socket));
            received_packet(buffer, socket);
            break;
    }
}
