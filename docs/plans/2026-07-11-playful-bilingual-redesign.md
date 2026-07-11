# Playful Bilingual Portfolio Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rebuild the portfolio as a polished light-color, animation-rich, cartoon-illustrated site with complete English and Simplified Chinese modes.

**Architecture:** Preserve the zero-dependency single-page architecture. Put visual styles and behavior in `index.html`, use paired JavaScript translation dictionaries, and store generated raster art in `assets/illustrations/`.

**Tech Stack:** Semantic HTML5, CSS custom properties and animations, vanilla JavaScript, shell/Python smoke checks, Playwright-compatible browser verification.

---

### Task 1: Add requirement guards

**Files:**
- Modify: `scripts/smoke.sh`

1. Add assertions for the language toggle, paired translation dictionaries, persistent language storage, and `html[lang]` updates.
2. Add assertions for three project-local cartoon illustration references.
3. Add assertions for reduced-motion handling and unchanged section anchors.
4. Run `bash scripts/smoke.sh` and verify it fails because the new features do not exist yet.

### Task 2: Generate cartoon artwork

**Files:**
- Create: `assets/illustrations/research-buddy.webp`
- Create: `assets/illustrations/idea-garden.webp`
- Create: `assets/illustrations/hello-orbit.webp`

1. Generate three cohesive pastel cartoon scenes with no text or logos.
2. Save each selected project-bound output under `assets/illustrations/`.
3. Inspect the outputs for palette, subject clarity, and suitability at desktop and mobile sizes.

### Task 3: Rebuild the semantic page and visual system

**Files:**
- Modify: `index.html`

1. Replace the current editorial layout with the selected pastel research-playground composition.
2. Preserve factual claims, stable anchors, document metadata, local files, and outbound links.
3. Add responsive navigation, illustration placements, research cards, project cards, about/toolkit content, and contact callout.
4. Implement a cohesive responsive layout at 1440px, tablet, and 390px widths.

### Task 4: Add bilingual content and metadata

**Files:**
- Modify: `index.html`

1. Add complete `en` and `zh` dictionaries with identical keys.
2. Bind all visible and accessible UI strings to translation keys.
3. Update `lang`, title, description, aria labels, and button feedback when switching.
4. Persist the choice in `localStorage` and handle unavailable storage safely.

### Task 5: Add motion and interaction

**Files:**
- Modify: `index.html`

1. Add staggered entrance and scroll reveal with no-JavaScript visibility safety.
2. Add fine-pointer card tilt, pointer glow, sticker shuffle, active navigation, mobile menu, and copy-email feedback.
3. Ensure all motion is disabled or simplified under `prefers-reduced-motion`.
4. Ensure keyboard and touch users receive equivalent functionality.

### Task 6: Verify and refine

**Files:**
- Modify if needed: `index.html`, `scripts/smoke.sh`

1. Run `bash scripts/smoke.sh` and require a clean pass.
2. Start a local static server and inspect desktop and mobile screenshots.
3. Check both languages, console output, anchors, navigation, image loading, print, and reduced motion.
4. Fix only issues found by verification and rerun the complete checks.
