let filepaths = ["assets/shape-0.svg"];
// let filepaths = ['assets/tester.svg'];
let shapes;
let planet;
let planetDimensions = { width: 0, height: 0 };
let neutralColor = "#D0D0D0";

function loadPlanet(index) {

	planet = Snap("#planet-container");
	snap = Snap.load(filepaths[index], onPlanetLoaded);

}

function checkNeighbours(pathOfIntersection, colorString) {

    // go through all the shapes in the svg
    planet.selectAll('path').forEach((shape) => {
        // don't test with yourself
        if (pathOfIntersection === shape) {
            return;
        }
        let intersectionPath = Snap.path.intersection(pathOfIntersection, shape);
        if (intersectionPath.length > 0) {
            
            console.log(intersectionPath);
            console.log(colorString);

        }
    });

}

function onPlanetLoaded(data) {

	shapes = [];

	let g = data.selectAll("path,circle,rect,polygon,ellipse");
	g.forEach(function (e) {
		e.attr({ fill: neutralColor });
		e.attr({ stroke: neutralColor });
		e.attr({ strokeWidth: 1 });
		shapes.push(e);
	});
	planet.append(data);

	let childSvg = planet.select("svg");
	if (childSvg) {
		childSvg.node.id = 'planet';
		planetDimensions.width = childSvg.node.width.baseVal.value;
		planetDimensions.height = childSvg.node.height.baseVal.value;
	}


}


function isPointInside(pt) {

	let intersection = null;

	let svgRect = document.getElementById('planet').getBoundingClientRect();
	
	// first, get the normalized mouse position inside the svg element
	let x = (pt.x - svgRect.x) / svgRect.width;
	let y = (pt.y - svgRect.y) / svgRect.height;

	// if this is not inside the svg element, return null
	if (x < 0 || x > 1 || y < 0 || y > 1) {
		return null;
	}

	// expand the range to the svg element
	x = map(x, 0, 1, 0, planetDimensions.width);
	y = map(y, 0, 1, 0, planetDimensions.height);

	let s = Snap("#planet-container");
	let paths = s.selectAll('path'); // select all path elements
	paths.forEach((path) => {
		let d = path.attr('d')
		let isInside = false;
		isInside = Snap.path.isPointInside(d, x, y);
		if (isInside) {
			intersection = path;
			return; // Exit the current iteration of the loop
		}
	});

	return intersection;
}


function colorPlanetSegment(segment, couleur) {

	segment.attr({ 'fill': couleur });
	segment.attr({ 'stroke': couleur });

}