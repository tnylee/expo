
public struct Constants: Exportable {
  public typealias ClosureType = () -> [String : Any?]

  let closure: ClosureType

  public init(_ closure: @escaping ClosureType) {
    self.closure = closure
  }
}
