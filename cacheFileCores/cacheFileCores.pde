
// This function is required, this is called once, and used to setup your 
// visualization environment
int mode = 0;
int modeCount = 0;
float dataMin;
float dataMax;

/*
float cooleyColumnx[];
float cooleyColumny[];
float cetusColumnx[];
float cetusColumny[];
float lastColumnx[];
float lastColumny[];
*/
int columnCount = 0;
int[] triples;
int tripleMin;
int tripleMax;
FloatTable data;
float plotX1, plotY1;
float plotX2, plotY2;

float labelX, labelY;
// boolean volumeOn;
// boolean barGraphOn;


// Integrator[] interpolators;


// Small tick line
int volumeIntervalMinor = 200;

// Big tick line
int volumeInterval = 1000;


int currentColumn;
int yearInterval = 10;
int cetusColumn = 0;
int cooleyColumn = 1;
int lastColumn=2;

int rowCount;


// Tab variables for the menus
float[] tabLeft, tabRight; // Add above setup() 
float tabTop, tabBottom;
float tabPad = 10;
int visualization = 0;
int vizCount = 4;
int yMarks;


void setup() {
    // This is your screen resolution, width, height
    //  upper left starts at 0, bottom right is max width,height
   	size(720,720);
    
  
  
    // This calls the class FloatTable - java class 
  	data = new FloatTable("data/baseballsalaries.csv");
  	rowCount = data.getRowCount();
  	print("row count " + rowCount + "\n");

  	// Retrieve number of columns in the dataset
  	columnCount = data.getColumnCount();
  	dataMin = 0;
  	dataMax = data.getTableMax();
    yMarks = (int) dataMax / rowCount;
    print("Y marks " + yMarks + "\n");
  	triples = int(data.getRowNames());  
  	tripleMin = 0; // triples[0];
  	tripleMax = triples[triples.length - 1];
  	print("Min " + tripleMin + " max " + tripleMax + " column count " + columnCount + "\n");
  
  
    // Corners of the plotted time series
  	plotX1 = 130;
  	plotX2 = width - 80;
  	labelX = 50;
  	plotY1 = 60;
  	plotY2 = height - 70;
  	labelY = height - 25;
  
 
  
  	// Print out the columns in this dataset 
  	int numColumns = data.getColumnCount();
  	int numRows = data.getRowCount();
  
  
    rowCount = data.getRowCount();


/*
    interpolators = new Integrator[rowCount];
*/
    for (int row = 0; row < rowCount; row++) {
    	float initialValue = data.getFloat(row, 0);
      	print("value " + initialValue + "\n");
    }  
  
  

  
  
}


//Require function that outputs the visualization specified in this function
// for every frame. 
void draw() {
  
  
  	// Filling the screen white (FFFF) -- all ones, black (0000)
  	background(255);
  	drawVisualizationWindow();
 	drawGraphLabels();
 
   // These functions contain the labels along with the tick marks
	drawYTickMarks();
  	drawXTickMarks();
  	drawDataPoints();
drawDataLine(mouseX, mouseY);
drawDataLine1(mouseX, mouseY);
drawDataLine2(mouseX, mouseY);


 //  drawTitleTabs();
/*  
  for (int row = 0; row < rowCount; row++) { 
    interpolators[row].update( );
  }*/
  
}
void drawMousePoint(int mx, int my){
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,cooleyColumn);
    float y = mapLog(value);
    float x = map(row,0,rowCount-1,plotX1,plotX2);
    drawRollover(mx, my, x, y);
  }
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,cooleyColumn);
    float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
    float y = map(value, dataMin, dataMax, plotY2, plotY1);
    drawRollover(mx, my, x, y);
  }
}
void drawRollover(int mx, int my, float x, float y){
  x = round(x);
  y = round(y);
  float w = plotX2 - plotX1;
  float h = plotY2 - plotY1;
  float yy = h - (y - plotY1);
  float xx = x - plotX1;
  float d = sqrt(pow(mx-x, 2) + pow(my-y,2));
  if(d <= 12){
    String txt = "Point " + xx + ", "+ yy;
    textSize(16);
    fill(color(0));
    rect(x, y, x+textWidth(txt), y-20);
    fill(color(255));
    text(txt,x + textWidth(txt)/2,y-20);
  }
}

