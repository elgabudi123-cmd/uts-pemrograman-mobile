---
name: Sehat Bersama Smart Village
colors:
  surface: '#effdf5'
  surface-dim: '#cfddd6'
  surface-bright: '#effdf5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e9f7ef'
  surface-container: '#e3f1e9'
  surface-container-high: '#deebe4'
  surface-container-highest: '#d8e6de'
  on-surface: '#121e1a'
  on-surface-variant: '#3e4945'
  inverse-surface: '#27332e'
  inverse-on-surface: '#e6f4ec'
  outline: '#6e7a74'
  outline-variant: '#bdc9c3'
  surface-tint: '#006b56'
  primary: '#00624e'
  on-primary: '#ffffff'
  primary-container: '#147d65'
  on-primary-container: '#c5ffea'
  inverse-primary: '#7cd7bb'
  secondary: '#005faf'
  on-secondary: '#ffffff'
  secondary-container: '#54a0fe'
  on-secondary-container: '#003567'
  tertiary: '#146250'
  on-tertiary: '#ffffff'
  tertiary-container: '#347b67'
  on-tertiary-container: '#c8ffeb'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#98f4d6'
  primary-fixed-dim: '#7cd7bb'
  on-primary-fixed: '#002018'
  on-primary-fixed-variant: '#005140'
  secondary-fixed: '#d4e3ff'
  secondary-fixed-dim: '#a5c8ff'
  on-secondary-fixed: '#001c3a'
  on-secondary-fixed-variant: '#004786'
  tertiary-fixed: '#a9f1d9'
  tertiary-fixed-dim: '#8dd4bd'
  on-tertiary-fixed: '#002018'
  on-tertiary-fixed-variant: '#005140'
  background: '#effdf5'
  on-background: '#121e1a'
  surface-variant: '#d8e6de'
  surface-bg: '#F7F9F8'
  surface-card: '#FFFFFF'
  text-primary: '#17211D'
  text-secondary: '#64716B'
  border-subtle: '#E2E8E5'
  status-success: '#23864A'
  status-warning: '#B7791F'
  status-error: '#C0392B'
  geofence-pulse: '#147D6526'
typography:
  headline-lg:
    fontFamily: Roboto Flex
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Roboto Flex
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Roboto Flex
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Roboto Flex
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  title-sm:
    fontFamily: Roboto Flex
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  body-lg:
    fontFamily: Roboto Flex
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Roboto Flex
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Roboto Flex
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Roboto Flex
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Roboto Flex
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Roboto Flex
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  margin: 1rem
  margin-lg: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system establishes a clean, civic-centered mobile health interface tailored for rural and sub-urban citizens (warga desa) interacting with Location-Based Services (LBS) and geofencing capabilities. The emotional atmosphere balances deep public reassurance, approachable clarity, and immediate utility during urgent or everyday health-seeking journeys. 

The aesthetic adheres to **Corporate / Modern** civic utility infused with warm communal accessibility. It avoids stark corporate rigidity and excessive ornamental clutter, prioritizing high legibility under varying outdoor lighting conditions, clear semantic cues, robust information chunking, and gentle 12–16px rounded card boundaries that feel friendly and dependable on standard Android devices.

## Colors

The palette grounds the application in restorative botanical tones paired with authoritative civic blues:

- **Primary (`#147D65`)**: The core healthcare emerald, utilized for primary calls to action, active navigation states, verified facility highlights, and geofence indicators.
- **Tertiary / Primary Dark (`#0B5D4B`)**: High-contrast anchor tone for pressed button states, deep headers, and focused UI elements.
- **Secondary (`#1976D2`)**: Digital navigation blue, reserved for wayfinding markers, map routes, transport mode selectors, and external navigational links.
- **Neutral (`#64716B`)**: Balanced sage-slate for supportive metadata, secondary descriptive text, unselected navigation icons, and distance metrics.
- **Surfaces (`#F7F9F8` & `#FFFFFF`)**: An ultra-soft off-white canvas preventing harsh glare under rural outdoor sunlight, contrasted cleanly by pure white elevated cards.

Color alone never dictates operational state; badges combine green/red semantic tints (`#23864A` and `#C0392B`) with explicit textual indicators ("Buka", "Tutup", "24 Jam").

## Typography

Typography is standardized around Flutter's native Android foundation using **Roboto Flex** to deliver uncompromised legibility across varying device DPI scales and dynamic OS text resizing:

- **Headings (`headline-lg`, `headline-md`)**: Crisp, semi-bold to bold weights that orient the user swiftly on screen titles (e.g., "Peta Lokasi", "RSUD Kabupaten X").
- **Card Titles & Service Names (`title-md`)**: Set at 16px semi-bold to ensure quick visual scanning within vertically scrolling feeds.
- **Body Text (`body-md`, `body-sm`)**: Set with generous line heights and `#17211D` high-contrast ink to remain readable for elderly or visually impaired citizens.
- **Metadata Labels (`label-md`, `label-sm`)**: Employed for status chips ("Buka • 24 jam"), geodesic distance units ("1,2 km"), and geofence perimeter notices.

