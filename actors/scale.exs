defmodule Player do
  def play(next_player) do
    receive do
      rally_count ->
        send(next_player, rally_count + 1)
    end
  end

  def create_players(n) do
    last_player = Enum.reduce 1..n, self,
                          fn(_, player) ->
                              spawn(Player, :play , [player])
                          end
    send last_player, 0
    receive do
      res ->
        IO.puts("Total rally count: #{inspect(res)}")
    end
  end

  def run(n) do
    IO.puts inspect :timer.tc(Player, :create_players, [n])
  end
end
