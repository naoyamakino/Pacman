      var marker1lat;
      var marker1long;
      var marker2lat;
      var marker2long;
      var map;
      var marker1;
      var marker2;
      var rectangle;

      function init() {
        map = new google.maps.Map(document.getElementById('map'), {
          'zoom': 14,
          'center': new google.maps.LatLng(49.284, -123.120),
          'mapTypeId': google.maps.MapTypeId.ROADMAP
        });

      
        marker1 = new google.maps.Marker({
          map: map,
          position: new google.maps.LatLng(49.280, -123.13),
          draggable: true,
        });
        marker2 = new google.maps.Marker({
          map: map,
          position: new google.maps.LatLng(49.284, -123.120),
          draggable: true,
        });
        
        google.maps.event.addListener(marker1, 'drag', redraw);
        google.maps.event.addListener(marker2, 'drag', redraw);
        
	rectangle = new google.maps.Rectangle({
          map: map
        });
        redraw();
      }
      
      function redraw() {
        var latLngBounds = new google.maps.LatLngBounds(
          marker1.getPosition(),
          marker2.getPosition(),
		  marker1lat = marker1.getPosition().lat(),
		  marker1long = marker1.getPosition().lng(),
		  marker2lat = marker2.getPosition().lat(),
		  marker2long = marker2.getPosition().lng()

        );
        rectangle.setBounds(latLngBounds);
      }