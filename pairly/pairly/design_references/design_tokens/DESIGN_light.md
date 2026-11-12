---
name: Pairly
colors:
  surface: '#f7faf4'
  surface-dim: '#d8dbd5'
  surface-bright: '#f7faf4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f5ee'
  surface-container: '#ecefe8'
  surface-container-high: '#e6e9e3'
  surface-container-highest: '#e0e3dd'
  on-surface: '#191d19'
  on-surface-variant: '#434843'
  inverse-surface: '#2d312d'
  inverse-on-surface: '#eff2eb'
  outline: '#737873'
  outline-variant: '#c3c8c1'
  surface-tint: '#506354'
  primary: '#425547'
  on-primary: '#ffffff'
  primary-container: '#5a6d5e'
  on-primary-container: '#d9eedb'
  inverse-primary: '#b7ccba'
  secondary: '#536251'
  on-secondary: '#ffffff'
  secondary-container: '#d4e4ce'
  on-secondary-container: '#586755'
  tertiary: '#65494c'
  on-tertiary: '#ffffff'
  tertiary-container: '#7f6164'
  on-tertiary-container: '#ffe2e4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e8d5'
  primary-fixed-dim: '#b7ccba'
  on-primary-fixed: '#0e1f14'
  on-primary-fixed-variant: '#394b3d'
  secondary-fixed: '#d7e7d1'
  secondary-fixed-dim: '#bbcbb6'
  on-secondary-fixed: '#111f11'
  on-secondary-fixed-variant: '#3c4b3a'
  tertiary-fixed: '#ffd9dc'
  tertiary-fixed-dim: '#e3bdc1'
  on-tertiary-fixed: '#2b1618'
  on-tertiary-fixed-variant: '#5a4043'
  background: '#f7faf4'
  on-background: '#191d19'
  surface-variant: '#e0e3dd'
typography:
  display:
    fontFamily: Manrope
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Manrope
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: DM Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system embodies Scandinavian minimalism tailored for a contemplative mobile gaming experience. The aesthetic balances architectural restraint with tactile warmth. It prioritizes mental clarity, intentional pauses, and deliberate physical interaction over visual clutter or hyper-stimulating gamification tropes.

### Core Principles
- **Clarity Over Spectacle:** Every visual element serves a mechanical or orienting function. Ornamental flares, skeuomorphic glares, and intense saturation are avoided in favor of quiet, organic balance.
- **Architectural Breathing Room:** Whitespace functions as structural framing. Generous margins and quiet canvases invite focus, turning memory card matching into a mindful exercise.
- **Muted Tactility:** Physical metaphors manifest through delicate surface divisions, disciplined structural lines, and soft, natural surface offsets rather than synthetic glass or aggressive depth.

## Colors

The palette draws directly from muted Nordic landscapes—pale limestone, soft spruce, and cool slate.

### Palette Architecture
- **Primary (`#5A6D5E`):** A deep, organic spruce-sage. Used intentionally for focal points: selected card states, primary match confirmations, active state toggles, and primary navigation buttons.
- **Secondary (`#8A9A86`):** A weathered pale sage. Used for subtle progress indicators, auxiliary interactive cues, and supportive state feedback.
- **Neutral / Text Primary (`#252925`):** Dark slate-charcoal. Provides legible, glare-free typographic presence against pale surfaces without the harshness of pure black.
- **Secondary Text (`#6B726A`):** Low-contrast stone grey for metadata, turn counters, and inactive labels.
- **Canvas Base (`#F7F7F5`):** Warm off-white limestone that reduces visual fatigue during extended sessions.
- **Surface Elevation (`#FFFFFF`):** Pure chalk white for interactive card faces, modals, and container elements.
- **Structural Outlines (`#E6E6E2`):** Low-contrast boundary strokes defining card outlines and structural dividers.

## Typography

The typographic pairing unites the geometric, architectural clarity of **Manrope** for display elements and headlines with the organic, legible flow of **DM Sans** for reading and interface labels.

### Typographic Principles
- **Geometric Hierarchy:** Headlines use Manrope with slight negative tracking to preserve structural solidity. Display numbers (such as match counts and timers) are weighted to maintain balance against generous whitespace.
- **Legibility at Glance:** DM Sans delivers neutral legibility in game states, status indicators, and body copy without competing with the card iconography.
- **Restraint:** Font weights are strictly capped between 400 (regular), 500 (medium), and 600 (semi-bold) to preserve an open, lightweight feel.

