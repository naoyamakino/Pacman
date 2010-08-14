// BASE URL 
// Set the base URL here (used for ajax calls, image resources)
var baseURL = 'http://cmpt470.csil.sfu.ca:8009/pacman/'
// Set the base URL here (used for ajax calls, image resources)
// TODO: Fix to unhackish root specification.

var request;
var map;
var player;
var object;
var playerMarkers = new Array();
var objectMarkers = new Array();

function initialize_map(){
  var mapOptions = { 
	    zoom: 12,
	    mapTypeControl: false,
	    mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
	    navigationControl: true,
	    navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
	    mapTypeId: google.maps.MapTypeId.ROADMAP      
}
map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
}

function initialize()
{

//grab coordinates of everyone, we're 'reinitializing' the map every time. 

	if(geo_position_js.init())
	{
		document.getElementById('current').innerHTML="Receiving...";
		geo_position_js.getCurrentPosition(show_positions,function(){document.getElementById('current').innerHTML="Couldn't get location"},{enableHighAccuracy:true});	
		
		//alert("Something just happened!");//do a call here to send position to server
		setTimeout(initialize, 5000); //tweak this as necessary
	}
	else
	{
		document.getElementById('current').innerHTML="Functionality not available";
	}
}
 
function show_positions(p)
{
	document.getElementById('current').innerHTML="latitude="+p.coords.latitude.toFixed(5)+" longitude="+p.coords.longitude.toFixed(5);
	var pos=new google.maps.LatLng(p.coords.latitude,p.coords.longitude);
	map.setCenter(pos);
	//map.setZoom(16);//sets level of zoom
	
	gameUpdate(p);
	
	//once we can successfully process the drawing of the user on their map, we send this information to the server as a function
 	//alert(request.success());
	//request.success() will allow us to print out whether or not the request was successful. We can update the status box below syaing 'successfully sent to server' or something. Status update # whatever, sent successfully. 
}
	
function gameUpdate(p) 
{
	myString = window.location.toString();
	path_array = myString.split("/");	
	game_id = path_array[path_array.length-1];
 
	/*
	var request = new Ajax.Request('http://cmpt470.csil.sfu.ca:8009/pm_dev/games/play',{ 
	parameters: {game_id, lat: p.coords.latitude, long: p.coords.longitude}, onSuccess: function(){onResponse()}}
	*/
	
	//for testing parsing from a file
	var options = {parameters: {game_id: game_id, lat: p.coords.latitude, long: p.coords.longitude}, onSuccess: onResponse}
	request = new Ajax.Request(baseURL + 'games/play', options)
	
}

function on200(originalRequest)
{
  onResponse(originalRequest)
}
	
function onResponse(originalRequest){

//z = xmlDoc.getElementsByTagName('entities');
var z = originalRequest.responseXML.getElementsByTagName('entities');
var x = z[0].getElementsByTagName('player');

for (i =0;i<playerMarkers.length;i++){
	playerMarkers[i].setMap(null);
}//clear the board


for (i=0; i<x.length; i++)
	{
			//GET game data
			latitude = x[i].getElementsByTagName('lat');
			longitude = x[i].getElementsByTagName('long');
			player_id = x[i].getElementsByTagName('id');
			type = x[i].getElementsByTagName('type');
			stat = x[i].getElementsByTagName('status');
	//gameid = x[i].getElementsByTagName('gameid');
	
			lat_text = latitude[0].firstChild.nodeValue;
			long_text = longitude[0].firstChild.nodeValue;
			playerid_text = player_id[0].firstChild.nodeValue;
			type_text = type[0].firstChild.nodeValue;
			status_text = stat[0].firstChild.nodeValue;

	//places player locations
			if (type_text == 'Ghost'){
			var pos = new google.maps.LatLng(lat_text, long_text);
			playerMarkers[i] = new google.maps.Marker();
			playerMarkers[i].setPosition(pos);
			playerMarkers[i].setMap(map);
			playerMarkers[i].setDraggable(false);
			playerMarkers[i].setIcon(baseURL + 'images/ghost');
			}
			else{
			var pos = new google.maps.LatLng(lat_text, long_text);
			playerMarkers[i] = new google.maps.Marker();
			playerMarkers[i].setPosition(pos);
			playerMarkers[i].setMap(map);
			playerMarkers[i].setDraggable(false);
			playerMarkers[i].setIcon(baseURL + 'images/pacman_icon');
			}
	
	}
 
var d = z[0].getElementsByTagName('dot');

for (i = 0;i<objectMarkers.length;i++){
	objectMarkers[i].setMap(null)
}


for (i=0;i<d.length;i++)
	{
  	//GET in-game data
  	latitude = d[i].getElementsByTagName('lat');
   	longitude = d[i].getElementsByTagName('long');
    	isPowerup = d[i].getElementsByTagName('isPowerup');
	lat_text = latitude[0].firstChild.nodeValue;
    	long_text = longitude[0].firstChild.nodeValue;
    	isPowerup_text = isPowerup[0].firstChild.nodeValue;
	
	//place dot markers
	if (isPowerup_text == 'false'){
		var pos = new google.maps.LatLng(lat_text, long_text);
		objectMarkers[i] = new google.maps.Marker();
		objectMarkers[i].setPosition(pos);
		objectMarkers[i].setMap(map);
		objectMarkers[i].setDraggable(false);
		objectMarkers[i].setIcon(baseURL + 'images/dot');
		}
	else{
		
		var pos = new google.maps.LatLng(lat_text, long_text);
		objectMarkers[i] = new google.maps.Marker();
		objectMarkers[i].setPosition(pos);
		objectMarkers[i].setMap(map);
		objectMarkers[i].setDraggable(false);
		objectMarkers[i].setIcon(baseURL + 'images/powerUp');
		
	}
 
	} // end for dots
} //end for onResponse
 

