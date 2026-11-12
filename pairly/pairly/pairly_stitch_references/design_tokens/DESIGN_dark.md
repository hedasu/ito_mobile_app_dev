---
name: Pairly Calm Mind
colors:
  surface: '#0f1512'
  surface-dim: '#0f1512'
  surface-bright: '#343b37'
  surface-container-lowest: '#0a0f0d'
  surface-container-low: '#171d1a'
  surface-container: '#1b211e'
  surface-container-high: '#252b28'
  surface-container-highest: '#303633'
  on-surface: '#dee4df'
  on-surface-variant: '#c3c8c0'
  inverse-surface: '#dee4df'
  inverse-on-surface: '#2c322e'
  outline: '#8d928b'
  outline-variant: '#434842'
  surface-tint: '#b6ccb7'
  primary: '#c0d7c1'
  on-primary: '#223526'
  primary-container: '#a5bba6'
  on-primary-container: '#384b3b'
  inverse-primary: '#4f6352'
  secondary: '#bdcabe'
  on-secondary: '#27332b'
  secondary-container: '#404c43'
  on-secondary-container: '#afbcb0'
  tertiary: '#c6d5c9'
  on-tertiary: '#27332b'
  tertiary-container: '#abb9ad'
  on-tertiary-container: '#3d4a41'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d2e8d2'
  primary-fixed-dim: '#b6ccb7'
  on-primary-fixed: '#0d1f12'
  on-primary-fixed-variant: '#384b3b'
  secondary-fixed: '#d9e6da'
  secondary-fixed-dim: '#bdcabe'
  on-secondary-fixed: '#131e17'
  on-secondary-fixed-variant: '#3e4a41'
  tertiary-fixed: '#d8e6da'
  tertiary-fixed-dim: '#bccabe'
  on-tertiary-fixed: '#121e17'
  on-tertiary-fixed-variant: '#3d4a41'
  background: '#0f1512'
  on-background: '#dee4df'
  surface-variant: '#303633'
typography:
  headline-xl:
    fontFamily: Manrope
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Manrope
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 30px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Manrope
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.04em
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.06em
  counter-display:
    fontFamily: Manrope
    fontSize: 36px
    fontWeight: '300'
    lineHeight: 40px
    letterSpacing: -0.03em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 2rem
  margin-desktop: 3rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

The design system embodies a serene, contemplative Nordic atmosphere tailored for a focused memory card matching experience. It rejects high-stimulus gamification (such as flashing neon highlights, harsh alarms, or frantic countdown bars) in favor of quiet digital craftsmanship, mindful clarity, and tactile restfulness. 

The aesthetic sits at the intersection of **Nordic Minimalism** and **Tactile Depth**. Rich, muted botanical dark tones eliminate eye fatigue, while gentle sage accents guide orientation and reward focus. Visual weight is expressed through pill-shaped geometries, organic surface tiers, and quiet physical metaphors that make cards feel like smoothed river stones or fine matte wood tiles laid out on slate.

## Colors

Color is deployed with disciplined restraint to ensure tranquil gameplay and deep ergonomic focus:

- **Background (`#171D1A`)**: A deep forest-slate obsidian that provides infinite optical depth without the stark, cold sterility of pure black (`#000000`).
- **Surface / Cards (`#252E28`)**: A soft, muted dark green elevation layer that grounds active play areas, boards, card backs, and floating control sheets.
- **Primary Accent (`#A5BBA6`)**: A pale, soothing sage highlight reserved for positive state confirmations, paired cards, active toggles, and primary navigation buttons.
- **Secondary / Muted (`#8E9B90`)**: Soft sage-gray used for secondary metrics (turn counters, timer subtitles, inactive icons, and ghost borders).
- **Subtle Outline / Border (`#3B483F`)**: A quiet dark-green stroke that defines structural card edges and containers against the slate background without breaking visual immersion.
- **Text Primary (`#F1F4EF`)**: An ethereal, warm off-white ensuring WCAG AAA legibility against slate surfaces.

## Typography

