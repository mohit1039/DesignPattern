//: [Previous](@previous)

//https://medium.com/@emanharout/swift-solutions-adapter-pattern-a2118a6a2910

import Foundation
/*
 
 So in software, an adapter is a construct which adapts an existing interface X to conform to the required
 */


class Point : CustomStringConvertible, Hashable
{
    
    var hashValue: Int {
        (x * 397) ^ y
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.x == lhs.x && lhs.y == rhs.y
    }
    
  var x: Int
  var y: Int

  init(_ x: Int, _ y: Int)
  {
    self.x = x
    self.y = y
  }

  public var description: String
  {
    return "X = \(x), Y = \(y)"
  }
    
    
}


class Line: CustomStringConvertible, Hashable
{
    
    var hashValue: Int {
        return (start.hashValue * 397) ^ end.hashValue
    }
    static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
    
  var start: Point
  var end: Point

  init(_ start: Point, _ end: Point)
  {
    self.start = start
    self.end = end
  }
    
    var description: String {
        return "Line from \(start) to \(end)"
    }
}

class VectorObject : Sequence
{
  var lines = [Line]()

  func makeIterator() -> IndexingIterator<Array<Line>>
  {
    return IndexingIterator(_elements: lines)
  }
}


class VectorRectangle : VectorObject
{
  init(_ x: Int, _ y: Int, _ width: Int, _ height: Int)
  {
    super.init()
    lines.append(Line(Point(x,y), Point(x+width, y)))
    lines.append(Line(Point(x+width, y), Point(x+width, y+height)))
    lines.append(Line(Point(x,y), Point(x,y+height)))
    lines.append(Line(Point(x,y+height), Point(x+width, y+height)))
  }
}


func drawPoint(_ p : Point) {
    print(".", terminator: "")
}
/*
 So let's suppose that we need to draw some vector objects, like it's a requirement for us to take a

 bunch of vector objects.
 So I'll define those.

 So we'll have a bunch of vector objects.

 I'm going to have a vector rectangle starting at one one side with size ten by ten, I'm going to have

 another one.

 Let's have three, three, six, six.

 So I have two vector rectangles and I want to draw them.
 */

let vectorObjects = [
  VectorRectangle(1,1,10,10),
  VectorRectangle(3,3,6,6)
]

/*
 Now, clearly there is a mismatch because we're talking about vector objects and we can only draw points

 and this is where you need an adapter.
 
 Basically you need a separate class which is going to convert the vector representations into individual

 points that we can subsequently draw.

 You can think of it like the points on a screen.

 For example, even though here we are simulating things by just printing ordinary dots.

 So how would you make such an adapter?
 */

class LineToPointAdapter : Sequence
{
  private static var count = 0
  
  // hash of line -> points for line
  static var cache = [Int: [Point]]()
  var hash: Int

  init(_ line: Line)
  {
    // if the line is cached, don't add it
    hash = line.hashValue
    if type(of: self).cache[hash] != nil { return }

    type(of: self).count += 1
    print("\(type(of: self).count): Generating points for \(line)")

    let left = Swift.min(line.start.x, line.end.x)
    let right = Swift.max(line.start.x, line.end.x)
    let top = Swift.min(line.start.y, line.end.y)
    let bottom = Swift.max(line.start.y, line.end.y)
    let dx = right - left
    let dy = line.end.y - line.start.y

    var points = [Point]()

    if dx == 0
    {
      for y in top...bottom
      {
        points.append(Point(left, y))
      }
    } else if dy == 0
    {
      for x in left...right
      {
        points.append(Point(x,top))
      }
    }

    type(of: self).cache[hash] = points
  }

  func makeIterator() -> IndexingIterator<Array<Point>>
  {
    return IndexingIterator(_elements: type(of: self).cache[hash]!)
  }
}



@MainActor func draw()
{
  // unfortunately, can only draw points
  for vo in vectorObjects
  {
    for line in vo
    {
      let adapter = LineToPointAdapter(line)
      adapter.forEach{ drawPoint($0) }
    }
  }
}

