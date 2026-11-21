# ZeldaPirate-Clone: Project Notes

*Last updated: November 21, 2026 (end of session 1)*

---

## 1. The Project

A hand-coded Legend of Zelda 1–style game, built from scratch in **Lua** with the **LÖVE** framework.

- **Scope:** 64 overworld screens (8×8 grid) + 4 dungeons + a final island location
- **Approach:** Jordan writes all code and makes all assets personally, with step-by-step guidance
- **Guidance format:** pairs of two related steps, then a test. Each step has a short *why* and exactly what to type. Instructions get rewritten in full after any question, until Jordan confirms to move on.
- **Tools:** free tools only; authentic retro look, scaled up a little
- **Machine:** M5 Pro Mac, VS Code, Terminal (zsh)
- **Timeline:** none; picked up a few hours at a time

---

## 2. Story & Design

### Protagonist
- Known only as **"CC"** throughout the game
- Real name **Chloe Constantine**, revealed at the very end. "CC" is her initials, hidden in plain sight.
- Inspired by the Elizabeth Swann archetype: always fascinated by pirates, but never truly one. (Her own name and look keep her original.)
- Being female is meant to provide intrigue later

### The Quest
- Collect **four gold coins**, one dropped by each of the **four dungeon bosses**
- Each dungeon boss has a little history tied to its coin
- The **final boss** lives on a cursed island across the sea (a 5th location)
- The final boss is **immortal** until all four coins are returned to a **chest** in his lair
- Coins go into the chest **during the fight**, while dodging him
- Hits **visibly appear** to damage him (flash, recoil), but do nothing until the curse is broken
- *(Concept borrowed from Pirates of the Caribbean's cursed Aztec gold)*

### The Ship
- CC crosses the sea by **ship**
- The ship's owner **knew her as a child**, which ties into a small backstory (to be fleshed out)

### Opening Screen
- Has some **water**, and CC **always starts at the water's edge**
- Deliberately ambiguous: is she stranded, or there on purpose?

### Test Screens (first build target)
- **Screen 1:** opening shoreline screen + a place to get weapons/items
- **Screen 2:** combat and hitbox testing
- Build out from there

### Code Notes for the Story
- Her display name lives in one variable: starts as `"CC"`, switches to `"Chloe Constantine"` at the reveal
- The final boss has an `immortal` flag that turns off only when all four coins are in the chest. In the cursed state, the hit reaction still plays but the damage is skipped.

---

## 3. Technical Decisions

| Decision | Choice | Why |
|---|---|---|
| Language/engine | Lua + LÖVE 11.5 | Free, simple, great for 2D |
| Resolution | **320×240** virtual screen at **3×** (960×720 window) | NES pixel style with a wider playfield for testing |
| Tile size | **16×16** px | Zelda 1 standard |
| HUD height | **32** px | Smaller HUD; leaves a 208 px playfield |
| Playfield | **20 × 13 tiles** | Odd row count gives a true center row (doors, spawn, symmetry) |
| Minimap | Not in HUD (for now) | Could live on a pause screen; revisit if needed |
| Copilot | **Off** for this project | Jordan writes the code himself |
| Code style | Aligned `=` signs, 4-space indents, double quotes | Readability |

### Roadmap
0. ✅ Setup
1. ✅ Window / game loop / virtual screen
2. ⬜ **Player movement** ← *next*
3. ⬜ Tile room
4. ⬜ Wall collision (water tiles are a good first test)
5. ⬜ Screen scrolling + 8×8 overworld
6. ⬜ Sword / combat
7. ⬜ Enemies
8. ⬜ HUD: hearts, rupees, items
9. ⬜ Four dungeons
   - 9.5 ⬜ Sea crossing + island + final boss / coin chest
10. ⬜ Sound / music
11. ⬜ Title screen / save / polish

---

## 4. What's Set Up

### Software
- **LÖVE 11.5** in `/Applications/love.app`
  - Allowed past Gatekeeper via System Settings → Privacy & Security → **Open Anyway**
  - Alias in `~/.zshrc`: `alias love="/Applications/love.app/Contents/MacOS/love"`
- **VS Code**
  - **Lua** extension (by sumneko / LuaLS)
  - **LÖVE addon** enabled via the Addon Manager (autocomplete for `love.*`, no "undefined global" warnings)
  - **Format On Save** turned on
  - **GitHub Copilot** disabled for this workspace
  - `code` command installed in PATH (optional; lets you open folders from Terminal)
- **macOS:** "Add period with double-space" turned **off** (System Settings → Keyboard → Text Input → Edit)
- **Git:** configured with name, email, and default branch `main`

### GitHub
- Repository: **github.com/jordanoboyle/ZeldaPirate-Clone** (private)
- Connected over **HTTPS** with a **fine-grained personal access token**
  - Scoped to ZeldaPirate-Clone only, Contents: Read and write
  - **90-day expiry (around February 18, 2027).** When `git push` fails with "Invalid username or token," regenerate the token: GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens → token → **Regenerate token**
  - Saved in macOS Keychain

### Project Folder
```
~/Projects/ZeldaPirate-Clone/
├── .editorconfig
├── .git/              (hidden; Git's history, don't touch)
├── .vscode/           (VS Code settings for this project, from the LÖVE addon)
├── conf.lua
└── main.lua
```

---

## 5. Current Code

### `conf.lua`
```lua
function love.conf(t)
    t.window.title     = "CC"
    t.window.width     = 960
    t.window.height    = 720
    t.window.resizable = false
    t.window.vsync     = 1
end
```
- File must be named `conf.lua`, and the function must be exactly `love.conf`. A misspelling fails silently (the window opens at 800×600).
- `t` is just the conventional name for the settings table.

### `.editorconfig`
```ini
root = true

[*.lua]
indent_style                       = space
indent_size                        = 4
quote_style                        = double
align_continuous_assign_statement  = true
align_continuous_rect_table_field  = true
align_continuous_inline_comment    = true
```
- **Alignment quirk:** the formatter aligns a block of `=` signs once one line has **two or more spaces** before its `=`. If it misbehaves, align by hand.

### `main.lua`
```lua
-- Game resolution (the "virtual screen")
GAME_WIDTH  = 320
GAME_HEIGHT = 240
SCALE       = 3

-- Layout
HUD_HEIGHT  = 32
TILE_SIZE   = 16

function love.load()
    -- Keep pixels sharp when scaled up
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- The small canvas the whole game draws on
    canvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
end

function love.update(dt)
    -- Game logic goes here (empty for now)
end

function love.draw()
    -- 1. Draw the game onto the small canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0)

    -- HUD strip (dark gray)
    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, HUD_HEIGHT)

    -- Playfield (green)
    love.graphics.setColor(0.2, 0.6, 0.3)
    love.graphics.rectangle("fill", 0, HUD_HEIGHT, GAME_WIDTH, GAME_HEIGHT - HUD_HEIGHT)

    -- One tile-sized square in the middle of the playfield (stand-in for CC)
    local playfieldHeight = GAME_HEIGHT - HUD_HEIGHT
    local squareX         = (GAME_WIDTH - TILE_SIZE) / 2
    local squareY         = HUD_HEIGHT + (playfieldHeight - TILE_SIZE) / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", squareX, squareY, TILE_SIZE, TILE_SIZE)

    -- HUD text
    love.graphics.print("CC", 8, 8)

    love.graphics.setCanvas()

    -- 2. Draw the canvas onto the window, scaled up
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
```

---

## 6. Concepts Learned

### LÖVE
- **The game loop:** `love.load()` runs once at startup. Then `love.update(dt)` (logic) and `love.draw()` (drawing) run every frame, about 60 times a second. `dt` is the seconds since the last frame.
- **`conf.lua`** is read before `main.lua`, so window settings go there
- **Virtual screen:** draw everything on a small canvas (320×240), then scale it up. `"nearest"` filtering keeps pixels sharp.
- `setCanvas(canvas)` means draw on the canvas, and `setCanvas()` means back to the real window
- **Coordinates:** `(0, 0)` is the top-left, x increases going right, y increases going **down**
- **Colors** use values from 0 to 1, not 0 to 255
- **Centering:** (total space − object size) ÷ 2

### Lua
- `function name() ... end` defines a block. Lua uses `end` instead of curly braces.
- **ALL_CAPS** names are a convention for constants (values that never change)
- `local` variables only exist inside the function they're declared in

### Layout Math
- The screen is 240 px tall = **15 tiles** of 16 px
- The HUD must be a multiple of 16, so the playfield is too
- **Odd** row counts give a true center row

### Git vs. GitHub
- **Git** is a program on the Mac that takes snapshots (**commits**) of the project
- **GitHub** is a website that stores those snapshots online (backup and sharing)
- **GitHub Copilot** is an unrelated AI code assistant from the same company (turned off here)
- A **remote** (`origin`) is the GitHub copy of the repo
- **Staging** (`git add`) puts files in the box, and **committing** (`git commit`) takes the snapshot
- `origin/main` in `git log` shows where GitHub is. If it's behind, you haven't pushed yet.
- GitHub rejects account passwords from Terminal, so use a **personal access token** instead. It's shown only **once** when created.

---

## 7. Command Cheat Sheet

### Terminal Basics
| Command | What it does |
|---|---|
| `cd ~/Projects/ZeldaPirate-Clone` | Go to the project folder |
| `ls` / `ls -a` | List files / include hidden files |
| `mkdir -p path` | Make a folder (and any missing parent folders) |
| `mv old new` | Move or rename |
| `source ~/.zshrc` | Reload shell settings |
| **Ctrl + C** | Cancel a running command |
| **q** | Exit a scrolling view (`git log`, `git diff`) |

⚠️ `>>` **adds** to a file, and `>` **replaces** it.

### Running the Game
| Command | What it does |
|---|---|
| `love .` | Run the game in the current folder |
| `love --version` | Check the LÖVE version |
| **Escape** | Quit the game |

### VS Code
| Shortcut | What it does |
|---|---|
| **⌘ + S** | Save (and auto-format) |
| **Shift + Option + F** | Format the document manually |
| **⌘ + Shift + P** | Command Palette |
| **⌘ + Shift + X** | Extensions |
| **⌘ + ,** | Settings |
| **Ctrl + Space** | Trigger autocomplete manually |
| `code .` (Terminal) | Open the current folder in VS Code |

### Git: The Everyday Loop
```
git status                     # what changed?
git diff                       # see line-by-line changes (q to quit)
git add .                      # stage everything
git commit -m "Message"        # take the snapshot
git push                       # send it to GitHub
git log --oneline              # view history
```

### Git: One-Time Setup (already done)
```
git config --global user.name "Name"
git config --global user.email "email"
git config --global init.defaultBranch main
git config --global --list     # check settings
git init
git remote add origin https://github.com/jordanoboyle/ZeldaPirate-Clone.git
git push -u origin main
```
- **Skip** `git branch -M main`; the branch is already named `main`
- **To clear a bad saved GitHub login:**
  `printf "protocol=https\nhost=github.com\n\n" | git credential reject`

---

## 8. Commit History

| Commit | Message |
|---|---|
| `4dfa252` | First Window: Hello CC |
| … | Add conf.lua, formatter config, and start virtual screen setup |
| … | Finish virtual screen: 32px HUD, centered test tile |

---

## 9. Open Questions

- [ ] Which **edge** of the opening screen is the water on?
- [ ] Is **anything on the shore** with CC (debris, footprints, rowboat), or nothing?
- [ ] Do the **four coins** show in the HUD?
- [ ] **How** does CC get the ship? Who is the owner, and what's the connection?
- [ ] Is the **island** extra screens beyond the 64? (Leaning yes)
- [ ] **Art tool:** compile Aseprite (free) / buy Aseprite / Pixelorama (decide when art is needed)

---

## 10. Next Session

**Step 2: Player movement**
- The white square becomes CC
- Move with the arrow keys
- First real use of `love.update(dt)` (frame-rate-independent movement)

Start with:
```
cd ~/Projects/ZeldaPirate-Clone
code .
love .
```

---

## Sources

- LÖVE: https://love2d.org · Getting Started: https://love2d.org/wiki/Getting_Started · Config Files: https://love2d.org/wiki/Config_Files · Canvas: https://love2d.org/wiki/Canvas
- LuaLS formatter: https://luals.github.io/wiki/formatter · Addons: https://luals.github.io/wiki/addons
- EmmyLuaCodeStyle config: https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
- Git book: https://git-scm.com/book/en/v2
- GitHub tokens: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
- Apple, opening apps from unknown developers: https://support.apple.com/guide/mac-help/mh40616/mac
- Double-space period fix: Apple Support Community (user forum) and OSXDaily
