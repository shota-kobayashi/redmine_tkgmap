    var map;
    
    function initMap(lat, lng) {
      var latlng = new google.maps.LatLng(lat, lng);
      var opts = {
        zoom: 8,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        center: latlng
      };
      map = new google.maps.Map(document.getElementById("gmap"), opts);
			setCenterMarker(map);
    }

		function setLatLng(id) {
				document.getElementById(id).value= map.getCenter();
		}

		function clearLatLng(id) {
				document.getElementById(id).value= "";
		}

    function setCenterMarker(map) {
        var centermarkImage = '/plugin_assets/redmine_tkgmap/images/red-dot.png';
        var image = new google.maps.MarkerImage(centermarkImage, new google.maps.Size(32,32),
        new google.maps.Point(0,0),  new google.maps.Point(16,16));
        var myLatLng = map.getCenter();
        var centerMarker = new google.maps.Marker({
            position: myLatLng,  map: map,
            icon: image,  zIndex: 1000
        });
        centerMark = centerMarker;
        cm_flag = true;
        google.maps.event.addListener(map, 'center_changed', function(none) {
            if (cm_flag) {
                centerMarker.setMap(null);
                centerMarker.setPosition(map.getCenter());
                centerMarker.setMap(map);
            }
        });
    }

    function returnValue() {
			var latLng = map.getCenter();
      window.opener.$("#" + window.name).val(latLng.lat() + "," + latLng.lng());
    }

