function showMapWindow (url, retId, width, height, sender) {
		var param = "width = " + width + "," + "height = " + height + "," + "location=no";
    window.open(url, retId, param);
}
