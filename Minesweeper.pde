import de.bezier.guido.*;

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 50;
public boolean isLost = false;
public boolean cheatMode = false;
public boolean usedAI = false;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{

   size(400, 600);
   textAlign(CENTER,CENTER);
   textSize (14);

   // make the manager
   Interactive.make( this );

   //System.out.println ("Setup.");
   isLost = false;

   buttons = new MSButton[NUM_ROWS][NUM_COLS];
   //your code to initialize buttons goes here
   for (int row = 0; row < NUM_ROWS; row++) {
     for (int col = 0; col < NUM_COLS; col++) {
       buttons[row][col] = new MSButton(row,col);   
     }
   }

   mines = new ArrayList <MSButton>();
   setMines();
}

public void displayData () {

fill (255);
textAlign(LEFT,LEFT);
textSize(14);
text("Tiles: "+countTiles('T')+". Mines: "+mines.size()+". Revealed: "+
          countTiles('R')+"/"+(countTiles('T')-mines.size())+".",10,425);
textSize(12);         
text("Left click to reveal a tile. Right click to Flag a tile."+
              "\nEnter 'c' for cheat display, \n'-' for fewer mines, &  '+' for more mines"+
              "\n 'a' for Assist with finding an empty tile (this is a cheat)",
          10,450);
textSize(14);
if (cheatMode) {
  text ("Mines: "+mines.size()+". Found: "+countTiles('F')+
  ". Not Found: "+countTiles('U')+" Erroneous Flags: "+countTiles('E'),
  10 , 525);
}
textSize(14);
textAlign(CENTER,CENTER);

}

public int countTiles (char c) {
 // if c == 'F' --> returns number of Flagged mines.
 // if c == 'U' --> returns number of unFlagged mines.
 // if c == 'M' --> returns number of mines, total.
 // if c == 'T' --> returns number of tiles total
 // if c == 'R' --> returns number of clicked (Revealed) tiles that are not also flagged
 // and also not bombs, This number plus number of bombs should equal total
 // if c == 'E' --> returns number of erroneously flagged tiles, that is flagged, but
     // no bomb there.


 int count = 0;
 if ((c == 'F') || (c == 'U')) {
   for (int i=0; i<mines.size(); i++) {
      if (mines.get(i).isFlagged() == true) {
      count++;
    }
  }
  if (c == 'F') {
    return count;
    }
  else {
    return (countTiles ('M') - count);
    }
   }
 else if (c == 'M') {
     return mines.size();
   }
 else if (c == 'T') {
     return (int) NUM_ROWS * NUM_COLS;
 }
 else if ((c == 'R') || (c == 'E')){
     for (int row = 0; row < NUM_ROWS; row++) {
       for (int col = 0; col < NUM_COLS; col++) {
         if (c == 'R') {
           if ((buttons[row][col].isClicked ()) &&
                 (buttons[row][col].isFlagged() == false) &&
                 (buttons[row][col].isAMine() == false)) {
             count++;
           }
         }
        else if (c == 'E') {
            if ((buttons[row][col].isFlagged() == true) &&
                (buttons[row][col].isAMine() == false))
                count++;
       }
     }
     }
   return count;
 }
 return 0;
}

public void setOneMine() {
 int r, c;
 //System.out.println ("Set One Mine.");
 r = (int) (Math.random() * (NUM_ROWS-1));
 c = (int) (Math.random() * (NUM_COLS-1));
   //System.out.println("Row, Col"+r+","+c);
 if (! isValid(r,c)) {
     //System.out.println ("Invalid Mine Coordinate: "+r+","+c);
   } 
 else {
     if (! mines.contains(buttons[r][c])) {
          mines.add(buttons[r][c]);
          buttons[r][c].setNotClickedNotFlagged();
     }
   }
 }


public void setMines()
{

 int numberOfBombs = NUM_MINES;
 //System.out.println ("Set Mines.");
 while (mines.size() < numberOfBombs) {
   setOneMine();
 }
}


