// simple csv creation flow

// load libs, filesystem and fast-csv 
const fs = require('fs');
const { format, writeToStream } = require('fast-csv');

// create file output
const fileout = fs.createWriteStream("out.csv");

// assing header for csv format
const csvStream = format({ headers: ['id', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10']});

// end process, pipes to fileout on exit.
csvStream.pipe(fileout).on('end', () => process.exit());


// // write write info to file
// csvStream.write(['v1', 'v2']);
// csvStream.end();

///////////////////////
// testing freelisting
//

// RNG function
function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
  }

// create array of choices
const itemArray = ['Apple', 'Box', 'Chair', 'Dishes', 'Eggs', 'Firewood', 'Grain', 'Heater', 'Ice', 'Juice', 'Kava', 'Lime', 'Money'];


// function to select from array
const chooseItem = function (i) {
    return itemArray[i];
}

// create an array to fill csv line
// naTestBoolean to test incomplete form behaviour
const fillCsv = function(id, naTestBoolean) {
    let max = 10;
    if(naTestBoolean){
        max= getRandomInt(7) + 4;
    }
    let line = [id]
    for(let i=0; i<max; i++){
        // force bias to certain item for testing salience etc...
        if (Math.random() < 0){
            line.push(chooseItem(0))
        } else {
        line.push(chooseItem(getRandomInt(12)));
        }
    }
    return line
}


// test function to write to csv
for(let i = 0; i< 40; i++){
    let test = fillCsv(i, true);
    csvStream.write(test);
}
csvStream.end();