class_name ForMap extends Node

var cache:Dictionary[String,PackedScene]

static func make_load_page(path:String)->Node:
	var page=preload("res://addons/for_map/scene/loading_page.tscn").instantiate()
	page.load_path=path
	return page

static func load_path(path:String)->PackedScene:
	await ResourceLoader.load_threaded_request(path)
	var res=ResourceLoader.load_threaded_get(path)
	return res

func add_to_cache(path: String,packed_scene:PackedScene):
	cache[path]=packed_scene

func get_scene(path:String)->PackedScene:
	if cache.has(path):
		return cache[path]
	else:
		var new_scene:=await load_path(path)
		add_to_cache(path,new_scene)
		return new_scene

func free_scene(path:String):
	if cache.has(path):
		cache.erase(path)
