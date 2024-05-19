extends Node

var player: Player : get = _get_player
var options_layer: Node2D : get = _get_options_layer
var foreground_layer: Node2D : get = _get_foreground_layer
 
var _cache = {}
 
 
func _get_player() -> Player:
	return _get_first_node_in_group("player") as Player


func _get_options_layer() -> Node2D:
	return _get_first_node_in_group("options_layer") as Node2D


func _get_foreground_layer() -> Node2D:
	return _get_first_node_in_group("foreground_layer") as Node2D


func _get_first_node_in_group(group_name: String) -> Node:
	if _cache.has(group_name) and is_instance_valid(_cache[group_name]):
		return _cache[group_name]
	
	var node = get_tree().get_first_node_in_group(group_name) as Node
	
	if node:
		print("GroupsUtils.caching_group: ", group_name)
		_cache[group_name] = node
		return node
	else:
		push_warning("No any Node in group '%s'" % group_name)
		return null
