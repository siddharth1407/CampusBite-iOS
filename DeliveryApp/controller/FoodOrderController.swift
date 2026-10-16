//
//  FoodOrderController.swift
//  CampusBite
//
//  Created by Siddharth Patel.
//  Copyright © Siddharth Patel. All rights reserved.
//

import Foundation
import SwiftUI
import Observation

@Observable
public final class FoodOrderController: ObservableObject {
    
    // MARK: - Navigation & Campus Location State
    public var selectedTab: AppTab = .home
    public var selectedCategory: Category
    public var selectedLocation: CampusLocation
    public var searchQuery: String = ""
    public var showToast: Bool = false
    public var toastMessage: String = ""
    
    // MARK: - Student User State (IIT Guwahati)
    public var userProfile: UserProfile = UserProfile()
    public var favoriteFoodIDs: Set<UUID> = []
    
    // MARK: - Cart & Checkout State
    public var cartItems: [CartItem] = []
    public var appliedPromoCode: String? = nil
    public var discountPercentage: Double = 0.0
    public var activeOrder: Order? = nil
    public var orderHistory: [Order] = []
    
    // MARK: - Campus Categories
    public let categories: [Category] = [
        Category(name: "All Canteens", imagePath: "hamburger", systemIcon: "square.grid.2x2.fill"),
        Category(name: "Hostel Night", imagePath: "sandwich", systemIcon: "moon.stars.fill"),
        Category(name: "Burgers & Fast Food", imagePath: "burger2", systemIcon: "flame.fill"),
        Category(name: "Pizza Hub", imagePath: "pizza1", systemIcon: "fork.knife"),
        Category(name: "Bakery & Desserts", imagePath: "cupcake", systemIcon: "birthday.cake.fill")
    ]
    
