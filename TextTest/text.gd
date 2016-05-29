
extends Label

var state = 1
const wait = 75
var pressed = null
var dilema = "you come across a man"
#starting values
var responses = ["Do you smell smoke?",
"I'm uncomfortable",
"Yes, i'd like the eggs and ham.",
"I'm Mr. Green, who are you?",
]
var player = ["Hello sir.",
"How are you sir?",
"May i take your order sir?",
"I say man, who are you?",
]

func _ready():
	set_process_input(true)
	
func _input(event):
	
	#set options
	get_node("Option1").set_text(str("1. ", player[0]))
	get_node("Option2").set_text(str("2. ", player[1]))
	get_node("Option3").set_text(str("3. ", player[2]))
	get_node("Option4").set_text(str("4. ", player[3]))
	#get keypresses
	if (Input.is_key_pressed(KEY_1) or Input.is_key_pressed(KEY_2) or Input.is_key_pressed(KEY_3) or Input.is_key_pressed(KEY_4)):
		pressed=1
		dilema = ""
	else:
		pressed=0
		get_node("Dilema").set_text(str(dilema))
	
	#Hide extraneous options
	if (player[0]==null):
		get_node("Option1").set_percent_visible(0)
	elif (player[1]==null):
		get_node("Option2").set_percent_visible(0)
	elif (player[2]==null):
		get_node("Option3").set_percent_visible(0)
	elif (player[3]==null):
		get_node("Option4").set_percent_visible(0)
	


		#set the state
	if (Input.is_key_pressed(KEY_1)):
		#case switch state algorithm 1 here...
		set_text(responses[0])
		if (state==1):
			state=2
		elif (state==5):
			state=2
		elif (state==8):
			state=11
		elif (state==6):
			state=9
			
	elif (Input.is_key_pressed(KEY_2)):
		#case switch state algorithm here...
		set_text(responses[1])
		if (state==1):
			state=3
		elif(state==2):
			state=7
		elif(state==4):
			state=2
		elif(state==7 or state==6):
			state=9
		elif (state==5):
			state=10
		elif (state==10):
			state=8
			
	elif (Input.is_key_pressed(KEY_3)):
		#case switch state algorithm 3 here...
		set_text(responses[2])
		if (state==1):
			state=4
		elif (state==6 or state==7):
			state=8
		elif (state==2):
			state=6
	
	elif (Input.is_key_pressed(KEY_4)):
		#case switch state algorithm 4 here...
		set_text(responses[3])
		if (state==3 or state==2 or state==5):
			state=8
		elif (state==1):
			state=5
			#print(pressed)
		#CONVERSATION STATES HERE
###########################################################################
#                                                                         #
#                         commence dialog!                                #
#                                                                         #
###########################################################################
	if(pressed==1):

		if (state == 2): #Do you smell smoke?
			player = ["Smoke... What's smoke?", 
			"(lie) Yes, i smell smoke!", 
			"No, do you?",
			"(Leave)"
			]
			responses = ["Son, smoke is a part of life!",
			"How odd!",
			"Yes! there must be a fire somewhere around here!",
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
		elif (state == 7): #how odd
			player = ["Well, sir, may i ask who you are?",
			"Odd indeed! i wonder where it's coming from!",
			"(Leave)",
			null
			]
			responses = ["I am Mr. Green! Esteemed insurance salseman! I'm surprised you haven't heard of me. Who are you?",
			"A fire naturally! Let's get out of here! Save youself! Thats what i always say. Save yourself chap!",
			"Goodbye fellow!",
			"How odd!"
			]
		elif (state == 8): #goodbye
			dilema = "you leave him"
			player = ["(go back)",
			"(keep walking)",
			"(turn the next corner to escape)",
			null
			]
			responses = ["Oh! hello again!",
			"",
			"",
			"goodbye!"
			]
		elif (state==9): #come with me!
			player = ["Good idea! let's get out of here! (go with him)",
			"C'ya later! (stay)",
			"*YOU'RE NOT GOING ANYWHERE!!!*",
			null
			]
		elif (state==10):#I'm ready to order.
			player = ["Alright then. What do you want for breakfast?",
			"I gotta go. (leave)",
			null,
			null,
			]
			responses = ["I'll take the eggs and ham please.",
			"Wait! come back!",
			"I'm ready to order.",
			"I'm ready to order."
			]