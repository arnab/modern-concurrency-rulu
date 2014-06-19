defmodule Player do
  def play(name, other_player, phrase) do
    receive do
      {:serve} ->
          IO.puts "#{name}: serving"
          send(other_player, {:play_next, 1})
          play(name, other_player, phrase)

      {:play_next, rally_count} ->
        :timer.sleep(700)

        :random.seed(:os.timestamp())
        percentage_shot = :random.uniform(20)
        unenforced_error = 0.3 * rally_count > percentage_shot

        shot = if :random.uniform(2) > 1 do "backhand" else "forehand" end

        if unenforced_error do
          IO.puts "##{rally_count}: #{name}: Noooooo!"
          send(other_player, {:celebrate_point})
        else
          IO.puts "##{rally_count}: #{name}: #{shot}"
          send(other_player, {:play_next, rally_count + 1})
        end

        play(name, other_player, phrase)

      {:celebrate_point} ->
        IO.puts("######## #{name}: #{phrase} #######")
        :timer.sleep(500)
        send(self, {:serve})
        play(name, other_player, phrase)

      _ ->
        IO.puts("I only know how to play tennis.")
        play(name, other_player, phrase)
    end
  end
end

p1 = spawn_link(Player, :play, ["Djokovic", :rafa, "Yeeaaaah!"])
Process.register(p1, :djoker)

p2 = spawn_link(Player, :play, ["Rafa", :djoker, "Vamos!"])
Process.register(p2, :rafa)
send(:djoker, {:serve})

receive do
  {:EXIT, pid, reason} -> IO.puts "#{pid} exited. Said: #{reason}."
end
