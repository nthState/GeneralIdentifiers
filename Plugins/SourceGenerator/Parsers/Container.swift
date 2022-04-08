//
//  File.swift
//  
//
//  Created by Chris Davis on 08/04/2022.
//

import Foundation

class Container {
  let name: String
  var value: String?
  var children: [String: Container]
  let root: Bool

  init(name: String, children: [String: Container], root: Bool = false) {
    self.name = name
    self.children = children
    self.value = nil
    self.root = root
  }
}

extension Container: CustomStringConvertible {
  var description: String {
    "Name: \(name), Value: \(value), Child Count: \(children.count) \(children)"
  }
}
