
class ModuleDefinition {
  let constants: [String : Any?]
  let methods: [String : AnyMethod]

  init(exports: [Exportable]) {
    self.methods = exports
      .compactMap { $0 as? AnyMethod }
      .reduce(into: [String : AnyMethod]()) { dict, method in
        dict[method.name] = method
      }

    self.constants = exports
      .compactMap { $0 as? Constants }
      .reduce(into: [String : Any?]()) { dict, item in
        dict.merge(item.closure()) { $1 }
      }
  }
}
