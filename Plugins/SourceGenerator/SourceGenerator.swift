import PackagePlugin
import Foundation

/**
 https://github.com/apple/swift-evolution/blob/main/proposals/0303-swiftpm-extensible-build-tools.md
 */
@main
struct SourceGenerator: BuildToolPlugin {
  /// This plugin's implementation returns a single `prebuild` command to run `swiftgen`.
  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
    //    guard let target = target as? SourceModuleTarget else {
    //      print("Not target")
    //      return []
    //    }
    //
    //    let resourcesDirectoryPath = context.pluginWorkDirectory
    //      .appending(subpath: target.name)
    //.appending(subpath: "Resources")
    //    print("resourcesDirectoryPath file: \(resourcesDirectoryPath)")

    let input = context.package.directory.appending("input.csv")
    let lines = fileToArray(at: input.string)
    print("lines: \(lines)")
    let d = linesToDict(lines: lines)

    var outputStr: String = ""
    writeFileRecurive(container: d, str: &outputStr, space: 0)



    let outputPath = context.pluginWorkDirectory.appending("GeneratedSources")

    do {
      try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputPath.string), withIntermediateDirectories: true, attributes: nil)
    } catch let error {
      print(error)
    }

    //let sourceFolder = context.package.directory//.appending(["Sources", "GeneralAccessibility"])

    //    print("SourceGenerator running")
    print("Input file: \(input)")
    //    print("pluginDirectory: \(pluginDirectory)")
    //    print("packageDirectory: \(context.package.directory)")

    let src = outputPath.appending("General.swift")
    //print("write: \(file)")

    // let out = resourcesDirectoryPath.appending("foo.swift")

    let data = outputStr.data(using: .utf8)

    writeFile(to: src.string, with: data)


    print("src: \(src)")

    // Passes the outputFilesDirectory to the next build stage
    return [.prebuildCommand(displayName: "Test",
                             executable: .init("/bin/cp"),
                             arguments: [
                              //                                                            src.string,
                              //                                                            outputPath.string
                             ],
                             outputFilesDirectory: outputPath)]
  }

  func writeFile(to: String, with data: Data?) {

    let written = FileManager.default.createFile(atPath: to, contents: data)
    //print("written: \(written)")
  }

  func fileToArray(at: String) -> [String] {

    guard let inputString = try? String(contentsOfFile: at) else {
      return []
    }

    let parts = inputString.components(separatedBy: CharacterSet(charactersIn: "\n"))
    let trimmed = parts.compactMap({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) })

      return trimmed.filter({ !$0.isEmpty }).filter({ !$0.starts(with: "#") })
  }

  func linesToDict(lines: [String]) -> Container {

    var container = Container(name: "General", children: [: ])

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



      //print("c: \(c)")


    }

    //print("Container: \(container)")

    return container
  }

  func addPart(parts: [String], parent: Container) {

    //print("Add parts: \(parts)")
    if parts.count == 1 {
      parent.value = parts.last
      print("jas last: \(parts)")
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

  func writeFileRecurive(container: Container, str: inout String, space: Int) {

    let name = container.name.replacingOccurrences(of: " ", with: "")

    let spaces = String(repeating: " ", count: space)


    if let v = container.value {
      str += "\n"
      str += "\(spaces)public let \(name) = \"\(v)\""
      str += "\n"
    }
      else {

      str += "\(spaces)public struct \(name.camelCase()) {\n"
      for item in container.children {
        print("Child: \(item.key) Value: \(item.value.value)")
        writeFileRecurive(container: item.value, str: &str, space: space + 2)
      }
      str += "\(spaces)}\n"

    }

  }

}

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
