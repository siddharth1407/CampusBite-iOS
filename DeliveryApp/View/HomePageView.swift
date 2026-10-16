//
//  HomePageView.swift
//  CampusBite
//
//  Created by Siddharth Patel.
//  Copyright © Siddharth Patel. All rights reserved.
//

import SwiftUI

public struct HomePageView: View {
    @StateObject private var controller = FoodOrderController()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Tab Content Switcher
                Group {
                    switch controller.selectedTab {
                    case .home:
                        HomeFeedView(controller: controller)
                    case .favorites:
                        FavoritesFeedView(controller: controller)
                    case .orders:
                        OrdersFeedView(controller: controller)
                    case .cart:
                        CartFeedView(controller: controller)
                    case .profile:
                        ProfileFeedView(controller: controller)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Floating Bottom Tab Bar
                ModernBottomTabBar(controller: controller)
                
                // Floating In-App Toast Notification
                if controller.showToast {
                    VStack {
                        toastBanner
                            .transition(.move(edge: .top).combined(with: .opacity))
                        Spacer()
                    }
                    .padding(.top, 10)
                    .zIndex(100)
                }
            }
            #if os(iOS)
            .toolbar(.hidden, for: .navigationBar)
            #endif
        }
    }
    
    // MARK: - Toast Banner
    private var toastBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "bell.badge.fill")
                .foregroundStyle(Color.brandPink)
            
            Text(controller.toastMessage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.brandDark)
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            Color.white
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - 1. Home Feed View
struct HomeFeedView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(spacing: 0) {
            // Campus Top App Bar
            CampusTopAppBarView(controller: controller)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 6)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Search Bar
                    SearchBarView(controller: controller)
                        .padding(.horizontal, 20)
                    
                    // Promo Discount Card
                    PromoOfferCard(controller: controller)
                        .padding(.horizontal, 20)
                    
                    // Categories Horizontal Bar
                    CategoryFilterView(controller: controller)
                    
                    // Popular Items Carousel
                    PopularSectionView(controller: controller)
                    
                    // All Menu Items Section
                    FullMenuSectionView(controller: controller)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 110) // Clearance for floating tab bar
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

// MARK: - Campus Top App Bar (IIT Guwahati Location Picker)
struct CampusTopAppBarView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        HStack {
            // Hostel / Campus Location Menu
            Menu {
                Text("Select Delivery Hostel")
                ForEach(CampusLocation.iitgLocations) { location in
                    Button(action: {
                        withAnimation {
                            controller.selectLocation(location)
                        }
                    }) {
                        HStack {
                            Text(location.name)
                            if controller.selectedLocation.name == location.name {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color.brandPink.opacity(0.12))
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "building.2.crop.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.brandPink)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("IIT Guwahati Campus")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.brandPink)
                            .textCase(.uppercase)
                        
                        HStack(spacing: 4) {
                            Text(controller.selectedLocation.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color.brandDark)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Student Profile Switcher
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    controller.selectedTab = .profile
                }
            }) {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.brandPink.opacity(0.35), lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
            }
            .accessibilityLabel("Open IITG Profile")
        }
    }
}

// MARK: - Search Bar
struct SearchBarView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundStyle(Color.gray)
            
            TextField("Search cheese Maggi, kathi rolls, burgers, canteens...", text: $controller.searchQuery)
                .font(.system(size: 14))
            
            if !controller.searchQuery.isEmpty {
                Button(action: {
                    controller.searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Promo Banner Card (Campus Special)
struct PromoOfferCard: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 12, weight: .bold))
                    Text("IITG EXAM FUEL: IITG20")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundStyle(Color.brandPink)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.white)
                .clipShape(Capsule())
                
                Text("20% Off Canteen Deliveries till 3:00 AM")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                    .lineLimit(2)
                
                Button(action: {
                    controller.applyPromoCode("IITG20")
                }) {
                    Text("Apply Student Coupon")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.brandPink)
                        .clipShape(Capsule())
                        .shadow(color: Color.brandPink.opacity(0.35), radius: 6, x: 0, y: 3)
                }
            }
            .padding(.vertical, 16)
            .padding(.leading, 16)
            
            Spacer()
            
            Image("deleviry")
                .resizable()
                .scaledToFit()
                .frame(width: 115, height: 115)
                .padding(.trailing, 6)
        }
        .background(Color.brandLightYellow)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.brandLightYellow.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Category Filter View
