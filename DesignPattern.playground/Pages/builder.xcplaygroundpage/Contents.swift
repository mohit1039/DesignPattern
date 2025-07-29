//: [Previous](@previous)

import UIKit


class HTMLElement: CustomStringConvertible {
    
    var name = ""
    var text = ""
    var elements = [HTMLElement]()
    private let indentSize = 2
    
    init(){}
    
    init(name: String = "", text: String = "") {
        self.name = name
        self.text = text
    }
    
    
    private func description(_ indent: Int) -> String {
        var result = ""
        let i = String(repeating: " ", count: indent)
        result+="\(i)<\(name)>\n"
        
        if !text.isEmpty {
            result += String(repeating: " ", count: indent + 1)
            result += text
            result += "\n"
        }
        
        for e in elements {
            result += e.description(indent + 1)
        }
        
        result += "\(i)</\(name)>\n"
        return result
    }
    
    public var description: String {
        return description(0)
    }
    
    
}


class HTMLBuilder : CustomStringConvertible {
    private let rootName: String
    var root = HTMLElement()
    
    init(rootName: String) {
        self.rootName = rootName
        root.name = rootName
    }
    
    func addChild(name: String, text: String) {
        let e = HTMLElement(name: name, text: text)
        root.elements.append(e)
    }
    
    var description: String {
        return root.description
    }
    
    func clear() {
        root = HTMLElement(name: rootName, text: "")
    }
    
    func addFluentChild(name: String, text: String) -> HTMLBuilder {
        let e = HTMLElement(name: name, text: text)
        root.elements.append(e)
        return self
    }
}

///Builder
func main() {
    /*
    let hello = "hello"
    var result = "<p>\(hello)</p>"
    print(result)
    
    let words = ["hello", "world"]
    result = "<ul>\n"
    for word in words {
        result.append("<li>\(word)</li>\n")
    }
    result.append("</ul>")
    print(result)
     */
    
    /*
     Simple build
    let builder = HTMLBuilder(rootName: "ul")
    builder.addChild(name: "li", text: "hello")
    builder.addChild(name: "li", text: "world")
    print(builder)
     */
    
    /// Fluent builder
    let builder = HTMLBuilder(rootName: "ul")
    builder.addFluentChild(name: "li", text: "hello")
        .addFluentChild(name: "li", text: "world")
    print(builder)
}
main()


class Person: CustomStringConvertible {
    var streetAdress = "", postcode = "", city = "" // addresss
    var companyName = "", position = "" //employment
    var annualIncome = 0
    
    var description: String {
        return "I live at \(streetAdress) \(postcode) \(city) \n" +
        "I work at \(companyName) as \(position) and earn \(annualIncome)"
    }
}

class PersonBuilder {
    var person = Person()
    
    var lives: PersonAddressBuilder {
        return PersonAddressBuilder(person)
    }
    
    var works: PersonEmploymentBuilder {
        return PersonEmploymentBuilder(person)
    }
    
    func build() -> Person {
        return person
    }
}

class PersonEmploymentBuilder: PersonBuilder {
   internal init(_ person: Person) {
       super.init()
       self.person = person
    }
    
    func at(_ companyName: String) -> Self {
        person.companyName = companyName
        return self
    }
    
    func asA(_ position: String) -> Self {
        person.position = position
        return self
    }
    
    func earning(_ annualIncome: Int) -> Self {
        person.annualIncome = annualIncome
        return self
    }
}

class PersonAddressBuilder: PersonBuilder {
    internal init(_ person: Person) {
        super.init()
        self.person = person
    }
    
    func at(_ streetAdress: String) -> Self {
        person.streetAdress = streetAdress
        return self
    }
    
    func withPostcode(_ postcode: String)-> Self {
        person.postcode = postcode
        return self
    }
    
    func inCity(_ city: String)-> Self {
        person.city = city
        return self
    }
}

func personemain() {
    let personBuilder = PersonBuilder()
        .lives.at("123 Main St")
              .withPostcode("12345")
              .inCity("Anytown")
        .works.at("Acme Inc.")
              .asA("Software Developer")
              .earning(100000)
    
    print(personBuilder.person)
}

personemain()


//Excersice




import Foundation

class CodeBuilder : CustomStringConvertible
{

  var rootName: String
  var variableAdder = VariableAdder()
  
    
  init(_ rootName: String)
  {
    self.rootName = rootName
  }

  func addField(called name: String, ofType type: String) -> CodeBuilder
  {
    let variable = VariableAdder(name: name, type: type)
    variableAdder.variables.append(variable)
    return self
  }

  public var description: String
  {
    var result = "class \(rootName)\n{\n"
      
      for variable in variableAdder.variables {
        result += String(repeating: " ", count: 2)
        result.append("var \(variable.name): \(variable.type)\n")
    }
      result.append("}")
      return result
  }
}

class VariableAdder {
    var name = ""
    var type = ""
    
    var variables = [VariableAdder]()
    
    init(){}
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}


var builder = CodeBuilder("Person")
builder.addField(called: "name", ofType: "String")
        .addField(called: "age", ofType: "Int")

print(builder)


/*
 - A builder is seperate component for building a object
 - Can either give builder an initializer or return  it via a static function
 - To make builder fluent, return self
 - Different aspects of objects can be build with different builder working together with base class
 */
