public class Cell{
	B_lab PARENT;
	Cell PARENT_CELL;
	int INDEX, SHAPE, J, K;
	PVector POSITION;
	float SIZE, MARGIN;
	ArrayList<Cell> SUBCELLS;

	Cell(B_lab parent, Cell parent_cell, int index, int j, int k, PVector position, float size, float margin, int shape, boolean... random){
		this.SUBCELLS = new ArrayList<Cell>();
		this.INDEX = index;
		this.PARENT = parent;
		this.PARENT_CELL = parent_cell;
		this.J = j;
		this.K = k;
		this.POSITION = position;
		this.SIZE = size;
		this.MARGIN = margin;
		if(random.length>0 && random[0]) this.SHAPE = (random(100) < 30) || shape >= 0 ? this.PARENT.random_shape() : shape;
		else this.SHAPE = shape;
	}

	public void divide(){
		if(this.SUBCELLS.size()==0 && this.SIZE>this.PARENT.MIN_SIZE*2){
			int index = 0, j = 0, k = 0;
			float margin = this.MARGIN;
			float size = this.SIZE*.5 - margin*.25;
			for(float x=0; x<size*2; x+=size+margin*.5){
				k = 0;
				for(float y=0; y<size*2; y+=size+margin*.5){
					k++;
					this.SUBCELLS.add(new Cell(this.PARENT, this, index, j, k, new PVector(this.POSITION.x + x, this.POSITION.y + y), size, margin, this.SHAPE));
					index++;
				}
				j++;
			}
		}else if(this.SIZE>12) for(Cell s : this.SUBCELLS) s.divide();
	}

	public void merge(){
		if(this.PARENT_CELL != null) this.PARENT_CELL.SUBCELLS.clear();
	}

	public PShape draw(){
		PShape s;
		if(this.SUBCELLS.size()==0){
			s = this.PARENT.build_shape(this.SHAPE);
			s.translate(this.POSITION.x, this.POSITION.y);
			s.scale(this.SIZE);
		}else{
			s = createShape(GROUP);
			for(Cell sub : this.SUBCELLS) s.addChild(sub.draw());
		}
		return s;
	}

	public Cell hover(PVector position){
		if(this.SUBCELLS.size()==0) return (position.x-this.MARGIN > this.POSITION.x && position.x-this.MARGIN < this.POSITION.x + this.SIZE && position.y-this.MARGIN > this.POSITION.y && position.y-this.MARGIN < this.POSITION.y + this.SIZE) ? this : null;
		else for(Cell sub : this.SUBCELLS) if(sub.hover(position)!=null) return sub.hover(position);
		return null;
	}


}