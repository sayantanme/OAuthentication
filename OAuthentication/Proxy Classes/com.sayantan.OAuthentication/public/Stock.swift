// # Proxy Compiler 1.7.3.17

import Foundation
import SAPOData

open class Stock: EntityValue {
    public static let lotSize: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "LotSize")

    public static let minStock: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "MinStock")

    public static let productID: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "ProductId")

    public static let quantity: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "Quantity")

    public static let quantityLessMin: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "QuantityLessMin")

    public static let updatedTimestamp: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "UpdatedTimestamp")

    public static let productDetails: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "ProductDetails")

    public init() {
        super.init(type: ESPMContainerMetadata.EntityTypes.stock)
    }

    open class func array(from: EntityValueList) -> Array<Stock> {
        return ArrayConverter.convert(from.toArray(), Array<Stock>())
    }

    open func copy() -> Stock {
        return CastRequired<Stock>.from(self.copyEntity())
    }

    open class func key(productID: String?) -> EntityKey {
        return EntityKey().with(name: "ProductId", value: StringValue.of(optional: productID))
    }

    open var lotSize: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Stock.lotSize))
        }
        set(value) {
            self.setOptionalValue(for: Stock.lotSize, to: DecimalValue.of(optional: value))
        }
    }

    open var minStock: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Stock.minStock))
        }
        set(value) {
            self.setOptionalValue(for: Stock.minStock, to: DecimalValue.of(optional: value))
        }
    }

    open var old: Stock {
        get {
            return CastRequired<Stock>.from(self.oldEntity)
        }
    }

    open var productDetails: Product {
        get {
            return CastRequired<Product>.from(self.optionalValue(for: Stock.productDetails))
        }
        set(value) {
            self.setOptionalValue(for: Stock.productDetails, to: value)
        }
    }

    open var productID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Stock.productID))
        }
        set(value) {
            self.setOptionalValue(for: Stock.productID, to: StringValue.of(optional: value))
        }
    }

    open var quantity: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Stock.quantity))
        }
        set(value) {
            self.setOptionalValue(for: Stock.quantity, to: DecimalValue.of(optional: value))
        }
    }

    open var quantityLessMin: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: Stock.quantityLessMin))
        }
        set(value) {
            self.setOptionalValue(for: Stock.quantityLessMin, to: BooleanValue.of(optional: value))
        }
    }

    open var updatedTimestamp: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Stock.updatedTimestamp))
        }
        set(value) {
            self.setOptionalValue(for: Stock.updatedTimestamp, to: value)
        }
    }
}
