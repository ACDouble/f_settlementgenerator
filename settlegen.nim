import nimx/window
import nimx/text_field
import nimx/button
import std/random
import std/strutils

type
  Settlement = object
    terrain: string
    climate: string
    rainfall: string
    is_coastal: bool #If true, adds one CoastalResource
    is_trading_outpost: bool #If true, population is capped at 15. Resources +3
    is_trading_hub: bool #If true, acts as having access to more resources. Increasese services limit by 3
    has_freshwater: bool
    has_fertile_soil: bool
    total_resources: int #Minimum of 3, cannot be initialized here
    resource_list: seq[string] #Size varies if trading_hub and trading_outpost are true
    services: seq[string] #Variable length array
    resource_weight: seq[int]
    age: int #How many years this settlement has existed for. Higher age leads to higher population
    population: int
    shrines: int #House sized places of adoration to a deity
    temples: int #Large buildings of adoration to a deity
    markets: int #Small and medium markets
    great_market: int #One for every 14000 population
    inns: int #Places for groups to rest and relax

  Climate = enum
    arctic="arctic", temperate="temperate", tropical="tropical"
  Terrain = enum
    plains = "plains", hills = "hills", mountains = "mountains"
  Rainfall = enum
   frequent = "frequent", seasonal = "seasonal", rare = "rare"
  #Gvars stands for Global Variables. Since Nim's GC doesn't let you use threads with global vars
  #They're all dumped into an object
  Gvars = object
    seed: int #Randomizer's seed
    Services: seq[string] #= @["woodworker", "mason", "jeweller", "metalsmith", "scribe", "leatherworker", "clothier", "cobbler", "medic", "priest", "cartographer"]
    arcticWeight: seq[int]
    temperateWeight: seq[int]
    tropicalWeight: seq[int]
    plainWeight: seq[int]
    hillWeight: seq[int]
    mountainWeight: seq[int]
    Resources: seq[string]
    Adjective: seq[string]
    Thing: seq[string]
    ptbrdesc: seq[string]
    engdesc: seq[string]

