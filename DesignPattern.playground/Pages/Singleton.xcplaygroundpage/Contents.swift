////: [Previous](@previous)
//
//import Foundation
//
///*
// For some components it only makes sense to have one in the system
//    - Database repository
//    - Object factory -
//        if you have a factory which knows how to create objects, which is not keeping any state, so the factory is stateless, then what is the point      of actually allowing people to create many of these factories?
//        
//        Why not simply have just a single factory that's being      created?
//        
//        It seems a bit inefficient.
// E.g the initializer call is expensive
//        So in many cases, for example, you have an object where         the initializer call is expensive.
//        
//        So for example, in the case of a database which reads data      from, let's say, a file and then exposes
//        
//        this data to your program, you don't want to be doing it        more than once because it's an expensive call.
//           We only do it once
//           We provide everyone with the same instance
// 
// And we also have additional concerns which I guess are taken up by Swift itself, such as, for example,
//
// this idea of lazy instantiation and this idea of thread safety to make sure that we don't have any race conditions when we're constructing these objects.
// 
// Defination
// So the singleton is quite simply a component which is instantiated only once, and sometimes the system
//
// will actively refuse you trying to instantiate it more than once.
// */
//
//import Foundation
//import XCTest
//
//protocol Database
//{
//  func getPopulation(name: String) -> Int
//}
//
//class SingletonDatabase : Database
//{
//  var capitals = [String: Int]()
//  static var instanceCount = 0
//  static var instance = SingletonDatabase()
//
//  private init()
//  {
//    type(of: self).instanceCount += 1
//    print("Initializing database")
//
//    let path = "/mnt/c/Dropbox/Projects/Demos/SwiftDesignPatterns/patterns/creational/singleton/capitals.txt"
//    if let text = try? String(contentsOfFile: path as String,
//      encoding: String.Encoding.utf8)
//    {
//      let strings = text.components(separatedBy: .newlines)
//        .filter { !$0.isEmpty }
//        .map { $0.trimmingCharacters(in: .whitespaces)}
//      //print(strings.count)
//      for i in 0..<(strings.count/2)
//      {
//        //print("`\(strings[i*2])` has population \(Int(strings[i*2+1])!)")
//        capitals[strings[i*2]] = Int(strings[i*2+1])!
//      }
//    }
//  }
//
//  func getPopulation(name: String) -> Int {
//    return capitals[name]!
//  }
//}
//
//class SingletonRecordFinder {
//  func totalPopulation(names: [String]) -> Int
//  {
//    var result = 0
//    for name in names {
//      // singleton database hardcoded here
//      result += SingletonDatabase.instance.getPopulation(name: name);
//    }
//    return result
//  }
//}
//
//class ConfigurableRecordFinder {
//  let database: Database
//  init(database: Database)
//  {
//    self.database = database
//  }
//  func totalPopulation(names: [String]) -> Int
//  {
//    var result = 0
//    for name in names {
//      result += database.getPopulation(name: name);
//    }
//    return result
//  }
//}
//
//class DummyDatabase : Database
//{
//    func getPopulation(name: String) -> Int {
//      return ["alpha": 1, "beta": 2, "gamma": 3][name]!
//    }
//}
//
//class SingletonTests: XCTestCase
//{
//    static let allTests = [
//    ("test_isSingletonTest", test_isSingletonTest),
//    ("test_singletonTotalPopulationTest", test_singletonTotalPopulationTest),
//    ("test_dependantTotalPopulationTest", test_dependantTotalPopulationTest)
//  ]
//
//  func test_isSingletonTest()
//  {
//    var db = SingletonDatabase.instance
//    var db2 = SingletonDatabase.instance
//    XCTAssertEqual(1, SingletonDatabase.instanceCount, "instance count must = 1")
//  }
//
//  func test_singletonTotalPopulationTest()
//  {
//    let rf = SingletonRecordFinder()
//    let names = ["Seoul", "Mexico City"]
//    let tp = rf.totalPopulation(names: names)
//    XCTAssertEqual(17_500_000+17_400_000, tp, "population size must match")
//  }
//
//// Resolving singleton testability with dependency injection
//  func test_dependantTotalPopulationTest() {
//    let db = DummyDatabase()
//    let rf = ConfigurableRecordFinder(database: db)
//    XCTAssertEqual(4, rf.totalPopulation(names: ["alpha", "gamma"]))
//  }
//}
//
//func main()
//{
//  XCTMain([testCase(SingletonTests.allTests)])
//}
//
//func main_old()
//{
//  // cannot construct database directly
//  //let mydb = SingletonDatabase()
//
//  let db = SingletonDatabase.instance
//  var city = "Tokyo"
//  print("\(city) has population \(db.getPopulation(name: city))")
//  city = "Manila"
//  print("\(city) has population \(db.getPopulation(name: city))")
//  print("SingletonDatabase has \(SingletonDatabase.instanceCount) instance(s)")
//}
//
//main()


//Monostate - singleton type
import Foundation
@MainActor
class CEO: @preconcurrency CustomStringConvertible {
    static var _name: String = ""
    static var _salary: Int = 0
    
    var name: String {
        get {
            return CEO._name
        }
        set {
            CEO._name = newValue
        }
    }
    
    var salary: Int {
        get {
            return CEO._salary
        }
        set {
            CEO._salary = newValue
        }
    }
    
    var description: String {
        return "CEO name: \(name), salary: \(salary)"
    }
}


@MainActor func mainMonoState() {
    let ceo1 = CEO()
    ceo1.name = "John"
    ceo1.salary = 1000000
     
    
    let ceo2 = CEO()
    ceo2.salary = 2000000
    print(ceo1)
    print(ceo2)
}

mainMonoState()


class SingletonTester
{
  static func isSingleton(factory: () -> AnyObject) -> Bool
  {
    let obj1 = factory()
    let obj2 = factory()
    return obj1 === obj2
  }
}

let obj = SingletonTester()
print(type(of: obj))
print(SingletonTester.isSingleton{obj})
print(SingletonTester.isSingleton{ SingletonTester() })


/*
 Making a 'safe' singleton is easy:
    construct a static(optionally lazy) property  and return is value
 Singleton are difficult to test
 Instead of directly using a singleton, consider depending on an abstraction(e.g. a protocol)
 Consider defining singleton lifetime in DI container
 */
