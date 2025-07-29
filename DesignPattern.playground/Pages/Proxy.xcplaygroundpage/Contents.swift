//: [Previous](@previous)

import Foundation

/*
 you are calling a foo.Bar()
 this assumes that foo is in the same process as Bar()
 what if later, you want to pull all foo-related operations into a seperate process
        - Can you avoid changing your code
 Proxy to rescue
        - same interface, entirely different behaviour
 this is called communication proxy
    -   other types - logging , virtual, guarding proxy etc
 
 defination - A class that function as an interface to a particular resource. that resource may be remote, expensive to construct, or may require logging or some other added functionality
 */


protocol Vehicle {
    func drive()
}

class Car: Vehicle {
    func drive() {
        print("Car being driven")
    }
}

class ProxyCar: Vehicle {
    private let car: Car = Car()
    private let driver: Driver
    init(driver: Driver) {
        self.driver  = driver
    }
    
    func drive() {
        if driver.age >= 16 {
            car.drive()
        } else {
            print("Driver is too young")
        }
    }
}

class Driver {
    var age: Int
    
    init(age: Int) {
        self.age = age
    }
}


func main() {
    let car: Vehicle = ProxyCar(driver: Driver(age: 12))
}
main()


/*
 A proxy has  the same interface as the underlying object
 To create a proxy, simply replicate the existing interface of an object
 Add relevant functionality to redefined member funtions
 Different proxies (communication, logging, caching etc). have completely different behaviors
 */
