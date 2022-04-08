//
//  File.swift
//  
//
//  Created by Chris Davis on 08/04/2022.
//

import Foundation
import PackagePlugin

class JSONParser: Parseable {

  let path: Path
  let configuration: SourceGeneratorConfiguration

  init(source: Path, configuration: SourceGeneratorConfiguration) {
    self.path = source
    self.configuration = configuration
  }

  func generate() -> Data? {
    nil
  }
}