#Initializing Global Variables
proc initGvars(): Gvars =
  var gvar: Gvars
  gvar.Services = @["woodworker", "mason", "jeweller", "metalsmith", "scribe", "leatherworker", "clothier", "cobbler", "medic", "priest", "cartographer"]
  #The following are default weights for resources for each climate
  gvar.arcticWeight = @[2,3,1,2,1,5,4,2,2,3,1,4,2,2,1,1,1,1,3,1,1]
  gvar.temperateWeight = @[2,3,2,2,1,5,4,3,3,3,1,5,3,3,1,2,2,2,3,1,1]
  gvar.tropicalWeight = @[2,2,1,1,1,3,3,3,4,3,3,3,1,1,4,4,4,4,2,1,1]
  #Terrain weights are added to the climate weight, hence negative numbers
  gvar.plainWeight = @[-1, -1, -2, -2, -1, 1, 1, 1, 0, 0, 1, 0, -1, 0, 1, 1, 1, 0, 1,0,0]
  gvar.hillWeight = @[1,1,1,1,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0]
  gvar.mountainWeight = @[1,2,1,2,1,-1,-2,-1,-1,0,-2,0,0,-1,-2,-2,-1,-2,-2,0,0]
  gvar.Resources = @["Copper"
    ,"Iron"
    ,"Gold"
    ,"Silver" #4
    ,"Gems"
    ,"Game"
    ,"Farm animals" #7
    ,"Textiles"
    ,"Dyes"
    ,"Salt" #10
    ,"Spices"
    ,"Fine woods"
    ,"Wine" #13
    ,"Beer"
    ,"Sugar"
    ,"Citric fruits" #16
    ,"Coffee"
    ,"Tea"
    ,"Horses" #19
    ,"Holy site"
    ,"Library"]
    #TODO - Load values from a file, to allow translation
  gvar.Adjective = @["Golden"
    ,"Silver"
    ,"Silken" #3
    ,"Sleepy"
    ,"Strong"
    ,"Broken" #6
    ,"Stiff"
    ,"Long"
    ,"Rocky" #9
    ,"Plentiful"
    ,"Wooden"
    ,"Angular" #12
    ,"Lost"
    ,"Tipped"
    ,"Holy"
    ,"Blessed"
    ,"Weary"]
  gvar.Thing = @["Anvil"
    ,"Dagger"
    ,"Hammer"
    ,"Cup"
    ,"Flag"
    ,"Throne"
    ,"Dress"
    ,"Garb"
    ,"Helmet"
    ,"Trousers"
    ,"Horn"
    ,"Table"
    ,"Chair"
    ,"Bed"
    ,"Traveller"
    ,"Merchant"
    ,"Bag"
    ,"Mug"
    ,"Barrel"
    ,"Flask"
    ,"Flagon"
    ,"Spear"
    ,"Cap"]
  gvar.ptbrdesc = @["Este assentamento existe em local de clima $#.\n"
  , "O terreno é $#.\n"
  , "As chuvas sao $#.\n"
  , "Este assentamento " #3, index position
  , ""
  , "não "
  , "tem acesso ao mar.\nEste local" #6
  , ""
  , " não"
  , " é um entreposto comercial.\n" #9
  , "É "
  , "Não é "
  , "um centro comercial.\n" #12
  , "O local existe há $# anos.\n"
  , "Tem"
  , "Não tem" #15
  , " acesso a água doce.\n"
  , "Tem"
  , "Não tem" #18
  , " solo fértil.\n"
  , "Este assentamento tem acesso aos seguintes recursos: "
  , "\nTem uma população de $# habitantes"
  , "\nOs seguintes serviços podem ser encontrados lá: " #22
  , "\nHá $# estalagens, $# mercados, $# capelas e $# templos lá. "]
  gvar.engdesc = @["This settlement has a $# climate.\n"
  , "The terrain is $#.\n"
  , "Rainfall is $#.\n"
  , "This settlement " #3
  , "has "
  , "does not have "
  , "a maritime coast.\nThis place is" #6
  , ""
  , " not"
  , " a trading outpost.\n" #9
  , "It is"
  , "It is not"
  , " a trading hub.\n" #12
  , "This place has existed for $# years.\n"
  , "It has"
  , "It does not have" #15
  , " a source of freshwater.\n"
  , "It has"
  , "It does not have" #18
  , " fertile soil.\n"
  , "This settlement has access to the following resources: "
  , "\nIt has $# inhabitants"
  , "\nThe following services can be found there: " #22
  , "\nThere are $# inns, $# markets, $# shrines and $# temples there."]
  return gvar
  #settlement: Settlement

#This proc loads the lines of a file into the given sequence
proc loadTxtSeq(filepath: string, thiseq: var seq[string]) =
  let fop = open(filepath)
  defer: fop.close()
  thiseq = @[] #empties the sequence before adding the file contents
  for line in fop.lines():
    thiseq.add(line)
    #echo line
  echo $thiseq
    
#This proc overload allows rand(bool) to return true or false. It also allows
#a random enum to be picked
proc rand(T: typedesc): T = 
  rand(T.low..T.high)

#Given one sequence of items, and one sequence with the equivalent weights, it picks a random value between 1 and 
#the maximum weight and randomly seeks the first item whose weight is equal or greater.
proc weightedRandom(items: seq[string], weight: seq[int]): string =
  var litems = items #a local copy, as it may be altered
  var lweight = weight #same as above
  while litems.len > lweight.len: #Fills the weight sequence, if it's not the same length as items
    lweight.add(1)
  var randind = rand(0..litems.high()) #First, choose a random index. High() is the same as array.len - 1
  var randwei = rand(1..lweight.max()) #Second, a random value up to or lower than the max informed weight
  while true:
    if lweight[randind] >= randwei: #Checks if the weight is lower than the random chance. If so, the item is good
      #echo "This item should work: $1 weight $2" % [$litems[randind], $lweight[randind]]
      return litems[randind]
    litems.delete(randind) #Removes the item from the index to avoid it being picked again
    lweight.delete(randind) #Removes the item from the index to avoid it being picked again
    randind = rand(0..litems.high()) #Sorts a new element in the reordered index

#Procedure to come with a number of working shrines, temples, markets and inns. 
proc calculateBuildings(self: var Settlement) =
  if self.is_trading_outpost:
    if self.is_trading_hub:
      self.shrines = 1
      self.inns = 1
      self.markets = 1
    else:
      self.shrines = 2
      self.temples = 1
      self.inns = 2
      self.markets = 1
  case self.age:
    of 0..8:
      self.shrines = 1
    else:
      self.shrines = 2
  
  self.shrines += self.population div 4000
  self.markets = 1 + (self.population div 2500)
  self.great_market = self.population div 14000
  self.temples = self.population div 20000
  self.inns = 1 + self.population div 1300
  
