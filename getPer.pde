int getPer(float a, float b, float c, float x, float y, float z) { //<>//
  FloatList pastX = new FloatList();
  FloatList pastZ = new FloatList();

  float newX = x;
  float newY = y;
  float newZ = z;

  // 過渡状態として100回分の交点を計算
  int _cnt = 0;
  float _t = 0;
  do {
    float preX = newX;
    float preY = newY;
    float preZ = newZ;

    newX = preX-dt*(preY+preZ);
    newY = preY+dt*(preX+a*preY);
    newZ = preZ+dt*(b+preZ*(preX-c));
    //if(abs(t%1) < 0.001)

    if (preY * newY < 0) {
      float appX = (preX*abs(newY) + newX*abs(preY))/abs(newY-preY);
      float appZ = (preZ*abs(newY) + newZ*abs(preY))/abs(newY-preY);

      /*
      for (int i = 0; i < cnt; i++) {
       if (sq(appX-pastX.get(i))+sq(appZ-pastZ.get(i)) < sq(epsilon)) {
       float ret[] = {cnt-i, appZ, 0, appX};
       return ret;
       }
       }
       pastX.append(newX);
       pastZ.append(newZ);
       */
      _cnt++;
    }
    _t += dt;
    
    // NaN対策
    if (newX != newX || newY != newY || newZ != newZ) {
      println("ERROR" , newX, newY, newZ);
      return 0;
    }
  } while (_cnt <= 100 && _t<=1000);

  int cnt = 0;
  float t = 0;

  // 周期を計算
  do {
    float preX = newX;
    float preY = newY;
    float preZ = newZ;

    newX = preX-dt*(preY+preZ);
    newY = preY+dt*(preX+a*preY);
    newZ = preZ+dt*(b+preZ*(preX-c));
    //if(abs(t%1) < 0.001)

    if (preY * newY < 0) {
      float appX = (preX*abs(newY) + newX*abs(preY))/abs(newY-preY);
      float appZ = (preZ*abs(newY) + newZ*abs(preY))/abs(newY-preY);

      for (int i = 0; i < cnt; i++) {
        if (sq(appX-pastX.get(i))+sq(appZ-pastZ.get(i)) < sq(epsilon)) {
          return cnt-i;
        }
      }
      pastX.append(newX);
      pastZ.append(newZ);
      cnt++;
    }
    t += dt;

    // NaN対策
    if (newX != newX || newY != newY || newZ != newZ) {
      println("ERROR" , newX, newY, newZ);
      return 0;
    }
  } 
  while (cnt <= N && t<=1000);
  //if(t > 1000) println("cnt: ", cnt);

  // 計算できなかったとき用の返り値
  return 0;
}
