# Popularity Check Report-book

A static, dependency-free report-book for a seven-candidate popularity check.

## Run
    python3 serve.py          # opens http://localhost:8080
    python3 serve.py 9000     # custom port

(Node alternative: `npx serve .`) Opening index.html straight from disk will not work, because the page fetches data/report.json.

## Edit content
Everything is in `data/report.json`: meta, candidates (with infobox fields), segments, analyst notes, interview voices (bulleted), actions and method notes. Refresh the browser after saving.

## Controls
Left/right arrow keys turn pages. Click a candidate card for the dossier. Print (side rail) saves the whole book as a PDF.

## Structure
    index.html   shell
    css/style.css   design tokens, transitions, print rules
    js/app.js    chapter renderers, page-turn wipe, dossier drawer
    data/report.json   all content (sample data)
    serve.py     local server with no-cache headers

Fonts load from Google Fonts when online and fall back to system fonts offline.
