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
| 3 | `arc.html` | Arc diagram | Connects collaborators, projects, and ideas with arcs along a linear axis | Planned |
| 4 | `constellation.html` | Constellation / particle system | Entries as particles clustering by deep affinity, drifting like PoEMM glyphs | Planned |

**Helix design intent:** Show the career as a helix — same themes returning at larger scale over time.
Viewer should feel the *recurrence and growth*, not just see a static map. Entries orbit the helix
spine; themes are color-coded strands that wind upward. Hovering a strand shows all the moments
it appears and how it widens over time.

**Implementation approach:** self-contained single HTML file per visualization (no build step, no bundler).
Use Canvas 2D or WebGL only if it meaningfully improves visual quality over SVG/CSS — otherwise plain SVG is preferred.
