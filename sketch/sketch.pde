B_lab b;
Map m;

float dx = 1, dy = 1;
float x = 0, y = 0;
Cell previous;


void setup(){
	size(1074, 839);
	smooth();
	new_b();
}



void draw(){
	background(b.GREEN);
	if(b.BUFFER != null) image(b.BUFFER, 0, 0);
	//noLoop();

	x += dx*10;
	y += dy*10;

	if(x>width) dx = random(-1,0);
	if(y>height) dy = random(-1,0);
	if(x<0) dx = random(1);
	if(y<0) dy = random(1);

	x = mouseX;
	y = mouseY;

	Cell c = b.get_cell(int(x), int(y));
	if(c!=null && c!=previous){
		previous = c;
	 	if(mouseButton != LEFT) c.divide();
	 	else c.merge();
	 	// c.shape = b.random_shape();
	 	b.refresh();
	 }

}



void new_b(){
	b = new B_lab(width-100, height-100, 3);
	m = new Map("input.jpg");
  surface.setSize(m.IMG.width, m.IMG.height);
	b.build_grid(m, 3);

	b.refresh();
	loop();
}



void mousePressed(){
	Cell c = b.get_cell(new PVector(mouseX, mouseY));
	if(c!=null){
		// c.merge();
    c.divide();
		b.refresh();
		//println(c.J + ";" + c.K);
	}
}

void keyPressed(){
	if(key == 'r') new_b();
	if(key == 's') save("export.png");
	if(key == ' '){
		b.get_cell(int(random(b.CELLS.size()-1))).divide();
		b.refresh();
	}
}