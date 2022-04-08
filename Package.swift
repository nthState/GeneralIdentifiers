// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GeneralIdentifiers",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GeneralIdentifiers",
            targets: ["GeneralIdentifiers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .plugin(
          name: "SourceGenerator",
          capability: .buildTool(),
          dependencies: []
        ),
        .target(
            name: "GeneralIdentifiers",
            dependencies: [],
            plugins: [
              .plugin(name: "SourceGenerator")
            ]),
        .testTarget(
            name: "GeneralIdentifiersTests",
            dependencies: ["GeneralIdentifiers"]),
    ]
)