void drawTitleTabs() { 
  rectMode(CORNERS); 
  noStroke( ); 
  textSize(20); 
  textAlign(LEFT);
  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs.
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  float runningX = plotX1;
  tabTop = plotY1 - textAscent() - 15; 
  tabBottom = plotY1;
  for (int col = 0; col < columnCount; col++) {
    String title = data.getColumnName(col);
    tabLeft[col] = runningX;
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    // If the current tab, set its background white; otherwise use pale gray.
    fill(col == currentColumn ? 255 : 224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    // If the current tab, use black for the text; otherwise use dark gray.
    fill(col == currentColumn ? 0 : 64);
    text(title, runningX + tabPad, plotY1 - 10);
    runningX = tabRight[col];
  }
}

//void mouseOver(){
  
  // This is modulating from 1 to 3
  //  currentColumn = columnCount % 3;
  //  columnCount += 1;

  
   //if (mouseY > x && mouseY < y) {
   // for (int col = 0; col < columnCount; col++) {
   //   if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
    //    setColumn(col);
    //  }
  //  }
  //}
  
  
//}
void keyPressed() {
  if ( key == 't') {
      // Show bar graph
      visualization = visualization + 1;
	  if (visualization == vizCount) visualization = 0;
   }
  
}

void mousePressed(){
  ellipse( mouseX, mouseY, 5, 5 );
  text( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
  println( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
  
}

void setColumn(int col) {

	/*
       if (col != currentColumn) {
         currentColumn = col;
          for (int row = 0; row < rowCount; row++) {
            interpolators[row].target(data.getFloat(row, col));
          }
       }
  
   */  
     
}




void drawVolumeData(int col) {

  beginShape( );
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      //float value = interpolators[row].value;
      float value = data.getFloat(row, col);
      float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x, y);
    }
  }
  // Draw the lower-right and lower-left corners.
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);

  
}

/*
void drawtextPoints() {

  fill(#0000FF);   // Color blue
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,cooleyColumn);
    
    float y = mapLog(value);
  //  float myPoint = map(value, dataMin,dataMax,0,rowCount-1);
    // float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
    float x = map(row,0,rowCount-1,plotX1,plotX2);
    //float y = map(myPoint, 0, rowCount-1, plotY2, plotY1);
    // float y = map(newValue, 0, rowCount-1, plotY2, plotY1);
    ellipse(x, y, 5, 5);
    

  }

  fill(#FF0000);   // Color red
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,cetusColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
    ellipse(x, y, 5, 5);

  }
  fill(#01DF3A);   // Color green
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,lastColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
    ellipse(x, y, 5, 5);

  }
}
 */ 
  
  
void drawDataPoints() {

  fill(#0000FF);   // Color blue
  for ( int row = 0; row < rowCount; row++ ) {
	  float value = data.getFloat(row,cooleyColumn);
    
    float y = mapLog(value);
  //  float myPoint = map(value, dataMin,dataMax,0,rowCount-1);
	  // float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
    float x = map(row,0,rowCount-1,plotX1,plotX2);
    //float y = map(myPoint, 0, rowCount-1, plotY2, plotY1);
    // float y = map(newValue, 0, rowCount-1, plotY2, plotY1);
    ellipse(x, y, 5, 5);
    

  }

  fill(#FF0000);   // Color red
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,cetusColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
    ellipse(x, y, 5, 5);

  }
  fill(#01DF3A);   // Color green
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,lastColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
    ellipse(x, y, 5, 5);

  }
  
  

}

void drawDataLine(int mx, int my) {
  beginShape(LINES);
  rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, cooleyColumn)) {
      float value = data.getFloat(row,cooleyColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
      vertex(x, y);
      drawRollover(mx, my, x, y);
    }
  }endShape( );
  }
  
