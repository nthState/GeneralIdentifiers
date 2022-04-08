//
//  File.swift
//  
//
//  Created by Chris Davis on 08/04/2022.
//
import PackagePlugin
import Foundation

extension Path {
  var url: URL {
    URL(fileURLWithPath: self.string)
  }
}
