# I was curious of the Monty Hall statistical problem after watching Brooklyn 99
# Writing this code and my 2 comments in the if/else statement was my realisation 
# Into why the statistics locks in at the initial choice as opposed to being 50/50

stayed = 0
switched = 0

x = ARGV[0].to_i # Amount of times we want to run the loop

x.times do |y|
	#Initialises the doors and sets the winning door
	doors = ['lose', 'lose', 'lose']
	doors[rand(3)] = 'win'

	chosen_door = rand(3)

	if doors[chosen_door] == 'win'
		# If winning door is chosen, any of the other doors can be opened
		# This means the player should stay
		stayed = stayed + 1
	else
		# If a losing door is chosen then only the other loosing door can be opened
		# This would mean the player should switch
		switched = switched +1
	end
end
puts "Player should have stayed #{stayed} times and switched #{switched} times"