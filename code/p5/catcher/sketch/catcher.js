let catcherColorIndexes = [];

function resetCatcher() {

    // send reset code to Catcher
    //catcherSerial.write('x');
    //catcherSerial.write('\n');

    catcherIndex = -1;
    catcherColorIndexes = [];

}


function setCatcherColorUsingIndex(colorIndex) {

    if (catcherColorIndexes.length < 4) {
        catcherColorIndexes.push(colorIndex);
    }


    // send color code to Catcher device

	// convert hsv to rgb
    // let colorHue = possibleColors[colorIndex].hue;
    // let colorSaturation = possibleColors[colorIndex].saturation;
    // let colorBrightness = possibleColors[colorIndex].brightness;
	// let rgb = hsvToRgb(colorHue / 360.0, colorSaturation / 100.0, colorBrightness / 100.0);
    // let r = rgb[0];
    // let g = rgb[1];
    // let b = rgb[2];
    //catcherSerial.write('c');
    //catcherSerial.write(catcherIndex.toString());
    //catcherSerial.write(r.toString());
    //catcherSerial.write(g.toString());
    //catcherSerial.write(b.toString());
    //catcherSerial.write('\n');

} 