module MazeMap
class Room
  # these make it easy to access the variables
  attr_reader :name, :description, :paths, :attempts

  def initialize(name, description)
    @name = name
    @description = description
    @paths = {}
    @attempts = 0
  end

  def go(direction)
    return @paths[direction]
  end

  def add_paths(paths)
    @paths.update(paths)
  end

end

STARTING_ROOM = Room.new("Starting Room",
"""
You've entered the dragon's fortress. You are equipped with a sword and shield. You see a door to your left and a door to your right.

Neither of them appear to be locked. You also see a door ahead of you that has a big lock on it.
""")


LIZALFOS_ROOM = Room.new("Lizalfos Room",
"""
You've entered the lizalfos room. The door behind you and the door on the other side of the room locks with large metal bars that come down from the ceiling. 

You fight them and collect their weapons from their corpses. Do you go forward or back?
""")

RIDDLE_ROOM = Room.new("Riddle Room",
"""
You've entered the riddle room. There is an ancient invention, still used in some parts of the world today, that allows people to see through walls. 

What is it?
""")


KEY_ROOM = Room.new("Key Room",
"""
Hurray, a key has appeared! You put it in your pocket. The only way to go is back the way you came.

Do you want to go back to the starting room? Yes or no.
""")

KOI_POND_ROOM = Room.new("Koi Pond Room", 
"""
You've entered the koi pond room. There is a door on the other side of the room that is locked.""")

EXTRA_LOOT_ROOM = Room.new("Extra Loot Room", 
"""
Hurray! You've found some extra loot! Along with extra loot, you find a large key that you put in your pocket. 

You need to go back to the starting room and say you want to use the key to proceed. Do you want to go back to the starting room?
""")

BOSS_ROOM = Room.new("Boss Room", 
"""
You've made it to the boss room. You come in swinging your sword for a surprise attack. The dragon is caught off guard and you slice its leg. 

It roars back at you with fire brewing in the back of its throat.
""")

THE_END_WINNER = Room.new("The End",
"""
You jump into pod 2 and hit the eject button.
The pod easily slides out into space heading to
the planet below.  As it flies to the planet, you look
back and see your ship implode then explode like a
bright star, taking out the Gothon ship at the same
time.  You won!
""")

THE_END_LOSER = Room.new("The End",
"""
You jump into a random pod and hit the eject button.
The pod escapes out into the void of space, then
implodes as the hull ruptures, crushing your body
into jam jelly.
"""
)

KEY_ROOM.add_paths({
  'yes' => STARTING_ROOM,
  'no' => THE_END_LOSER
})

RIDDLE_ROOM.add_paths({
  'a window' => KEY_ROOM,
  '*' => THE_END_LOSER
})

LIZALFOS_ROOM.add_paths({
  'forward' => RIDDLE_ROOM,
  'back' => STARTING_ROOM,
  '*' => LIZALFOS_ROOM
})

KOI_POND_ROOM.add_paths({
  'use key' => EXTRA_LOOT_ROOM,
  '*' => KOI_POND_ROOM
})

EXTRA_LOOT_ROOM.add_paths({
  'yes' => STARTING_ROOM,
  'no' => THE_END_LOSER
})

BOSS_ROOM.add_paths({
  'dodge and strike' => THE_END_WINNER,
  'cry' => THE_END_LOSER
})

STARTING_ROOM.add_paths({
  'left' => LIZALFOS_ROOM,
  'right' => KOI_POND_ROOM,
  'use key' => BOSS_ROOM,
  '*' => STARTING_ROOM
})

START = STARTING_ROOM

# A whitelist of allowed room names. We use this so that
# bad people on the internet can't access random variables
# with names.  You can use Test::constants and Kernel.const_get
# too.
ROOM_NAMES = {
  'STARTING_ROOM' => STARTING_ROOM,
  'LIZALFOS_ROOM' => LIZALFOS_ROOM,
  'RIDDLE_ROOM' => RIDDLE_ROOM,
  'KEY_ROOM' => KEY_ROOM,
  'EXTRA_LOOT_ROOM' => EXTRA_LOOT_ROOM,
  'BOSS_ROOM' => BOSS_ROOM,
  'THE_END_WINNER' => THE_END_WINNER,
  'THE_END_LOSER' => THE_END_LOSER,
  'START' => START,
}

def MazeMap::load_room(session)
  # Given a session this will return the right room or nil
  return ROOM_NAMES[session[:room]]
end

def MazeMap::save_room(session, room)
  # Store the room in the session for later, using its name
  session[:room] = ROOM_NAMES.key(room)
end

end