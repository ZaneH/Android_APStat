import http.requests.*;
import cassette.audiofiles.*;
import org.apache.http.util.EntityUtils;

private enum AppState {
  MainMenu, 
    Listening, 
    ClassPicking
}

AppState appState = AppState.ClassPicking;

// this makes touching 2 things by holding impossible
boolean touched = false;

int pickedStage = 0;

char responses[] = new char[5];
char correctResponses[] = {'D', 'E', 'A', 'G', 'C'};

String classChosen = "";

// pickedStage #
SoundFile aNote; // 3
SoundFile cNote; // 5
SoundFile dNote; // 1
SoundFile eNote; // 2
SoundFile gNote; // 4

void setup() {
  fullScreen();

  aNote = new SoundFile(this, "aNote.mp3");
  cNote = new SoundFile(this, "cNote.mp3");
  dNote = new SoundFile(this, "dNote.mp3");
  eNote = new SoundFile(this, "eNote.mp3");
  gNote = new SoundFile(this, "gNote.mp3");
}

void draw() {
  background(255);
  // draw main menu buttons & text
  if (appState == AppState.MainMenu) {
    drawMainMenu();
  } else if (appState == AppState.Listening) {
    drawListening();
  } else if (appState == AppState.ClassPicking) {
    drawClassPicking();
  }
}

void drawClassPicking() {
  pushMatrix();
  translate(width / 2, height / 2);

  for (int i = 0; i < 2; i++) {
    // drop shadow
    fill(50, 0, 0);
    noStroke();
    ellipse((-400 * (0.5 - i)) + 6, 6, 350, 350);

    // button
    fill(150, 0, 0);
    strokeWeight(1);
    ellipse((-400 * (0.5 - i)), 0, 350, 350);
  }

  // text
  fill(255);
  textSize(64);
  textAlign(CENTER, CENTER);
  text("Male", (-400 * (0.5 - 0)), 0);
  text("Female", (-400 * (0.5 - 1)), 0);

  popMatrix();
}

void drawMainMenu() {
  pushMatrix();
  translate(width / 2, height / 2);

  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Which Pitch Is Which?", 0, -200);

  for (int i = 0; i < 5; i++) {
    // drop shadow
    if (responses[i] != 0) {
      // color green if answered
      fill(39, 174, 96);
    } else {
      fill(50, 0, 0);
    }
    noStroke();
    ellipse((-200 * (2 - i)) + 6, 6, 150, 150);

    // button
    if (responses[i] != 0) {
      // color green if answered
      fill(46, 204, 113);
    } else {
      fill(150, 0, 0);
    }
    strokeWeight(1);
    ellipse((-200 * (2 - i)), 0, 150, 150);

    // text
    fill(255);
    textSize(64);
    textAlign(CENTER, CENTER);
    text(Integer.toString(i + 1), (-200 * (2 - i)), 0);
  }

  // if all notes have been responded to, show a done button
  if (responses[0] != 0 && responses[1] != 0 && responses[2] != 0 && responses[3] != 0 && responses[4] != 0) {
    rectMode(CENTER);
    // drop shadow
    fill(39, 174, 96);
    rect(6, 206, 200, 75);
    // button
    fill(46, 204, 113);
    rect(0, 200, 200, 75);

    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Finished", 0, 200);
  }

  popMatrix();
}

void mouseReleased() {
  print("RESET");
  touched = false;
}

void mousePressed() {
  if (!touched) {
    checkInteraction();
  }
}

