// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function networkPlayerConnect(socket, _username){
    //create player on server
                var player = instance_create_depth(playerSpawnX,playerSpawnY,depth, obj_player);
                player.username = _username;
                ds_map_add(socket_to_InstanceId, socket, player); //Add socket as key w/ value of obj player instance ID
    #region Create obj_player for connecting client
    
                buffer_seek(server_buffer,buffer_seek_start,0);
                buffer_write(server_buffer, buffer_u8, network.connect);
                buffer_write(server_buffer, buffer_u8, socket);
            //u16's for x, y coordinates
                buffer_write(server_buffer, buffer_u16, player.x);
                buffer_write(server_buffer, buffer_u16, player.y);
                buffer_write(server_buffer, buffer_string, player.username);
                network_send_packet(socket, server_buffer, buffer_tell(server_buffer));
    #endregion
    
    #region Send current client list to connecting client
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
                    buffer_write(server_buffer, buffer_string, _mock.username)
                    network_send_packet(socket, server_buffer, buffer_tell(server_buffer));   
                }
            }
                
    #endregion
    
    #region Send connected clients, the new client that is joining 
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
                    buffer_write(server_buffer, buffer_string, player.username);
                    network_send_packet(_sock, server_buffer, buffer_tell(server_buffer));   
                }
            }
    #endregion
}