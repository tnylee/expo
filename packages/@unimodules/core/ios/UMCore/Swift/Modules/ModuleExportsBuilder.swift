
/**
 A function builder that provides DSL-like syntax. In thanks to this, the function doesn't need to explicitly return an array,
 but can just return multiple methods one after another. This works similarly to SwiftUI's `body` block.
 */
@resultBuilder
public struct ModuleExportsBuilder {
  public static func buildBlock(_ components: Exportable...) -> [Exportable] {
    return components
  }
}