## Layout & Spacing

The spatial engine strictly adheres to an 8-point base rhythm, engineered specifically for compact, portrait-first mobile viewports (baseline target: 390x844 pt).

### Layout Rules
- **Margins & Safe Zones:** Canvas lateral padding defaults to `margin` (24px / 1.5rem). The game area retains a dedicated vertical buffer above the bottom home indicator and under the status bar.
- **Card Grids:** Memory grids (2x3, 3x4, 4x4) employ a uniform `gutter` (16px / 1rem) or `space-sm` (8px / 0.5rem) on higher card densities, guaranteeing strict aspect ratio conservation (1:1 or 3:4 portrait cards).
- **Component Padding:** Standard interactive surfaces use `space-md` (16px) internally, while minimal indicators leverage `space-xs` (4px) and `space-sm` (8px).

## Elevation & Depth

Visual hierarchy rejects noisy skeuomorphism and synthetic glass blurs in favor of flat tonal layering anchored by delicate hairline boundaries and low-diffusion environmental shadows.

### Layering Model
1. **Canvas Layer (`#F7F7F5`):** The foundational substrate across all game screens and configuration menus.
2. **Resting Card & Surface Layer (`#FFFFFF`):** Pure white container surfaces bounded by a continuous 1px stroke of `#E6E6E2`. Depth is reinforced with a faint, warm shadow: `box-shadow: 0 2px 8px rgba(37, 41, 37, 0.04)`.
3. **Active / Lifted State:** When a card is touched or flipped, the elevation subtly expands with zero border shift: `box-shadow: 0 8px 20px rgba(37, 41, 37, 0.07)`.
4. **Modals & Bottom Sheets:** Elevated chalk white layers bounded by a 1px `#E6E6E2` border, resting upon a 20% opacity neutral-tinted backdrop scrim (`rgba(37, 41, 37, 0.2)`).

## Shapes

The geometric identity is defined by soft architectural roundedness (Radius Token 2). It provides a calm, ergonomic touch profile without softening into childlike or cartoonish silhouettes.

### Corner Curvature Scale
- **Standard (`0.5rem` / 8px):** Small badges, icon wells, segmented pill tabs, and discrete selection chips.
- **Large (`rounded-lg` / `1rem` / 16px):** Core interactive cards, primary input fields, and standard buttons.
- **Extra Large (`rounded-xl` / `1.5rem` / 24px):** Score summary sheets, modal dialog containers, and game completion cards.
- **Full / Pill:** Reserved exclusively for small status indicators (turn counters, timer pills) and circular icon actions.

## Components

### Memory Cards
- **Back Face (Concealed):** `#FFFFFF` surface, 1px `#E6E6E2` perimeter stroke, `rounded-lg` corner radius. Contains an understated geometric or botanical debossed motif rendered in `#E6E6E2`.
- **Front Face (Revealed):** `#FFFFFF` background with an inset primary visual motif (minimal line illustration or icon).
- **Matched State:** Background shifts to a faint organic wash (`#5A6D5E` at 8% opacity) with a `#5A6D5E` hairline border, accompanied by a subtle scale feedback animation.

### Buttons
- **Primary:** Filled `#5A6D5E` background, `#FFFFFF` Manrope semi-bold label, `rounded-lg` radius, minimum 48px tap height. Zero border, flat appearance with a slight tactile compression on press.
- **Secondary / Ghost:** Transparent canvas background, 1px `#E6E6E2` outline, `#252925` label. Transitions to `#F0F0EC` on press.

### Chips & Stat Badges
- Pill-shaped or `rounded-lg` containers using `#FFFFFF` surface with a 1px `#E6E6E2` border.
- Text combines an uppercase `label-sm` in `#6B726A` paired with a numeric value in `#252925` Manrope medium.

### Input Fields & Controls
- **Inputs:** `#FFFFFF` fill, 1px `#E6E6E2` static outline, focusing to a 1.5px `#5A6D5E` outline. `rounded-lg` radius with generous vertical padding (14px).
- **Toggles / Switches:** Minimalist track using `#E6E6E2` when off, transitioning to `#5A6D5E` when on. Chalk-white circular knob with subtle 1px offset shadow.

### Modals & Dialogs
- Inset by `margin` (24px) from screen edges or docked as an ergonomic bottom sheet. Surfaces are solid `#FFFFFF`, bordered by 1px `#E6E6E2`, with an internal padding of `space-xl` (32px).