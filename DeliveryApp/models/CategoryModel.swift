//
//  CategoryModel.swift
//  CampusBite
//
//  Created by Siddharth Patel.
//  Copyright © Siddharth Patel. All rights reserved.
//

import SwiftUI
import Foundation

// MARK: - Color Theme
public extension Color {
    static let brandPink = Color("pink")
    static let brandLightYellow = Color("lightYellow")
    static let cardBackground = Color.gray.opacity(0.08)
    static let brandDark = Color(red: 0.12, green: 0.12, blue: 0.14)
}

// MARK: - Campus Location Model (IIT Guwahati)
public struct CampusLocation: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let zone: String
    
    public init(name: String, zone: String) {
        self.id = name
        self.name = name
        self.zone = zone
    }
    
    public static let iitgLocations: [CampusLocation] = [
        CampusLocation(name: "Brahmaputra Hostel", zone: "North Hostel Zone"),
        CampusLocation(name: "Siang Hostel", zone: "Central Hostel Zone"),
        CampusLocation(name: "Kameng Hostel", zone: "Central Hostel Zone"),
        CampusLocation(name: "Lohit Hostel", zone: "South Hostel Zone"),
        CampusLocation(name: "Umiam Hostel", zone: "South Hostel Zone"),
        CampusLocation(name: "Core 1 - Academic Complex", zone: "Academic Area"),
        CampusLocation(name: "New SAC (Student Activity)", zone: "Campus Center"),
        CampusLocation(name: "Khokha Market Canteens", zone: "Commercial Zone")
    ]
}

// MARK: - Category Model
public struct Category: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let imagePath: String
    public let systemIcon: String
    
    public init(name: String, imagePath: String, systemIcon: String = "fork.knife") {
        self.id = name
        self.name = name
        self.imagePath = imagePath
        self.systemIcon = systemIcon
    }
}

// MARK: - Food Item Model
public struct Food: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let category: String
    public let subtitle: String
    public let price: Double
    public let imagePath: String
    public let description: String
    public let rating: Double
    public let reviewCount: Int
    public let calories: Int
    public let prepTime: String
    public let outletName: String
    public let isPopular: Bool
    public let ingredients: [String]
    
    public var formattedPrice: String {
        String(format: "₹%.0f", price)
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        category: String,
        subtitle: String,
        price: Double,
        imagePath: String,
        description: String,
        rating: Double = 4.8,
        reviewCount: Int = 120,
        calories: Int = 450,
        prepTime: String = "15-20 Min",
        outletName: String = "Khokha Food Court",
        isPopular: Bool = false,
        ingredients: [String] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.subtitle = subtitle
        self.price = price
        self.imagePath = imagePath
        self.description = description
        self.rating = rating
        self.reviewCount = reviewCount
        self.calories = calories
        self.prepTime = prepTime
        self.outletName = outletName
        self.isPopular = isPopular
        self.ingredients = ingredients
    }
}

// MARK: - Cart Item Model
public struct CartItem: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let food: Food
    public var quantity: Int
    public var specialInstructions: String
    
    public var subtotal: Double {
        food.price * Double(quantity)
    }
    
    public var formattedSubtotal: String {
        String(format: "₹%.0f", subtotal)
    }
    
    public init(
        id: UUID = UUID(),
        food: Food,
        quantity: Int = 1,
        specialInstructions: String = ""
    ) {
        self.id = id
        self.food = food
        self.quantity = quantity
        self.specialInstructions = specialInstructions
    }
}

// MARK: - Order Status & Model
public enum OrderStatus: String, CaseIterable, Hashable, Sendable {
    case placed = "Order Placed"
    case preparing = "Canteen Preparing"
    case onTheWay = "Campus Rider On The Way"
    case delivered = "Delivered to Hostel"
    
    public var iconName: String {
        switch self {
        case .placed: return "checkmark.circle.fill"
        case .preparing: return "flame.fill"
        case .onTheWay: return "bicycle"
        case .delivered: return "house.fill"
        }
    }
    
    public var stepIndex: Int {
        switch self {
        case .placed: return 0
        case .preparing: return 1
        case .onTheWay: return 2
        case .delivered: return 3
        }
    }
}

public struct Order: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let orderNumber: String
    public let items: [CartItem]
    public let subtotal: Double
    public let deliveryFee: Double
    public let tax: Double
    public let discount: Double
    public let total: Double
    public let placedAt: Date
    public var status: OrderStatus
    public let deliveryLocation: String
    public let estimatedMinutes: Int
    
    public var formattedTotal: String {
        String(format: "₹%.0f", total)
    }
    
    public init(
        id: UUID = UUID(),
        orderNumber: String,
        items: [CartItem],
        subtotal: Double,
        deliveryFee: Double,
        tax: Double,
        discount: Double,
        total: Double,
        placedAt: Date = Date(),
        status: OrderStatus = .placed,
        deliveryLocation: String,
        estimatedMinutes: Int = 20
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.items = items
        self.subtotal = subtotal
        self.deliveryFee = deliveryFee
        self.tax = tax
        self.discount = discount
        self.total = total
        self.placedAt = placedAt
        self.status = status
        self.deliveryLocation = deliveryLocation
        self.estimatedMinutes = estimatedMinutes
    }
}

// MARK: - Student Profile Model (IIT Guwahati)
public struct UserProfile: Hashable, Sendable {
    public var name: String
    public var role: String
    public var college: String
    public var email: String
    public var phone: String
    public var hostelRoom: String
    public var memberTier: String
    public var loyaltyPoints: Int
    
    public init(
        name: String = "Siddharth Patel",
        role: String = "B.Tech Student & iOS Developer",
        college: String = "IIT Guwahati",
        email: String = "siddharthkota01@gmail.com",
        phone: String = "+91 98765 43210",
        hostelRoom: String = "Brahmaputra Hostel, Room B-214",
        memberTier: String = "IITG Gold Campus Member",
        loyaltyPoints: Int = 1850
    ) {
        self.name = name
        self.role = role
        self.college = college
        self.email = email
        self.phone = phone
        self.hostelRoom = hostelRoom
        self.memberTier = memberTier
        self.loyaltyPoints = loyaltyPoints
    }
}

// MARK: - Navigation Tab Enum
public enum AppTab: String, CaseIterable, Hashable, Sendable {
    case home = "home2"
    case favorites = "heart"
    case orders = "bell"
    case cart = "cart2"
    case profile = "profile"
    
    public var title: String {
        switch self {
        case .home: return "Campus Menu"
        case .favorites: return "Saved"
        case .orders: return "My Orders"
        case .cart: return "Cart"
        case .profile: return "IITG Profile"
        }
    }
    
    public var systemFallbackIcon: String {
        switch self {
        case .home: return "house.fill"
        case .favorites: return "heart.fill"
        case .orders: return "clock.fill"
        case .cart: return "cart.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}