proc calculateWeight(self: var Settlement, gvar: Gvars) =
  var cli, ter: seq[int]
  case self.climate:
    of $Climate.arctic:
      cli = gvar.arcticWeight
    of $Climate.temperate:
      cli = gvar.temperateWeight
    of $Climate.tropical:
      cli = gvar.tropicalWeight
  case self.terrain:
    of $Terrain.plains:
      ter = gvar.plainWeight
    of $Terrain.hills:
      ter = gvar.hillWeight
    of $Terrain.mountains:
      ter = gvar.mountainWeight
  for i in 0..ter.high():
    self.resource_weight.add(ter[i] + cli[i])

#Fiddle with numbers for different results. They are completely arbitrary
proc calculatePopulation(self: Settlement): int =
  var minpop, maxpop: int
  var popmultiplier = 1.0
  if self.is_trading_outpost:
    if self.is_trading_hub:
      maxpop = 1300
      minpop = 400
    else:
      maxpop = 15
      minpop = 5
    return rand(minpop..maxpop)
    
  case self.climate:
    of $Climate.arctic:
      popmultiplier = 0.5
    of $Climate.temperate:
      popmultiplier = 1.0
    of $Climate.tropical:
      popmultiplier = 1.5
  case self.rainfall:
    of $Rainfall.frequent:
      popmultiplier += 0.3
    of $Rainfall.seasonal: 
      popmultiplier += 0.1
    of $Rainfall.rare: 
      popmultiplier -= 0.4
  case self.terrain:
    of $Terrain.plains:
      popmultiplier += 0.4
    of $Terrain.hills:
      popmultiplier -= 0.1
    of $Terrain.mountains:
      popmultiplier -= 0.4

  if self.has_freshwater:
    popmultiplier += 0.3 
  else:
    popmultiplier -= 0.2
  if self.has_fertile_soil:
    popmultiplier += 0.6
  else:
    popmultiplier -= 0.2
  if self.is_trading_hub:
    maxpop += 3000
    minpop += 30
  if self.is_coastal:
    maxpop += 100
    minpop += 10
  case self.age:
    of 0..5:
      maxpop -= 300
    of 6..15:
      minpop += 10
    of 16..30:
      maxpop += 1500
      minpop += 20
    of 31..50:
      maxpop += 4000
      minpop += 50
    of 51..70:
      maxpop += 9000
      minpop += 80
    else:
      maxpop += 15000
      minpop += 150
  if "Farm Animals" in self.resource_list:
    popmultiplier += 0.25
  if "Game" in self.resource_list:
    popmultiplier += 0.1
  if "Citric Fruits" in self.resource_list:
    popmultiplier += 0.2
  echo "Max population $# ; Min population $# ; $# population multiplier: " % [$maxpop, $minpop, $popmultiplier]
  if maxpop < 0 or maxpop < minpop:
    minpop = 0
    maxpop = 5
  var ret = toFloat(rand(minpop..maxpop)) * popmultiplier 
  if ret < 0:
    ret = 0
  return toInt(ret)

#self is received as a var to allow adding to its service list
proc calculateServices(self: var Settlement, gvar: Gvars) = 
  var totalservices: int
  case self.population:
    of 0:
      return
    of 1..100:
      totalservices = 1
    of 101..200:
      totalservices = 2
    of 201..600:
      totalservices = 4
    of 601..1800:
      totalservices = 7
    of 1801..4000:
      totalservices = 10
    of 4001..8000:
      totalservices = 12
    else:
      totalservices = 14
  for i in 1..totalservices:
    self.services.add(sample(gvar.Services))

