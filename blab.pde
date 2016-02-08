B_lab b;
PGraphics pg;

void b(){
	b = new B_lab(16, 6, 3);
	b.draw_grid(width-50, height-50, 25);
	pg = createGraphics(width, height);
		pg.beginDraw();
		pg.background(b.GREEN);
		pg.shape(b.GRID_shape, 25, 25);
		pg.endDraw();
}

void setup(){
	size(851, 315);
	smooth();
	b();
}

void draw(){
 	image(pg, 0, 0);
}

void keyPressed(){
	if(key == 'r') b();
	if(key == 's') save("/Users/RNO/Desktop/blab.png");
}