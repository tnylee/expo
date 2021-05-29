
/**
 A protocol for any type-erased module that provides methods used by the core.
 */
public protocol AnyModule: AnyObject {
  /**
   The default initializer, must be public.
   */
  init()

  /**
   Returns the name of the module that is exported to the JavaScript world.
   */
  func name() -> String

  /**
   A DSL-like function that returns an array of exportable objects — these are only `Method`s and `Constants`.
   */
  @ModuleExportsBuilder
  func exports() -> [Exportable]
}
