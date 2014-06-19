require "celluloid"

class Player
  include Celluloid

  attr_writer :other_player

  def initialize(name, phrase, other_player=nil)
    @name = name
    @phrase = phrase
    @other_player = other_player
  end

  def serve
    puts "#{@name}: serving"
    @other_player.async.play_next(1)
  end

  def play_next(rally_count)
    sleep(0.5)
    percentage_shot = rand(20).to_i
    unenforced_error = 0.3 * rally_count > percentage_shot
    shot = rand(2) > 1 ? "backhand" : "forehand"
    if unenforced_error
      puts "##{rally_count}: #{@name}: Noooooo!"
      @other_player.async.celebrate_point
    else
      puts "##{rally_count}: #{@name}: #{shot}"
      @other_player.async.play_next(rally_count + 1)
    end
  end

  def celebrate_point
    puts("######## #{@name}: #{@phrase} #######")
    sleep(0.5)
    self.async.serve
  end
end

djoker_manager =
  Player.supervise_as(:djoker, "Djokovic",  "Yeeaaaah!")
rafa_manager =
  Player.supervise_as(:rafa, "Rafa", "Vamos!", Celluloid::Actor[:djoker])

Celluloid::Actor[:djoker].other_player = Celluloid::Actor[:rafa]

Celluloid::Actor[:djoker].async.serve

gets