    // MARK: - Campus Food Catalog (IIT Guwahati Canteens & Outlets)
    public var foodList: [Food] = [
        Food(
            name: "Hostel Night Cheese Maggi",
            category: "Hostel Night",
            subtitle: "Double Butter & Green Chili",
            price: 70.0,
            imagePath: "sandwich",
            description: "The legendary IIT Guwahati midnight craving: piping hot 2-minute noodles tossed in double butter, shredded Amul cheese, fresh green chilies, and secret hostel canteen masala.",
            rating: 4.9,
            reviewCount: 480,
            calories: 380,
            prepTime: "8-12 Min",
            outletName: "Brahmaputra Night Canteen",
            isPopular: true,
            ingredients: ["Maggi Noodles", "Amul Butter", "Processed Cheese", "Hostel Secret Spices", "Green Chilies"]
        ),
        Food(
            name: "Campus Double Burger",
            category: "Burgers & Fast Food",
            subtitle: "Double Patty & Melted Cheddar",
            price: 140.0,
            imagePath: "bur2",
            description: "Two succulent grilled patties layered with double molten cheese, crisp lettuce, red onions, and house-made smoky tandoori mayo on a toasted sesame brioche bun.",
            rating: 4.9,
            reviewCount: 395,
            calories: 620,
            prepTime: "12-15 Min",
            outletName: "Khokha Food Court",
            isPopular: true,
            ingredients: ["Double Patty", "Cheddar Slice", "Brioche Bun", "Tandoori Mayo", "Caramelized Onions"]
        ),
        Food(
            name: "Crispy Paneer Kathi Roll",
            category: "Hostel Night",
            subtitle: "Mint Chutney & Spiced Onions",
            price: 110.0,
            imagePath: "sandwich",
            description: "Flaky golden paratha stuffed with marinated tandoori paneer cubes, crisp capsicum, pickled red onions, and zesty pudina (mint) chutney.",
            rating: 4.8,
            reviewCount: 310,
            calories: 440,
            prepTime: "10-15 Min",
            outletName: "Khokha Market Stall 4",
            isPopular: true,
            ingredients: ["Tandoori Paneer", "Flaky Paratha", "Mint Chutney", "Bell Peppers", "Chaat Masala"]
        ),
        Food(
            name: "Campus Burger Max",
            category: "Burgers & Fast Food",
            subtitle: "Triple Stack Feast",
            price: 190.0,
            imagePath: "bur3",
            description: "The ultimate post-exam celebration burger: three grilled patties, extra cheddar cheese, crispy potato wafers, and rich barbecue glaze.",
            rating: 4.8,
            reviewCount: 290,
            calories: 780,
            prepTime: "15-20 Min",
            outletName: "Food Court Core 1",
            isPopular: false,
            ingredients: ["Triple Patty", "Double Cheese", "Crisp Wafers", "BBQ Glaze", "Sesame Bun"]
        ),
        Food(
            name: "Farmhouse Fresh Margherita",
            category: "Pizza Hub",
            subtitle: "Fresh Basil & Extra Mozzarella",
            price: 199.0,
            imagePath: "pizza1",
            description: "Stone-baked thin crust pizza topped with rich Italian herb tomato sauce, bubbling mozzarella cheese, diced farm tomatoes, and fragrant basil leaves.",
            rating: 4.8,
            reviewCount: 260,
            calories: 590,
            prepTime: "15-20 Min",
            outletName: "SAC Pizza Outlet",
            isPopular: true,
            ingredients: ["San Marzano Sauce", "Mozzarella Cheese", "Fresh Basil", "Herbs", "Olive Oil"]
        ),
        Food(
            name: "Khokha Loaded Pepperoni",
            category: "Pizza Hub",
            subtitle: "Crispy Slices & Herbs",
            price: 249.0,
            imagePath: "Pizza2",
            description: "Signature campus pizza loaded with crispy spiced slices, melted mozzarella, garlic butter brushed crust, and oregano seasoning.",
            rating: 4.9,
            reviewCount: 340,
            calories: 720,
            prepTime: "15-20 Min",
            outletName: "SAC Pizza Outlet",
            isPopular: true,
            ingredients: ["Spiced Pepperoni", "Whole Milk Mozzarella", "Oregano", "Garlic Butter Crust"]
        ),
        Food(
            name: "Classic Prime Beef Burger",
            category: "Burgers & Fast Food",
            subtitle: "Smoky Aioli & Cheddar",
            price: 130.0,
            imagePath: "bur1",
            description: "Hand-crafted juicy patty seared to perfection with melted cheese, fresh lettuce, and tangy burger spread on a soft toasted bun.",
            rating: 4.7,
            reviewCount: 220,
            calories: 510,
            prepTime: "10-15 Min",
            outletName: "Khokha Food Court",
            isPopular: false,
            ingredients: ["Grilled Patty", "Cheddar Cheese", "Leaf Lettuce", "House Aioli", "Bun"]
        ),
        Food(
            name: "Rustic Garden Veggie Pizza",
            category: "Pizza Hub",
            subtitle: "Capsicum, Onion & Sweet Corn",
            price: 219.0,
            imagePath: "pizza3",
            description: "Crunchy hand-tossed crust packed with crunchy green capsicum, red onions, golden sweet corn, and mushrooms over creamy mozzarella.",
            rating: 4.6,
            reviewCount: 175,
            calories: 540,
            prepTime: "15-20 Min",
            outletName: "SAC Pizza Outlet",
            isPopular: false,
            ingredients: ["Green Capsicum", "Sweet Corn", "Red Onions", "Mushrooms", "Mozzarella"]
        ),
        Food(
            name: "Belgian Choco Truffle Cupcake",
            category: "Bakery & Desserts",
            subtitle: "Molten Dark Ganache Center",
            price: 65.0,
            imagePath: "cup1",
            description: "Rich dark chocolate sponge filled with molten Belgian chocolate ganache, crowned with silky frosting. The perfect late-night study reward.",
            rating: 4.9,
            reviewCount: 380,
            calories: 260,
            prepTime: "5 Min",
            outletName: "CCD & Bakery, New SAC",
            isPopular: true,
            ingredients: ["Belgian Cocoa", "Molten Ganache", "Buttercream", "Sugar", "Flour"]
        ),
        Food(
            name: "Vanilla Bean Velvet Pastry",
            category: "Bakery & Desserts",
            subtitle: "Whipped Buttercream & Sprinkles",
            price: 50.0,
            imagePath: "cub2",
            description: "Light and fluffy Madagascar vanilla sponge topped with whipped buttercream and golden sprinkles.",
            rating: 4.7,
            reviewCount: 190,
            calories: 230,
            prepTime: "5 Min",
            outletName: "CCD & Bakery, New SAC",
            isPopular: false,
            ingredients: ["Vanilla Bean", "Whipped Frosting", "Pastry Butter", "Flour"]
        ),
        Food(
            name: "Wild Berry Frost Cupcake",
            category: "Bakery & Desserts",
            subtitle: "Strawberry Glaze Swirl",
            price: 75.0,
            imagePath: "cup3",
            description: "Berry-infused sponge topped with a rich strawberry frosting swirl and crushed raspberry crumble.",
            rating: 4.8,
            reviewCount: 165,
            calories: 240,
            prepTime: "5 Min",
            outletName: "CCD & Bakery, New SAC",
            isPopular: false,
            ingredients: ["Strawberries", "Berry Frosting", "Sponge Cake", "Berry Glaze"]
        )
    ]
    
