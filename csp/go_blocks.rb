require 'jo'

include Jo

c = chan

jo do
  x = c.take
  y = c.take
  puts (x + y)
end

c << 10
c << 25

gets