The design system exclusively implements **Manrope**, leveraging its geometric purity and semi-rounded internal terminals to reinforce the organic Nordic character. 

Numbers and score counters employ lighter weights (`300` and `400`) at larger scales to project effortless calm during real-time game play. Tracking is gently tightened on prominent display numbers, while UI micro-labels employ wide positive tracking to maintain absolute clarity against dark green surfaces.

## Layout & Spacing

Layouts are framed within a centralized, fluid viewport constrained to an optimal reading and interaction width (maximum 680px for mobile/tablet matching boards; 960px for desktop landscape layouts). 

- **Grid Rhythms**: Card boards arrange into fluid symmetrical matrices ($3 \times 4$, $4 \times 4$, or $4 \times 6$). Spacing between cards matches `gutter` on mobile (16px) and expands to `gutter-desktop` (24px) on screens above 1024px.
- **Breathing Margins**: Canvases require expansive outer margins (`margin-desktop`) to produce a vignette-like focus on the game table, pushing ambient noise away from the active playing arena.

## Elevation & Depth

This system avoids heavy, artificial drop shadows in favor of **Tonal Layering** and **Ambient Luminescence**:

1. **Base Layer (Elevation 0 - `#171D1A`)**: The resting canvas. Uninterrupted, deep matte backdrop.
2. **Surface Layer (Elevation 1 - `#252E28`)**: Resting memory cards, score panels, and header pills. Card edges are framed with a hairline outline (`1px solid #3B483F`).
3. **Lifted / Hover Layer (Elevation 2)**: Cards on cursor hover or pre-flip anticipation translate vertically by `-2px` with a diffused ambient shadow (`0 10px 24px -4px rgba(10, 14, 12, 0.45)`).
4. **Matched & Revealed (Elevation 3)**: Matched pairs softly radiate a low-density sage halo (`0 0 20px 2px rgba(165, 187, 166, 0.18)`), acknowledging success without harsh visual flashes.

## Shapes

The design system embraces generous, organic rounding. All interactive surfaces utilize pill and pebble geometry to evoke smooth river stones, eliminating sharp corners and visual friction:

- **Cards**: Sculpted with large rounded radii (equivalent to `rounded-2xl` / 1.5rem on standard screens, `rounded-3xl` / 2rem on desktop views).
- **Buttons & Chips**: Pure full-radius pills (`rounded-full` / 9999px).
- **Modals & Overlays**: Generous containers with smooth continuous corners (`rounded-3xl` / 2rem).

## Components

### Memory Cards (Primary Entity)
- **Dimensions**: Aspect ratio is strictly 1:1 or 3:4.
- **Card Back**: `#252E28` surface, bordered with `1px solid #3B483F`, centered with a debossed geometric brand glyph rendered in `#3B483F`.
- **Card Face (Revealed)**: Surface transitions via a smooth 3D flip transform (`0.4s cubic-bezier(0.2, 0.8, 0.2, 1)`) to `#1F2621`. Face artwork/icons are drawn with `#F1F4EF` strokes and gentle `#A5BBA6` fills.
- **Matched Pair State**: Card surface is kissed with a soft border (`1.5px solid #A5BBA6`) and the serene sage ambient bloom.

### Buttons & Controls
- **Primary Pill**: Filled `#A5BBA6` with `#171D1A` text. Used for "Start Journey", "New Game", and "Play Again". Hover introduces subtle scale (`scale(1.02)`).
- **Secondary Ghost Pill**: Transparent background with `1px solid #3B483F` border, `#F1F4EF` text, and `#8E9B90` icon accents. Hover deepens background to `#252E28`.

### Status & HUD Chips
- Compact, floating pill pods holding move counts and zen timers.
- Background: `#252E28` at 90% opacity with a `backdrop-filter: blur(8px)` treatment.
- Typography: Secondary metric label in `#8E9B90`, numeric value in crisp `#F1F4EF`.

### End-of-Round Modal Card
- Floating overlay centered on the slate backdrop with an ambient scrim (`#171D1A` at 70% opacity).
- Card body uses `#252E28` with a continuous `2rem` radius, containing completion time, streak count, and paired primary actions.