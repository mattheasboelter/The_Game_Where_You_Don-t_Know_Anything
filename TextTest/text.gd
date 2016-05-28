
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
	
	if (Input.is_key_pressed(KEY_1) or Input.is_key_pressed(KEY_2) or Input.is_key_pressed(KEY_3) or Input.is_key_pressed(KEY_4)):
		pressed=0
	else:
		pressed=1
	
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
		if (state==5):
			state=2
			
	elif (Input.is_key_pressed(KEY_2)):
		#case switch state algorithm here...
		if (state==1):
			state=3
			
	elif (Input.is_key_pressed(KEY_3)):
		#case switch state algorithm 3 here...
		if (state==1):
			state=4
		if (state==4):
			state=2
			
	elif (Input.is_key_pressed(KEY_4)):
		#case switch state algorithm 4 here...
		if (state==1):
			state=5
		
	if (pressed==1):
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
			"Yes sir! right away!",
			"Eggs scrambled or fried?",
			"oh... i was just joking around, i'm not even a waiter."
			]
			responses = ["what kinda establishment is this? First that terrible smell, and now you run outta eggs?!!",
			"Oh, and no butter or cheese on anything, i'm lactose-intollerant.",
			"Fried. speaking of which, is your frier broken? i smell smoke. do you?",
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