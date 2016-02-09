B_lab b;
PGraphics pg;

void b(){
	b = new B_lab(width-100, height-100, 3);
	pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), 25, 25);
		pg.endDraw();
}

void setup(){
	size(950, 450);
	smooth();
	b();
}

void draw(){
	background(b.GREEN);
	image(pg, 0, 0);
}


void mousePressed(){
	for(B_lab.Cell c : b.CELLS){
		B_lab.Cell hover = c.hover();
		if(hover!=null){
			hover.merge();
			pg = createGraphics(width, height);
			pg.beginDraw();
			pg.shape(b.draw_cells(), 25, 25);
			pg.endDraw();
		}
	}
}

void mouseDragged(){
	for(B_lab.Cell c : b.CELLS){
		B_lab.Cell hover = c.hover();
		if(hover!=null){
			hover.divide();
			pg = createGraphics(width, height);
			pg.beginDraw();
			pg.shape(b.draw_cells(), 25, 25);
			pg.endDraw();
		}
	}
}

void keyPressed(){
	if(key == 'r') b();
	if(key == 's') save("/Users/RNO/Desktop/blab.png");
	if(key == ' '){
		b.CELLS.get(int(random(b.CELLS.size()-1))).divide();
		pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.draw_cells(), 25, 25);
		pg.endDraw();
	}
}