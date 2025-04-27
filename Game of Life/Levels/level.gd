extends Node2D

var grid = []
var grid_size = Vector2(41, 20)
var dead_cell = Vector2i(0, 1)
var alive_cell = Vector2i(0,0)
enum pedo {
	DEAD_CELL,
	ALIVE_CELL,
}
var dr_pepper = pedo.ALIVE_CELL

func _ready():
	grid.resize(grid_size.x)
	for x in grid_size.x:
		grid[x] = []
		grid[x].resize(grid_size.y)
		for y in grid_size.y:
			grid[x][y] = dead_cell
	redraw_cells(grid)

func _process(_delta):
	if Input.is_action_just_pressed("NextGen"):
		create_next_gen()
	if Input.is_action_pressed("ChangeCell"):
		swap_cell_state($CellMap.local_to_map(get_local_mouse_position()))
	if Input.is_action_just_released("ChangeCell"):
		match dr_pepper:
			pedo.ALIVE_CELL:
				dr_pepper = pedo.DEAD_CELL
			pedo.DEAD_CELL:
				dr_pepper = pedo.ALIVE_CELL
func create_next_gen():
	var temp_grid = []
	temp_grid.resize(grid_size.x)
	for x in range(0, grid_size.x - 1):
		temp_grid[x] = []
		temp_grid[x].resize(grid_size.y)
		for y in range(0, grid_size.y - 1):
			var current_cell_state = $CellMap.get_cell_atlas_coords(0, Vector2(x,y))
			temp_grid[x][y] = get_next_cell_state(Vector2(x,y), current_cell_state)
	redraw_cells(temp_grid)

# Swaps the current state of the cell to the opposite one. E.g a live cell becomes a dead cell
func swap_cell_state(cell_coords):
	var current_cell = $CellMap.get_cell_atlas_coords(0, cell_coords)
	match dr_pepper:
		pedo.ALIVE_CELL:
			$CellMap.set_cell(0, cell_coords, 0, alive_cell)
		pedo.DEAD_CELL:
			$CellMap.set_cell(0, cell_coords, 0, dead_cell)
	

func get_next_cell_state(cell_coords, cell_state) -> Vector2i:
	var alive_count = count_alive_neighbors(cell_coords)
	if cell_state == alive_cell:
		if alive_count > 3 or alive_count < 2:
			return dead_cell
		else:
			return alive_cell
	else:
		if alive_count == 3:
			return alive_cell
		else:
			return dead_cell

func count_alive_neighbors(cell_coords) -> int:
	var alive_count = 0
	for x in 3:
		for y in 3:
			var neighbor_tile_coords = cell_coords + Vector2(x - 1, y - 1)
			var neighbor_tile_state = $CellMap.get_cell_atlas_coords(0, neighbor_tile_coords)
			
			if neighbor_tile_coords == cell_coords or $CellMap.get_cell_tile_data(0, neighbor_tile_coords) == null:
				continue
			elif neighbor_tile_state == alive_cell:
				alive_count += 1
	return alive_count

func redraw_cells(temp_grid):
	grid = temp_grid
	for x in range(0, grid_size.x - 1):
		for y in range(grid_size.y - 1):
			if grid[x][y] == alive_cell:
				$CellMap.set_cell(0, Vector2(x,y), 0, alive_cell)
			else:
				$CellMap.set_cell(0, Vector2(x,y), 0, dead_cell)


func _on_create_next_gen_delay_timeout():
	create_next_gen()


func _on_button_toggled(toggled_on):
	if not toggled_on:
		$CanvasLayer/MarginContainer/HBoxContainer/Button.text = "Start Simulation"
		$CreateNextGenDelay.stop()
	if toggled_on:
		$CanvasLayer/MarginContainer/HBoxContainer/Button.text = "Stop Simulation"
		$CreateNextGenDelay.start()