void checkInteraction() {
  // ensures holding down won't press 2 buttons
  touched = true;

  if (appState == AppState.MainMenu) {
    // only check if buttons are being touched on the main menu
    if (overCircle((-200 * (2 - 0)) + width / 2, 0 + height / 2, 300)) {
      // button one is being touched
      print("BUTTON ONE SELECTED");
      pickedStage = 1;
      appState = AppState.Listening;
    } else if (overCircle((-200 * (2 - 1)) + width / 2, 0 + height / 2, 300)) {
      // button two is being touched
      print("BUTTON TWO SELECTED");
      pickedStage = 2;
      appState = AppState.Listening;
    } else if (overCircle((-200 * (2 - 2)) + width / 2, 0 + height / 2, 300)) {
      // button three is being touched
      print("BUTTON THREE SELECTED");
      pickedStage = 3;
      appState = AppState.Listening;
    } else if (overCircle((-200 * (2 - 3)) + width / 2, 0 + height / 2, 300)) {
      // button four is being touched
      print("BUTTON FOUR SELECTED");
      pickedStage = 4;
      appState = AppState.Listening;
    } else if (overCircle((-200 * (2 - 4)) + width / 2, 0 + height / 2, 300)) {
      // button five is being touched
      print("BUTTON FIVE SELECTED");
      pickedStage = 5;
      appState = AppState.Listening;
    } else if (overRect((width / 2) - 100, (height / 2) + 162.5, 200, 75) && (responses[0] != 0 && responses[1] != 0 && responses[2] != 0 && responses[3] != 0 && responses[4] != 0)) {
      // finished button is being touched
      print("FINISHED BUTTON PRESSED");
      submitSurvey();
    }
  } else if (appState == AppState.Listening) {
    // only check if buttons are being touched on the listening screen
    if (overCircle((-150 * (2.5 - 0)) + width / 2, 0 + height / 2, 240)) {
      // play button was pressed
      print("PLAY BUTTON PRESSED");
      switch (pickedStage) {
      case 1:
        dNote.play();
        break;
      case 2:
        eNote.play();
        break;
      case 3:
        aNote.play();
        break;
      case 4:
        gNote.play();
        break;
      case 5:
        cNote.play();
        break;
      default:
        // if this happens...well...let's just say this shouldn't happen
        print("No note selected...");
      }
    } else if (overCircle((-150 * (2.5 - 1)) + width / 2, 0 + height / 2, 240)) {
      // a was selected
      print("A BUTTON PRESSED");
      responses[pickedStage - 1] = 'A';
      appState = AppState.MainMenu;
    } else if (overCircle((-150 * (2.5 - 2)) + width / 2, 0 + height / 2, 240)) {
      // c was selected
      print("C BUTTON PRESSED");
      responses[pickedStage - 1] = 'C';
      appState = AppState.MainMenu;
    } else if (overCircle((-150 * (2.5 - 3)) + width / 2, 0 + height / 2, 240)) {
      // d was selected
      print("D BUTTON PRESSED");
      responses[pickedStage - 1] = 'D';
      appState = AppState.MainMenu;
    } else if (overCircle((-150 * (2.5 - 4)) + width / 2, 0 + height / 2, 240)) {
      // e was selected
      print("E BUTTON PRESSED");
      responses[pickedStage - 1] = 'E';
      appState = AppState.MainMenu;
    } else if (overCircle((-150 * (2.5 - 5)) + width / 2, 0 + height / 2, 240)) {
      // g was selected
      print("G BUTTON PRESSED");
      responses[pickedStage - 1] = 'G';
      appState = AppState.MainMenu;
    }
  } else if (appState == AppState.ClassPicking) {
    if (overCircle((-400 * (0.5 - 0)) + width / 2, 0 + height / 2, 700)) {
      print("BAND CHOSEN");
      classChosen = "Male";
      appState = AppState.MainMenu;
    } else if (overCircle((-400 * (0.5 - 1)) + width / 2, 0 + height / 2, 700)) {
      print("CHORUS CHOSEN");
      classChosen = "Female";
      appState = AppState.MainMenu;
    }
  }
}

void submitSurvey() {
  PostRequest post = new PostRequest("https://docs.google.com/forms/d/e/1FAIpQLScYhfEdg2_gospmdjSekQ_edXxgqmIFTHgV8oW4seMv0tW_sA/formResponse", "UTF-8");
  post.addData("entry.19168660", classChosen);
  // tally score
  int score = 0;
  for (int i = 0; i < responses.length; i++) {
    if (responses[i] == correctResponses[i]) {
      score++;
    }
  }
  post.addData("entry.790481548", Integer.toString(score));

  post.send();
}

void drawListening() {
  pushMatrix();
  translate(width / 2, height / 2);

  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Play the sound, then choose the note you believe you heard", 0, 200);

  for (int i = 0; i < 6; i++) {
    // drop shadow
    fill(50, 0, 0);
    noStroke();
    // CIRCLE LOGIC:
    // -150 = Size of circle plus some padding (arbitrary)
    // 2.5  = Number of iterations in for loop / 2
    ellipse(-150 * (2.5 - i) + 6, 6, 120, 120);

    // button
    fill(150, 0, 0);
    strokeWeight(1);
    ellipse(-150 * (2.5 - i), 0, 120, 120);

    // text
    fill(255);
    textSize(64);
    textAlign(CENTER, CENTER);
    String txt = "";
    if (i == 0) txt = "\u25b6";
    else if (i == 1) txt = "A";
    else if (i == 2) txt = "C";
    else if (i == 3) txt = "D";
    else if (i == 4) txt = "E";
    else if (i == 5) txt = "G";
    text(txt, -150 * (2.5 - i), 0);
  }

  popMatrix();
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(float x, float y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

boolean overRect(int x, int y, int rwidth, int rheight) {
  if (mouseX >= x && mouseX <= x + rwidth && 
    mouseY >= y && mouseY <= y + rheight) {
    return true;
  } else {
    return false;
  }
}

boolean overRect(float x, float y, int rwidth, int rheight) {
  if (mouseX >= x && mouseX <= x + rwidth && 
    mouseY >= y && mouseY <= y + rheight) {
    return true;
  } else {
    return false;
  }
}
