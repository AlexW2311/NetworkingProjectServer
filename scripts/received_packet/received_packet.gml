// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function received_packet(_buffer,_socket){
    //first read, matches data
    var msgId = buffer_read(_buffer, buffer_u8) //read first buffer item
    
    switch(msgId) //case from item
    {
        
        case network.established:
            var _username = buffer_read(_buffer, buffer_string);
            networkPlayerConnect(_socket,_username);
        
            break;
        
        
        case network.move: 
        //read in data
        var moveX = buffer_read(_buffer, buffer_u16);
        var moveY = buffer_read(_buffer, buffer_u16);
        var spriteDirection = buffer_read(_buffer, buffer_u8);
        //read in directional data here
        
        //finds player movement values
        var _player = ds_map_find_value(socket_to_InstanceId, _socket);
        _player.x = moveX;
        _player.y = moveY;
        _player.direction = spriteDirection;               // this was direction before, if its broken
        //updates to all other clients
        for(var i = 0; i < ds_list_size(socket_list); i++){
            var _sock = ds_list_find_value(socket_list, i);
            
            buffer_seek(server_buffer, buffer_seek_start, 0);
            buffer_write(server_buffer, buffer_u8, network.move);
            buffer_write(server_buffer, buffer_u8, _socket);
            buffer_write(server_buffer, buffer_u16, moveX);
            buffer_write(server_buffer, buffer_u16, moveY);
            buffer_write(server_buffer, buffer_u8, _player.direction); // here too
            network_send_packet(_sock, server_buffer, buffer_tell(server_buffer));
        }
        

        break;
        
        
        case network.chat:
            var _chat = buffer_read(_buffer, buffer_string); //Reads chat input from a user
            var player = ds_map_find_value(socket_to_InstanceId, _socket); //Get instance ID of client 
            _chat = player.username + ": "+_chat;  // Adds Client name to chat string
        for(var i = 0; i < ds_list_size(socket_list); i++){  //sends chat input to all other clients
                    var _sock = ds_list_find_value(socket_list, i)
                    
                    buffer_seek(server_buffer, buffer_seek_start, 0);
                    buffer_write(server_buffer, buffer_u8, network.chat);
                    buffer_write(server_buffer, buffer_string, _chat);
                    network_send_packet(_sock, server_buffer, buffer_tell(server_buffer));
        }
        break;
    }
    

};
