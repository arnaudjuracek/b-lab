// CONSTANTS FOR EASY NAMING SCHEME
public static int
	SMALL_DIAMOND = -2,
	SMALL_CIRCLE = -3,
	EMPTY = -1,
	TRIANGLE_UP = 0,
	TRIANGLE_DOWN = 1,
	DIAMOND = 2,
	CIRCLE = 3,
	SQUARE = 4; // bonus debug



public class B_lab{
	public color GREEN = color(18, 211, 169);
	public color BLACK = color(0);
	public PShape LOGO;


	private int[] PROBA = {
		EMPTY,
		TRIANGLE_UP, TRIANGLE_UP,
		TRIANGLE_DOWN, TRIANGLE_DOWN,
		CIRCLE, CIRCLE, CIRCLE,
		DIAMOND, DIAMOND, DIAMOND};
	// private int[] PROBA = {SQUARE}; // bonus debug


	public int
		MIN_SIZE = 12,
		MAX_SIZE = 100,
		MARGIN = 20;



	// -------------------------------------------------------
	// CONSTRUCTORS

	B_lab(int w, int h, int n_scales, int... max_size){
		this.MARGIN /= n_scales;
		if(max_size.length>0) this.MAX_SIZE = max_size[0];
		this.MIN_SIZE = max(6, this.MAX_SIZE / int(pow(2, n_scales)));

		this.build_grid(w, h, n_scales);
	}



	// -------------------------------------------------------
	// DRAWING

	PGraphics BUFFER;

	public PShape draw_cells(){
		PShape g = createShape(GROUP);
		for(Cell c : this.CELLS) g.addChild(c.draw());
		return g;
	}

	public PGraphics refresh(){
		this.BUFFER = createGraphics(width, height);
			this.BUFFER.beginDraw();
			this.BUFFER.shape(this.draw_cells(), this.MARGIN*2, this.MARGIN*2);
			this.BUFFER.endDraw();
		return this.BUFFER;
	}



	// -------------------------------------------------------
	// CELLS RELATED HELPERS

	public ArrayList<Cell> CELLS;

	public Cell get_cell(int index){
		return this.CELLS.get(index);
	}

	public Cell get_cell(){
		return this.get_cell(int(random(this.CELLS.size())));
	}

	public Cell get_cell(PVector position){
		Cell rtrn = null;
		for(Cell c : this.CELLS){
			rtrn = c.hover(position);
			if(rtrn!=null) break;
		}
		return rtrn;
	}

	public Cell get_cell(int j, int k){
		Cell rtrn = null;
		for(Cell c : this.CELLS){
			if(c.J == j && c.K == k) rtrn = c;
		}
		return rtrn;
	}




	// -------------------------------------------------------
	// CELL GRID

	private void build_grid(int w, int h){
		this.CELLS = new ArrayList<Cell>();
		int index = 0, j = 0, k = 0;
		for(int x=0; x<w; x+=this.MAX_SIZE + this.MARGIN*.5){
			j++;
			k = 0;
			for(int y=0; y<h; y+=this.MAX_SIZE + this.MARGIN*.5){
				this.CELLS.add(new Cell(this, null, index, j, k, new PVector(x,y), this.MAX_SIZE, this.MARGIN, this.PROBA[int(random(this.PROBA.length))]));
				index++;
				k++;
			}
		}
	}

	private void build_grid(int w, int h, int n){
		this.CELLS = new ArrayList<Cell>();
		int index = 0, j = 0, k = 0;
		for(int x=0; x<w; x+=this.MAX_SIZE + this.MARGIN*.5){
			k = 0;
			for(int y=0; y<h; y+=this.MAX_SIZE + this.MARGIN*.5){
				this.CELLS.add(new Cell(this, null, index, j, k, new PVector(x,y), this.MAX_SIZE, this.MARGIN, this.PROBA[int(random(this.PROBA.length))]));
				k++;
				index++;
			}
			j++;
		}

		ArrayList<Cell> divided = new ArrayList<Cell>();
		for(int a=0; a<n; a++){
			int r = int( random(this.CELLS.size() - divided.size()) );
			for(int c=0; c<r; c++){
				Cell cell = this.get_cell();
				if(!divided.contains(cell)){
					cell.divide();
					divided.add(cell);
				}
			}
		}
	}

