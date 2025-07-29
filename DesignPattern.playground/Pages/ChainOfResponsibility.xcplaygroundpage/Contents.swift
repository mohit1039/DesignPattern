/*
 A chain of components who all get a chance to process a command or a query, optionally having default processing implementation and an ability to terminate the processing chain
 
 Command = asking for an action or change (e.g., please set your attack value to 2).

 Query = asking for information (e..g, please give me your attack value).

 CQS(Command Query Seperation) = having separate means of sending commands and queries to e.g., direct field access.
 */

import Foundation
class Creature: CustomStringConvertible {
    var description: String {
        return "Name: \(name), Attack: \(attack), Defence: \(defence)"
    }
    
    var name: String
    var attack: Int
    var defence: Int
    
    init(name: String, attack: Int, defence: Int) {
        self.name = name
        self.attack = attack
        self.defence = defence
    }
}

class CreatureModifier {
    let creature: Creature
    var next: CreatureModifier?
    
    init(creature: Creature) {
        self.creature = creature
    }
    
    func add(_ cm: CreatureModifier){
        if next != nil {
            next!.add(cm)
        } else {
            next = cm
        }
    }
    
    func handle() {
        next?.handle() // chain behaviour
    }
}

class DoubleAttackModifier: CreatureModifier {
    override func handle() {
        print("Doubling  \(creature.name)'s attack...")
        creature.attack *= 2
        super.handle()
    }
}

class IncreaseDefenseModifier: CreatureModifier {
    override func handle() {
        print("Increasing \(creature.name)'s defence...")
        creature.defence += 3
        super.handle()
    }
}

//Witch stops

class NoBonusesModifier: CreatureModifier {
    override func handle() {
        
    }
}


func main() {
    let goblin = Creature(name: "Goblin", attack: 2, defence: 2)
    print(goblin)
    
    let root = CreatureModifier(creature: goblin)
    
    // If enabled witch curse no change in goblin attack and defence
    // root.add(NoBonusesModifier(creature: goblin))
    
    print("Lets double the goblin's attack")
    root.add(DoubleAttackModifier(creature: goblin))
    
    print("Lets increase goblins defence")
    root.add(IncreaseDefenseModifier(creature: goblin))
    
    root.handle()
    print(goblin)
}

main()


//Broker Chain

protocol Invocable: AnyObject {
    func invoke(_ data: Any)
}

public protocol Disposable {
    func dispose()
}

public class Event<T> {
    public typealias EventHandler = (T) -> Void
    
    var eventHandlers: [Invocable] = []
    
    public func raise(_ data: T) {
        for handler in eventHandlers {
            handler.invoke(data)
        }
    }
    
    public func addHandler<U: AnyObject>(target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let subscription = Subscription(target:target, handler: handler, event: self)
        eventHandlers.append(subscription)
        return subscription
    }
    
}

class Subscription<T: AnyObject, U>: Invocable, Disposable {
    
    weak var target: T?
    let handler: (T) -> (U) -> Void
    let event: Event<U>
    
    init(target: T? = nil, handler: @escaping (T) -> ( (U) -> Void), event: Event<U>) {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(_ data: Any) {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter{ $0 as AnyObject? !== self}
    }
    
    
}

//CQS


class Query {

    var creatureName: String
    
    enum Argument {
        case attack
        case defense
    }
    
    var whatToQuery: Argument
    
    var value: Int
    
    init(creatureName: String, whatToQuery: Argument, value: Int) {
        self.creatureName = creatureName
        self.whatToQuery = whatToQuery
        self.value = value
    }
}

class Game {
    
}

