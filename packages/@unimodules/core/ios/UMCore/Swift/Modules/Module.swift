
open class BaseModule {
  required public init() {}
}

extension AnyModule {
  public func name() -> String {
    return String(describing: type(of: self))
  }
}

public typealias Module = AnyModule & BaseModule
