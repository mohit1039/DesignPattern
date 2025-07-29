
/*
 
 A component responsible solely for the wholesale (not piecewise) creation of objects
 
 Object creation logic becomes extremely complicated and difficult to follow
 Initializer is not descriptive
    - Name is mandated init
    - we can overload with same sets of argument with diffent names
        - works to some degree but sometime we need initializer name
Object creation(non-piecewise, unlike builder) can be outsourced to
 - seperate function(factory method)
 - That may exist in seperate class(factory)
 - Can create heirarchy of factories with abstract factory
 
 */
import Foundation

class Point {
    var x, y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init (rho: Double, theta: Double) {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }
    
    static func createCartesion(x: Double, y: Double) -> Point {
        return Point(x: x, y: y)
    }
    
    static func createPolar(rho: Double, theta: Double) -> Point {
        return Point(rho: rho, theta: theta)
    }
}

func main() {
    var p = Point(x: 1.0, y: 2.0) // Have to call point only but in factory we can rewrite init name
    
    // Factory method is simply a static method which is used to construct a particular object
    
    let point1 = Point.createCartesion(x: 1.0, y: 2.0)
    let point2 = Point.createPolar(rho: 1.0, theta: 2.0)
}


class PointFactory {
    func createCartesion(x: Double, y: Double) -> Point {
        return Point(x: x, y: y)
    }
    
    func createPolar(rho: Double, theta: Double) -> Point {
        return Point(rho: rho, theta: theta)
    }
}

func main2() {
    let factory = PointFactory()
    let point1 = factory.createCartesion(x: 1.0, y: 2.0)
    let point2 = factory.createPolar(rho: 1.0, theta: 2.0)
}



// Innerfactory

class Point2 {
    class Factory {
        static func createCartesion(x: Double, y: Double) -> Point2 {
            return Point2(x: x, y: y)
        }
    }
    
    var x, y: Double
    
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}


let point2 = Point2.Factory.createCartesion(x: 1.0, y: 2.0)


//Abstract factory

protocol HotDrink {
    func consume()
}

class Tea: HotDrink {
    func consume() {
        print("This tea is nice but i prefer it with lemon")
    }
}

class Coffee: HotDrink {
    func consume() {
        print("This coffee is delicious")
    }
}

protocol HotDrinkFactory {
    init()
    func prepare(amount: Int) -> HotDrink
}

class TeaFactory {
    required init() {}
    func prepare(amount: Int) -> HotDrink {
        print("Put in tea bag , boil water, pour \(amount)ml, add lemon, enjoy!")
        return Tea()
    }
}

class CoffeeFactory {
    required init() {}
    func prepare(amount: Int) -> HotDrink {
        print("Grind beans, boil waterm, pour \(amount)ml, sugar, enjoy!")
        return Coffee()
    }
}

class HotDrinkMachine {

  enum AvailableDrink : String { // violates open-closed {
    case coffee = "Coffee"
    case tea = "Tea"

    static let all = [coffee, tea]
  }

  internal var factories = [AvailableDrink: HotDrinkFactory]()

  internal var namedFactories = [(String, HotDrinkFactory)]()

  init() {
    for drink in AvailableDrink.all {
      let type = NSClassFromString("Factory.\(drink.rawValue)Factory")
        print(type)
      let factory = (type as! HotDrinkFactory.Type).init()
      factories[drink] = factory

      namedFactories.append((drink.rawValue, factory))
    }
  }

  func makeDrink() -> HotDrink {
    print("Available drinks")
    for i in 0..<namedFactories.count
    {
      let tuple = namedFactories[i]
      print("\(i): \(tuple.0)")
    }
    let input = Int(readLine()!)!
    return namedFactories[input].1.prepare(amount: 250)
  }
}

func Hotmain()
{
  let machine = HotDrinkMachine()
  print(machine.namedFactories.count)
  let drink = machine.makeDrink()
  drink.consume()
}

Hotmain()

/*
 Factory method is static method that create objects
 A factory can take care of object creation
 A factory can  be external or reside inside the object  as an inner class
 Heirarchies of factories can be used to create related objects 
 */
