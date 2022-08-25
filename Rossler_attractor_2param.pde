import java.util.Map;

// 変更可
int N = 100;
float epsilon = 0.001;
int b = 20;

// 変更不可
boolean isUpdate = false;
int _a = 0;
float dt = 0.001;
ArrayList<colorContainer> colList = new ArrayList<colorContainer>(N+1);
HashMap<PVector, Integer> perMap = new HashMap<PVector, Integer>();
ArrayList<String> ALLines = new ArrayList<String>();

void setup() {
  size(640, 480);
  frameRate(240);
  background(220);

  colorContainer tmp_black = new colorContainer(color(0));
  colList.add(tmp_black);


  for (float i = 1; i <= N; i++) {
    colorMode( HSB, 360, 100, 100 );
    colorContainer tmp = new colorContainer(color(log(i)/log(N)*360., 100, 100));
    //println(i, log(i), log(N), log(i)/log(N)*360.);
    colList.add(tmp);
  }

  String lines[] = loadStrings(dataPath("mapData.txt"));
  if (lines != null) {
    for (String line : lines) {
      try {
        String SValues[] = line.split(" ");
        int per = int(SValues[0]);
        float FValues[] = new float[3];
        for (int i = 0; i < 3; i++) {
          FValues[i] = float(SValues[i+1]);
        }
        PVector tmpKey = new PVector(FValues[0], FValues[1], FValues[2]);
        perMap.put(tmpKey, per);
        ALLines.add(line);
      } 
      catch(Exception e) {
      }
    }
  }

  println("\nb =", b/100.);
}

void draw() {
  // float perXYZ[] = {0, 0.01, 0.01, 0.01}; // {per, x, y, z}
  for (int _c = 0; _c < 640; _c++) {
    int perCnt = 0;
    PVector tmpPVec = new PVector(_a, b, _c);
    Integer per = perMap.get(tmpPVec);

    if (per == null) {
      perCnt = getPer(0.1+0.2*(_a/480.), b/100., 2.0+4.0*(_c/640.), 0.01, 0.01, 0.01);
      perMap.put(tmpPVec, int(perCnt));
      String line = str(perCnt) + " " + str(_a) + " " + str(b) + " " + str(_c);
      ALLines.add(line);
      isUpdate = true;
    } else {
      perCnt = per;
    }
    //printArray(perXYZ);
    
    if(perCnt > N) perCnt = 0;
    stroke(colList.get(perCnt).getCol()); // perに合わせて色を変更
    point(_c, 480-_a-1);
    //println(_c, _a, perXYZ[0], colList.get((int)perXYZ[0]).getCol());
  }

  if (isUpdate && _a % 10 == 0) {
    String tmpLines[] = new String[ALLines.size()];
    for (int i = 0; i < ALLines.size(); i++) {
      tmpLines[i] = ALLines.get(i);
    }
    saveStrings(dataPath("mapData.txt"), tmpLines);
    isUpdate = false;
  }
  _a++;
  print(_a + "\t");
  if (_a == 480) {
    save("b_"+str(b/100.)+".png");
    noLoop();
  }
}

void keyPressed() {
  if (key == TAB) {
    if (isUpdate) {
      String tmpLines[] = new String[ALLines.size()];
      for (int i = 0; i < ALLines.size(); i++) {
        tmpLines[i] = ALLines.get(i);
      }
      saveStrings(dataPath("mapData.txt"), tmpLines);
      isUpdate = false;
    }
    exit();
  }
  if (key == CODED) {
    if (keyCode == LEFT) {
      _a = 0;
      b-=1;
      println("\nb =", b/100.);
      colorMode(RGB, 255, 255, 255);
      background(204);
      loop();
    }
    if (keyCode == RIGHT) {
      _a = 0;
      b+=1; 
      println("\nb =", b/100.);
      colorMode(RGB, 255, 255, 255);
      background(204);
      loop();
    }
  }
}
