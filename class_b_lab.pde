public class B_lab{
	// CONSTANTS FOR EASY NAMING SCHEME
	public color GREEN = color(18, 211, 169);
	public color BLACK = color(0);
	public PShape LOGO;
	private int
		EMPTY = -1,
		TRIANGLE_UP = 0,
		TRIANGLE_DOWN = 1,
		DIAMOND = 2,
		CIRCLE = 3,
		SQUARE = 4; // bonus debug

	// private int[] PROBA = {
	// 	EMPTY,
	// 	TRIANGLE_UP, TRIANGLE_UP,
	// 	TRIANGLE_DOWN, TRIANGLE_DOWN,
	// 	CIRCLE, CIRCLE, CIRCLE,
	// 	DIAMOND, DIAMOND, DIAMOND};
	private int[] PROBA = {SQUARE}; // bonus debug

	public ArrayList<Cell> CELLS;



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
	// HELPERS


	// -------------------------------------------------------
	// DRAWING

	public PShape draw_cells(){
		PShape g = createShape(GROUP);
		for(Cell c : this.CELLS) g.addChild(c.draw());
		return g;
	}

	// -------------------------------------------------------
	// BUILDING


	private void build_grid(int w, int h, int n){
		this.CELLS = new ArrayList<Cell>();
		int index = 0;
		for(int x=0; x<w; x+=this.MAX_SIZE + this.MARGIN*.5){
			for(int y=0; y<h; y+=this.MAX_SIZE + this.MARGIN*.5){
				this.CELLS.add(new Cell(this, null, index, x, y, this.MAX_SIZE, this.MARGIN, this.PROBA[int(random(this.PROBA.length))]));
				index++;
			}
		}

		// for(int a=0; a<n; a++){
		// 	// ArrayList<Cell> to_divide = new ArrayList<Cell>();

		// }
	}





	private int random_shape(){
		return this.PROBA[int(random(this.PROBA.length))];
	}

	private PShape build_shape(int shape){
		PShape s;
		switch(shape){
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

	// private void build_shapes(){
	// 	this.SHAPES_list = new ArrayList<PShape>();
	// 	this.SHAPES_list.add(this.build_triangle_up());
	// 	this.SHAPES_list.add(this.build_triangle_down());
	// 	this.SHAPES_list.add(this.build_diamond());
	// 	this.SHAPES_list.add(this.build_circle());
	// }






	// -------------------------------------------------------
	// CELLS


	public Cell get(int x, int y){
		Cell rtrn = null;
		for(Cell c : this.CELLS){
			rtrn = c.hover(x,y);
			if(rtrn!=null) break;
		}
		return rtrn;
	}

	public Cell get(int x, int y, int radius){
		Cell rtrn = null;
		for(Cell c : this.CELLS){
			rtrn = c.hover(x,y,radius);
			if(rtrn!=null) break;
		}
		return rtrn;
	}

	private class Cell{
		B_lab parent;
		Cell parent_cell;
		int index, shape;
		float x, y, size, margin;
		ArrayList<Cell> subcells;
		Cell(B_lab parent, Cell parent_cell, int index, float x, float y, float size, float margin, int shape){
			this.subcells = new ArrayList<Cell>();
			this.index = index;
			this.parent = parent;
			this.parent_cell = parent_cell;
			this.x = x;
			this.y = y;
			this.size = size;
			this.margin = margin;
			this.shape = (random(100) < 30) || shape >= 0 ? parent.random_shape() : shape;
		}

		public void divide(){
			if(this.subcells.size()==0 && this.size>this.parent.MIN_SIZE*2){
				int index = 0;
				float margin = this.margin;
				float size = this.size*.5 - margin*.25;
				for(float x=0; x<size*2; x+=size+margin*.5){
					for(float y=0; y<size*2; y+=size+margin*.5){
						this.subcells.add(new Cell(this.parent, this, index, this.x + x, this.y + y, size, margin, this.shape));
						index++;
					}
				}
			}else if(this.size>25) for(Cell s : this.subcells) s.divide();
		}

		public void merge(){
			if(this.parent_cell != null) this.parent_cell.subcells.clear();
		}

		public PShape draw(){
			PShape s;
			if(this.subcells.size()==0){
				s = build_shape(this.shape);
				s.translate(this.x, this.y);
				s.scale(this.size);
			}else{
				s = createShape(GROUP);
				for(Cell sub : this.subcells) s.addChild(sub.draw());
			}
			return s;
		}

		public Cell hover(int x, int y){
			if(this.subcells.size()==0) return (x-this.margin > this.x && x-this.margin < this.x + this.size && y-this.margin > this.y && y-this.margin < this.y + this.size) ? this : null;
			else for(Cell sub : this.subcells) if(sub.hover(x,y)!=null) return sub.hover(x,y);
			return null;
		}

		public Cell hover(int x, int y, int radius){
			if(this.subcells.size()==0) return (x-this.margin > this.x && x-this.margin < this.x + this.size && y-this.margin > this.y && y-this.margin < this.y + this.size) ? this : null;
			else for(Cell sub : this.subcells) if(sub.hover(x,y,radius)!=null) return sub.hover(x,y,radius);
			return null;
		}

	}
}