public void draw ()
{
   background( 0 );


   if(isWon() == true) {
       displayWinningMessage();
   }
   else {
     if (isLost == true) {
       displayLosingMessage();
       //System.out.println ("displaying losing message.");
     }
     else {
           // draw all of the tiles
     for (int row = 0; row < NUM_ROWS; row++) {
       for (int col = 0; col < NUM_COLS; col++) {
         buttons[row][col].draw();
       }
     }       
    }

   }
   displayData();
}

public boolean isWon()
{
   // you win if all the tiles that don't contain mines are clicked.
   boolean allFlagged = true;
   for (int i = 0; i < mines.size(); i++) {
     allFlagged = allFlagged && mines.get(i).isFlagged();
   }
   if (allFlagged) {
     return true;
   }
   else
     {
       if (countTiles ('R') + mines.size() == countTiles('T')) {
         return true;
       }
     }
     return false;
}

public void displayLosingMessage()
{
   fill (255,0,255);
   //stroke (255,0,0);
   textSize(48);
   text("You Lost, sorry.",200,550);
   fill(0);
   textSize(14);
}
public void displayWinningMessage()
{
   fill (178,255,123);
   //stroke (255,0,0);
   textSize(48);
   if ((! cheatMode) &&
       (! usedAI)) {
     text("You won!",200,300);
       }
   else {
       text ("Cheating never leads to a victory, sorry.",200,300);
   }
   fill(0);
   textSize(14);

}
public boolean isValid(int r, int c)
{
   //your code here
   // we do not have to check whether buttons[r][c] exists as long
   // as both r and c are within bounds, since we initialized every
   // button in the two dimensional array of buttons.
   return ((r >= 0) && (r < NUM_ROWS) && (c >= 0) && (c < NUM_COLS));
}

public void keyPressed () {
 //System.out.println("Key Pressed.");
 if ((key == 'c') || (key == 'C')) { 
   cheatMode = ! cheatMode;
 }
 else if (key == '-') {
   if (mines.size()>0) {
     mines.remove(mines.size()-1);
   }
 }
 else if ((key == '+') || (key == '=')) {
     setOneMine();
 }
 else if ((key == 'A') || (key == 'a')) {
     aITileFind();
     usedAI = true;
 }
}

public void aITileFind() {
 int r = 0;
 int c = 0;
 boolean found = false;
 while (((countTiles('R') + mines.size()) < countTiles('T')) &&
           (! found) &&
           (r < NUM_ROWS) &&
           (c < NUM_COLS)){

   //System.out.println("Row, Col"+r+","+c);
 if (! isValid(r,c)) {
     //System.out.println ("Invalid Mine Coordinate: "+r+","+c);
   }
 else {
     if (! mines.contains(buttons[r][c]) &&
        (buttons[r][c].isFlagged() == false) &&
        (buttons[r][c].isClicked() == false)){
       buttons[r][c].setClicked();
       buttons[r][c].setLabel("A");
       found = true;
      }
     else {
         if (c == NUM_COLS -1) {
             c = 0;
             r++;
         }
         else {
             c++;
         }
     }
   }
 }
}

public class MSButton
{
   private int myRow, myCol;
   private float x,y, width, height;
   private boolean clicked, flagged;
   private String myLabel;

   public MSButton ( int row, int col )
   {
       width = 400/NUM_COLS;
       height = 400/NUM_ROWS;
       myRow = row;
       myCol = col;
       x = myCol*width;
       y = myRow*height;
       myLabel = "";
       flagged = clicked = false;
       Interactive.add( this ); // register it with the manager
   }

   // called by manager
   public void mousePressed ()
   {
       //System.out.println("Mouse pressed.");
       if (isLost) {
         displayLosingMessage();
       }
       else {
         if (isWon()) {
           displayWinningMessage();
         }
         else
         {
           if (mouseButton == LEFT) {
            clicked = true;
            flagged = false;
           if (this.isAMine()) {
             isLost = true;
             System.out.println("isLost: "+isLost);
               }
             }
           else if (mouseButton == RIGHT) {
             if (flagged) {
               flagged = false;
               setLabel ("");
             }
               else {
                flagged = true;
               }
               clicked = false;
             }
             }
         }
       }