#Creates random values to the settlement
proc generateSettlement(gvar: Gvars): Settlement =
  var self: Settlement
  self.terrain = $rand(Terrain)
  self.climate = $rand(Climate)
  self.rainfall = $rand(Rainfall)
  self.is_coastal = rand(bool)
  self.is_trading_outpost = rand(bool)
  self.is_trading_hub = rand(bool)
  self.has_freshwater = rand(bool)
  self.has_fertile_soil = rand(bool)
  self.age = rand(1..100)
  #Blocks in Nim exist just to organize code
  block calculate_resources:
    self.total_resources = 2  
    if self.is_trading_hub:
      self.total_resources += 4 
      if self.is_coastal:
        self.total_resources += 2
    if self.is_trading_outpost:
      self.total_resources += 2
      if self.is_coastal:
        self.total_resources += 1
    #self.resource_weight = self.calculateWeight()
    self.calculateWeight(gvar)
    for i in 1..self.total_resources:
      #self.resource_list.add(sample(Resources))
      #echo $weightedRandom(Resources, self.resource_weight)
      self.resource_list.add(weightedRandom(gvar.Resources, self.resource_weight))
  self.population = self.calculatePopulation()
  self.calculateServices(gvar)
  self.calculateBuildings()
  return self

#This proc simplifies what would otherwise be a large repetition of if true: "text1; else "text2"
proc trufalseString(value: bool, iftru: string, iffalse: string): string =
  if value:
    return iftru
  else:
    return iffalse
  
proc describe(self: Settlement, txtdesc: seq[string]): string =
  var description = txtdesc[0] % $self.climate & txtdesc[1] % $self.terrain  & txtdesc[2] % $self.rainfall 
  description.addf(txtdesc[3])
  description.addf(trufalseString(self.is_coastal, txtdesc[4], txtdesc[5]) & txtdesc[6]) 
  description.addf(trufalseString(self.is_trading_outpost, txtdesc[7], txtdesc[8]) & txtdesc[9]) 
  description.addf(trufalseString(self.is_trading_hub, txtdesc[10], txtdesc[11]) & txtdesc[12])
  description.addf(txtdesc[13] % $self.age)
  description.addf(trufalseString(self.has_freshwater, txtdesc[14], txtdesc[15]) & txtdesc[16])
  description.addf(trufalseString(self.has_fertile_soil, txtdesc[17], txtdesc[18]) & txtdesc[19])
  description.add(txtdesc[20])
  for i in self.resource_list:
    description.addf(i & ", ")
  description.addf(txtdesc[21] % $self.population)
  description.addf(txtdesc[22])
  for sr in self.services:
    description.addf(sr & ", ")
  description.addf(txtdesc[23] % [$self.inns, $self.markets, $self.shrines, $self.temples])
  return description

proc createAndDescribe(gvar: Gvars): string =
  var lsettl = generateSettlement(gvar)
  lsettl.describe(gvar.ptbrdesc)

proc getSeed(val: string): int =
  var resul: int
  for i in val:
    resul = resul + int(i)
  return resul

#Window Initializer
proc startUp() =
  #randomize()
  var gvar = initGvars()
  let wnd = newWindow(newRect(100,50,600,500))
  let textfield = newTextField(newRect(160,10,410,450))
  wnd.title = "Gerador de Assentamento"
  wnd.addSubview(textfield)

  let seedlabel = newLabel(newRect(10,10,120,80))
  seedlabel.text = "Valor da Semente (vazio para aleatorio)"
  wnd.addSubview(seedlabel)
  let seedfield = newTextField(newRect(10,80,100,30))
  #var seedfield = newTextField(newRect(30,50,100,30))
  wnd.addSubview(seedfield)
  
  let btn1 = newButton(newRect(10, 110, 80, 40))
  btn1.title = "Gerar"
  btn1.onAction do():
    if seedfield.text != "":
      randomize(getSeed(seedfield.text))
    else:
      randomize()
    #label.text = label.text & "\nWorking!"
    textfield.text = textfield.text & "\n-----------\n" & createAndDescribe(gvar)
  #label.text = "Working!"
  wnd.addSubview(btn1)
  
  var btn2 = newButton(newRect(10, 150, 96, 40))
  btn2.title = "Limpar Texto"
  btn2.onAction do():
    textfield.text = ""
  wnd.addSubview(btn2)

  var btn3 = newButton(newRect(10, 190, 120, 40))
  btn3.title = "Limpar e Gerar"
  btn3.onAction do():
    if seedfield.text != "":
      randomize(getSeed(seedfield.text))
    else:
      randomize()  
    textfield.text = createAndDescribe(gvar)
  wnd.addSubview(btn3) 
  
#Main thread. "runApplication" is a reserved proc
runApplication:
    startUp()
