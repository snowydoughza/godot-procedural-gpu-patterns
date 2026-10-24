# Procedural GPU Patterns

[This is a tutorial series](https://catlikecoding.com/godot/procedural-gpu-patterns/) that is about creating procedural patterns with shader, with Godot Engine 4.

It is assumed that you went through at least the first four parts of the [Introduction series](https://catlikecoding.com/godot/introduction) or are familiar with Godot Engine 4 and have written a shader before.

Each Individual tutorial has its own numbered folder.

## Tutorials

1. [Sine Waves](https://catlikecoding.com/godot/procedural-gpu-patterns/01-sine-waves/)
2. [2D Waves](https://catlikecoding.com/godot/procedural-gpu-patterns/02-2d-waves/)
3. [Fractal Waves](https://catlikecoding.com/godot/procedural-gpu-patterns/03-fractal-waves/)
4. [Hashing](https://catlikecoding.com/godot/procedural-gpu-patterns/04-hashing/)
5. [Shader Library](https://catlikecoding.com/godot/procedural-gpu-patterns/05-shader-library/)
6. [Animating Octaves](https://catlikecoding.com/godot/procedural-gpu-patterns/06-animating-octaves/)
7. [Value Noise](https://catlikecoding.com/godot/procedural-gpu-patterns/07-value-noise/)
8. [Value Noise Derivatives](https://catlikecoding.com/godot/procedural-gpu-patterns/08-value-noise-derivatives/)
9. [Tiling Noise](https://catlikecoding.com/godot/procedural-gpu-patterns/09-tiling-noise/)
10. [Curled Noise](https://catlikecoding.com/godot/procedural-gpu-patterns/10-curled-noise/)

## 3D First-Person Exhibition & Room Simulator

A 3D first-person gallery where you can walk around an exhibition hall and experiment with all procedural GPU patterns on interactive sandbox tables in real time.

### Quick Start
Launch via terminal:
```bash
./run_room_sim.sh
```
Or open **Godot 4** and open the project in `10-curled-noise/`. The main scene is set to `res://room_sim/room.tscn`.

### Controls
- **W, A, S, D / Arrow Keys**: Move
- **Mouse**: Look around
- **Shift**: Sprint
- **Space**: Jump
- **E / Left Click**: Inspect table when looking at it
- **Tab / ESC**: Toggle mouse cursor capture
- **ESC / E**: Close inspector and resume walking

### Experiment Stations
1. **01. Sine Waves & Interference**: Fundamental 1D/2D wave functions (U, V, Average, Product), normal derivatives, and 3D vertex displacement.
2. **02. Fractal Octaves & Waves**: Multi-scale octave layering, lacunarity, persistence, and temporal lacunarity for organic ocean turbulence.
3. **03. GPU xxHash32 Matrix**: Parallel GPU pseudo-random hash generator with 1D Grayscale, 2D Vector (RG), and 3D Color (RGB) visualizations.
4. **04. Value Noise & Derivatives**: Lattice noise interpolation (Step voxels, Linear facets, Hermite smooth, and Perlin quintic smoother) with analytical normal derivatives.
5. **05. Seamless Tiling & Torus**: Boundary-free periodic lattice modulo math wrapping onto Torus and Plane meshes.
6. **06. Curled Noise & Domain Warping**: Pinnacle curl noise using analytical noise derivatives to dynamically curl and swirl sampling coordinates into fluid vortices.

Each station features:
- Live parameter sliders (frequencies, amplitudes, octaves, speeds, curl strength).
- Instant shape switcher (Subdivided Plane, Torus, Sphere, Cylinder, Cube).
- Curated presets for instant dynamic visual effects.
- Auto-rotation toggle.

This is a work in progress. More parts will be added in due time.

## Giving Credit

If you want to credit me in your work you can do so by mentioning [Jasper Flick](https://catlikecoding.com/jasper-flick/) and/or [Catlike Coding](https://catlikecoding.com).