void drawDataLine1(int mx, int my) {
  beginShape(LINES);
  rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, cetusColumn)) {
      float value = data.getFloat(row,cetusColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
            drawRollover(mx, my, x, y);

      vertex(x, y);
    }    
    
  }
  endShape( );
}

void drawDataLine2(int mx, int my) {
  beginShape(LINES);
  rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, lastColumn)) {
      float value = data.getFloat(row,lastColumn);
        float y = mapLog(value);

    float x = map(row,0,rowCount-1,plotX1,plotX2);
        drawRollover(mx, my, x, y);

      vertex(x, y);
    }
  }endShape( );
}


float barWidth = 2; // Add to the end of setup()
void drawDataBars(int col) {
  /*
  noStroke( );
  rectMode(CORNERS);
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      // float value = data.getFloat(row, col);
      float value = interpolators[row].value;
     // float value = data.getFloat(row, col);
      float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }*/
  
}

void drawYTickMarks() {
  fill(0);
  textSize(10);

  stroke(128);
  strokeWeight(1);
  int tickStart =8;
 // float marker = dataMin;
//  for (float v = dataMin; v <= dataMax; v += 500) { 
    for (int i = 0; i < rowCount; i++ ) {
   // if (v % volumeIntervalMinor == 0) { // If a tick mark
   
      float y = map(i, 0, rowCount-1, plotY2, plotY1);
     // if (i % volumeInterval == 0) { // If a major tick mark
        if (i == 0) {
          textAlign(RIGHT); // Align by the bottom
        } else if (i == rowCount -1) {
          textAlign(RIGHT, TOP); // Align by the top
        } else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        
        text((int) pow(2,tickStart), plotX1 - 10, y);
        tickStart += 1;
        line(plotX1 - 4, y, plotX1, y); // Draw major tick
    //  } 
      
 //     else {
 //       line(plotX1 - 2, y, plotX1, y); // Draw minor tick
 //     }
//    }
   // marker = marker + v;
  }  
  
}

float mapLog(float value) {
   int startPoint = 8;
   float newVal = 0;
   for (int i = 0; i < rowCount; i ++ ) {
      
      float lowValue =  pow(2,startPoint);
      float topValue =  pow(2,startPoint+1);
      startPoint += 1;
      // print("value " + value + " low " + lowValue + " high " + topValue);
      
      if (value > lowValue && value < topValue) {
         
         newVal = map(value, lowValue, topValue, i,i+1);
        
      }  
   }
   
//  print(" NEW VAL IS " + newVal);
  float y = map(newVal, 0, rowCount-1, plotY2, plotY1);
  return y;
  
}




void drawXTickMarks() {
  
  fill(0);
  textSize(5);
  textAlign(CENTER, TOP);

  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(1);


  for (int row = 0; row < rowCount; row++) {
//    if (triples[row] % yearInterval == 0) {
      //float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
      float x = map(row, 0, rowCount-1, plotX1, plotX2);
      text(triples[row], x, plotY2 + 10);
      
      // Long verticle line over each year interval
      line(x, plotY1, x, plotY2);
//    }
  } 
  
}

void drawVisualizationWindow() {
    fill(255);
  rectMode(CORNERS);
  // noStroke( );
  rect(plotX1, plotY1, plotX2, plotY2);
  
}

void drawGraphLabels(){ 
  fill(0);
  textSize(15);
  textAlign(CENTER, CENTER);
  float x1 = labelX;
  float y1 = (plotY1+plotY2)/2;

  text("Year", (plotX1+plotX2)/2, labelY);  
 
  pushMatrix();
  translate(x1,y1);
  rotate(-HALF_PI);
  translate(-x1,-y1);
  
  text("Amount of Dollars ", labelX, (plotY1+plotY2)/2);
  popMatrix();
}
