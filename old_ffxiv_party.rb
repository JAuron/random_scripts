# {name: '', tank: false, healer: false, dps: false, needed: false},
players = [
						{name: 'Lyna Wild', tank: false, healer: true, dps: true, needed: false},
						{name: 'Ikara Avalonia', tank: false, healer: true, dps: true, needed: false},
						{name: 'Luka Ducouteau', tank: false, healer: true, dps: false, needed: true},
						{name: 'Auron Masamune', tank: true, healer: false, dps: false, needed: false},
						{name: 'Sen Soken', tank: true, healer: true, dps: true, needed: false},
						{name: 'Dothrah Tenkjoth', tank: false, healer: true, dps: true, needed: false},
						{name: 'Kakarot Son', tank: true, healer: false, dps: false, needed: false},
						{name: 'Cassiesaurus Nukupuku', tank: true, healer: false, dps: true, needed: false},
						{name: 'Endeavour Wentworth', tank: false, healer: false, dps: true, needed: false},
						{name: 'Yugure Noctem', tank: true, healer: false, dps: true, needed: false},
						{name: 'Alan partridge', tank: false, healer: false, dps: true, needed: false},
						{name: 'Penis McButtface (Skarlet Sinborn)', tank: true, healer: true, dps: true, needed: false},
						{name: 'Yma Night', tank: false, healer: false, dps: true, needed: false},
						{name: 'Shinon Miyumi', tank: false, healer: true, dps: true, needed: false},
						{name: 'Melaikh Kesaiyn', tank: false, healer: false, dps: true, needed: false},
						{name: 'Lala Beilschmidt', tank: false, healer: true, dps: true, needed: false},
						{name: 'Zaros Alune', tank: false, healer: true, dps: true, needed: false},
						{name: 'Aqualta Tia', tank: false, healer: true, dps: false, needed: false},
						{name: 'Hexissa Cloudseer', tank: false, healer: false, dps: true, needed: true},
						{name: 'Tao Matsuki', tank: true, healer: false, dps: true, needed: false},
						{name: 'Shinx Flash', tank: true, healer: true, dps: true, needed: false}
					]

# Manual sorting
# 								Party 1					Party 2						Party 3
# Tank 						Auron						Kakarot						Cassiesaurus
# Healer					Aqualta					Lyna							Dothrah
# Healer					Luka						Ikara							Shinon
# DPS 						Alan						Yugure						Lala
# DPS 						Yma							Tao								Zaros
# DPS 						Melaikh					Shinx	
# DPS 						Hexissa					Skar	
# DPS							Endeavour				Sen


# Safest way to put needed players at the top of the list
2.times do |x|
	players = players.partition { |player| player[:needed] == true }.flatten

	players_based_on_roles = {tanks: [], healers: [], dps: []}

	players.each_with_index do |player, index|
		players_based_on_roles[:tanks] << [player[:name], index] if player[:tank]
		players_based_on_roles[:healers] << [player[:name], index] if player[:healer]
		players_based_on_roles[:dps] << [player[:name], index] if player[:dps]
	end


	party = { }

	party[:tanks] = players_based_on_roles[:tanks][0..0]
	players_based_on_roles[:tanks] = players_based_on_roles[:tanks].drop(1)
	party[:healers] = players_based_on_roles[:healers][0..1]
	players_based_on_roles[:healers] = players_based_on_roles[:healers].drop(2)
	party[:dps] = players_based_on_roles[:dps][0..4]
	players_based_on_roles[:dps] = players_based_on_roles[:dps].drop(5)



	while (party[:tanks] & party[:healers]).any? || (party[:tanks] & party[:dps]).any? || (party[:healers] & party[:dps]).any?
		if (party[:tanks] & party[:healers]).any? 
			tank = players_based_on_roles[:tanks].first
			healer = players_based_on_roles[:healers].first
			if tank.nil? && healer.nil?
				return "NOT ENOUGH TANKS/HEALERS"
			elsif tank.nil? || (tank[1] > healer[1])
				party[:healers].delete((party[:tanks] & party[:healers]).first)
				party[:healers] << healer
				players_based_on_roles[:healers].delete(healer)
			elsif healer.nil?|| (healer[1] > tank[1]) || (tank[1] == healer[1])
				puts (party[:tanks] & party[:healers])
				party[:tanks].delete((party[:tanks] & party[:healers]).first)
				party[:tanks] << tank
				players_based_on_roles[:tanks].delete(tank)
			end
		elsif (party[:tanks] & party[:dps]).any?
			tank = players_based_on_roles[:tanks].first
			dps = players_based_on_roles[:dps].first
			if tank.nil? && dps.nil?
				return "NOT ENOUGH TANKS/DPS"
			elsif tank.nil? || (tank[1] > dps[1])
				party[:dps].delete((party[:tanks] & party[:dps]).first)
				party[:dps] << dps
				players_based_on_roles[:dps].delete(dps)
			elsif dps.nil?|| (dps[1] > tank[1]) || (tank[1] == dps[1])
				party[:tanks].delete((party[:tanks] & party[:dps]).first)
				party[:tanks] << tank
				players_based_on_roles[:tanks].delete(tank)
			end
		elsif (party[:healers] & party[:dps]).any?
			healer = players_based_on_roles[:healers].first
			dps = players_based_on_roles[:dps].first
			if healer.nil? && dps.nil?
				return "NOT ENOUGH HEALERS/DPS"
			elsif healer.nil? || (healer[1] > dps[1])
				party[:dps].delete((party[:healers] & party[:dps]).first)
				party[:dps] << dps
				players_based_on_roles[:dps].delete(dps)
			elsif healer.nil?|| (dps[1] > healer[1]) || (healer[1] == dps[1])
				party[:healers].delete((party[:healers] & party[:dps]).first)
				party[:healers] << healer
				players_based_on_roles[:healers].delete(healer)
			end
		end
	end
	puts "PARTY #{x+1}"
	party.each do |role, names|
		puts '-----------------'
		puts role.upcase
		puts '-----------------'
		names.each do |name|
			players.reject! { |player| player[:name] == name[0] }
			puts name[0]
		end
	end
	puts '-----------------'
end


# New way?
# Get first x members needed for full party
# Place those who can only do 1 role first (Keep indexes)
# Place those who do 2 roles in order of priority (count those who can do each role and lowest is highest priority?)
# Place those who can do all roles 
# If a person cannot do any of the exposed roles
	# Check if anyone currently the roles the player wants to do can do any exposed roles and move them to the exposed role
	# If not check if anyone in the current roles has a higher index then the current player and replace the one with the higest index
	# If you cant do that, then add them to a seperate reserves list