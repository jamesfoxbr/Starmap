extends RichTextLabel

var x : float
var y : float

func _ready():
	x = roundf(global_position.x)
	y = roundf(global_position.y)
	star_name_generator()


func rand100():
	var random100: int = floor(randf_range(1,100))
	return random100


func star_name_generator():
	text = generate_name(false) + " " + generate_name(true)


func generate_name(random: bool):
	# Generate individual words to be used in the star_name_generator() or other places.
	var char1 = ["c","d","l","m","n","p","r","s","t","h","b","f","g","j","k","v","w","x","y","z","q","cr","ch","fr","gr","pr","ph","st","str","sh","sp","sk","sl","tr","th","wh"]
	var char2 = ["a","e","i","o"]
	var store_name = []
	var complete = ""
	
	if random == true:
		if rand100() < 20:
			seed(x * y)
			for i in randf_range(1, 4):
				store_name.push_back(char1.pick_random() + char2.pick_random())
				seed((x * i) * (y * i))
	else:
		for i in randf_range(1, 4):
				store_name.push_back(char1.pick_random() + char2.pick_random())
				seed((x * i) * (y * i))
		
	for i in range(0,store_name.size()):
		complete += store_name[i] 
		
	return complete