struct CategoryFilterView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Campus Canteens & Menus")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(Color.brandDark)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(controller.categories) { category in
                        let isSelected = controller.selectedCategory.name == category.name
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                controller.selectCategory(category)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(category.imagePath)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                Text(category.name)
                                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                    .foregroundStyle(isSelected ? Color.white : Color.brandDark)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(isSelected ? Color.brandPink : Color.cardBackground)
                            .clipShape(Capsule())
                            .shadow(color: isSelected ? Color.brandPink.opacity(0.35) : Color.clear, radius: 8, x: 0, y: 3)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Popular Section Carousel
struct PopularSectionView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Campus Top Picks")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                
                Spacer()
                
                Text("\(controller.popularFoods.count) popular")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brandPink)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(controller.popularFoods) { food in
                        NavigationLink(destination: FoodDetailsPage(food: food, controller: controller)) {
                            PopularFoodCard(food: food, controller: controller)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Popular Food Card
struct PopularFoodCard: View {
    let food: Food
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Food Image + Favorite Button
            ZStack(alignment: .topTrailing) {
                Image(food.imagePath)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 125)
                    .padding(.top, 8)
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        controller.toggleFavorite(food)
                    }
                }) {
                    Image(systemName: controller.isFavorite(food) ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(controller.isFavorite(food) ? Color.brandPink : Color.gray)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                }
            }
            .frame(width: 170)
            
            // Name & Outlet
            VStack(alignment: .leading, spacing: 2) {
                Text(food.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.brandDark)
                    .lineLimit(1)
                
                Text(food.outletName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.brandPink)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            
            // Rating & Prep Time
            HStack(spacing: 6) {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", food.rating))
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                
                Text("•")
                    .foregroundStyle(Color.gray.opacity(0.5))
                
                Text(food.prepTime)
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
            }
            .padding(.horizontal, 12)
            
            // Price & Quick Add Button
            HStack {
                Text(food.formattedPrice)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        controller.addToCart(food: food, quantity: 1)
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 32, height: 32)
                        .background(Color.brandPink)
                        .clipShape(Circle())
                        .shadow(color: Color.brandPink.opacity(0.4), radius: 6, x: 0, y: 3)
                }
                .accessibilityLabel("Quick add \(food.name) to cart")
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Full Menu Section
struct FullMenuSectionView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("All Campus Delicacies")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(Color.brandDark)
            
            if controller.filteredFoodList.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.gray.opacity(0.4))
                        .padding(.top, 20)
                    
                    Text("No dishes found for this filter")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                    
                    Button("Reset Menu") {
                        controller.searchQuery = ""
                        controller.selectedCategory = controller.categories[0]
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.brandPink)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                ForEach(controller.filteredFoodList) { food in
                    NavigationLink(destination: FoodDetailsPage(food: food, controller: controller)) {
                        MenuListRow(food: food, controller: controller)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Menu List Row
struct MenuListRow: View {
    let food: Food
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        HStack(spacing: 14) {
            Image(food.imagePath)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.brandDark)
                
                Text(food.outletName)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brandPink)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", food.rating))
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    
                    Text("•")
                        .foregroundStyle(Color.gray.opacity(0.4))
                    
                    Text(food.prepTime)
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                }
                
                Text(food.formattedPrice)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.brandPink)
            }
            
            Spacer()
            
            // Add To Cart Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    controller.addToCart(food: food, quantity: 1)
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(width: 34, height: 34)
                    .background(Color.brandPink)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Add \(food.name) to cart")
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

