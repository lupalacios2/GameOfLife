import de.bezier.guido.*;

private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;

private Life[][] buttons;
private boolean[][] buffer;
private boolean running = true;

public void setup () {
  size(400, 400);
  frameRate(6);
  reset();
}

public void reset() {
  running = true;
  Interactive.make( this );
  buttons = new Life[NUM_ROWS][NUM_COLS];
  buffer = new boolean[NUM_ROWS][NUM_COLS];

  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new Life(i, j);
    }
  }
}

public void draw () {
  background(28, 39, 57);
 
  if (!running) {
    return;
  }
 
  copyFromButtonsToBuffer();

  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (countNeighbors(i, j) == 3) {
        buffer[i][j]=true;
      } else if (countNeighbors(i, j) == 2 && buttons[i][j].getLife())
        buffer[i][j]=true;
      else {
        buffer[i][j]=false;
      }

      buttons[i][j].draw();
    }
  }

  copyFromBufferToButtons();
}

public void keyPressed() {
  if (key == 'r') {
    reset();
  }
 
  if (key == ' ') {
    running = !running;
  }

  if (key == RETURN || key == ENTER) {
    for (int i = 0; i < NUM_ROWS; i++) {
      for (int j = 0; j < NUM_COLS; j++) {
        buttons[i][j].setLife(false);
      }
    }
  }
}

public void copyFromBufferToButtons() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j].setLife(buffer[i][j]);
    }
  }
}

public void copyFromButtonsToBuffer() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buffer[i][j] = buttons[i][j].getLife();
    }
  }
}

public boolean isValid(int r, int c) {
  return !(r >= NUM_ROWS || c >= NUM_COLS || r < 0 || c < 0);
}

public int countNeighbors(int row, int col) {
  int count = 0;
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (i == 0 && j == 0) {
        continue;
      }

      if (isValid(row + i, col + j)) {
        if (buttons[row + i][col + j].getLife()) {
          count++;
        }
      }
    }
  }

  return count;
}

public class Life {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean alive;

  public Life (int row, int col) {
    width = 400 / NUM_COLS;
    height = 400 / NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol * width;
    y = myRow * height;
    alive = Math.random() < 0.5;
    Interactive.add( this );
  }

  public void mousePressed () {
    alive = !alive;
  }

  public void draw () {    
    if (alive != true) {
      noStroke();
      fill(28, 39, 57);
    } else {
      stroke(0);
      fill(227, 98, 78);
    }
      
    rect(x, y, width, height);
  }

  public boolean getLife() {
    return alive;
  }

  public void setLife(boolean living) {
    alive = living;
  }
}
