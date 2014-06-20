# Modern Concurrency Practices in Ruby

#### @arnab_deka

^ Lyon has been wonderful
^ Love this auditorium

---

![fit](http://f.cl.ly/items/0T3U191A0q22383t3X0f/Screen%20Shot%202014-06-19%20at%2018.57.29%20pm.png)

---

![fit](http://f.cl.ly/items/1B2t1l040Y3o0i2z3C46/Screen%20Shot%202014-06-19%20at%2018.57.16%20pm.png)

---

![](http://f.cl.ly/items/061d3h2B1F2B2P0a3V2F/IMG_20140619_162112.jpg)

^ Anyway, rather than talk about toilets, I'd like to talk about
Ruby and concurrency today

---

## Agenda

> I would remove the thread and add actors or some other more advanced
> concurrency features
-- Matz

---

## Agenda...

![original right 140%](http://theferventshaker.files.wordpress.com/2013/03/mojito.jpg)

* Elixir
* Clojure
* Go
* Of course, *_Ruby_* ...
* Even some French!

^ Nice cocktail.
Any Pascal fans? We are in France, right?

---

## Agenda...

![original right 140%](http://theferventshaker.files.wordpress.com/2013/03/mojito.jpg)

* Elixir
* Clojure
* Go
* Of course, *_Ruby_* ...
* Even some French!

## Sadly, **_NO_** Pascal

---

## Arnab

+ @arnab_deka
* [http://arnab-deka.com/](http://arnab-deka.com/)
* Assam > Kerala > Pune > NYC > Seattle > Bangalore
* Infosys/Goldman > Amazon > LivingSocial
* C/C++ > Perl > Java > Ruby > Ruby/Clojure

^ French connections run deep

---

![fit](french-conn-statue-of-liberty.jpg)

---

![fit](http://healthyrecipesblogs.com/wp-content/uploads/2012/05/french-toast.jpg)

---

![fit](http://www.montereylaw.edu/wp-content/uploads/2012/07/neighbors.gif)

^As if that's not enough, neighbor is from Lyon itself!
If that's not deep enough a connection, I don't know what is. Come on,
tell me how many of you know your neighbor's name? Where they are
from?

---

# Warm up

```ruby
class Counter
  attr_reader :count

  def initialize
    @count = 0
  end

  def inc
    @count += 1
  end
end
```

---

## Warm up...

```ruby
counter = Counter.new

t1 = Thread.new { 1000.times { counter.inc } }
t2 = Thread.new { 1000.times { counter.inc } }
t1.join; t2.join

puts "Final count: #{counter.count}"
```

^ Ask:
MRI: 2000
JRuby/Rubinius: less than 2000

---

## Solution?

### Mutexes!
Of course!

---

## Solution?

### Mutexes! But...

+ testing?
+ debugging?
+ waking up at 3 AM to solve that Race condition?

---

![fit](http://4.bp.blogspot.com/_138MoxgxagU/TDZHW8sUkDI/AAAAAAAAARU/BizvoCl6Tyk/s1600/2009-09-21-Locksmith.png)

^ So we will get introduced to some higher level concurrency
abstractions.

---

# STM

![](http://smallbusiness.chron.com/DM-Resize/photos.demandstudios.com/getty/article/171/144/78364071.jpg?w=650&h=406&keep_ratio=1&webp=1)
![original](http://3.bp.blogspot.com/_iYm10EqjH6A/THq4EyKD4EI/AAAAAAAAApE/903NVF_Otks/s1600/Matrix.jpg)

---

## STMs: sidetrack on atoms

+ Compare and Swap
+ Lock-free
+ Non-blocking

---

![fit](http://f.cl.ly/items/341o1t2Q222O162E3c0E/Screen%20Shot%202014-06-19%20at%2019.17.42%20pm.png)

---

## STMs: sidetrack on atoms...

```ruby
require 'atomic'
class Counter
  def initialize
    @count = Atomic.new(0)
  end

  def inc
    @count.update { |num| num + 1 }
  end

  def count
    @count.value
  end
end
```

---

## STMs: sidetrack on atoms...

```ruby
counter = Counter.new

t1 = Thread.new { 1000.times { counter.inc } }
t2 = Thread.new { 1000.times { counter.inc } }
t1.join; t2.join

puts "Final count, using atomic: #{counter.count}"
```

---

## STM...

```clojure
(def transfer-count (atom 0))

(let [fn-nonnegative #(>= % 0)]
  (def alice (ref 1000 :validator fn-nonnegative))
  (def bob (ref 2000 :validator fn-nonnegative)))
```

---

## STM...

```clojure
(defn transfer [from to amount]
  (dosync
   (swap! transfer-count inc)
   (alter from - amount)
   (alter to + amount)))
```

---

## STM...

```
(repeatedly 25 #(transfer alice bob 100))
```

=> **_IllegalStateException_**

```clojure
(println[@alice @bob @transfer-count])
;; => [0 3000 11]
```

---

## STM...

 ✔Atomic

---

## STM...

 ✔Atomic
 ✔Consistent

---

## STM...

 ✔Atomic
 ✔Consistent
 ✔Isolated

---

## STM...

 ✔Atomic
 ✔Consistent
 ✔Isolated

### But...

✘ Durable

---

## STM...

+ Synchronous
+ Retries...

---

## STMs in Ruby???

:(

^ Sadly, nothing yet.

---

## STMs in Ruby???

#### Alternatives...

* HTM
  * Intel's Transactional Synchronization Extensions
  * PyPy's Transactional Memory
* Atoms

^ Alright, so we've seen a couple of ways of solving our problems. But
do you know the best way? It's to do it in French!

---

`counting.rubis`
----------------

```ruby
classe Compteur
  attr_lire :recenser

  définir initialiser
    @recenser = 0
  fin

  définir accroissement
    @recenser += 1
  fin
fin
```

^ Only two things needed to happen...

---

# Step 1

## _*1763: French Indian War*_

![original](french-indian-war.jpg)

---

# Step 2
## _*East India Companies:*_
## _*French > Brits*_

![original](east-india-co.jpg)

---

![fit](new-france.jpg)

---

![fit](french-india.jpg)

---

## French in the US and in India...

* *_ENIEO_*, not ENIAC
* *_La sous-traitance_*, not "outsourcing"
* ...
* ...
* ...
* *_"Le Rubis"_*, not Ruby

^Électronique Numérique Intégrateur et Ordinateur
Also, it's not like you guys gave up, right?

---

![](http://travelhdwallpapers.com/wp-content/uploads/2014/04/Statue-Of-Liberty-3.jpg)

^You even tried to bribe the US to speak French, but sadly they just
kept the gift

^So let's get back to our uncultured English speaking Ruby

---

# Actors
![fit](http://d24w6bsrhbeh9d.cloudfront.net/photo/5706300_700b.jpg)

^Exists since 1970s. Made famous by Erlang and BEAM VM. Scala/akka recently.

---

# [fit] WHAT *OOP* WAS _*MEANT*_ TO BE.

^You have actors and you pass messages to them.
^Scala's akka uses JVM threads to implement actors.
^ Erlang/BEAM uses processes. We'll use elixir, which is built on top
of Erlang, to see how we can build actors.

---

## Actors in Elixir

```elixir
defmodule Player do
  def play(name) do
    receive do
      {:serve} ->
        # do it ...
    end
  end
end

p1 = spawn_link(Player, :play, ["Djokovic"])
send(p1, {:serve})

# or register to a name
Process.register(p1, :djoker)
send(:djoker, {:serve})
```

---

## Actors in Ruby

```ruby
class Player
  include Celluloid

  def initialize(name); end
  def serve; end
end

djoker = Player.new
djoker.async.serve

Player.supervise_as(:djoker, "Djokovic")
Celluloid::Actor[:djoker].async.serve
```

^Let's play. DEMO!

---

## Erlang/Elixir: there's more...

* Processes are _very very_ light-weight

^Show how light they are.
100, 10_000, 100_0000 processes
Then 1000_000 with +P

---

## Erlang/Elixir: there's more...

* Processes are _very very_ light-weight
* fault-tolerance: **let it crash**

^ Riak, WhatsApp

---

## Erlang/Elixir: there's more...

* Processes are _very very_ light-weight
* fault-tolerance: **let it crash**
* OTP framework

---

## Erlang/Elixir: there's more...

* Processes are _very very_ light-weight
* fault-tolerance: **let it crash**
* OTP framework
* Distributed

^Demo multiple nodes

---

## What about Ruby?

![fill 80% inline](http://f.cl.ly/items/3H1P420d0i442r082M18/Screen%20Shot%202014-06-19%20at%2019.05.28%20pm.png)

* Celluloid
* DCell

^ How does DCell work? over 0MQ

---

## Actors in Ruby: DCell

* Over 0mq

```ruby
require 'dcell'

DCell.start :id => "itchy", :addr => "tcp://127.0.0.1:9001"

DCell.start :id => "scratchy", :addr => "tcp://127.0.0.1:9002"
itchy_node = DCell::Node["itchy"]
```

---

# Channels
![fit](http://upload.wikimedia.org/wikipedia/commons/c/c8/EnglishChannel.jpg)

^ Also known as coroutines/goroutines/CSP

---

### Actors
* focus: **named processes/actors**
* coupled to message format

### Channels
* focus: **transport**, not receiver
* anything can produce/consume

^ both based on the same ideas, around 1970.
Recently made famous again by goroutines in Go.

---

## side-track: #golang

```go
TODO: show dynamic array vs in Clojure vs in Ruby
```

^ instead we'll stick with core.async. Clojure library from Rich
Hickey and co. Same ideas as goroutines, but easier to express, IMO,
as it's in Clojure.

---

## core.async

```clojure
(def c (chan))
(thread (println "Pouring: " (<!! c) " from channel"))

(>!! c "Hello RuLu")
```

^ using thread, otherwise will block

---

## core.async: buffering

* **unbuffered** by default. Will **block** on
  * reading from empty channels
  * writing to non-empty channels

---

## core.async: buffering

* will buffer upto `n`:

```clojure
(def bc (chan 20))
(>!! bc "Hello")
(>!! bc "RuLu")

(<!! bc) ;;; "Hello"
(<!! bc) ;;; "RuLu"
```

---

## core.async: buffering

* dropping channels

```clojure
(def c (chan (dropping-buffer 20)))
```

* sliding channels

```clojure
(def c (chan (sliding-buffer 20)))
```

* Why not handle buffering automatically?

^ After 20, dropping: drop new ones. Sliding: drop old ones.

---

## core.async: channel functions

* map-chan
* onto-chan
* ...

---

## core.async: go blocks

```clojure
(def c (chan))
(go
  (let [x (<! c)
        y (<! c)]
    (println (clojure.string/join " " [x y]))))

(>!! c "Hello")
(>!! c "RubyConf AU")
```

^ Evented, without the nesting-hell.
Parked between state-machine transitions.
Real efficient

---

## core.async: go block efficiency

```clojure
TODO: go-block scaling example
```

---

![fit](http://f.cl.ly/items/1T3O0E2a1r1t2x2d3g1c/Screen%20Shot%202014-06-19%20at%2019.19.31%20pm.png)

---

## Channels in Ruby

* TODO: code snippet
* TODO: Demo

---

# Closing thoughts & Advice
![fit](http://www.rudebaguette.com/assets/Obama-Hollande.jpg)

---

# [fit] Experiment

---

# [fit] Keep it simple

^ micro-services
^ multi-process queues in Ruby

---

![fit](heterogenous.jpg)

---

# Resources

* github: arnab/modern-concurrency-rulu
*  [presentation/resources.md](https://github.com/arnab/modern-concurrency-rulu/blob/master/presentation/resources.md)

---

# RuLu
![fit](http://cdn.shopify.com/s/files/1/0134/1572/products/Merci_Boucoup_Card.jpg)
