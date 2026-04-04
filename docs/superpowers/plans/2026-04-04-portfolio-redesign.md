# Portfolio Website Redesign Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:executing-plans to implement this plan.

**Goal:** Complete redesign of index.html from dark cyberpunk aesthetic to a clean light academic portfolio optimised for summer research applications (NUS/NTU).

**Architecture:** Single-file HTML with embedded CSS and vanilla JS. Three.js removed; replaced with CSS dot-grid background. GSAP kept with `defer`. No external font changes.

**Tech Stack:** HTML5 · CSS custom properties · GSAP 3 (deferred) · Vanilla JS · Playwright for testing

---

## Design Decisions (agent-resolved)

| Decision | Choice | Reason |
|---|---|---|
| Color palette | Light slate — bg #F8FAFC, accent #2563EB, text #0F172A | Academic professionalism |
| Background | CSS radial-gradient dot grid (no JS) | Performance, no loader needed |
| Three.js | Remove | Performance; replaced by CSS |
| Loader | Remove | Eliminated performance bloat |
| Custom cursor | Desktop only via `@media (pointer: fine)` | Fixes mobile bug |
| Emoji icons | Inline SVG paths | Cross-platform consistency |
| Section order | Hero → Ticker → About → Research → Skills → Projects → Contact | Research prioritised |

---

## Chunk 1: Full Rewrite — index.html

### Task 1: Remove loader, fix cursor, add defer, light CSS variables

**Files:**
- Modify: `index.html` (full rewrite)

- [ ] Remove all loader HTML + JS
- [ ] Remove scanlines div
- [ ] Remove noise div
- [ ] Remove aurora div
- [ ] Remove Three.js canvas and CDN script tag
- [ ] Add `defer` to GSAP script tags
- [ ] Wrap cursor CSS in `@media (pointer: fine)`
- [ ] Replace all dark CSS variables with light palette

### Task 2: Hero section — academic positioning

- [ ] Add "Open to 2026 Summer Research · NUS / NTU" badge above name
- [ ] Change subtitle to include PolyU URIS affiliation
- [ ] Rewrite stats: GPA 3.85/4.3 · 2 Papers Under Review · URIS Funded · 12+ Projects
- [ ] Add "Download CV" as primary CTA button
- [ ] Reorder CTAs: Download CV (primary filled) → View Research (outline) → Get in Touch (text)
- [ ] Replace CSS dot-grid background for hero

### Task 3: Publications ticker

- [ ] Replace word marquee with academic conference ticker:
  `ACM MM 2026 · KDD 2026 · URIS Funded Research · PolyU · Multimodal AI · VLM Systems`

### Task 4: Research section — move up, add content

- [ ] Move research section to BEFORE skills/projects in DOM
- [ ] Add CCD-VQA paper with full title, ACM MM 2026, key metrics
- [ ] Add SurveyLens paper with full title, KDD 2026, key metrics
- [ ] Add URIS project description (YOLOv8 + Qwen2.5-VL architecture)
- [ ] Add paper status badge ("Under Review") to each item

### Task 5: Skills — replace emoji with SVG

- [ ] Replace all emoji skill icons with inline SVG paths or styled text badges
- [ ] Keep hexagon layout, update colours to light theme

### Task 6: Projects — add technical metrics

- [ ] Add one technical metric or architecture note to each project description
- [ ] Replace marketing language with research-oriented copy for key projects

### Task 7: Contact section

- [ ] Add explicit "Open to 2026 Summer Research at NUS / NTU" line
- [ ] Replace emoji in buttons with SVG icons
- [ ] Add PolyU email alongside Gmail
- [ ] Fix GitHub button icon

### Task 8: Performance + mobile

- [ ] Verify no `cursor: none` leaks to mobile
- [ ] Add `loading="lazy"` where relevant
- [ ] Ensure nav hamburger menu or links visible on mobile

---

## Chunk 2: Playwright Testing

### Task 9: Visual + functional tests

- [ ] Navigate to file:// and take full-page screenshot
- [ ] Verify no loading screen
- [ ] Verify hero badge text "NUS / NTU"
- [ ] Verify CV download button present
- [ ] Verify Research section appears before Skills in DOM order
- [ ] Verify paper titles and venues visible
- [ ] Mobile viewport test (390px)
- [ ] Check cursor CSS scoped to pointer:fine
- [ ] Check no console JS errors
- [ ] Check all nav links scroll correctly
