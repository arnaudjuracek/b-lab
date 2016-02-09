public class B_lab{
	// CONSTANTS FOR EASY NAMING SCHEME
	public color GREEN = color(18, 211, 169);
	public color BLACK = color(0);
	public PShape LOGO;
	private int
		TRIANGLE_UP = 0,
		TRIANGLE_DOWN = 1,
		DIAMOND = 2,
		CIRCLE = 3;
	private int[] PROB = {TRIANGLE_UP, TRIANGLE_DOWN, CIRCLE, DIAMOND, CIRCLE, DIAMOND};

	public ArrayList<Cell> CELLS;




	// -------------------------------------------------------
	// CONSTRUCTORS

	B_lab(int w, int h, int n_scales){
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
		int size = 100;
		for(int x=0; x<w; x+=size){
			for(int y=0; y<h; y+=size){
				this.CELLS.add(new Cell(this, null, index, x, y, 100, this.PROB[int(random(this.PROB.length))]));
				index++;
			}
		}

		// for(int a=0; a<n; a++){
		// 	// ArrayList<Cell> to_divide = new ArrayList<Cell>();

		// }
	}







	private PShape build_shape(int shape){
		PShape s;
		switch(shape){
			case 0 : s = this.build_triangle_up(); break;
			case 1 : s = this.build_triangle_down(); break;
			case 2 : s = this.build_diamond(); break;
			case 3 : s = this.build_circle(); break;
			default : s = null; break;
		}
		return s;
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
		for(Cell c : this.CELLS) if(c.x == x && c.y == y) return c;
		return null;
	}

	private class Cell{
		B_lab parent;
		Cell parent_cell;
		int index, x, y, size, shape;
		ArrayList<Cell> subcells;
		Cell(B_lab parent, Cell parent_cell, int index, int x, int y, int size, int shape){
			this.subcells = new ArrayList<Cell>();
			this.index = index;
			this.parent = parent;
			this.parent_cell = parent_cell;
			this.x = x;
			this.y = y;
			this.size = size;
			this.shape = random(100) < 30 ? parent.PROB[int(random(parent.PROB.length))] : shape;
		}

		public void divide(){
			if(this.subcells.size()==0 && this.size>25){
				int index = 0;
				int size = int(this.size*.5);
				for(int x=0; x<size*2; x+=size){
					for(int y=0; y<size*2; y+=size){
						this.subcells.add(new Cell(this.parent, this, index, this.x + x, this.y + y, size, this.shape));
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

		public Cell hover(){
			if(this.subcells.size()==0) return (mouseX-25 > this.x && mouseX-25 < this.x + this.size && mouseY-25 > this.y && mouseY-25 < this.y + this.size) ? this : null;
			else for(Cell sub : this.subcells) if(sub.hover()!=null) return sub.hover();
			return null;
		}
	}
}