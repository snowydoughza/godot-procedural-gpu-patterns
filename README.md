# Procedural GPU Patterns — Interactive 3D Sandbox

> **Note**: This repository is an interactive fork of the original [godot-procedural-gpu-patterns](https://github.com/jasper-flick/godot-procedural-gpu-patterns) project by **Jasper Flick** ([Catlike Coding](https://catlikecoding.com/)).
>
> **What this fork adds:** A complete **first-person 3D room simulation & interactive sandbox lab** (styled like the research deck / bridge of the Starship Enterprise). Instead of only inspecting shaders in Godot's editor, you can walk around a 3D environment in real time, approach dedicated experiment tables, and live-tweak shader uniforms, swap geometries, and experiment with dynamic procedural GPU effects inside mini sandboxes.

---

## About the Original Tutorial Series

[Procedural GPU Patterns](https://catlikecoding.com/godot/procedural-gpu-patterns/) is an in-depth tutorial series by Jasper Flick about creating procedural patterns with Godot Engine 4 shaders.

It covers everything from fundamental sine waves and GPU hashing algorithms to analytical noise derivatives, seamless periodic tiling, and curl noise / domain warping.

### Tutorials
1. [Sine Waves](https://catlikecoding.com/godot/procedural-gpu-patterns/01-sine-waves/) — Fundamental 1D waves, displacement, and normal vectors.
2. [2D Waves](https://catlikecoding.com/godot/procedural-gpu-patterns/02-2d-waves/) — 2D wave functions (U, V, Average, and Product).
3. [Fractal Waves](https://catlikecoding.com/godot/procedural-gpu-patterns/03-fractal-waves/) — Superposition of harmonic octaves, lacunarity, and persistence.
4. [Hashing](https://catlikecoding.com/godot/procedural-gpu-patterns/04-hashing/) — GPU implementation of xxHash32 and pseudo-random numbers.
5. [Shader Library](https://catlikecoding.com/godot/procedural-gpu-patterns/05-shader-library/) — Modular shader includes (`.gdshaderinc`).
6. [Animating Octaves](https://catlikecoding.com/godot/procedural-gpu-patterns/06-animating-octaves/) — Temporal lacunarity and time-varying octaves.
7. [Value Noise](https://catlikecoding.com/godot/procedural-gpu-patterns/07-value-noise/) — Lattice value noise and interpolation curves (step, linear, smoothstep, smootherstep).
8. [Value Noise Derivatives](https://catlikecoding.com/godot/procedural-gpu-patterns/08-value-noise-derivatives/) — Analytical noise derivatives for accurate surface normals.
9. [Tiling Noise](https://catlikecoding.com/godot/procedural-gpu-patterns/09-tiling-noise/) — Periodic modulo arithmetic for seamless wrapping on manifolds (planes, toruses).
10. [Curled Noise](https://catlikecoding.com/godot/procedural-gpu-patterns/10-curled-noise/) — Domain warping with curl noise to create fluid vortices and swirling patterns.

Each individual tutorial retains its own numbered folder (`01-sine-waves/` through `10-curled-noise/`).

---

## What This Fork Adds: 3D Interactive Sandbox Lab

This fork builds upon Chapter 10's completed shader codebase by adding a **first-person 3D room simulation** where each shader concept from the series is brought to life on dedicated experiment consoles.

### Highlights & Sandbox Features
- **Walkable 3D Science Deck**: Explore a luminous, high-visibility Starship Enterprise bridge / science research lab with bright ambient illumination, glowing LCARS status conduits, and focused spotlights.
- **Dedicated Experiment Stations**: 6 interactive tables placed around the deck, each displaying hovering, rotating demo items demonstrating a distinct procedural GPU pattern.
- **Real-Time Parameter Control**: Walk up to any table and press `[E]` or Left-Click to open an LCARS-inspired control panel. Adjust frequencies, amplitudes, octave counts, curl strengths, animations, and color gradients with instant real-time feedback.
- **Dynamic Item Shapes**: Swap the demo object on any table on the fly between **Subdivided Plane**, **Torus**, **Sphere**, **Cylinder**, and **Cube** to observe how procedural displacement behaves on different 3D manifolds.
- **Curated Presets**: One-click instant presets for every station (e.g. *Turbulent Ocean*, *RGB Cyber Matrix*, *Lush Alpine Terrain*, *Voxel World*, *Jupiter Atmospheric Bands*, *Violent Plasma Vortex*).
- **Accessibility & Hard-of-Vision UI**: High-contrast, large-format typography (18px–24px UI, 54px–80px in-world 3D signage), chunky touch-friendly sliders, and clear visual indicators.
- **Flexible Mouse Controls**: Starts with the mouse cursor visible and unlocked so you never feel trapped. Easily look around by holding Right-Click or pressing `[Tab]` to toggle mouse capture mode.

---

### Quick Start

#### Via Terminal
```bash
./run_room_sim.sh
```

#### Via Godot Engine
1. Open **Godot 4** (4.x supported).
2. Import or open the project folder in [`10-curled-noise/`](10-curled-noise/project.godot).
3. Press **Play** (the startup scene is set to `res://room_sim/room.tscn`).

---

### Controls

| Action | Control |
|---|---|
| **Move** | `W`, `A`, `S`, `D` or `Arrow Keys` |
| **Look Around** | Move Mouse (when captured) or **Hold Right-Click + Drag** (when cursor free) |
| **Sprint** | `Shift` |
| **Jump** | `Space` |
| **Interact / Open Sandbox** | `E` or `Left-Click` (when aiming at an experiment station) |
| **Toggle Mouse Cursor** | `Tab`, `ESC`, or click the top-right HUD button |
| **Close Inspector** | `ESC`, `E`, or click **DONE** |

---

### The 6 Sandbox Experiment Stations

1. **Station 01 — Sine Waves & Interference**  
   *Jasper Flick: 01-Sine Waves & 02-2D Waves*  
   Experiment with 1D and 2D wave functions (`U`, `V`, `UV Average`, `UV Product`), normal derivatives, and 3D vertex displacement.
2. **Station 02 — Fractal Octaves & Waves**  
   *Jasper Flick: 03-Fractal Waves & 06-Animating Octaves*  
   Layer harmonic octaves to build complex ocean swells. Control lacunarity, persistence, and temporal lacunarity speeds.
3. **Station 03 — GPU xxHash32 Matrix**  
   *Jasper Flick: 04-Hashing*  
   Parallel pseudo-random hash generator running on the GPU. Switch between Grayscale (1D), Motion Vectors RG (2D), and Full RGB (3D) visualizer modes.
4. **Station 04 — Value Noise & Derivatives**  
   *Jasper Flick: 07-Value Noise & 08-Value Noise Derivatives*  
   Lattice noise interpolation sandbox. Compare `Step` (blocky voxels), `Linear` (faceted crystals), `Smooth` (Hermite), and `Smoother` (Perlin quintic) with analytical normal bump shading and terrain color ramps.
5. **Station 05 — Seamless Tiling & Torus**  
   *Jasper Flick: 09-Tiling Noise*  
   Seamless periodic lattice modulo arithmetic. Test seamless UV wrapping on Torus vs Plane geometries and toggle tiling to witness boundary seam artifacts.
6. **Station 06 — Curled Noise & Domain Warping**  
   *Jasper Flick: 10-Curled Noise*  
   Catlike Coding's pinnacle curl noise simulation. Analytical noise derivatives act as a tangent vector field to swirl sampling coordinates into cosmic eddies and fluid vortices.

---

## Giving Credit & Original Author

All procedural GPU pattern shader algorithms, mathematical formulas, and tutorial implementations are the work of **Jasper Flick** at [Catlike Coding](https://catlikecoding.com/).

- **Author**: Jasper Flick ([@catlikecoding](https://twitter.com/catlikecoding))
- **Website & Tutorials**: [https://catlikecoding.com/godot/procedural-gpu-patterns/](https://catlikecoding.com/godot/procedural-gpu-patterns/)
- **Upstream Repository**: [https://github.com/jasper-flick/godot-procedural-gpu-patterns](https://github.com/jasper-flick/godot-procedural-gpu-patterns)
- **Support Catlike Coding**: If you find these tutorials and shaders educational and valuable, consider supporting Jasper Flick on [Patreon](https://www.patreon.com/catlikecoding).

This fork was created to provide an interactive, hands-on 3D sandbox playground that lets learners and developers experiment with Catlike Coding's procedural patterns dynamically in real time.
