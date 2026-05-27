#挂载到全局中以使用

var cache:Dictionary[String,PackedScene]

func load_scene(path:String)->PackedScene:
	await ResourceLoader.load_threaded_request(path)
	var res=ResourceLoader.load_threaded_get(path)
	return res

func add_to_cache(path: String,packed_scene:PackedScene):
	cache[path]=packed_scene

func get_scene(path:String)->PackedScene:
	if cache.has(path):
		return cache[path]
	else:
		push_error("ForMap:没有在缓存中找到场景")
		return null
