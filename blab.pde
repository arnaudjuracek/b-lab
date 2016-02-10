B_lab b;
PGraphics pg;

void b(){
	b = new B_lab(width-100, height-100, 3);
	pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), b.MARGIN*2, b.MARGIN*2);
		pg.endDraw();
}

void setup(){
	size(950, 450);
	smooth();
	b();
}

float dx = 1, dy = 1;
float x = 0, y = 0;
B_lab.Cell previous;

void draw(){
	background(b.GREEN);
	image(pg, 0, 0);

	// x += dx*10;
	// y += dy*10;

	// if(x>width) dx = random(-1,0);
	// if(y>height) dy = random(-1,0);
	// if(x<0) dx = random(1);
	// if(y<0) dy = random(1);

	x = mouseX;
	y = mouseY;

	B_lab.Cell c = b.get(int(x), int(y), 50);
	if(c!=null && c!=previous){
		previous = c;
		if(mouseButton != LEFT) c.divide();
		else c.merge();
		// c.shape = b.random_shape();
		pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), b.MARGIN*2, b.MARGIN*2);
		pg.endDraw();
	}

	stroke(255, 100);
	strokeWeight(50);
	point(x, y);

}


void mousePressed(){
	B_lab.Cell c = b.get(mouseX, mouseY);
	if(c!=null){
		c.divide();
		pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), b.MARGIN*2, b.MARGIN*2);
		pg.endDraw();
	}
}

void mouseDragged(){
	B_lab.Cell c = b.get(mouseX, mouseY);
	if(c!=null){
		c.divide();
		pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), b.MARGIN*2, b.MARGIN*2);
		pg.endDraw();
	}
}

void keyPressed(){
	if(key == 'r') b();
	if(key == 's') save("/Users/RNO/Desktop/blab.png");
	if(key == ' '){
		b.CELLS.get(int(random(b.CELLS.size()-1))).divide();
		pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), b.MARGIN*2, b.MARGIN*2);
		pg.endDraw();
	}
}