// MARK: - 2. Favorites Feed View
struct FavoritesFeedView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Saved Campus Favorites")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                
                Spacer()
                
                Text("\(controller.favoriteFoods.count) items")
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            if controller.favoriteFoods.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "heart.slash.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.brandPink.opacity(0.4))
                    
                    Text("No Saved Campus Bites")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.brandDark)
                    
                    Text("Save your favorite canteen dishes here for quick late-night study cravings!")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        controller.selectedTab = .home
                    }) {
                        Text("Explore Campus Menu")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.brandPink)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 8)
                    Spacer()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(controller.favoriteFoods) { food in
                            NavigationLink(destination: FoodDetailsPage(food: food, controller: controller)) {
                                MenuListRow(food: food, controller: controller)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 110)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

// MARK: - 3. Orders Feed View (IIT Guwahati Delivery)
struct OrdersFeedView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Campus Deliveries")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Active Order Card
                    if let activeOrder = controller.activeOrder {
                        ActiveOrderTrackerCard(order: activeOrder, controller: controller)
                    }
                    
                    // Order History Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Past Campus Orders")
                            .font(.headline)
                            .foregroundStyle(Color.brandDark)
                        
                        if controller.orderHistory.isEmpty && controller.activeOrder == nil {
                            VStack(spacing: 12) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.gray.opacity(0.4))
                                    .padding(.top, 30)
                                
                                Text("No campus orders placed yet")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            ForEach(controller.orderHistory) { order in
                                OrderHistoryCard(order: order)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 110)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

// MARK: - Active Order Tracker Card (Campus Rider)
struct ActiveOrderTrackerCard: View {
    let order: Order
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("ACTIVE CAMPUS DISPATCH")
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.brandPink)
                    
                    Text(order.orderNumber)
                        .font(.headline)
                        .foregroundStyle(Color.brandDark)
                }
                
                Spacer()
                
                Text(order.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.brandPink)
                    .clipShape(Capsule())
            }
            
            // Progress Steps
            HStack(spacing: 8) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    let isCompleted = status.stepIndex <= order.status.stepIndex
                    VStack(spacing: 6) {
                        Rectangle()
                            .fill(isCompleted ? Color.brandPink : Color.gray.opacity(0.2))
                            .frame(height: 5)
                            .clipShape(Capsule())
                        
                        Text(status.rawValue.components(separatedBy: " ").first ?? "")
                            .font(.system(size: 9, weight: isCompleted ? .bold : .regular))
                            .foregroundStyle(isCompleted ? Color.brandPink : Color.gray)
                    }
                }
            }
            
            // Campus Rider Card
            HStack(spacing: 12) {
                Image("delivery-man")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .background(Color.brandLightYellow)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Rahul Sharma")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.brandDark)
                    
                    Text("Campus Cycle Courier • Bicycle #14")
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Button(action: {
                    controller.advanceOrderStatus()
                }) {
                    Text("Next Step")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.brandPink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.brandPink.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .padding(12)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            // Destination
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(Color.brandPink)
                    .font(.caption)
                Text("Deliver to: \(order.deliveryLocation)")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Order History Card
struct OrderHistoryCard: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bag.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color.brandPink)
                .frame(width: 46, height: 46)
                .background(Color.brandPink.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(order.orderNumber)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.brandDark)
                
                Text("\(order.items.count) items • \(order.status.rawValue)")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
            
            Text(order.formattedTotal)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.brandDark)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - 4. Cart Feed View
struct CartFeedView: View {
    @ObservedObject var controller: FoodOrderController
    @State private var promoInput: String = ""
    @State private var promoFeedback: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Campus Cart")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                
                Spacer()
                
                if !controller.cartItems.isEmpty {
                    Button("Clear") {
                        withAnimation { controller.clearCart() }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brandPink)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            if controller.cartItems.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "cart.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.gray.opacity(0.3))
                    
                    Text("Your Cart is Empty")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.brandDark)
                    
