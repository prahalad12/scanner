---
name: project-overview
description: High-level overview of the scaner Flutter project — YWC Crew Marketplace app for yacht crew
metadata:
  type: project
---

Flutter app package named "scaner", branded as **YWC Crew Marketplace** — a peer-to-peer marketplace for yacht crew to buy/sell uniforms, safety gear, electronics, and yacht gear.

**Why:** Targeted niche marketplace for yacht world crew (YWC). Domain-specific categories like Uniforms, Safety Equipment, Electronics, Yacht Gear, Services.

**How to apply:** When suggesting features or architecture changes, keep the yacht-crew niche in mind. The app is currently UI-only with mock data — no backend integration yet.

**Current state (as of 2026-06-05):**
- Entry: main.dart → LoginScreen → BottomNavWrapper (pushReplacement on login)
- Screens implemented: Login, Home, ListingDetail, MessagesScreen, ChatDetailScreen
- Screens pending: Search, CreateListing, Dashboard, Profile
- Data layer: all hardcoded mock data in lib/data/ — no state management library, uses setState
- No backend / API integration yet