@MainActor func main()
{
  draw()
  draw() // shows why we need caching
}

main()

/*The Adapter Pattern is a design pattern that enables objects with similar functionality to work together despite having incompatible interfaces. It allows for integration that results in code that is cleaner and easier to use. Quite literally, it adapts an object so that it uses more familiar APIs.

Use Cases
The Adapter Pattern should be used when the following are true:

A component shares similar functionality with existing objects in your app.
Despite sharing similar functionality, the component has an interface that is incompatible with other objects in your app. The component is often from a third party framework.
The component’s source code cannot (or should not) be modified.
The component needs to integrate with your app.
The Adapter Pattern allows us to take this foreign object and make it play nice with our existing objects. There are two primary approaches to accomplishing this: Swift Extensions and the Dedicated Adapter Class.

Enough with theory! Let us see what the Adapter Pattern looks like in practice :)

Adapter Pattern: Swift Extension Approach
The Swift Extension is an elegant solution for most simple scenarios.
*/
protocol Jumping {
  func jump()
}

class Dog: Jumping {
  func jump() {
    print("Jumps Excitedly")
  }
}

class Cat: Jumping {
  func jump() {
    print("Pounces")
  }
}
 
let dog = Dog()
let cat = Cat()
/*
Here we have a dog and a cat. They are both able to perform jump(). Now let’s say we integrate a third party framework, and have a foreign animal.
 */

//The Adaptee
class Frog {
  func leap() {
    print("Leaps")
  }
}

let frog = Frog()
/*A few things to note:

Our leaping frog object has some similar functionality with our furry friends.
Though it jumps, its interface is different: we have to call leap() instead of jump() to get the desired functionality.
The Adapter
 */
extension Frog: Jumping {
  func jump() {
    leap()
  }
}
/*Here we integrate our component by implementing the Adapter Pattern. We simply conform Frog to Jumping and create a wrapper function our other objects recognize. We are now able to get the same behavior out of our frog without modifying its existing implementation. We simply extend it with a new wrapper function to abstract away its differences! :)

“Objects should be open for extension, but closed for modification.”

Before and After
It is helpful to see how we would work with our objects before and after we adapted our frog’s interface.

Before:
*/
var animals: [Jumping] = [dog, cat]

func jumpAll(animals: [Jumping], frog: Frog?) {
  for animal in animals {
    animal.jump()
  }
  if let frog = frog {
    frog.leap()
  }
}
//Here we want to make all our animals jump. Without an implemented adapter, the caller has to have knowledge of the frog’s foreign interface. We cannot treat the component like the rest of our code.

//After:

var animals1: [Jumping] = [dog, cat, frog]

@MainActor func jumpAll(animals: [Jumping]) {
  for animal in animals1 {
    animal.jump()
  }
}
/*With the adapter in place, we can treat the frog like the rest of our objects and include it in our animals array. We also get to simplify our function by removing the frog: parameter.

Moreover, we can treat the frog like any other native object by simply calling jump() on it. The frog is obviously still “leaping” under the hood, but we do not care. The caller no longer needs to have knowledge of how Frog jumps.

Adapter Pattern: The Dedicated Adapter Approach
For more complex scenarios, creating a dedicated adapter class can be helpful.
*/
class FrogAdapter: Jumping {
  private let frog = Frog()
  
  func jump() {
    frog.leap()
  }
}
/*Here we create an adapter class that holds the foreign component in a private property.

Extending Frog may have exposed more than we would have liked. With a dedicated adapter, the caller is no longer able to manipulate the frog directly; it can only use whatever is exposed by FrogAdapter. This allows for better encapsulation of the frog, giving us complete control over what gets exposed to the caller.

And that is pretty much it for both approaches!

Conclusion
The Adapter Pattern freed us from having to accommodate objects with different interfaces through the unification of their APIs. This greatly increased the clarity and simplicity of our code, enabling us to integrate a foreign object with ease. It is a classic, simple pattern that is highly practical in its usage. Hope you enjoyed learning it!
*/
