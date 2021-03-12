class Bone {

  //relative direction bone points, radians
  // if 0, then this bone points in the same way as its parent
  float dir = random(-1, 1);

  // the length of the the bone, in pixels
  float mag = random(50, 150);

  Bone parent;
  ArrayList<Bone> children = new ArrayList<Bone>();

  boolean isRevolute = true;
  boolean isPrismatic = true;

  // cached / derived values
  PVector worldStart;
  PVector worldEnd;
  float worldDir = 0;

  Bone() {
  }
  Bone(int numChildren, int chainLength) {
    if (chainLength > 1) {

      for (int i = 0; i < numChildren; i++) {

        AddBone(chainLength -1);
      }
    }
  }
  void AddBone(int chainLength) {
    if (chainLength < 1) chainLength = 1;
    for (int i = 0; i < 3; i ++) {
      Bone newBone = new Bone();
      children.add(newBone);
      newBone.parent = this;

      if (chainLength > 1) {
        newBone.AddBone(chainLength - 1);
      }
    }
  }

  void draw() {
    line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);

    fill(100, 100, 200);
    ellipse(worldStart.x, worldStart.y, 20, 20);

    for (Bone child : children) child.draw();

    //if(child != null) child.draw();

    fill(150, 150, 255);
    ellipse(worldEnd.x, worldEnd.y, 10, 10);
  }

  void calc() {
    if (parent != null) {
      worldStart = parent.worldEnd;
      worldDir = parent.worldDir + dir;
    } else {
      worldStart = new PVector(100, 100);
      worldDir = dir;
    }


    PVector localEnd = PVector.fromAngle(worldDir);//new PVector(mag * cos(worldDir), mag * sin(worldDir));
    localEnd.mult(mag);
    worldEnd = PVector.add(worldStart, localEnd);

    for (Bone child : children) child.calc();
  }

  Bone onClick() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldEnd);
    if (vToMouse.magSq() < 20 * 20) return this;

    for (Bone child : children) {
      Bone b = child.onClick();
      if (b != null) return b;
    }

    return null;
  }

  void drag() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldStart);

    if (isRevolute) {
      if (parent != null) {
        dir = vToMouse.heading() - parent.worldDir;
      } else {
        dir = vToMouse.heading();
      }
    }
    if (isPrismatic) {
      mag = vToMouse.mag();
    }
  }
}
