# Playful Bilingual Portfolio Redesign

## Goal

Turn the existing editorial academic portfolio into a light, playful, bilingual personal site without losing its factual credibility, accessibility, or zero-dependency architecture.

## Direction considered

1. **Pastel research playground, selected.** A cream paper canvas, sky blue, apricot, coral and mint accents, research-note cards, friendly cartoon objects, and restrained tactile motion. This balances personality with academic trust.
2. **Soft glass AI cosmos.** Atmospheric and animated, but too close to common AI landing-page styling and less personal.
3. **Editorial botanical studio.** Elegant and warm, but too quiet for the requested level of interaction.

## Visual system

The page uses a warm cream base with dark navy text and four controlled accent colors. Rounded cards, imperfect hand-drawn borders, tape marks, dots, and tiny doodles create a collected-notebook feeling. Display typography stays editorial while body typography remains highly legible. Decorative illustration is raster artwork generated specifically for this site, with CSS doodles used only for minor accents.

## Information architecture

- Sticky pill navigation with language toggle
- Hero with concise positioning, primary links, key facts, and one large playful illustration
- Research cards that explain the question, contribution, and evidence
- Project cards with clearer one-line outcomes and technology labels
- About and toolkit section with a second illustration
- Contact callout with a third illustration and direct links

The existing stable anchors remain unchanged: `#research`, `#projects`, `#about`, `#skills`, and `#contact`.

## Interaction and motion

- Orchestrated hero entrance and scroll reveal
- Subtle pointer-responsive background glow on fine pointers
- Gentle card tilt and lift on fine pointers
- A small “play” button that shuffles the decorative stickers
- Language switch with persistent local preference and updated document metadata
- Active-section navigation, mobile menu, scroll progress, and copy-email feedback
- Full `prefers-reduced-motion` support with all content visible and interaction still functional

## Internationalization

Every user-facing string, including navigation labels, accessibility labels, buttons, project descriptions, captions, status text, and footer copy, is stored in paired English and Simplified Chinese entries. The selected language updates `html[lang]`, title, description, labels, and visible copy. English is the first-visit default to preserve the current public profile positioning; the user's choice persists in `localStorage`.

## Technical approach

Keep the single `index.html` architecture with embedded CSS and vanilla JavaScript. Use `data-i18n` keys for text and `data-i18n-aria` for accessible labels. Generated artwork lives under `assets/illustrations/`. No framework, build step, third-party runtime, or remote font request is added.

## Verification

- Extend `scripts/smoke.sh` before implementation so the new requirements fail first
- Run the smoke suite after implementation
- Serve locally and inspect desktop and mobile screenshots
- Check JavaScript console errors, menu behavior, language persistence, anchor navigation, reduced motion, and print visibility
- Verify both language dictionaries have the same keys and no missing visible labels
