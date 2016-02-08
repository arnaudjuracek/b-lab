B_lab b;
PGraphics pg;

void b(){
	b = new B_lab(10, 10, 3);
	b.draw_grid(width*.75, height*.75, 25);
	pg = createGraphics(width, height);
		pg.beginDraw();
		pg.shape(b.GRID_shape, int(width*.125), int(height*.125));
		pg.endDraw();
}

void setup(){
	size(800, 800);
	smooth();
	b();
}

void draw(){
	background(b.GREEN);
 	image(pg, 0, 0);
}

void keyPressed(){
	if(key == 'r') b();
}