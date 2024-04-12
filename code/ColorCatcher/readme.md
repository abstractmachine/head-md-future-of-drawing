# ColorCatcher
This is code for [Sarah Meylan](https://www.instagram.com/sarah.meylan/)’s [Color Catcher](https://github.com/SarahM1236/head-md-future-of-drawing/tree/main) project. It was designed for the exhibition [Drawing Futures](https://github.com/abstractmachine/head-md-future-of-drawing/tree/main/press) in collaboration with Caran d'Ache at Plateforme 10, Lausanne, May 14-24, 2024.

## Processing
We are using [Processing](http://processing.net) classic (Java edition) for this project. We could also have used [P5.js](http://p5js.org) (my personal preference) but Java handles SVG natively very well without any hacks, and given the SVG files Sarah will generate for this project, it's probably for the best. Also, serial communication will be easier to handle (Bluetooth is serial communication) using the old-skool app.

## Copilot
[Github Co-pilot](http://github.com/copilot) is awesome, which means we will be using [VS Code](https://code.visualstudio.com). There is a [free student tier for Copilot](https://techcommunity.microsoft.com/t5/educator-developer-blog/step-by-step-setting-up-github-student-and-github-copilot-as-an/ba-p/3736279).

## Processing <> VS Code
I'm using this tutorial for my setup: [Processing + Visual Studio Code setup for Mac](https://www.youtube.com/watch?v=FlVFRzX6jtE) and this is the direct link to the [Processing Extension](https://github.com/AvinZarlez/processing-vscode#add-processing-to-path) for VS Code.


## Processing Command Line
To install command line tools, open Processing app: `Menu` > `Tools` > `Install "processing-java"`

To test that installation worked:

```
% processing-java
```