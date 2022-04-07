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
    let resourcesDirectoryPath = context.pluginWorkDirectory
      .appending(subpath: target.name)
    //.appending(subpath: "Resources")
    //    print("resourcesDirectoryPath file: \(resourcesDirectoryPath)")

    let input = context.package.directory.appending("input.csv")

    let outputPath = context.pluginWorkDirectory.appending("GeneratedSources")

    do {
      try  FileManager.default.createDirectory(at: URL(fileURLWithPath: outputPath.string), withIntermediateDirectories: true, attributes: nil)
    } catch let error {
      print(error)
    }

    //let sourceFolder = context.package.directory//.appending(["Sources", "GeneralAccessibility"])

//    print("SourceGenerator running")
//    print("Input file: \(input)")
//    print("pluginDirectory: \(pluginDirectory)")
//    print("packageDirectory: \(context.package.directory)")

    let src = outputPath.appending("foo.swift")
    //print("write: \(file)")

   // let out = resourcesDirectoryPath.appending("foo.swift")

    let data = "import Foundation \n public struct Foo { \n public init() {} \n}".data(using: .utf8)

    writeFile(to: src.string, with: data)


    print("src: \(src)")

    // Passes the outputFilesDirectory to the next build stage
    return [.prebuildCommand(displayName: "Test",
                             executable: .init("/bin/cp"),
                             arguments: [
//                              src.string,
//                              outputPath.string
                             ],
                             outputFilesDirectory: outputPath)]
  }

  func writeFile(to: String, with data: Data?) {

    let written = FileManager.default.createFile(atPath: to, contents: data)
    //print("written: \(written)")
  }

}
