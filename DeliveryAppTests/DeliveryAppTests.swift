//
//  DeliveryAppTests.swift
//  CampusBiteTests
//
//  Created by Siddharth Patel.
//  Copyright © Siddharth Patel. All rights reserved.
//

import XCTest
@testable import DeliveryApp

final class DeliveryAppTests: XCTestCase {

    var controller: FoodOrderController!

    override func setUp() {
        super.setUp()
        controller = FoodOrderController()
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    // MARK: - Campus Catalog & IIT Guwahati Data Integrity
    func testCampusCatalogHasAuthenticIITGDishes() {
        XCTAssertFalse(controller.foodList.isEmpty, "CampusBite catalog should not be empty")
        
        // Verify signature hostel dishes exist
        let hasHostelMaggi = controller.foodList.contains { $0.name.contains("Maggi") }
        let hasPaneerRoll = controller.foodList.contains { $0.name.contains("Kathi Roll") }
        let hasBurger = controller.foodList.contains { $0.name.contains("Burger") }
        
        XCTAssertTrue(hasHostelMaggi, "Campus catalog must include legendary hostel night Maggi")
        XCTAssertTrue(hasPaneerRoll, "Campus catalog must include Khokha kathi rolls")
        XCTAssertTrue(hasBurger, "Campus catalog must include Food court burgers")
    }

    func testCampusCategoryFiltering() {
        let hostelCategory = Category(name: "Hostel Night", imagePath: "sandwich")
        controller.selectCategory(hostelCategory)
        
        let filtered = controller.filteredFoodList
        XCTAssertFalse(filtered.isEmpty)
        for food in filtered {
            XCTAssertEqual(food.category, "Hostel Night", "Every item must belong to Hostel Night category")
        }
        
        // Test All Canteens returns entire catalog
        let allCategory = Category(name: "All Canteens", imagePath: "hamburger")
        controller.selectCategory(allCategory)
        XCTAssertEqual(controller.filteredFoodList.count, controller.foodList.count)
    }

    func testCampusSearchQueryFiltering() {
        controller.searchQuery = "Maggi"
        let filtered = controller.filteredFoodList
        XCTAssertFalse(filtered.isEmpty, "Searching for 'Maggi' must return cheese Maggi")
        XCTAssertTrue(filtered.first?.name.contains("Maggi") == true)
        
        // Search by outlet name
        controller.searchQuery = "Khokha"
        let khokhaDishes = controller.filteredFoodList
        XCTAssertFalse(khokhaDishes.isEmpty, "Searching for 'Khokha' must return Khokha market dishes")
    }

    // MARK: - IIT Guwahati Hostel Selection
    func testHostelLocationSelection() {
        XCTAssertEqual(controller.selectedLocation.name, "Brahmaputra Hostel")
        
        if let siang = CampusLocation.iitgLocations.first(where: { $0.name == "Siang Hostel" }) {
            controller.selectLocation(siang)
            XCTAssertEqual(controller.selectedLocation.name, "Siang Hostel")
            XCTAssertTrue(controller.userProfile.hostelRoom.contains("Siang Hostel"))
        }
    }

    // MARK: - Cart & Free Hostel Delivery Math
    func testAddToCartIncrementsQuantity() {
        guard let maggi = controller.foodList.first(where: { $0.name.contains("Maggi") }) else {
            XCTFail("Maggi not found")
            return
        }
        
        controller.addToCart(food: maggi, quantity: 2, specialInstructions: "Extra green chilies")
        XCTAssertEqual(controller.cartItems.count, 1)
        XCTAssertEqual(controller.cartItems.first?.quantity, 2)
        XCTAssertEqual(controller.cartItems.first?.specialInstructions, "Extra green chilies")
        
        // Add 1 more Maggi
        controller.addToCart(food: maggi, quantity: 1)
        XCTAssertEqual(controller.cartItemCount, 3)
    }

    func testFreeCampusDeliveryThreshold() {
        guard let burger = controller.foodList.first(where: { $0.name.contains("Campus Double Burger") }) else {
            XCTFail("Burger not found")
            return
        }
        
        // 1 Burger (₹140): under ₹200 threshold -> Delivery fee is ₹20
        controller.addToCart(food: burger, quantity: 1)
        XCTAssertFalse(controller.isFreeDeliveryEligible)
        XCTAssertEqual(controller.deliveryFee, 20.0, accuracy: 0.01)
        
        // 2 Burgers (₹280): over ₹200 threshold -> FREE Delivery!
        controller.addToCart(food: burger, quantity: 1)
        XCTAssertTrue(controller.isFreeDeliveryEligible)
        XCTAssertEqual(controller.deliveryFee, 0.0, accuracy: 0.01)
    }

    func testIITGPromoCodeDiscounts() {
        guard let food = controller.foodList.first else {
            XCTFail("Empty catalog")
            return
        }
        
        controller.addToCart(food: food, quantity: 2)
        let subtotal = controller.cartSubtotal
        
        // Test IITG20 (20% student discount)
        let iitgResult = controller.applyPromoCode("IITG20")
        XCTAssertTrue(iitgResult.success)
        XCTAssertEqual(controller.discountPercentage, 0.20, accuracy: 0.001)
        XCTAssertEqual(controller.discountAmount, subtotal * 0.20, accuracy: 0.01)
        
        // Test MIDSEM (25% exam fuel discount)
        let midsemResult = controller.applyPromoCode("MIDSEM")
        XCTAssertTrue(midsemResult.success)
        XCTAssertEqual(controller.discountPercentage, 0.25, accuracy: 0.001)
        
        // Test SIDDHARTH (30% VIP discount)
        let creatorResult = controller.applyPromoCode("SIDDHARTH")
        XCTAssertTrue(creatorResult.success)
        XCTAssertEqual(controller.discountPercentage, 0.30, accuracy: 0.001)
    }

    // MARK: - Checkout & Campus Courier Dispatch
    func testPlaceOrderClearsCartAndSetsHostelLocation() {
        guard let food = controller.foodList.first else {
            XCTFail("Empty catalog")
            return
        }
        
        controller.addToCart(food: food, quantity: 2)
        let order = controller.placeOrder()
        
        XCTAssertNotNil(order)
        XCTAssertTrue(controller.cartItems.isEmpty, "Cart must clear after placing order")
        XCTAssertEqual(controller.activeOrder?.id, order?.id)
        XCTAssertTrue(order?.deliveryLocation.contains("Brahmaputra Hostel") == true)
        XCTAssertEqual(order?.status, .placed)
    }

    func testCampusOrderStatusProgression() {
        guard let food = controller.foodList.first else {
            XCTFail("Empty catalog")
            return
        }
        
        controller.addToCart(food: food, quantity: 1)
        _ = controller.placeOrder()
        
        XCTAssertEqual(controller.activeOrder?.status, .placed)
        
        controller.advanceOrderStatus()
        XCTAssertEqual(controller.activeOrder?.status, .preparing)
        
        controller.advanceOrderStatus()
        XCTAssertEqual(controller.activeOrder?.status, .onTheWay)
        
        controller.advanceOrderStatus()
        XCTAssertEqual(controller.activeOrder?.status, .delivered)
    }
}