    // MARK: - Initializer
    public init() {
        self.selectedCategory = Category(name: "All Canteens", imagePath: "hamburger", systemIcon: "square.grid.2x2.fill")
        self.selectedLocation = CampusLocation.iitgLocations[0] // Brahmaputra Hostel by default
        
        // Pre-populate realistic favorites
        if let maggi = foodList.first(where: { $0.name.contains("Maggi") }),
           let burger = foodList.first(where: { $0.name.contains("Campus Double") }) {
            self.favoriteFoodIDs = [maggi.id, burger.id]
        }
    }
    
    // MARK: - Dynamic Filtered Lists
    public var filteredFoodList: [Food] {
        var list = foodList
        
        // 1. Filter by category
        if selectedCategory.name != "All Canteens" {
            list = list.filter { $0.category == selectedCategory.name }
        }
        
        // 2. Filter by search query
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            list = list.filter { food in
                food.name.localizedCaseInsensitiveContains(query) ||
                food.subtitle.localizedCaseInsensitiveContains(query) ||
                food.category.localizedCaseInsensitiveContains(query) ||
                food.outletName.localizedCaseInsensitiveContains(query) ||
                food.ingredients.contains(where: { $0.localizedCaseInsensitiveContains(query) })
            }
        }
        
        return list
    }
    
    public var popularFoods: [Food] {
        if selectedCategory.name == "All Canteens" {
            return foodList.filter { $0.isPopular }
        } else {
            let categoryPopular = foodList.filter { $0.category == selectedCategory.name && $0.isPopular }
            return categoryPopular.isEmpty ? foodList.filter { $0.category == selectedCategory.name } : categoryPopular
        }
    }
    
    public var favoriteFoods: [Food] {
        foodList.filter { favoriteFoodIDs.contains($0.id) }
    }
    
    // MARK: - Cart Calculations (Indian Rupee ₹)
    public var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    public var cartSubtotal: Double {
        cartItems.reduce(0.0) { $0 + $1.subtotal }
    }
    
    public var deliveryFee: Double {
        if cartSubtotal == 0 { return 0.0 }
        return cartSubtotal >= 200.0 ? 0.0 : 20.0 // Free campus delivery above ₹200, else ₹20
    }
    
    public var isFreeDeliveryEligible: Bool {
        cartSubtotal >= 200.0
    }
    
    public var freeDeliveryRemaining: Double {
        max(0.0, 200.0 - cartSubtotal)
    }
    
    public var taxAmount: Double {
        cartSubtotal * 0.05 // 5% GST for restaurant/canteen food
    }
    
    public var discountAmount: Double {
        cartSubtotal * discountPercentage
    }
    
    public var cartTotal: Double {
        max(0.0, cartSubtotal + deliveryFee + taxAmount - discountAmount)
    }
    
    // MARK: - Category & Location Selection
    public func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    public func selectLocation(_ location: CampusLocation) {
        selectedLocation = location
        userProfile.hostelRoom = "\(location.name), IIT Guwahati"
        triggerToast("📍 Delivery set to \(location.name)")
    }
    
    // MARK: - Favorite Management
    public func toggleFavorite(_ food: Food) {
        if favoriteFoodIDs.contains(food.id) {
            favoriteFoodIDs.remove(food.id)
            triggerToast("Removed \(food.name) from saved")
        } else {
            favoriteFoodIDs.insert(food.id)
            triggerToast("Saved \(food.name) to favorites ❤️")
        }
    }
    
    public func isFavorite(_ food: Food) -> Bool {
        favoriteFoodIDs.contains(food.id)
    }
    
    // MARK: - Cart Management
    public func addToCart(food: Food, quantity: Int = 1, specialInstructions: String = "") {
        guard quantity > 0 else { return }
        
        if let index = cartItems.firstIndex(where: { $0.food.id == food.id }) {
            cartItems[index].quantity += quantity
            if !specialInstructions.isEmpty {
                cartItems[index].specialInstructions = specialInstructions
            }
        } else {
            let newItem = CartItem(food: food, quantity: quantity, specialInstructions: specialInstructions)
            cartItems.append(newItem)
        }
        
        triggerToast("Added \(quantity)x \(food.name) to cart 🛒")
    }
    
    public func incrementCartItem(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
        }
    }
    
    public func decrementCartItem(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    public func removeFromCart(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
        triggerToast("Removed \(item.food.name) from cart")
    }
    
    public func clearCart() {
        cartItems.removeAll()
        appliedPromoCode = nil
        discountPercentage = 0.0
    }
    
    // MARK: - Campus Promo Codes (IIT Guwahati)
    @discardableResult
    public func applyPromoCode(_ code: String) -> (success: Bool, message: String) {
        let clean = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        switch clean {
        case "IITG20":
            discountPercentage = 0.20
            appliedPromoCode = clean
            triggerToast("🎓 20% IIT Guwahati Student Discount Applied!")
            return (true, "20% IITG student discount applied!")
        case "MIDSEM":
            discountPercentage = 0.25
            appliedPromoCode = clean
            triggerToast("📚 25% Midsem Late-Night Fuel Discount Applied!")
            return (true, "25% Midsem study discount applied!")
        case "SIDDHARTH":
            discountPercentage = 0.30
            appliedPromoCode = clean
            triggerToast("🎉 30% Siddharth Creator VIP Discount Applied!")
            return (true, "30% VIP discount applied!")
        case "FREEHOSTEL":
            discountPercentage = 0.10
            appliedPromoCode = clean
            triggerToast("🚲 Free hostel delivery discount applied!")
            return (true, "Hostel delivery discount applied!")
        default:
            return (false, "Invalid coupon. Try 'IITG20', 'MIDSEM', or 'SIDDHARTH'")
        }
    }
    
    // MARK: - Checkout & Order Lifecycle
    @discardableResult
    public func placeOrder() -> Order? {
        guard !cartItems.isEmpty else { return nil }
        
        let orderNumber = "#IITG-\(Int.random(in: 1000...9999))"
        let newOrder = Order(
            orderNumber: orderNumber,
            items: cartItems,
            subtotal: cartSubtotal,
            deliveryFee: deliveryFee,
            tax: taxAmount,
            discount: discountAmount,
            total: cartTotal,
            placedAt: Date(),
            status: .placed,
            deliveryLocation: "\(selectedLocation.name), IIT Guwahati",
            estimatedMinutes: 20
        )
        
        activeOrder = newOrder
        orderHistory.insert(newOrder, at: 0)
        userProfile.loyaltyPoints += Int(cartTotal * 2)
        
        clearCart()
        triggerToast("🎉 Order \(orderNumber) placed! Heading to \(selectedLocation.name)")
        return newOrder
    }
    
    public func advanceOrderStatus() {
        guard var order = activeOrder else { return }
        
        switch order.status {
        case .placed:
            order.status = .preparing
        case .preparing:
            order.status = .onTheWay
        case .onTheWay:
            order.status = .delivered
        case .delivered:
            break
        }
        
        activeOrder = order
        if let index = orderHistory.firstIndex(where: { $0.id == order.id }) {
            orderHistory[index] = order
        }
    }
    
    // MARK: - Notification / Toast Helper
    public func triggerToast(_ message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if self.toastMessage == message {
                self.showToast = false
            }
        }
    }
}