   public void draw ()
   {   
       int howManyMines;
       if (flagged) {
           fill(255,126,126);
           setLabel("f");
       }
       else if( clicked && mines.contains(this) ) {
            fill(255,0,0); // if clicked, and there's a mine here, draw it red.
            setLabel("X");
       }
       else if(clicked) {
           fill( 200 ); // if clicked and there's no mine, draw it white.
           howManyMines = howManyMinesNextToMe();
           if (howManyMines == 0) {
             setLabel ("");
             if (isValid(myRow-1,myCol)) {
               buttons[myRow-1][myCol].setClickedIfNotFlagged();
             }
              if (isValid(myRow-1,myCol+1)) {
               buttons[myRow-1][myCol+1].setClickedIfNotFlagged();
             }
              if (isValid(myRow-1,myCol-1)) {
               buttons[myRow-1][myCol-1].setClickedIfNotFlagged();
             }
              if (isValid(myRow+1,myCol)) {
               buttons[myRow+1][myCol].setClickedIfNotFlagged();
             }
              if (isValid(myRow+1,myCol+1)) {
               buttons[myRow+1][myCol+1].setClickedIfNotFlagged();
             }
              if (isValid(myRow+1,myCol-1)) {
               buttons[myRow+1][myCol-1].setClickedIfNotFlagged();
             }
              if (isValid(myRow,myCol+1)) {
               buttons[myRow][myCol+1].setClickedIfNotFlagged();
             }
              if (isValid(myRow,myCol-1)) {
               buttons[myRow][myCol-1].setClickedIfNotFlagged();
             }
           }
           else {
             setLabel (howManyMines);
           }
       }
       else {
           fill( 100 ); // if not clicked, draw it gray
       }

       rect(x, y, width, height);
       fill(0);
       text(myLabel,x+width/2,y+height/2);
   }
   public void setLabel(String newLabel)
   {
       myLabel = newLabel;
   }
   public void setLabel(int newLabel)
   {
       myLabel = ""+ newLabel;
   }
   public boolean isFlagged()
   {
       return flagged;
   }

   public boolean isClicked ()
   {
       return clicked;
   }
   public void setClickedIfNotFlagged () {
       if (! isFlagged()) {
         clicked = true;
       }
   }
   public void setNotClickedNotFlagged () {
     clicked = flagged = false;
   }

   public void setClicked () {
     clicked = true;
   }


   public boolean isAMine (){
     return mines.contains(this);
 }
 public int returnOneIfMine () {
     if (isAMine()) {
       return 1;
     }
     else
     {
       return 0;
     }
 }

 public int howManyMinesNextToMe() {
   int count = 0;
   if (isValid(myRow-1, myCol+1)) {
     count += buttons[myRow-1][myCol+1].returnOneIfMine();
   }
    if (isValid(myRow, myCol+1)) {
     count += buttons[myRow][myCol+1].returnOneIfMine();
   }
     if (isValid(myRow+1, myCol+1)) {
     count += buttons[myRow+1][myCol+1].returnOneIfMine();
   }
       if (isValid(myRow-1, myCol)) {
     count += buttons[myRow-1][myCol].returnOneIfMine();
   }
     if (isValid(myRow+1, myCol)) {
     count += buttons[myRow+1][myCol].returnOneIfMine();
   }
       if (isValid(myRow-1, myCol-1)) {
     count += buttons[myRow-1][myCol-1].returnOneIfMine();
   }
    if (isValid(myRow, myCol-1)) {
     count += buttons[myRow][myCol-1].returnOneIfMine();
   }
     if (isValid(myRow+1, myCol-1)) {
     count += buttons[myRow+1][myCol-1].returnOneIfMine();
   }
   return count;
 }

