//: [Previous](@previous)

import Foundation

// A space optimization techniques that lets us use less memory by storing externally the data associated with similar objects

import Foundation

class User
{
  var fullName: String

  init(_ fullName: String)
  {
    self.fullName = fullName
  }

  var charCount: Int
  {
    return fullName.utf8.count
  }
}

class User2
{
  static var strings = [String]()
  private var names = [Int]()

  init(_ fullName: String)
  {
    func getOrAdd(_ s: String) -> Int
    {
      if let idx = type(of: self).strings.index(of: s)
      {
        return idx
      }
      else
      {
        type(of: self).strings.append(s)
        return type(of: self).strings.count + 1
      }
    }
    names = fullName.components(separatedBy: " ").map { getOrAdd($0) }
  }

  static var charCount: Int
  {
    return strings.map{ $0.utf8.count }.reduce(0, +)
  }
}

func main()
{
  let user1 = User("John Smith")
  let user2 = User("Jane Smith")
  let user3 = User("Jane Doe")
  // "Smith" and "Jane" allocated twice, eat 2x memory

  let totalChars = user1.charCount + user2.charCount + user3.charCount
  print("Total number of chars used: \(totalChars)")

  let user4 = User2("John Smith")
  let user5 = User2("Jane Smith")
  let user6 = User2("Jane Doe")
  print("Total number of chars used: \(User2.charCount)")
}

main()







//Text Formatting

import Foundation

extension String {
    func substring(_ location: Int, _ length: Int) -> String? {
        guard characters.count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: location + length)
        return substring(with: start..<end)
    }
}

class FormattedText: CustomStringConvertible
{
  private var text: String
  private var capitalize: [Bool]

  init(_ text: String)
  {
    self.text = text
    capitalize = [Bool](repeating: false, count: text.utf8.count)
  }
  
  func capitalize(_ start: Int, _ end: Int)
  {
    for i in start...end
    {
      capitalize[i] = true
    }
  }

  var description: String
  {
    var s = ""
    for i in 0..<text.utf8.count
    {
      let c = text.substring(i,1)!
      s += capitalize[i] ? c.capitalized : c
    }
    return s
  }
}

class BetterFormattedText: CustomStringConvertible
{
  private var text: String
  private var formatting = [TextRange]()

  init(_ text: String)
  {
    self.text = text
  }

  func getRange(_ start: Int, _ end: Int) -> TextRange
  {
    let range = TextRange(start, end)
    formatting.append(range)
    return range
  }

  var description: String
  {
    var s = ""
    for i in 0..<text.utf8.count
    {
      var c = text.substring(i, 1)!
      for range in formatting
      {
        if range.covers(i) && range.capitalize
        {
          c = c.capitalized
        }
      }
      s += c
    }
    return s
  }

  class TextRange
  {
    var start, end: Int
    var capitalize: Bool = false // bold, italic, etc

    init(_ start: Int, _ end: Int)
    {
      self.start = start
      self.end = end
    }

    func covers(_ position: Int) -> Bool
    {
      return position >= start && position <= end
    }
  }
}

func main1()
{
  let ft = FormattedText("This is a brave new world")
  ft.capitalize(10,15)
  print(ft)

  let bft = BetterFormattedText("This is a brave new world")
  bft.getRange(10,15).capitalize = true
  print(bft)
}

main1()


import Foundation

class Sentence : CustomStringConvertible
{
 private var words: [String]
  private var wordTokens: [WordToken] = []
  init(_ plainText: String)
  {
    self.words = plainText.components(separatedBy: " ")
        for word in words {
            wordTokens.append(WordToken(word: word))
        }
  }

  subscript(index: Int) -> WordToken
  {
    return wordTokens[index]
  }

  var description: String
  {
    var result = ""
        for (index, token) in wordTokens.enumerated() {
            if token.capitalize {
                result += token.word.uppercased()
            } else {
                result += token.word
            }
            if index < wordTokens.count - 1 {
                result += " "
            }
        }
        return result
  }

  class WordToken
  {
    var capitalize: Bool = false
    let word: String

    init(word: String) {
        self.word = word
    }
  }
}


/*
 
 Store common data
 define the idea of 'ranges' on homogeneous collection and store related to those ranges
 */
