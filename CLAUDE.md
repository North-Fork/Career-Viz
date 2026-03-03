Purpose of this project is to visualize the themes in Jason Lewis' career.

This project draws on data gathered as part of the Timeline project. Look at dev notes in there for background.

---

## Data Source

**File used:** `data/cv-data-enriched.js` — a copy of (or symlink to) the enriched CV data produced by the Timeline-JEL pipeline.

**How cv-data-enriched.js is generated** (all scripts in `Timeline/Timeline-JEL/data/cv-data/`):

1. CV source text lives in `cv.txt` (manually maintained) and three published Google Docs:
   - Research-Creation: https://docs.google.com/document/d/e/2PACX-1vRIeY4A3fbqJj29GP2yT0FpJkoPOLiLVqaOqPuIUDuJOjXLGwM0jEuS2WGb_daBLY8dCEuooURhz-5D/pub
   - Funding: https://docs.google.com/document/d/e/2PACX-1vTitfLMisxZ3NcqdLOIsf4Bsj_qSuMfuj6vh2N3d86ZjHyy4FlXx0cRIgGWdEhoerPLjs7rgVn75XNL/pub
   - Teaching & Service: https://docs.google.com/document/d/e/2PACX-1vQXdHyfjF3YivP2hM8Tf81qiasZymZKN4edMZFK3Rp7cq1O__opAvx0iFqdvK-xFzH5duKBb4Eo3Xt6/pub

2. `generate_cv_xlsx.py` → converts `cv.txt` to `cv.xlsx`
3. `make_cv_data_js.py` → converts `cv.xlsx` to `cv-data.js` (sets `window.__TIMELINE_DATA__`)
4. `enrich_cv.py` → calls Claude API (Haiku) to add themes/concepts/collaborators → `cv-data-enriched.js`
   - Uses `enrich-cache.json` to avoid re-calling the API on unchanged entries
   - Optionally uses PDFs in a `--pdf-dir` to enrich Books/Chapters, Journal Articles, Honors entries

**Data shape** (each entry in `window.__TIMELINE_DATA__`):

```js
{
  "start date": "MM/DD/YYYY",
  "end date":   "MM/DD/YYYY",
  "headline":   "...",
  "description": "...",
  "group":      "Employment | Books/Chapters | Journal Articles | ...",
  "org":        "...",
  "program":    "...",
  "project":    "...",
  "themes":     ["Indigenous digital sovereignty", "Electronic literature", ...],
  "concepts":   ["...", ...],
  "collaborators": ["...", ...]
}
```

**To refresh data:** re-run the pipeline in `Timeline/Timeline-JEL/data/cv-data/`, then copy the resulting `cv-data-enriched.js` into `Career-Viz/data/`.

---

## Conceptual Reading of the Career

The enriched theme tags are a keyword index, not a reading. The deeper structure:

**The master metaphor is Territory.**
AbTeC = Aboriginal Territories in Cyberspace. PoEMM = letters that inhabit a screen like they own it.
Language revitalization = keeping a tongue alive so it can hold ground. The research chair =
*Indigenous Future Imaginary*. Every project is a form of territory-making — claiming, inhabiting,
and reshaping space that wasn't designed for you.

**Three deep tensions run through everything:**
1. **Living word vs. fixed system** — Can a medium be made to carry something it wasn't built for?
   (NextText, language revitalization, AI/creativity)
2. **Making vs. institution-building** — Objects (poems, installations) vs. infrastructure
   (NextText, AbTeC, research programs, policy). Both are the same thing at different scales.
3. **Individual voice vs. collective sovereignty** — The poet vs. the community. The single glyph
   on a phone screen vs. the governance framework.

**The shape of the career is a helix, not a network.**
The same concerns (territory, language, Indigenous futures, computation) return at larger and larger
scales: single letter on screen → poem → framework → research program → university policy →
shaping how AI treats Indigenous data. Time is the vertical axis; recurrence is the spiral.

---

## Planned Visualizations

Four approaches to try, each as a separate self-contained HTML file:

| # | File | Name | Description | Status |
|---|------|------|-------------|--------|
| 1 | `index.html` | Orbits | Force-directed network: nodes = themes; edges = co-occurrence; animated over time | Built |
| 2 | `helix.html` | Spiral | Time on vertical axis; recurring concerns spiral outward at growing scale | Built |
| 3 | `arc.html` | Arc | Above axis = collaborator span arcs (who); below = strand rhythm arcs (what) | Built |
| 4 | `constellation.html` | Stars | 949 particles drifting in 4 clusters; PoEMM-like physics; Grow animation | Built |

All four share a nav bar: Orbits / Spiral / Arc / Stars.

---

## Visualization Notes

### Orbits (`index.html`)
- D3 force-directed network; external CDN dependency (d3 v7)
- Nodes = themes, sized by entry count; edges = co-occurrence weight
- Dual-handle year range slider + ▶ Grow animation
- Core / Full toggle filters low-frequency themes

### Spiral (`helix.html`)
- Canvas 2D; no external dependencies
- 3D helix projected to 2D; slow auto-rotation (ROT_SPEED = 0.0016 rad/frame)
- 4 conceptual strands at 90° offsets; strand width varies with entry density
- Hover highlights full strand lifespan; Rotate / Pause buttons

### Arc (`arc.html`)
- SVG; no external dependencies
- **Above the timeline:** one span arc per collaborator (first → last year); activity dots on arc curve
- **Below the timeline:** strand arcs connect consecutive active years when gap ≥ 2 years
- Entry count per strand: territory 533, making 227, word 152, infrastructure 37
- Collaborator normalization handles name variants (Skawennati / Skawennati Fragnito, etc.)
- Heather Igloliorte (1985–2025, 40yr) is the tallest arc

### Stars (`constellation.html`)
- Canvas 2D; no external dependencies; ~949 particles
- Spring physics: each particle has a `homeX/homeY` within its cluster, spring constant 0.0022, damping 0.955
- **Cursor interaction:** tangential eddy force (NOT repulsion) — perpendicular to cursor→particle
  direction creates a gentle swirl; tiny radial nudge (0.04) prevents singularity at dist=0.
  Tried radial repulsion first but particles fled before you could click them.
- Constellation lines: spatial grid neighbor lookup (O(n)), recomputed every 25 frames; connect
  same-strand particles within 62px
- Birth flash: new particles appear white and fade to strand color over 45 frames
- ▶ Grow animation: 380ms per year step (1985→2026 ≈ 16s)
- Territory dominates (533 entries, spread radius 195px); cluster at W×0.42, H×0.45
- Infrastructure is smallest (37 entries, spread radius 72px); tight cluster at W×0.22, H×0.68

**Implementation approach:** self-contained single HTML file per visualization (no build step, no bundler).
Canvas 2D used for Spiral and Stars (animation/physics); SVG used for Arc (static paths).
