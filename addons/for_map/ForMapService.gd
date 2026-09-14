class_name ForMap extends Node

var cache:Dictionary[String,PackedScene]


func goto(path:String):
	var page = make_load_page(path)
	get_tree().change_scene_to_node(page)


static func make_load_page(path:String)->Node:
	var page=preload("res://addons/for_map/scene/loading_page.tscn").instantiate()
	page.load_path=path
	return page

static func load_by_path(path: String) -> PackedScene:
	# 1. 发起异步加载请求
	var err = ResourceLoader.load_threaded_request(path)
	if err != OK:
		push_error("加载失败: ", path)
		return null
	
	# 2. 等待加载完成
	while true:
		var status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			# 加载完成，获取资源
			var res = ResourceLoader.load_threaded_get(path)
			return res as PackedScene
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("加载失败: ", path)
			return null
		
		# 让出主线程，让 Timer / UI 继续运行
		await Engine.get_main_loop().process_frame
	
	# 兜底返回（理论上不会执行到这里）
	return null

func add_to_cache(path: String,packed_scene:PackedScene):
	cache[path]=packed_scene

func get_scene(path:String)->PackedScene:
	if cache.has(path):
		return cache[path]
	else:
		var new_scene:=await load_by_path(path)
		add_to_cache(path,new_scene)
		return new_scene

func free_scene(path:String):
	if cache.has(path):
		cache.erase(path)