## Layout & Spacing

Layout follows an ergonomic 4dp/8dp base rhythm optimized for one-handed mobile Android interactions:

- **Screen Margins**: Default to `margin` (16dp / `1rem`) on standard smartphones, expanding to 24dp (`margin-lg`) on larger portrait phablets or tablets.
- **Grid & Card Flow**: Facility feeds and category icons utilize a fluid column distribution with a 12dp to 16dp gutter.
- **Touch Ergonomics**: All interactive elements maintain a strict minimum target boundary of 48×48dp, ensuring easy tapping without accidental misclicks.
- **BottomSheet & Overlays**: Map inspection sheets and geofence alerts nest within a safe margin of 16dp from screen edges with automatic bottom safe-area insets.

## Elevation & Depth

Visual hierarchy adopts a dual strategy of **ambient tonal layering** and **soft structural outlines**:

- **Canvas Tier (0dp)**: Surface background tinted at `#F7F9F8`.
- **Card Tier (1dp - 2dp)**: Elevated pure white surfaces (`#FFFFFF`) framed by a subtle 1px border (`#E2E8E5`) and an ultra-soft ambient shadow: `0px 2px 8px rgba(23, 33, 29, 0.04)`.
- **Active / Floating Overlays (4dp - 8dp)**: Geofence alert cards, map utility buttons ("Lokasi Saya"), and floating category pills feature elevated ambient depth: `0px 6px 16px rgba(20, 125, 101, 0.12)`.
- **Modal & Bottom Sheet Tier (12dp)**: Dismissible bottom sheets cast a broader backdrop scrim (`rgba(23, 33, 29, 0.4)`) paired with smooth top-edge rounding.

## Shapes

The design system uses a friendly, ergonomic roundedness curve matching Level 2:

- **Base Cards & List Tiles (`rounded-lg`)**: Structured with 12dp to 16dp corner radiuses (`1rem`), offering a modern, welcoming pebble feel that softens civic data.
- **Action Buttons & Search Bar**: Styled with 12dp to 16dp squircle profiles for touch comfort.
- **Badges & Filter Chips**: Feature fully rounded pill configurations (`9999px`) to distinguish categorical selectors from static content cards.
- **Map Bottom Sheets**: Top corners rounded to 20dp, framing location summaries clearly above interactive cartography.

## Components

### Buttons
- **Primary Button (`PrimaryButton`)**: Height 48–52dp, solid fill `#147D65`, text `#FFFFFF` 15px semi-bold, radius 12dp. Pressed state scales smoothly to `#0B5D4B`.
- **Secondary / Map Action Button**: Height 48dp, solid fill `#1976D2` or soft tint `#EBF3FA`, text `#1976D2` for external navigation triggers ("Lihat di Peta", "Mulai Navigasi").
- **Floating Map Action**: Circular 48×48dp white container with centered iconography, elevated with subtle shadow.

### Chips & Badges
- **Category Filter Chip (`CategoryFilterChip`)**: Pill shape, 36dp height. Unselected: surface `#FFFFFF`, border 1px `#E2E8E5`, text `#64716B`. Selected: background `#147D65`, text `#FFFFFF`.
- **Operational Status Badge (`FacilityStatusBadge`)**: Compact pill padding (4dp vertical, 10dp horizontal). Green tint (`#E8F5E9`) with `#23864A` text and dot icon for "Buka"; muted red tint (`#FFEBEE`) with `#C0392B` for "Tutup".

### Cards
- **Facility Card (`FacilityCard`)**: Pure white `#FFFFFF` body, 12–16dp border radius, 1px `#E2E8E5` stroke. Features a 72×72dp thumbnail or top banner, title in `title-md`, geodesic distance indicator with blue pin icon, and inline service tags.
- **Geofence Notification Card**: High-visibility card with a subtle 2px emerald left accent border, location icon within a soft green circular avatar, headline, and dual action ("Lihat Lokasi" & "Tutup").

### Form & Input Fields
- **Search Field (`AppSearchField`)**: 48dp height, surface `#FFFFFF`, border `#E2E8E5`, prefix search icon in `#64716B`. Placeholder text: "Cari rumah sakit, puskesmas, klinik...".

### Service Grid Tiles (`ServiceIconTile`)
- 64×64dp rounded square container tinted with brand soft-light tones (`#EBF5F2`), housing single-tone SVG healthcare icons (Poli, IGD, Rawat Inap, Lab) paired with concise labels below.