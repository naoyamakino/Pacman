function initialize_map()
{
    var myOptions = {
	      zoom: 6,
	      mapTypeControl: true,
	      mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
	      navigationControl: true,
	      navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
	      mapTypeId: google.maps.MapTypeId.ROADMAP      
	    }	
	game_map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	marker = new google.maps.Marker(); //later on we probably want an array of markers to mark ALL the positions of all players
	game_id = 3;
	player_id = 1234;
	//both game_id and player_id will be updated by the server at initial handshake and greeting, these variables will be stored userside. 
  google.maps.event.addDomListener(window, 'load', initialize_map);
}
function initialize()
{
	if(geo_position_js.init())
	{
		document.getElementById('current').innerHTML="Receiving...";
		geo_position_js.getCurrentPosition(show_position,function(){document.getElementById('current').innerHTML="Couldn't get location"},{enableHighAccuracy:true});	
		
		//alert("Something just happened!");//do a call here to send position to server
		setTimeout(initialize, 5000);
	}
	else
	{
		document.getElementById('current').innerHTML="Functionality not available";
	}
  google.maps.event.addDomListener(window, 'load', initialize);
}

function show_position(p)
{
	document.getElementById('current').innerHTML="latitude="+p.coords.latitude.toFixed(5)+" longitude="+p.coords.longitude.toFixed(5);
	var pos=new google.maps.LatLng(p.coords.latitude,p.coords.longitude);
	game_map.setCenter(pos);
	game_map.setZoom(16);//sets level of zoom
	
	//once we can successfully process the drawing of the user on their map, we send this information to the server as a function

	var request = new Ajax.Request('http://cmpt470.csil.sfu.ca:8009/pm_dev/match_logs/create/0',{ 
		parameters: {lat: p.coords.latitude, long: p.coords.longitude, player_id: player_id, game_id: game_id}
		});	
	//alert(request.success());
	//request.success() will allow us to print out whether or not the request was successful. We can update the status box below syaing 'successfully sent to server' or something. Status update # whatever, sent successfully. 
	
	
	marker.setMap(null);
	marker.setPosition(pos);
	marker.setMap(game_map);
	marker.setTitle(title);

}