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

  init(name: String, children: [String: Container]) {
    self.name = name
    self.children = children
    self.value = nil
  }
}

extension Container: CustomStringConvertible {
  var description: String {
    "Name: \(name), Value: \(value), Child Count: \(children.count) \(children)"
  }
}
