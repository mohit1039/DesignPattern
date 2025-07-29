//https://medium.com/@emanharout/swift-solutions-decorator-pattern-49fcfb18c1ce

import Foundation

// Adding behaviour to class without altering the class itself

//Dynamic decorator
import Foundation

protocol Shape : CustomStringConvertible
{
  var description: String { get }
}

class Circle : Shape
{
  private var radius: Float = 0

  init(_ radius: Float)
  {
    self.radius = radius
  }

  func resize(_ factor: Float)
  {
    radius *= factor
  }

  public var description: String
  {
    return "A circle of radius \(radius)"
  }
}

class Square : Shape
{
  private var side: Float = 0

  init(_ side: Float)
  {
    self.side = side
  }

  public var description: String
  {
    return "A square with side \(side)"
  }
}

class ColoredShape : Shape
{
  var shape: Shape
  var color: String

  init(_ shape: Shape, _ color: String)
  {
    self.shape = shape
    self.color = color
  }

  var description: String
  {
    return "\(shape.description) has color \(color)"
  }
}

class TransparentShape : Shape
{
  var shape: Shape
  var transparency: Float

  init(_ shape: Shape, _ transparency: Float)
  {
    self.shape = shape
    self.transparency = transparency
  }

  var description: String
  {
    return "\(shape.description) has \(transparency*100)% transparency"
  }
}

func main()
{
  // dynamic
  let square = Square(1.23)
  print(square)

  let redSquare = ColoredShape(square, "red")
  print(redSquare)

  let redHalfTransparentSquare = TransparentShape(redSquare, 0.5)
  print(redHalfTransparentSquare)
}

main()


//Static decorator

import Foundation

protocol Shape : CustomStringConvertible
{
  init() // requited for construction
  var description: String { get }
}

class Circle : Shape
{
  private var radius: Float = 0

  required init() {}
  init(_ radius: Float)
  {
    self.radius = radius
  }

  func resize(_ factor: Float)
  {
    radius *= factor
  }

  public var description: String
  {
    return "A circle of radius \(radius)"
  }
}

class Square : Shape
{
  private var side: Float = 0

  required init() {}
  init(_ side: Float)
  {
    self.side = side
  }

  public var description: String
  {
    return "A square with side \(side)"
  }
}

class ColoredShape<T> : Shape where T : Shape
{
  private var color: String = "black"
  private var shape: T = T()

  required init() {}
  init(_ color: String)
  {
    self.color = color
  }

  public var description: String
  {
    return "\(shape.description) has the color \(color)"
  }
}

class TransparentShape<T> : Shape where T : Shape
{
  private var transparency: Float = 0
  private var shape: T = T()
  
  required init(){}
  init(_ transparency: Float)
  {
    self.transparency = transparency
  }

  public var description: String
  {
    return "\(shape.description) has transparency \(transparency*100)%"
  }
}

func main()
{
  let blueCircle: ColoredShape<Circle> = ColoredShape<Circle>("blue")
  print(blueCircle)

  // only transparency propagates, color does not
  let blackHalfSquare = TransparentShape<ColoredShape<Square>>(0.4)
  print(blackHalfSquare)
}

main()
