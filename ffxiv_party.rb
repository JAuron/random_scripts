# {name: '', tank: false, healer: false, dps: false, needed: false},

TANKS = 3
HEALERS = 6
DPS = 15
players = [
						{name: 'Lyna Wild', tank: false, healer: true, dps: true, needed: false},
						{name: 'Ikara Avalonia', tank: false, healer: true, dps: true, needed: false},
						{name: 'Luka Ducouteau', tank: false, healer: true, dps: false, needed: true},
						{name: 'Auron Masamune', tank: true, healer: false, dps: false, needed: false},
						{name: 'Sen Soken', tank: true, healer: true, dps: true, needed: false},
						{name: 'Kakarot Son', tank: true, healer: false, dps: false, needed: false},
						{name: 'Cassiesaurus Nukupuku', tank: true, healer: false, dps: true, needed: false},
						{name: 'Endeavour Wentworth', tank: false, healer: false, dps: true, needed: false},
						{name: 'Yugure Noctem', tank: true, healer: false, dps: true, needed: false},
						{name: 'Alan Partridge', tank: false, healer: false, dps: true, needed: false},
						{name: 'Penis McButtface (Skarlet Sinborn)', tank: true, healer: true, dps: true, needed: false},
						{name: 'Yma Night', tank: false, healer: false, dps: true, needed: false},
						{name: 'Shinon Miyumi', tank: false, healer: true, dps: true, needed: false},
						{name: 'Melaikh Kesaiyn', tank: false, healer: false, dps: true, needed: false},
						{name: 'Lala Beilschmidt', tank: false, healer: true, dps: true, needed: false},
						{name: 'Zaros Alune', tank: false, healer: true, dps: true, needed: false},
						{name: 'Aqualta Tia', tank: false, healer: true, dps: false, needed: false},
						{name: 'Hexissa Cloudseer', tank: false, healer: false, dps: true, needed: true},
						{name: 'Tao Matsuki', tank: true, healer: false, dps: true, needed: false},
						{name: 'Shinx Flash', tank: true, healer: true, dps: true, needed: false},
						{name: 'Minamoto Kinamo', tank: true, healer: true, dps: true, needed: false},
						{name: 'Old Man Outrack', tank: true, healer: false, dps: false, needed: false},
						{name: 'Jmie Ashtaum', tank: false, healer: false, dps: true, needed: false},
						{name: 'Cecilia Nuit', tank: true, healer: true, dps: true, needed: false},
						{name: 'Serena Raha', tank: false, healer: false, dps: true, needed: true}
					]

# Manual sorting
# 								Party 1					Party 2						Party 3
# Tank 						Auron						Kakarot						Outrack
# Healer					Aqualta					Lyna							Lala
# Healer					Luka						Ikara							Shinon
# DPS 						Alan						Yugure						Serena
# DPS 						Yma							Tao								Zaros
# DPS 						Melaikh					Shinx							Cassiesaurus
# DPS 						Hexissa					Skar							Minamoto
# DPS							Endeavour				Sen 							Jmie


# Safest way to put needed and redwing players at the top of the list
# players = players.partition { |player| player[:redwing] == true }.flatten
players = players.partition { |player| player[:needed] == true }.flatten

# initializes the party and constants
party = {tank: [], healer: [], dps: []}
reserves = []
party_size = ([TANKS+HEALERS+DPS, players.size].max) - 1


# Adds an index to the selected players list
selected_players = []
party_size.times do |x|
	selected_players << [players[x], x]
end

tank_only = selected_players.select { |player, index| player[:tank] && !player[:healer] && !player[:dps] }
party[:tank] = tank_only.first(TANKS)
reserves << tank_only[TANKS..-1]
selected_players = selected_players - tank_only

healer_only = selected_players.select { |player, index| !player[:tank] && player[:healer] && !player[:dps] }
party[:healer] = healer_only.first(HEALERS)
reserves << healer_only[HEALERS..-1]
selected_players = selected_players - healer_only

dps_only = selected_players.select { |player, index| !player[:tank] && !player[:healer] && player[:dps] }
party[:dps] = dps_only.first(DPS)
reserves << dps_only[DPS..-1]
selected_players = selected_players - dps_only

# Post assignment count
needed_per_class = { tank: TANKS - party[:tank].count, healer: HEALERS - party[:healer].count, dps: DPS - party[:dps].count }.sort_by { |class_name, value| value}

# Players that can do 2 jobs
duel_job = selected_players.select { |player, index| [player[:tank], player[:healer], player[:dps]].count(false) == 1 }

needed_per_class.each_with_index do |class_name, class_index|
	while class_name[1] > 0
		player = duel_job.select { |player, index| player[class_name[0].to_sym] == true && player[needed_per_class[class_index - 1][0].to_sym] == true }.first ||
						 duel_job.select { |player, index| player[class_name[0].to_sym] == true && player[needed_per_class[class_index - 2][0].to_sym] == true }.first
		next if player.nil?
		party[class_name[0].to_sym] << player
		duel_job.delete(player)
		class_name[1] = class_name[1] - 1
		break if duel_job.empty? || duel_job.select { |player, index| player[class_name[0].to_sym] == true }.empty?
	end
end
selected_players = selected_players - duel_job


# Pepper in the all rounders into rolls we need
all_rounders = selected_players.select { |player, index| [player[:tank], player[:healer], player[:dps]].count(true) == 3 }
all_rounders.each do |player|
	if party[:tank].count < TANKS 
		party[:tank] << player 
	elsif party[:healer].count < HEALERS 
		party[:healer] << player 
	elsif party[:dps].count < DPS 
		party[:dps] << player 
	else #This really shouldnt be hit... if it is then WTF
		reserves << player 
	end
end
selected_players = selected_players - all_rounders

party.each do |role, players|
	puts '------------'
	puts role.upcase
	puts '------------'
	players.each do |player|
		puts player[0][:name]
	end
end

players = players - selected_players
puts players


# puts "PARTY #{x+1}"
# party.each do |role, names|
# 	puts '-----------------'
# 	puts role.upcase
# 	puts '-----------------'
# 	names.each do |name|
# 		players.reject! { |player| player[:name] == name[0] }
# 		puts name[0]
# 	end
# end
# puts '-----------------'


# New way?
# Get first x members needed for full party
# Place those who can only do 1 role first (Keep indexes)
# Place those who do 2 roles in order of priority (count those who can do each role and lowest is highest priority?)
# Place those who can do all roles 
# If a person cannot do any of the exposed roles
	# Check if anyone currently the roles the player wants to do can do any exposed roles and move them to the exposed role
	# If not check if anyone in the current roles has a higher index then the current player and replace the one with the higest index
	# If you cant do that, then add them to a seperate reserves list