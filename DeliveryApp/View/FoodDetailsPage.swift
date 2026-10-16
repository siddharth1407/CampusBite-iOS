//
//  FoodDetailsPage.swift
//  DeliveryApp
//
//  Created by Siddharth Patel.
//  Copyright © Siddharth Patel. All rights reserved.
//

import SwiftUI

public struct FoodDetailsPage: View {
    public let food: Food
    @ObservedObject var controller: FoodOrderController
    @Environment(\.dismiss) private var dismiss
    
    @State private var quantity: Int = 1
    @State private var specialInstructions: String = ""
    @State private var isAddedSuccess: Bool = false
    
    public init(food: Food, controller: FoodOrderController) {
        self.food = food
        self.controller = controller
    }
    
    private var totalPrice: Double {
        food.price * Double(quantity)
    }
    
    public var body: some View {
        ZStack {
            // Background Warm Ambient Layer
            Color.brandLightYellow
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Custom Header
                headerBar
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Hero Food Image Presentation
                        heroImageSection
                        
                        // Main Detail White Card
                        detailCard
                    }
                    .padding(.bottom, 120) // Space for sticky bottom checkout bar
                }
            }
            
            // Sticky Floating Add to Cart Bar
            VStack {
                Spacer()
                bottomFloatingBar
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        #if os(iOS)
        .toolbar(.hidden, for: .navigationBar)
        #endif
    }
    
    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.brandPink)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
            .accessibilityLabel("Go back")
            
            Spacer()
            
            Text("Food Details")
                .font(.headline)
                .foregroundStyle(Color.brandDark)
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    controller.toggleFavorite(food)
                }
            }) {
                Image(systemName: controller.isFavorite(food) ? "heart.fill" : "heart")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(controller.isFavorite(food) ? Color.brandPink : Color.gray)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
            .accessibilityLabel("Favorite food")
        }
    }
    
    // MARK: - Hero Image Section
    private var heroImageSection: some View {
        VStack(spacing: 12) {
            Image(food.imagePath)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
                .padding(.top, 10)
            
            // Stepper Pill
            HStack(spacing: 24) {
                Button(action: {
                    if quantity > 1 {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            quantity -= 1
                        }
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 32, height: 32)
                }
                .accessibilityLabel("Decrease quantity")
                
                Text("\(quantity)")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Color.white)
                    .frame(minWidth: 28)
                
                Button(action: {
                    if quantity < 20 {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            quantity += 1
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 32, height: 32)
                }
                .accessibilityLabel("Increase quantity")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.brandPink)
            .clipShape(Capsule())
            .shadow(color: Color.brandPink.opacity(0.35), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - Detail White Card
    private var detailCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title & Price Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.brandDark)
                    
                    Text("\(food.outletName) • \(food.subtitle)")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Text(food.formattedPrice)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.brandPink)
            }
            
            // Quick Info Badges
            HStack(spacing: 12) {
                infoBadge(icon: "star.fill", color: .yellow, text: String(format: "%.1f (%d)", food.rating, food.reviewCount))
                Spacer()
                infoBadge(icon: "flame.fill", color: .orange, text: "\(food.calories) Kcal")
                Spacer()
                infoBadge(icon: "timer", color: .red, text: food.prepTime)
            }
            .padding(14)
            .background(Color.brandLightYellow.opacity(0.45))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            // Ingredients Tags
            if !food.ingredients.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.headline)
                        .foregroundStyle(Color.brandDark)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(food.ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.brandDark)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.cardBackground)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            
            // Food Description
            VStack(alignment: .leading, spacing: 8) {
                Text("About This Dish")
                    .font(.headline)
                    .foregroundStyle(Color.brandDark)
                
                Text(food.description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .lineSpacing(4)
            }
            
            // Special Instructions Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Special Instructions")
                    .font(.headline)
                    .foregroundStyle(Color.brandDark)
                
                TextField("E.g. Extra spicy, deliver to room door, extra ketchup...", text: $specialInstructions)
                    .font(.subheadline)
                    .padding(14)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: -4)
    }
    
    // MARK: - Info Badge Helper
    private func infoBadge(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
            
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.brandDark)
        }
    }
    
    // MARK: - Bottom Floating Action Bar
    private var bottomFloatingBar: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray)
                
                Text(String(format: "₹%.0f", totalPrice))
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.brandDark)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    controller.addToCart(
                        food: food,
                        quantity: quantity,
                        specialInstructions: specialInstructions
                    )
                    isAddedSuccess = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    dismiss()
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: isAddedSuccess ? "checkmark.circle.fill" : "bag.fill.badge.plus")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(isAddedSuccess ? "Added!" : "Add to Cart")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
                .background(isAddedSuccess ? Color.green : Color.brandPink)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: (isAddedSuccess ? Color.green : Color.brandPink).opacity(0.4), radius: 10, x: 0, y: 5)
            }
            .accessibilityLabel("Add \(quantity) to cart")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: -4)
        )
    }
}
