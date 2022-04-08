//
//  File.swift
//  
//
//  Created by Chris Davis on 08/04/2022.
//

import Foundation
import PackagePlugin

class CSVParser: Parseable {

  let path: Path
  let configuration: SourceGeneratorConfiguration

  init(source: Path, configuration: SourceGeneratorConfiguration) {
    self.path = source
    self.configuration = configuration
  }

  func generate() -> Data? {
    let lines = fileToArray(at: self.path)
    //print("lines: \(lines)")
    let d = linesToDict(lines: lines)

    var outputStr: String = ""
    writeFileRecurive(container: d, str: &outputStr, space: 0)

    return outputStr.data(using: .utf8)
  }

}

extension CSVParser {

  private func fileToArray(at: Path) -> [String] {

    guard let inputString = try? String(contentsOfFile: at.string) else {
      Diagnostics.error("input not found at: \(at)")
      return []
    }

    let parts = inputString.components(separatedBy: CharacterSet(charactersIn: "\n"))
    let trimmed = parts.compactMap({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) })

    return trimmed.filter({ !$0.isEmpty }).filter({ !$0.starts(with: "#") })
  }

  private func linesToDict(lines: [String]) -> Container {

    var container = Container(name: "GeneralIdentifiers", children: [: ], root: true)

    for line in lines {

      let parts = line.components(separatedBy: CharacterSet(charactersIn: ","))

      let key = parts[0]
      //print("key: \(key)")

      let c: Container
      if container.children[key] != nil {
        //print("parent gound: \(key)")
        c = container.children[key]!
        addPart(parts: Array(parts[1...]), parent: c)
      } else {
        c = Container(name: key, children: [: ])
        addPart(parts: Array(parts[1...]), parent: c)
        container.children[key] = c
      }
    }

    //print("Container: \(container)")

    return container
  }

  private func addPart(parts: [String], parent: Container) {

    //print("Add parts: \(parts)")
    if parts.count == 1 {
      parent.value = parts.last
      print("has last: \(parts)")
    }

    guard parts.count >= 1 else {
      return
    }

    let key = parts[0]
    //print("subbbb: \(key)")

    let c: Container
    if parent.children[key] != nil {
      //print("sub: \(key)")
      c = parent.children[key]!
    } else {
      c = Container(name: key, children: [: ])
      parent.children[key] = c
    }

    //

    addPart(parts: Array(parts[1...]), parent: c)
  }

  private func writeFileRecurive(container: Container, str: inout String, space: Int) {

    let name = container.name.replacingOccurrences(of: " ", with: "")

    let spaces = String(repeating: " ", count: space)

    if let v = container.value {
      str += "\n"
      str += "\(spaces)public let \(name) = \"\(v)\""
      str += "\n"
    }
    else {

      let formattedName: String
      switch configuration.outputCasing {
      case .camelCase:
        formattedName = name.camelCase()
      case .snakeCase:
        formattedName = name.snake_case()
      }

      if container.root {
        str += "\(spaces)public extension GeneralIdentifiers {\n"
      } else {
        str += "\(spaces)public struct \(formattedName) {\n"
      }

      for item in container.children {
        //print("Child: \(item.key) Value: \(item.value.value)")
        writeFileRecurive(container: item.value, str: &str, space: space + 2)
      }
      str += "\(spaces)}\n"

    }

  }

}