                    Text("Add your favorite Maggi, rolls, or burgers to order to your hostel room.")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        controller.selectedTab = .home
                    }) {
                        Text("Browse Canteen Menu")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.brandPink)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 8)
                    Spacer()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        // Free delivery progress banner (Orders >= ₹200)
                        freeDeliveryProgress
                        
                        // Cart Items List
                        VStack(spacing: 12) {
                            ForEach(controller.cartItems) { item in
                                CartItemRow(item: item, controller: controller)
                            }
                        }
                        
                        // Promo Code Input
                        promoCodeSection
                        
                        // Financial Breakdown Card
                        receiptBreakdownCard
                        
                        // Checkout Action Button
                        checkoutButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // Free Delivery Progress
    private var freeDeliveryProgress: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: controller.isFreeDeliveryEligible ? "checkmark.circle.fill" : "bicycle")
                    .foregroundStyle(controller.isFreeDeliveryEligible ? Color.green : Color.brandPink)
                
                Text(controller.isFreeDeliveryEligible ? "Unlocked FREE hostel delivery!" : "Add ₹\(String(format: "%.0f", controller.freeDeliveryRemaining)) more for FREE hostel delivery")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.brandDark)
            }
            
            ProgressView(value: min(1.0, controller.cartSubtotal / 200.0))
                .tint(controller.isFreeDeliveryEligible ? Color.green : Color.brandPink)
        }
        .padding(14)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    // Promo Code Section
    private var promoCodeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                TextField("Promo code (e.g. IITG20, MIDSEM)", text: $promoInput)
                    .font(.subheadline)
                    .textCase(.uppercase)
                    .padding(12)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Button(action: {
                    let result = controller.applyPromoCode(promoInput)
                    promoFeedback = result.message
                }) {
                    Text("Apply")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(Color.brandPink)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            
            if !promoFeedback.isEmpty {
                Text(promoFeedback)
                    .font(.caption2)
                    .foregroundStyle(controller.appliedPromoCode != nil ? Color.green : Color.red)
                    .padding(.leading, 4)
            }
        }
    }
    
    // Receipt Breakdown Card (INR ₹)
    private var receiptBreakdownCard: some View {
        VStack(spacing: 10) {
            receiptLine(label: "Items Subtotal", amount: controller.cartSubtotal)
            receiptLine(label: "Campus Courier Fee", amount: controller.deliveryFee, isFree: controller.deliveryFee == 0)
            receiptLine(label: "Restaurant GST (5%)", amount: controller.taxAmount)
            
            if controller.discountAmount > 0 {
                HStack {
                    Text("Student Discount (\(Int(controller.discountPercentage * 100))%)")
                        .font(.subheadline)
                        .foregroundStyle(Color.green)
                    Spacer()
                    Text("-₹\(String(format: "%.0f", controller.discountAmount))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.green)
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            HStack {
                Text("Total Payable")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.brandDark)
                Spacer()
                Text("₹\(String(format: "%.0f", controller.cartTotal))")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.brandPink)
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
    
    private func receiptLine(label: String, amount: Double, isFree: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Spacer()
            Text(isFree ? "FREE" : "₹\(String(format: "%.0f", amount))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(isFree ? Color.green : Color.brandDark)
        }
    }
    
    // Checkout Button
    private var checkoutButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                _ = controller.placeOrder()
                controller.selectedTab = .orders
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 16))
                
                Text("Confirm & Deliver to \(controller.selectedLocation.name)")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.brandPink)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.brandPink.opacity(0.4), radius: 10, x: 0, y: 5)
        }
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: CartItem
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        HStack(spacing: 12) {
            Image(item.food.imagePath)
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.food.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.brandDark)
                
                Text(item.food.formattedPrice)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brandPink)
                
                if !item.specialInstructions.isEmpty {
                    Text("Note: \(item.specialInstructions)")
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Stepper Pill
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation { controller.decrementCartItem(item) }
                }) {
                    Image(systemName: item.quantity == 1 ? "trash" : "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.brandPink)
                        .frame(width: 26, height: 26)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.brandDark)
                
                Button(action: {
                    withAnimation { controller.incrementCartItem(item) }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.brandPink)
                        .frame(width: 26, height: 26)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding(6)
            .background(Color.cardBackground)
            .clipShape(Capsule())
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - 5. Profile Feed View (IIT Guwahati Student Profile)
struct ProfileFeedView: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Student Profile")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandDark)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Profile Header Card
                    VStack(spacing: 10) {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 86, height: 86)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.brandPink, lineWidth: 3))
                            .shadow(color: Color.brandPink.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Text(controller.userProfile.name)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.brandDark)
                        
                        Text("\(controller.userProfile.role) • \(controller.userProfile.college)")
                            .font(.subheadline)
                            .foregroundStyle(Color.brandPink)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.caption)
                            Text(controller.userProfile.hostelRoom)
                                .font(.caption)
                        }
                        .foregroundStyle(Color.gray)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "envelope.fill")
                                .font(.caption)
                            Text(controller.userProfile.email)
                                .font(.caption)
                        }
                        .foregroundStyle(Color.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 3)
                    
                    // Stats Trio
                    HStack(spacing: 12) {
                        statPill(title: "Orders", value: "\(controller.orderHistory.count + (controller.activeOrder != nil ? 1 : 0))")
                        statPill(title: "Favorites", value: "\(controller.favoriteFoodIDs.count)")
                        statPill(title: "Campus Pts", value: "\(controller.userProfile.loyaltyPoints)")
                    }
                    
                    // CampusBite Project Highlights Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 8) {
                            Image(systemName: "apple.terminal.fill")
                                .foregroundStyle(Color.brandPink)
                            Text("CampusBite Engineering Highlights")
                                .font(.headline)
                                .foregroundStyle(Color.brandDark)
                        }
                        
                        techBadgeRow(tech: "Target Audience", desc: "8,000+ Students & Faculty across IIT Guwahati Hostels")
                        techBadgeRow(tech: "Swift 6 Concurrency", desc: "Data-race safe models with Sendable conformance")
                        techBadgeRow(tech: "SwiftUI & Observation", desc: "Zero redraw overhead with granular @Observable tracking")
                        techBadgeRow(tech: "Hostel Routing", desc: "Real-time dispatch system for IITG campus cycle couriers")
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
                    
                    // Developer GitHub Link
                    VStack(spacing: 12) {
                        Link(destination: URL(string: "https://github.com/siddharthpatel") ?? URL(string: "https://github.com")!) {
                            HStack {
                                Image(systemName: "chevron.left.forwardslash.chevron.right")
                                    .foregroundStyle(Color.brandPink)
                                Text("View CampusBite on GitHub")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.brandDark)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            .padding(16)
                            .background(Color.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    private func statPill(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.brandPink)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private func techBadgeRow(tech: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(tech)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.brandPink)
                .clipShape(Capsule())
            
            Text(desc)
                .font(.caption)
                .foregroundStyle(Color.secondary)
        }
    }
}

// MARK: - Modern Floating Bottom Tab Bar
struct ModernBottomTabBar: View {
    @ObservedObject var controller: FoodOrderController
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let isSelected = controller.selectedTab == tab
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        controller.selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack(alignment: .topTrailing) {
                            Image(tab.rawValue)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(isSelected ? Color.brandPink : Color.gray.opacity(0.7))
                            
                            // Badge on Cart
                            if tab == .cart && controller.cartItemCount > 0 {
                                Text("\(controller.cartItemCount)")
                                    .font(.system(size: 10, weight: .heavy))
                                    .foregroundStyle(Color.white)
                                    .padding(4)
                                    .background(Color.brandPink)
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -8)
                            }
                        }
                        
                        Text(tab.title)
                            .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                            .foregroundStyle(isSelected ? Color.brandPink : Color.gray.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                }
                .accessibilityLabel(tab.title)
            }
        }
        .padding(.vertical, 12)
        .background(
            Color.white
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 6)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}
