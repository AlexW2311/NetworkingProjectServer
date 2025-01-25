// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function received_packet(_buffer,_socket){
	//first read, matches data
	var msgId = buffer_read(_buffer, buffer_u8) //read first buffer item
	
	switch(msgId) //case from item
	{
		case network.move: 
		//read in data
		var moveX = buffer_read(_buffer, buffer_u16);
		var moveY = buffer_read(_buffer, buffer_u16);
        
        var _player = ds_map_find_value(socket_to_InstanceId, _socket);
        _player.x = moveX;
        _player.y = moveY;
        
        
		
		//find start of server buffer, write some shit to it
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer, buffer_u8, network.move);
		buffer_write(server_buffer, buffer_u16, moveX);
		buffer_write(server_buffer, buffer_u16, moveY);
		
		
		//send that shit to the client socket suppplied 
		network_send_packet(_socket, server_buffer, buffer_tell(server_buffer));
		break;
	}
	
	
}