    var map;
    
    function initMap(lat, lng, fixedCenter) {
      var latlng = new google.maps.LatLng(lat, lng);
      var opts = {
        zoom: 8,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        center: latlng
      };
      map = new google.maps.Map(document.getElementById("gmap"), opts);
			setMarker(lat, lng, map, fixedCenter);
    }

    function initMapCustomControl(controlUI) {
        controlUI.index = 1;
        controlUI.style.marginBottom = "15px";
        map.controls[google.maps.ControlPosition.BOTTOM_CENTER].push(controlUI);
    }

		function setLatLng(id) {
				document.getElementById(id).value= map.getCenter();
		}

		function clearLatLng(id) {
				document.getElementById(id).value= "";
		}

		function setMarker(lat,lng,map,fixedCenter){
				var latLng = new google.maps.LatLng(lat, lng);
        var marker = new google.maps.Marker({
            position: latLng,  map: map,
            zIndex: 1000
        });

				if(fixedCenter){
      	  cm_flag = true;
					google.maps.event.addListener(map, 'center_changed', function(none) {
   	         if (cm_flag) {
   	             marker.setMap(null);
   	             marker.setPosition(map.getCenter());
   	             marker.setMap(map);
   	         }
   	      });
				}
		}

    function returnValue() {
			var latLng = map.getCenter();
      latLng = new google.maps.LatLng(latLng.lat(), latLng.lng()); // see https://code.google.com/p/gmaps-api-issues/issues/detail?id=3247
      window.opener.$("#" + window.name).val(latLng.lat() + "," + latLng.lng());
    }
