public class B_lab{
	// CONSTANTS FOR EASY NAMING SCHEME
	public color GREEN = color(18, 211, 169);
	public color BLACK = color(0);
	private int
		TRIANGLE_UP = 0,
		TRIANGLE_DOWN = 1,
		DIAMOND = 2,
		CIRCLE = 3;

	public ArrayList<PShape> SHAPES_list;
	public PShape GRID_shape;
	private ArrayList<int[][]> GRID_list;




	// -------------------------------------------------------
	// CONSTRUCTORS

	B_lab(){
		this.build_shapes();
	}

	B_lab(int width, int height){
		this.build_shapes();

		this.GRID_list = new ArrayList<int[][]>();
		this.build_grid_list(width, height);
	}

	B_lab(int width, int height, int n_scales){
		this.build_shapes();

		this.GRID_list = new ArrayList<int[][]>();
		this.build_grid_list(width, height, n_scales);
	}





	// -------------------------------------------------------
	// PUBLIC ACCESS

	public color green(){ return this.GREEN; }
	public PShape triangle_up(){ return this.SHAPES_list.get(TRIANGLE_UP);}
	public PShape triangle_down(){ return this.SHAPES_list.get(TRIANGLE_DOWN);}
	public PShape circle(){ return this.SHAPES_list.get(CIRCLE);}
	public PShape diamond(){ return this.SHAPES_list.get(DIAMOND);}





	// -------------------------------------------------------
	// HELPERS

	private PVector calc_size_diff(PVector input, PVector output){ return new PVector(output.x - input.x, output.y - input.y); }
	private PVector calc_size_diff(float input_width, float input_height, float output_width, float output_height){ return new PVector(output_width - input_width, output_height - input_height); }
	private float get_size_diff(PVector input, PVector output){ PVector s = calc_size_diff(input, output); return (s.x < s.y) ? s.x : s.y; }
	private float get_size_diff(float input_width, float input_height, float output_width, float output_height){ PVector s = calc_size_diff(input_width, input_height, output_width, output_height); return (s.x < s.y) ? s.x : s.y; }


	// -------------------------------------------------------
	// DRAWING

	public PShape draw_grid(float w, float h, float margin){
		PShape group = createShape(GROUP);

		int sq = 1;
		for(int a=0; a<this.GRID_list.size(); a++){
			int[][] g = this.GRID_list.get(a);
			int n_cols = g.length,
				n_rows = g[0].length;
			// float scale = (max(n_cols, n_rows)-max(w, h))/max(n_cols, n_rows);
			float scale = (w<h) ? (n_cols - w)/n_cols : (n_rows - h)/n_rows;

			PVector position = new PVector();

			for(int y=0; y<n_rows; y++){
				for(int x=0; x<n_cols; x++){
					if(g[x][y] > -1){
						PShape s = this.build_shape(g[x][y]);
						if(s!=null){
							position.x = x*(w/n_cols) + abs(scale); // + (x/sq)*margin,
							position.y = y*(h/n_rows) + abs(scale);  // + (y/sq)*margin,

							s.resetMatrix();
							s.translate(position.x, position.y);
							s.scale(scale + sqrt(margin));
							group.addChild(s);
						}
					}
				}
			}
			sq *= 2;
		}
		return this.GRID_shape = group;
	}





	// -------------------------------------------------------
	// BUILDING

	// GRID_list BUILDING
	private void build_grid_list(int w, int h){
		int[] s = {TRIANGLE_UP, TRIANGLE_DOWN, CIRCLE, DIAMOND, CIRCLE, DIAMOND};
		int[][] g = new int[w][h];

		for(int x=0; x<w; x++){
			for(int y=0; y<h; y++){
				g[x][y] = s[int(random(s.length))];
			}
		}
		this.GRID_list.add(g);
	}

	private void build_grid_list(int w, int h, int n){
		int[] s = {TRIANGLE_UP, TRIANGLE_DOWN, CIRCLE, DIAMOND, CIRCLE, DIAMOND};
		int sq = 1;
		for(int i=0; i<n; i++){
			int n_cols = int(w*sq),
				n_rows = int(h*sq);
			int[][] g = new int[n_cols][n_rows];

			for(int x=0; x<n_cols; x++){
				for(int y=0; y<n_rows; y++){
					g[x][y] = pow(sq, 2) < pow(random(pow(2,n-1)), 2) ? -1 : s[int(s.length * noise(x,y))];

					for(int prev=1; prev<i+1; prev++){
						int previous_shape = this.GRID_list.get(i - prev)[int(x/pow(2, prev))][int(y/pow(2, prev))];
						if(previous_shape > -1){
							g[x][y] = -1;
							break;
						}
					}
				}
			}
			sq *= 2;
			this.GRID_list.add(g);
		}
	}

	// SHAPE BUILDING

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

	private void build_shapes(){
		this.SHAPES_list = new ArrayList<PShape>();
		this.SHAPES_list.add(this.build_triangle_up());
		this.SHAPES_list.add(this.build_triangle_down());
		this.SHAPES_list.add(this.build_diamond());
		this.SHAPES_list.add(this.build_circle());


	}
}