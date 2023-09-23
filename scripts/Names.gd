class_name Names



func generate_name(pos):
	var star_name_chars: int = 10
	seed(pos)
	var char1 = [
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",
		"b","c","d","f","h","j","l","m","n","p","q","r","s","t","v","x","z","j","k","y",]
	var char2 = [
		"a","a","e","i","o"]
	var char3  = [
		"bh","br","bl","cr","ch","dr","dh","fr","fh","jh","gr","nh","mh","mr",
		"pr","ph","ps","pw","st","str","sh","sw","sp","sk","sl","ss","tr","th","wh",
		"wr","vl","vh","vr","wl","a","e","i","o","u"]
	var store_name = []
	var complete = ""
	
	# Create sylables
	for i in randf_range(1, 8):
		var space: String = ""
		var special_char: String = ""
		
		if  randf() < 0.05:
			special_char = char3.pick_random()
		else:
			special_char = char2.pick_random()
		
		if randf() < 0.05:
			store_name.push_back(" ")
		elif randf() > 0.95:
			store_name.push_back("-")
		
		store_name.push_back(char1.pick_random() + special_char + space)
	
	# create a possible number at the end of the star name
	if randf() < 0.2:
		store_name.push_back(str(floor(randf_range(1, 999))))
	
	# concatenate the sylables togheter forming a name
	for i in range(0,store_name.size()):
		complete += store_name[i] 
		
	return complete.capitalize().left(star_name_chars)
