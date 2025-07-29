//: [Previous](@previous)

import Foundation

/*
 - Complicated objects(eg. cars) aren't designed from scratch
    - they reiterate existing designs
 - An existing (partially or fully constructed) design is a prototype
 - We make a copy(clone) the prototype and customize to our liking
    - requires "deep copy" support (instead of just copying the references to the objects that you're object to be cloned has, you have to replicate everything recursively)
 - We can make cloning convenient(eg. via a factoty)
 
 
 Definitation -
  A partially or fully intialized object that you copy(clone) and make use of
 */

class Address: CustomStringConvertible {
    var street: String
    var city: String
    
    init(_ street: String,_ city: String) {
        self.street = street
        self.city = city
    }
    
    var description: String {
        return "\(street), \(city)"
    }
}

class Employee: CustomStringConvertible {
     var name: String
    var address: Address
    
    var description: String {
        return "My name is \(name), I live at \(address)"
    }
    
    init(_ name: String, _ address: Address) {
        self.name = name
        self.address = address
    }
}

func main() {
    var john = Employee("John", Address("123 Main St", "Anytown"))
    
    //if we have to copy john and if we do it like this
    var chris = john
    chris.name = "Chris"
    chris.address.city = "London"
    print(john) // My name is Chris, I live at 123 Main St, London
    print(chris) // My name is Chris, I live at 123 Main St, London
    
    // As we can see both of them are chris as we have copied reference as both employee and address are class not struct and when one is modified it will affect john as well
    
    
    // So what can we do to allow replication of object without overriding values
    // What can we do to make sure chris and john actually refer to different object?
    
    // - first we make class to struct for both classes
    
    // Another method by using protocol(eg Copying)
    
    var prototypeJohn = PrototypeEmployee("John", PrototypeAddress("123 Main St", "Anytown"))
    
    //if we have to copy john and if we do it like this
    var prototypechris = PrototypeEmployee(copyFrom: prototypeJohn)
    prototypechris.name = "Chris"
    prototypechris.address.city = "London"
    
    print(prototypeJohn) // My name is John, I live at 123 Main St, Anytown
    print(prototypechris) // My name is Chris, I live at 123 Main St, London
    
    
    /*
     Main issue
        - If there are lot of internal dependency then we have to use copy protocol in all of those
        like we have to do in address case if there are multiple complex and if we miss this protocol copy will not work properly
     */
    
}


protocol Copying {
    init(copyFrom other: Self)
}

class PrototypeAddress: CustomStringConvertible, Copying, FunctionCopying {
    
    required init(copyFrom other: PrototypeAddress) {
        street = other.street
        city = other.city
    }
    
    var street: String
    var city: String
    
    init(_ street: String,_ city: String) {
        self.street = street
        self.city = city
    }
    
    var description: String {
        return "\(street), \(city)"
    }
    
    /*
     Will not work
     func clone() -> Self {
         return Address(street, city)
     }
     */
    func clone() -> Self {
        return cloneImpl()
    }
    private func cloneImpl<T>() -> T {
        return PrototypeAddress(street, city) as! T
    }
}

// This can also be class
struct PrototypeEmployee: CustomStringConvertible, Copying, FunctionCopying {
    
    // If this was class we have to write Self instead of PrototypeEmployee
    func clone() -> PrototypeEmployee {
        return PrototypeEmployee(name, address.clone())
    }
    
   
    
     var name: String
    var address: PrototypeAddress
    
    var description: String {
        return "My name is \(name), I live at \(address)"
    }
    
    init(_ name: String, _ address: PrototypeAddress) {
        self.name = name
        self.address = address
    }
    
    init(copyFrom other: PrototypeEmployee) {
        name = other.name
        //1
        //address = PrototypeAddress(other.address.street, other.address.city)
        
        address = PrototypeAddress(copyFrom: other.address)
    }
}

protocol Prototype {
    associatedtype CloneType
    func clone() -> CloneType
}


func mainWithClone() {
    var prototypeJohn = PrototypeEmployee("John", PrototypeAddress("123 Main St", "Anytown"))
    
    //if we have to copy john and if we do it like this
    var prototypechris = prototypeJohn.clone()
    prototypechris.name = "Chris"
    prototypechris.address.city = "London"
    
    print(prototypeJohn) // My name is John, I live at 123 Main St, Anytown
    print(prototypechris) // My name is Chris, I live at 123 Main St, London
}
main()
mainWithClone() // This is without using copy by initializer we are actually using function name clone. It is self document where function is called clone




/* Summary
 - To implement a prototype partially(or fully) construct an object and store it somewhere for replication
 - Clone the prototype
 - So for example, in Swift, you can make a copying initializer, which is specifically designed for
 
 replicating the entire object graph recursively.

 Or alternatively, you can implement some sort of your own deep copy functionality.

 For example, you can declare a protocol which defines that the type is deep copy, for example.

 And then once you've made the copy, then you customize the resulting instance.

 You make the changes that you want and you use this object in your program.
*/
