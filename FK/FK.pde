
Bone bone = new Bone(3, 5);
Bone draggedBone;


void setup() {
  size(600, 600);
  //bone.child = new Bone();
  //bone.child.parent = bone;
}

void draw() {
  background(128);

  if (draggedBone != null) draggedBone.drag();

  bone.calc();
  bone.draw();
}

void mousePressed() {
  Bone clickedBone = bone.onClick();
  if (clickedBone != null) {
    clickedBone.AddBone(1);
  } else {
    draggedBone = clickedBone;
  }
}

void mouseReleased() {
  draggedBone = null;
}
