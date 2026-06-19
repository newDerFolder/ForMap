class_name NeighborChunkManager extends Node

@export var table: NeighborChunkTable

# 运行时索引（加速查找）
var _index: Dictionary = {}  # Vector2i → NeighborChunk

func _ready() -> void:
	if table == null:
		push_error("NeighborChunkManager: table is null")
		return
	
	_build_index()

func _build_index() -> void:
	_index.clear()
	var pos_set: Dictionary = {}
	
	for chunk in table.entries:
		if chunk == null:
			push_error("NeighborChunkManager: null chunk found")
			continue
		
		if pos_set.has(chunk.map_position):
			push_error("Duplicate chunk at position: ", chunk.map_position)
			return
		else:
			pos_set[chunk.map_position] = true
			_index[chunk.map_position] = chunk  # 建立索引
	
	print("NeighborChunkManager: Loaded ", _index.size(), " unique chunks")


# 根据坐标获取区块数据
func get_chunk(pos: Vector2i) -> NeighborChunk:
	return _index.get(pos, null)

# 根据坐标实例化场景
func instantiate_chunk(pos: Vector2i) -> Node:
	var chunk = get_chunk(pos)
	if chunk == null:
		push_error("No chunk at position: ", pos)
		return null
	
	if chunk.chunk_scene == null:
		push_error("Chunk at ", pos, " has no scene assigned")
		return null
	
	return chunk.chunk_scene.instantiate()

# 检查区块是否存在
func has_chunk(pos: Vector2i) -> bool:
	return _index.has(pos)

# 获取所有区块坐标
func get_all_positions() -> Array[Vector2i]:
	return _index.keys()

# ========== 邻居查询 ==========
func get_neighbors(pos: Vector2i) -> Dictionary:
	var dirs = {
		"north": Vector2i(0, -1),
		"south": Vector2i(0, 1),
		"west": Vector2i(-1, 0),
		"east": Vector2i(1, 0)
	}
	var result = {}
	for dir_name in dirs:
		result[dir_name] = get_chunk(pos + dirs[dir_name])
	return result
