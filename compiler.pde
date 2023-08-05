/** 
 * 
 * This is currently a WIP
 * Takes a journal entry (or any text) and compiles to color
 *
 */

int letterHeight = 20; // height of the letters
int letterWidth = 20;  // width of the letter

int x = -letterWidth; // X position of the letters
int y = 0;            // Y position of the letters

boolean newletter;

int numChars = 59;  // 26 letters + 33 characters that I use when I write (program can be modified to include more)
color[] colors = new color[numChars];

String entry; // entry to be compiled
int[] params;

void settings() {
  String[] file = loadStrings("journal-entry.txt"); // read file
  entry = String.join("", file);
  params = getCanvasParams(entry.length());
  size(params[0]*20, params[1]*20);
}

void setup() {
  noStroke();
  colorMode(RGB, numChars);
  background(numChars/2);
  // set a color value for each key
  // this can be modified to change the gamut (i.e. using HSB with (i, 59, 59) gives bright colors across the visible spectrum, etc.)
  for (int i = 0; i < numChars; i++) {
    colors[i] = color(i, i, i);
  }
}

void draw() {
  // params[0]*params[1]= entry.length() + added whitespace for aspect ratio
  for (int i = 0; i < params[0]*params[1]; i++) {
    
    if (i < entry.length()) {
      typeChar((int) entry.charAt(i));
    } else {
      // random character if extra space was added to preserve aspect ratio
      // this will rarely be executed many times, if at all
      typeChar((int) random(59));
    }
 
    if (newletter == true) {
      // draw the "letter"
      int y_pos;
      y_pos = y;
      rect(x, y_pos, letterWidth, letterHeight);
      newletter = false;
    }
  }
  save("test.tif"); // save output to image file
  noLoop();
}

void typeChar(int key)
{
  // tses ASCII code of character to assign a color
  // treating upper and lowercase as the same, this can be modified to treat them as different characters
  if ((key >= 32 && key <= 90) || (key >= 97 && key <= 122)) {
    int keyIndex;
    if (key <= 64) {        // Special Characters
      keyIndex = key-6;
    } else if (key <= 90) { // A - Z
      keyIndex = key-65;
    } else {                // a - z
      keyIndex = key-97;
    }

    fill(colors[keyIndex]);
    newletter = true;

    // update the "letter" position
    x = ( x + letterWidth );

    // wrap horizontally
    if (x > width - letterWidth) {
      x = 0;
      y+= letterHeight;
    }

    // wrap vertically
    if ( y > height - letterHeight) {
      y = 0;      // reset y to 0
    }
  }
}

// finds the height and width of canvas based on entry length
int[] getCanvasParams(int entryLength) {
  int[] p = new int[2];
  float root = sqrt(entryLength);

  // find height and width that are as close as possible to each other
  for(int i = 1; i <= ceil(root); i++) {
    if(entryLength % i == 0) {
      p[0] = i;
      p[1] = entryLength/i;
    }
  }
  
  // adds space to make sure we don't get a 1x811 canvas
  // This will not add a ton of extra characters in ~1000-2000 character entries
  if (p[1]/p[0] > 6.472135955){
    p = getCanvasParams(entryLength + 1);
  }
  return p;
}
