public class Map{
	public PImage IMG;
	public int[] PIXELS;
	public int[][] DEPTHMAP;
	public int DARKEST, BRIGHTEST;

	public int[] SCALE = { // from brightest to darkest (a.k.a increasing shape area)
		EMPTY,
		SMALL_DIAMOND,
		SMALL_CIRCLE,
		TRIANGLE,
		DIAMOND, DIAMOND,
		CIRCLE, CIRCLE, CIRCLE
	};

	// public int[] SCALE = {EMPTY, SMALL_DIAMOND, SQUARE, SQUARE};



	// -------------------------------------------------------
	// CONSTRUCTORS

	Map(String filename){
		this.IMG = loadImage(filename);
		this.init();
	}

	Map(PImage img){
		this.IMG = img;
		this.init();
	}

	public void init(){
		this.IMG.filter(POSTERIZE, this.SCALE.length);

		this.PIXELS = this.IMG.pixels;

		this.DEPTHMAP = new int[this.IMG.width][this.IMG.height];

		this.BRIGHTEST = 0;
		this.DARKEST = 255;
		for(int x=0; x<this.IMG.width; x++){
			for(int y=0; y<this.IMG.height; y++){
				int index = x + y*this.IMG.width;
				color c = this.PIXELS[index];
				int b = (int) brightness(c);

				if(b > this.BRIGHTEST) this.BRIGHTEST = b;
				if(b < this.DARKEST) this.DARKEST = b;
				this.DEPTHMAP[x][y] = b;
			}
		}
	}



	public void pixelate(int zoom){
		this.BRIGHTEST = 0;
		this.DARKEST = 255;

		for(int x=0; x<this.IMG.width; x+=zoom){
			for(int y=0; y<this.IMG.height; y+=zoom){
				PImage px = this.IMG.get(x, y, zoom, zoom);
				px.resize(1, 1);
				px.loadPixels();
				color c = px.pixels[0];
				int b = (int) brightness(c);

				if(b > this.BRIGHTEST) this.BRIGHTEST = b;
				if(b < this.DARKEST) this.DARKEST = b;
				for(int xx=0; (xx<zoom) && (x+xx<this.IMG.width); xx++){
					for(int yy=0; (yy<zoom) && (y+yy<this.IMG.height); yy++){
						this.DEPTHMAP[x+xx][y+yy] = b;
					}
				}
			}
		}
	}



	public int get(int x, int y){
		try{
			return (int) this.SCALE[ int(map(this.DEPTHMAP[x][y], this.DARKEST, this.BRIGHTEST, this.SCALE.length-1, 0)) ];
		}catch(IndexOutOfBoundsException e){
    		println("IndexOutOfBoundsException: " + e.getMessage());
    		return -1;
		}
	}



	public void draw(){
		loadPixels();
		for(int x=0; x<min(this.IMG.width, width); x++){
			for(int y=0; y<min(this.IMG.height, height); y++){
				int index = x + y*min(this.IMG.width, width);
				pixels[index] = color(this.DEPTHMAP[x][y]);

			}
		}
		updatePixels();
	}
}