# The elevator pitch
A tool for Game Masters of medieval and fantasy games to come up with inhabited places of interest

# The longer explanation
A simple generator of settlement information. Basically you'll get something with the following information:
* Climate (arctic, temperate or tropical)
* Terrain (plains, hills or mountains)
* Whether it is a trading outpost (small buildings between cities, where trading caravans would often stay for the night. This is the only flag that sets a very low hard limit to population)
* Whether it is a trading hub (if it sits at trading "crossroads", it means resources from many places pass there)
* Whether it has access to a maritime coast, a freshwater source and fertile soil
* Resources it has access to (similar to resources found on Civilization games, like Iron, Copper, Citrus, Tea, etc)
* How long it has existed (directly affects population)
* Population (calculated off a random min-max, multiplied by some factors, such as some resources, terrain and climate).
* How many inns, shrines, temples and marketplaces the place has
* Which services can be found there (specialized services include, but are not limited to: woodworkers, scribes, metalworkers, cobblers, priests, clothiers, etc)

It outputs it all in an easy to read piece of text, but provides no context. That is left to you to add, if you so need.

## What do I do with this info?
That's up to you! I made this with the intent to give Game Masters of medieval-esque games an easy way to get some details about towns and places. With this in mind, it's easy to understand why population rarely surpasses 1k, but when it does, it usually goes very, very high: getting stuff from point A to B when carts are still the epitome of transportation means that a very low volume of goods (compared to today) is on transit.

Combine that low volume with lack of machinery to help with farming and no synthetic fertilizers and it makes more sense why most places couldn't hold large populations. It just wasn't possible to have enough food for more people! Coastal places not only have access to sea resources, but trading volume can also increase greatly.

So, let's say you rolled something with a low population, despite existing for 80 years and having fertile soil and freshwater. What should you make of it? Perhaps the place was recently ransacked, or is currently dealing with a plague!

Maybe you rolled an outpost that has everything to become a bustling metropolis, but is still no more than a lone outpost. Perhaps the area is too dangerous, with too many bandits around. Maybe if a group could get rid of them, huh?

## Why Nim?
It's a language that I find interesting, even if I don't do stuff with it as often as I should. The Garbage Collector annoyed me for a while, since I was using global variables at first, but nothing some Object Orientation didn't fix

As for the language, think of it as Advanced Python, as the syntax is somewhat familiar, but way faster at doing the maths

### But isn't this project too small to bother with speed?
It is! But, if I only ever bother with that when I decide that the speed **will** be needed, then I'll probably never actually do anything in Nim.

## Why not a web page, javascript?
The funny thing is that Nim does compile to JS! The problem is that the UI lib I choose, Nimx, has a currently (as of June 19 2023) open issue where compiling to JS fails.

# Compiling yourself
* Download and install Nim
* Run the Nimble package manager to install Nimx. It should be `nimble install nimx` on any OS
* Run the command `nim c --d:release --threads:on settlegen.nim`
  * If you add `--r` as an option, it will automatically run once it finishes compiling
* Run the compiled executable

**NOT TESTED ON LINUX OR MACOS!**

## Stuff to do
* Give a chance to roll negative pop for temperate and tropical climates, to create 0 pop (abandoned) settlements.
* Make it load text off a .txt file, for easy translation
* Come up with names for the inns
* Make it load the list of resources, services and respective randomizer weights off .txt files, again for translation purposes
* Give the TextField a vertical scrollbar
