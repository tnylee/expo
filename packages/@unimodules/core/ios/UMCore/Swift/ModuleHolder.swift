
/**
 Holds a reference to the module instance, caches its properties such as name and an array of methods.
 */
public class ModuleHolder {
  private(set) var name: String

  private(set) var module: AnyModule

  private(set) lazy var definition: ModuleDefinition = ModuleDefinition(exports: module.exports())

  init(module: AnyModule) {
    self.name = module.name()
    self.module = module

    // FIXME: Temporarily preload
    self.definition.constants
  }

  func call(method methodName: String, args: [Any?], promise: Promise) {
    if let method = definition.methods[methodName] {
      let queue = method.queue ?? DispatchQueue.global(qos: .default)
      queue.async {
        method.call(args: args, promise: promise)
      }
    } else {
      promise.reject("Method \"\(methodName)\" is not exported by \(name)")
    }
  }
}
