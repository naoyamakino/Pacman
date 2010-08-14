var baseURL = 'http://cmpt470.csil.sfu.ca:8009/pacman/'
var flipit = 0;
function toggleReady()
{	
	myString = window.location.toString();
	path_array = myString.split("/");	
	game_id = path_array[path_array.length-1];
	var options = {parameters: {game_id: game_id}}
	request = new Ajax.Request(baseURL + 'games/toggleReady', options)
	

}


function flipText(myButton){
	var button = document.getElementById(myButton);
	if (flipit == 0){
		button.value = "Send Ready";
		flipit = 1;
	}
	else{
		button.value = "Retract Ready";
		flipit = 0;
	}
}
