let catcherIndex = -1;
let possibleColors = [
    [0, 100, 100],
    [60, 100, 100],
    [90, 100, 100],
    [120, 100, 100],
    [180, 100, 100],
    [210, 100, 100],
    [240, 100, 100],
    [270, 100, 100],
    [300, 100, 100],
    [330, 100, 100]
];
let catcherColors = [];

function resetCatcher() {

    // send reset code to Catcher
    //catcherSerial.write('x');
    //catcherSerial.write('\n');

    catcherIndex = -1;
    catcherColors = [];

}


function setCatcherColor(r, g, b) {

    catcherIndex = ++catcherIndex % 4;

    if (catcherColors.length <= catcherIndex) {
        catcherColors.push([r, g, b]);
    } else {
        catcherColors[catcherIndex] = [r, g, b];
    }

    // send color code to Catcher
    //catcherSerial.write('c');
    //catcherSerial.write(catcherIndex.toString());
    //catcherSerial.write(r.toString());
    //catcherSerial.write(g.toString());
    //catcherSerial.write(b.toString());
    //catcherSerial.write('\n');

    console.log(catcherColors);

} 