	private void build_grid(Map contrast_map, int n){
		this.CELLS = new ArrayList<Cell>();
		contrast_map.pixelate(int(this.MIN_SIZE + this.MARGIN*.5));
		int index = 0, j = 0, k = 0;

		for(int x=0; x<contrast_map.IMG.width; x+=this.MIN_SIZE + this.MARGIN*.5){
			k = 0;
			for(int y=0; y<contrast_map.IMG.height; y+=this.MIN_SIZE + this.MARGIN*.5){
				int shape = contrast_map.get(x, y);
				Cell cell = new Cell(this, null, index, j, k, new PVector(x,y), this.MIN_SIZE, this.MARGIN, shape);
				this.CELLS.add(cell);
				index++;
				k++;
			}
			j++;

		}

		for(int a=0; a<n; a++){
			for(int x=0; x<j; x+=2){
				for(int y=0; y<k; y+=2){
					Cell o = this.get_cell(x,y);
					if(o != null){
						o.J = int(o.J*.5);
						o.K = int(o.K*.5);

						ArrayList<Cell> nhgbrs = new ArrayList<Cell>();
							nhgbrs.add(this.get_cell(x+1, y));
							nhgbrs.add(this.get_cell(x, y+1));
							nhgbrs.add(this.get_cell(x+1, y+1));

						boolean merge = true;
						for(Cell c : nhgbrs)
							if(c == null || o.SHAPE < 0 || c.SHAPE != o.SHAPE || c.SIZE != o.SIZE) merge = false;

						if(merge){
							o.SIZE = o.SIZE*2 + o.MARGIN*.5;
							for(Cell c : nhgbrs) this.CELLS.remove(c);
						}
					}
				}
			}
		}

		for(Cell c : this.CELLS) if(c.SHAPE == TRIANGLE) c.SHAPE = (random(1)>.5) ? TRIANGLE_DOWN : TRIANGLE_UP;
	}



	// -------------------------------------------------------
	// SHAPE RELATED HELPERS

	private int random_shape(){
		return this.PROBA[int(random(this.PROBA.length))];
	}

	private PShape build_shape(int shape){
		PShape s;
		switch(shape){
			case -2 : s = this.build_sm_diamond(); break;
			case -3 : s = this.build_sm_circle(); break;
			case -1 : s = this.build_empty(); break;
			case 0 : s = this.build_triangle_up(); break;
			case 1 : s = this.build_triangle_down(); break;
			case 2 : s = this.build_diamond(); break;
			case 3 : s = this.build_circle(); break;
			case 4 : s = this.build_square(); break;
			default : s = null; break;
		}
		return s;
	}

	private PShape build_sm_diamond(){
		PShape sub = createShape();
			sub.beginShape();
				sub.vertex(.25, .5);
				sub.vertex(.5, .25);
				sub.vertex(.75, .5);
				sub.vertex(.5, .75);
			sub.endShape(CLOSE);
			sub.setFill(this.BLACK);
			sub.setStroke(false);
		return sub;
	}

	private PShape build_sm_circle(){
		PShape sub = createShape(PShape.ELLIPSE, .5, .5, .5, .5);
			sub.setFill(this.BLACK);
			sub.setStroke(false);
		return sub;
	}

	private PShape build_empty(){
		PShape empty = createShape();
		return empty;
	}

	private PShape build_triangle_up(){
		PShape triangle = createShape(PShape.TRIANGLE, 0, 0, 1, 0, .5, 1);
			triangle.setFill(this.BLACK);
			triangle.setStroke(false);
		return triangle;
	}

	private PShape build_triangle_down(){
		PShape triangle = createShape(PShape.TRIANGLE, 0, 1, 1, 1, .5, 0);
			triangle.setFill(this.BLACK);
			triangle.setStroke(false);
		return triangle;
	}

	private PShape build_diamond(){
		PShape diamond = createShape();
			diamond.beginShape();
				diamond.vertex(0, .5);
				diamond.vertex(.5, 0);
				diamond.vertex(1, .5);
				diamond.vertex(.5, 1);
			diamond.endShape(CLOSE);
			diamond.setFill(this.BLACK);
			diamond.setStroke(false);
		return diamond;
	}

	private PShape build_square(){
		PShape square = createShape(RECT, 0, 0, 1, 1);
			square.setFill(this.BLACK);
			square.setStroke(false);
		return square;
	}

	private PShape build_circle(){
		PShape circle = createShape(PShape.ELLIPSE, .5, .5, 1, 1);
			circle.setFill(this.BLACK);
			circle.setStroke(false);
		return circle;
	}



}