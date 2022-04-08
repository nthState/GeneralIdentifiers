//
//  File.swift
//  
//
//  Created by Chris Davis on 08/04/2022.
//

import Foundation

struct SourceGeneratorConfiguration: Decodable {
  let outputCasing: Casing
  let sourceName: String // should this be here?
}

extension SourceGeneratorConfiguration: CustomStringConvertible {
  var description: String {
    "Source: \(sourceName), Casing: \(outputCasing)"
  }
}
