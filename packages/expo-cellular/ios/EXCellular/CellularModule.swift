
import CoreTelephony
import UMCore

// Keep this enum in sync with JavaScript
// Based on the EffectiveConnectionType enum described in the W3C Network Information API spec
// (https://wicg.github.io/netinfo/).
enum CellularGeneration: Int {
  case unknown = 0
  case cellular2G = 1
  case cellular3G = 2
  case cellular4G = 3
}

public class CellularModule: Module {
  public func name() -> String { "ExpoCellular" }

  public func exports() -> [Exportable] {
    Constants {
      let carrier = self.currentCarrier()

      return [
        "allowsVoip": carrier?.allowsVOIP,
        "carrier": carrier?.carrierName,
        "isoCountryCode": carrier?.isoCountryCode,
        "mobileCountryCode": carrier?.mobileCountryCode,
        "mobileNetworkCode": carrier?.mobileNetworkCode
      ]
    }
    Method("getCellularGenerationAsync") {
      return self.currentCellularGeneration()
    }
    Method("test with one arg") { (a: String) in
      print("1:", a)
    }
    Method("test with two args") { (a: String, b: Int) in
      print("2:", a, b)
    }
    Method("test with promise") { (promise: Promise) in
      promise.resolve("for asynchronous operations")
    }
  }

  //MARK: internals

  func currentCellularGeneration() -> CellularGeneration {
    let radioAccessTechnology = currentRadioAccessTechnology()

    switch radioAccessTechnology {
    case CTRadioAccessTechnologyGPRS,
         CTRadioAccessTechnologyEdge,
         CTRadioAccessTechnologyCDMA1x:
      return .cellular2G
    case CTRadioAccessTechnologyWCDMA,
         CTRadioAccessTechnologyHSDPA,
         CTRadioAccessTechnologyHSUPA,
         CTRadioAccessTechnologyCDMAEVDORev0,
         CTRadioAccessTechnologyCDMAEVDORevA,
         CTRadioAccessTechnologyCDMAEVDORevB,
         CTRadioAccessTechnologyeHRPD:
      return .cellular3G
    case CTRadioAccessTechnologyLTE:
      return .cellular4G
    default:
      return .unknown
    }
  }

  func currentRadioAccessTechnology() -> String? {
    let netinfo = CTTelephonyNetworkInfo()

    if #available(iOS 12.0, *) {
      return netinfo.serviceCurrentRadioAccessTechnology?.values.first
    } else {
      return netinfo.currentRadioAccessTechnology
    }
  }

  func currentCarrier() -> CTCarrier? {
    let netinfo = CTTelephonyNetworkInfo()

    if #available(iOS 12.0, *), let providers = netinfo.serviceSubscriberCellularProviders {
      for carrier in providers.values {
        if carrier.carrierName != nil {
          return carrier
        }
      }
      return providers.values.first
    }
    return netinfo.subscriberCellularProvider
  }
}
