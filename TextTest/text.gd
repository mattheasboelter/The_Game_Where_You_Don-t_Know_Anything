
extends Label

var state = 1
const wait = 75
var pressed = null
#responses
var responses = ["Do you smell smoke?",
"I'm uncomfortable",
"Yes, i'd like the eggs and ham.",
"I'm Mr. Green, who are you?",
]


#player says...
var player = ["Hello sir.",
"How are you sir?",
"May i take your order sir?",
"I say man, who are you?",
]

func _ready():
	set_process(true)
	
func _process(delta):
	
	#set options
	get_node("Option1").set_text(str("1. ", player[0]))
	get_node("Option2").set_text(str("2. ", player[1]))
	get_node("Option3").set_text(str("3. ", player[2]))
	get_node("Option4").set_text(str("4. ", player[3]))
	#get keypresses
	if (Input.is_key_pressed(KEY_1) or Input.is_key_pressed(KEY_2) or Input.is_key_pressed(KEY_3) or Input.is_key_pressed(KEY_4)):
		pressed=1
	else:
		pressed=0
	
	#Hide extraneous options
	if (player[0]==null):
		get_node("Option1").set_percent_visible(0)
	elif (player[1]==null):
		get_node("Option2").set_percent_visible(0)
	elif (player[2]==null):
		get_node("Option3").set_percent_visible(0)
	elif (player[3]==null):
		get_node("Option4").set_percent_visible(0)
	
	
	#get response
	if (Input.is_key_pressed(KEY_1)):
		set_text(responses[0])
	elif (Input.is_key_pressed(KEY_2)):
		set_text(responses[1])
	elif (Input.is_key_pressed(KEY_3)):
		set_text(responses[2])
	elif (Input.is_key_pressed(KEY_4)):
		set_text(responses[3])
	
	#set the state
	if (Input.is_key_pressed(KEY_1)):
		#case switch state algorithm 1 here...
		if (state==1):
			state=2
		elif (state==5):
			state=2
		elif (state==2):
			state=6
			
	elif (Input.is_key_pressed(KEY_2)):
		#case switch state algorithm here...
		if (state==1):
			state=3
		elif(state==4):
			state=2
			
	elif (Input.is_key_pressed(KEY_3)):
		#case switch state algorithm 3 here...
		if (state==1):
			state=4
			
	elif (Input.is_key_pressed(KEY_4)):
		#case switch state algorithm 4 here...
		if (state==1):
			state=5
		
	if (pressed==0):
		#print(pressed)
		
		#The States are defined here
		if (state == 2): #Do you smell smoke?
			player = ["No... Do you?", 
			"(lie) Yes, i smell smoke!", 
			"Sir, you should see a doctor",
			"(Leave)"
			]
			responses = ["Yes! there must be a fire somewhere around here!",
			"How odd!",
			"Son, even doctors smoke sometimes!",
			"goodbye old chap!"
			]
		elif (state == 3): #I'm uncomfortable
			player = ["Oh! That's unfortunate!",
			"How terrible! what can i do to help?",
			"Why are you telling me this?",
			"Pity... (leave)"
			]
			responses = ["Yes, there is a strange smell about here...",
			"Hmmm... Yes. If you could call the firemen please. i fear something must be on fire!",
			"Well you asked me chap!",
			"Wait! come back!"
			]
		elif (state == 4): #Yes, I'll take...
			player = ["I'm sorry, but we're all out of those today",
			"Eggs scrambled or fried?",
			"Yes sir! right away!?",
			"oh... i was just joking around, i'm not even a waiter."
			]
			responses = ["what kinda establishment is this? First that terrible smell, and now you run outta eggs?!!",
			"Fried. speaking of which, is your frier broken? i smell smoke. do you?",
			"Oh, and no butter or cheese on anything, i'm lactose-intollerant.",
			"haha! right you are, and this isn't a restaraunt!"
			]
		elif (state == 5): #Who are you...
			player = ["I'm not sure myself...",
			"I'm Dan. I'll be your waiter today.",
			"Pleased to meet you, Mr. Green. I need some help.",
			"Uh... (look around nervously) I gotta go! (leave)"
			]
			responses = ["How unfortunate! say... Do you smell any smoke?",
			"Very well. I'm ready to order.",
			"Why didn't you say so in the first place! Tell me what you need",
			"How rude!"
			]
		elif (state == 6):#fire somewhere around here...
			player = ["Maybe the chef just burned something. I wouldn't worry about it.",
			"(lie) Actually, now i do smell a bit of smoke.",
			"I gotta go. (leave)",
			null
			]
			responses = ["What terrible practice! (he walks off in a huff)",
			"This is quite a dilema! lets get out of here before we get hurt. Save yourself, old chap! Thats what i say!",
			"Terribly sorry old chap! see you around!",
			"Yes! there must be a fire somewhere around here!"
			]