require_relative "../lib/gothonweb/map.rb"

RSpec.describe Map::Room, "#run" do
  it "creates a room with a name" do
    gold = Map::Room.new("GoldMap::Room", "This room has gold in it you can grab. There is a room to the North.")
    expect(gold.name).to eq("GoldMap::Room")
    expect(gold.paths).to eq({})
  end

  it "creates paths from the room" do
    center = Map::Room.new("center", "This is a room in the center")
    north = Map::Room.new("north", "This is a room in the north")
    south = Map::Room.new("south","This is a room in the south")

    center.add_paths({'north' => north, 'south' => south})
    expect(center.go('north')).to eq(north)
    expect(center.go('south')).to eq(south)
  end

  it "creates a map" do
    start = Map::Room.new("Start", "You can go west and down a hole")
    west = Map::Room.new("Trees", "There are threes here, you can go east")
    down = Map::Room.new("Dungeon", "It's dark down here, you can go up")

    start.add_paths({'west'=> west, 'down' => down})
    west.add_paths({'east'=> start})
    down.add_paths({'up'=> start})

    expect(start.go('west')).to eq(west)
    expect(west.go('east')).to eq(start)
    expect(down.go('up')).to eq(start)
  end

  it "creates a miniature version of my game from exercise 45" do
    starting_room = Map::Room.new("Start", "You've entered the dragon's fortress. You are equipped with a sword and shield. You see a door to your left and a door to your right. Neither of them appear to be locked. You also see a door ahead of you that has a big lock on it.")
    lizalfos_room = Map::Room.new("Lizalfos", "You've entered the lizalfos room. The door behind you and the door on the other side of the room locks with large metal bars that come down from the ceiling. Do you fight the lizalfos? Yes or no.")
    riddle_room = Map::Room.new("Riddle", "You've entered the riddle room. There is an ancient invention, still used in some parts of the world today, that allows people to see through walls. What is it?")
    key_room = Map::Room.new("Key", "Hurray, a key has appeared! You put it in your pocket. The only way to go is back the way you came. Do you want to go to the starting room?")
    koi_pond_room = Map::Room.new("Koi Pond", "You've entered the koi pond room. There is a door on the other side of the room that is locked.")
    extra_loot_room = Map::Room.new("Extra Loot", "You've found some extra loot!")
    boss_room = Map::Room.new("Boss", "You've made it to the boss room. You come in swinging your sword for a surprise attack. The dragon is caught off guard and you slice its leg. It roars back at you with fire brewing in the back of its throat.")

    starting_room.add_paths({'left'=> lizalfos_room, 'right'=> koi_pond_room, 'ahead'=> boss_room})
    lizalfos_room.add_paths({'back'=> starting_room, 'forward' => riddle_room})
    riddle_room.add_paths({'back' => lizalfos_room, 'forward' => key_room})
    key_room.add_paths({'back'=> starting_room})
    koi_pond_room.add_paths({'back' => starting_room, 'forward' => extra_loot_room})
    extra_loot_room.add_paths({'back'=> koi_pond_room})
    boss_room.add_paths({'back' => starting_room})

    expect(starting_room.go('left')).to eq(lizalfos_room)
    expect(lizalfos_room.go('forward')).to eq(riddle_room)
    expect(riddle_room.go('forward')).to eq(key_room)
    expect(key_room.go('back')).to eq(starting_room)
    expect(koi_pond_room.go('forward')).to eq(extra_loot_room)
    expect(extra_loot_room.go('back')).to eq(koi_pond_room)
    expect(boss_room.go('back')).to eq(starting_room)
  end

  it "successfully goes through the map" do
    expect(Map::START.go('shoot!')).to eq(Map::GENERIC_DEATH)
    expect(Map::START.go('dodge!')).to eq(Map::GENERIC_DEATH)

    room = Map::START.go('tell a joke')
    expect(room).to eq(Map::LASER_WEAPON_ARMORY)

    # complete this test by making it play the game
  end

  it "makes sure you can save and load rooms" do
    session = {}

    room = Map::load_room(session)
    expect(room).to eq(nil)

    Map::save_room(session, Map::START)
    room = Map::load_room(session)
    expect(room).to eq(Map::START)

    room = room.go('tell a joke')
    expect(room).to eq(Map::LASER_WEAPON_ARMORY)

    Map::save_room(session, room)
    expect(room).to eq(Map::LASER_WEAPON_ARMORY)
  end
end