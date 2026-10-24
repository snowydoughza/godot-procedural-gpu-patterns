class_name StationData
extends RefCounted

enum MeshType {
	PLANE,
	TORUS,
	SPHERE,
	CYLINDER,
	BOX
}

static func get_mesh(type: MeshType) -> Mesh:
	match type:
		MeshType.PLANE:
			var plane := PlaneMesh.new()
			plane.size = Vector2(2.4, 2.4)
			plane.subdivide_width = 127
			plane.subdivide_depth = 127
			return plane
		MeshType.TORUS:
			var torus := TorusMesh.new()
			torus.inner_radius = 0.5
			torus.outer_radius = 1.1
			torus.rings = 128
			torus.ring_segments = 64
			return torus
		MeshType.SPHERE:
			var sphere := SphereMesh.new()
			sphere.radius = 1.0
			sphere.height = 2.0
			sphere.radial_segments = 64
			sphere.rings = 32
			return sphere
		MeshType.CYLINDER:
			var cyl := CylinderMesh.new()
			cyl.top_radius = 0.9
			cyl.bottom_radius = 0.9
			cyl.height = 2.0
			cyl.radial_segments = 64
			cyl.rings = 32
			return cyl
		MeshType.BOX:
			var box := BoxMesh.new()
			box.size = Vector3(1.8, 1.8, 1.8)
			box.subdivide_width = 32
			box.subdivide_height = 32
			box.subdivide_depth = 32
			return box
	return PlaneMesh.new()

static func get_station_definitions() -> Array[Dictionary]:
	return [
		# 01 - Sine Waves
		{
			"id": "sine_waves",
			"number": "01",
			"title": "Sine Waves & Interference",
			"subtitle": "Jasper Flick: 01-Sine Waves & 02-2D Waves",
			"description": "Fundamental procedural GPU waves. Calculates 1D/2D wave functions (U, V, Average, Product) with analytical normal derivatives and vertex displacement along surface normals.",
			"shader_path": "res://sine_waves/sine_waves.gdshader",
			"default_mesh": MeshType.PLANE,
			"default_params": {
				"function": 3,
				"displacement": 0.25,
				"bumpiness": Vector2(0.5, 0.5),
				"base_frequency": Vector2(3.0, 3.0),
				"octaves": 1,
				"lacunarity": 2.0,
				"persistence": 0.5,
				"base_animation": Vector2(0.2, 0.2),
				"temporal_lacunarity": Vector2(1.5, 1.25),
				"adaptive_fractal_scale": true,
				"colors_per_vertex": false,
				"vertex_displacement": true,
				"derivatives_per_vertex": false
			},
			"controls": [
				{
					"name": "function",
					"label": "Wave Function",
					"type": "enum",
					"options": ["U Wave", "V Wave", "UV Average", "UV Product"]
				},
				{
					"name": "base_frequency",
					"component": "x",
					"label": "Frequency X",
					"type": "slider",
					"min": 0.5,
					"max": 12.0,
					"step": 0.5
				},
				{
					"name": "base_frequency",
					"component": "y",
					"label": "Frequency Y",
					"type": "slider",
					"min": 0.5,
					"max": 12.0,
					"step": 0.5
				},
				{
					"name": "displacement",
					"label": "Displacement Amplitude",
					"type": "slider",
					"min": 0.0,
					"max": 1.0,
					"step": 0.02
				},
				{
					"name": "bumpiness",
					"component": "xy",
					"label": "Normal Bumpiness",
					"type": "slider",
					"min": 0.0,
					"max": 2.0,
					"step": 0.05
				},
				{
					"name": "base_animation",
					"component": "xy",
					"label": "Animation Speed",
					"type": "slider",
					"min": 0.0,
					"max": 1.0,
					"step": 0.02
				},
				{
					"name": "vertex_displacement",
					"label": "Physical 3D Displacement",
					"type": "bool"
				},
				{
					"name": "colors_per_vertex",
					"label": "Vertex Color Overlay",
					"type": "bool"
				}
			],
			"presets": [
				{
					"name": "Interference Grid",
					"params": {
						"function": 3,
						"base_frequency": Vector2(4.0, 4.0),
						"displacement": 0.3,
						"bumpiness": Vector2(0.6, 0.6),
						"base_animation": Vector2(0.2, 0.2),
						"vertex_displacement": true
					}
				},
				{
					"name": "1D Transverse Ripple",
					"params": {
						"function": 0,
						"base_frequency": Vector2(5.0, 1.0),
						"displacement": 0.35,
						"bumpiness": Vector2(0.8, 0.8),
						"base_animation": Vector2(0.3, 0.0),
						"vertex_displacement": true
					}
				},
				{
					"name": "Diagonal Wave",
					"params": {
						"function": 2,
						"base_frequency": Vector2(3.0, 3.0),
						"displacement": 0.25,
						"bumpiness": Vector2(0.5, 0.5),
						"base_animation": Vector2(0.25, 0.25),
						"vertex_displacement": true
					}
				},
				{
					"name": "Gentle Swell",
					"params": {
						"function": 2,
						"base_frequency": Vector2(1.5, 1.5),
						"displacement": 0.15,
						"bumpiness": Vector2(0.3, 0.3),
						"base_animation": Vector2(0.1, 0.1),
						"vertex_displacement": true
					}
				}
			]
		},

		# 02 - Fractal Waves
		{
			"id": "fractal_waves",
			"number": "02",
			"title": "Fractal Octaves & Waves",
			"subtitle": "Jasper Flick: 03-Fractal Waves & 06-Animating Octaves",
			"description": "Layered fractal harmonic waves. Successive octaves scale in frequency (lacunarity) and decay in amplitude (persistence), with temporal lacunarity speeding up higher frequency micro-ripples.",
			"shader_path": "res://sine_waves/sine_waves.gdshader",
			"default_mesh": MeshType.PLANE,
			"default_params": {
				"function": 3,
				"displacement": 0.3,
				"bumpiness": Vector2(0.6, 0.6),
				"base_frequency": Vector2(2.0, 2.0),
				"octaves": 4,
				"lacunarity": 2.0,
				"persistence": 0.5,
				"base_animation": Vector2(0.12, 0.12),
				"temporal_lacunarity": Vector2(1.6, 1.4),
				"adaptive_fractal_scale": true,
				"colors_per_vertex": false,
				"vertex_displacement": true
			},
			"controls": [
				{
					"name": "octaves",
					"label": "Octave Count",
					"type": "slider",
					"min": 1,
					"max": 6,
					"step": 1
				},
				{
					"name": "lacunarity",
					"label": "Lacunarity (Freq Multiplier)",
					"type": "slider",
					"min": 1.2,
					"max": 3.5,
					"step": 0.1
				},
				{
					"name": "persistence",
					"label": "Persistence (Amp Multiplier)",
					"type": "slider",
					"min": 0.1,
					"max": 0.9,
					"step": 0.05
				},
				{
					"name": "displacement",
					"label": "Wave Amplitude",
					"type": "slider",
					"min": 0.0,
					"max": 1.0,
					"step": 0.02
				},
				{
					"name": "base_animation",
					"component": "xy",
					"label": "Animation Speed",
					"type": "slider",
					"min": 0.0,
					"max": 0.5,
					"step": 0.02
				},
				{
					"name": "adaptive_fractal_scale",
					"label": "Adaptive Fractal Scale",
					"type": "bool"
				},
				{
					"name": "vertex_displacement",
					"label": "Vertex 3D Waves",
					"type": "bool"
				}
			],
			"presets": [
				{
					"name": "Turbulent Ocean",
					"params": {
						"octaves": 5,
						"lacunarity": 2.1,
						"persistence": 0.55,
						"displacement": 0.38,
						"base_animation": Vector2(0.15, 0.15),
						"temporal_lacunarity": Vector2(1.7, 1.5)
					}
				},
				{
					"name": "Single Low Swell",
					"params": {
						"octaves": 1,
						"lacunarity": 2.0,
						"persistence": 0.5,
						"displacement": 0.25,
						"base_animation": Vector2(0.1, 0.1)
					}
				},
				{
					"name": "Choppy Storm",
					"params": {
						"octaves": 4,
						"lacunarity": 2.8,
						"persistence": 0.6,
						"displacement": 0.28,
						"base_animation": Vector2(0.2, 0.2)
					}
				},
				{
					"name": "Silky Organic Shimmer",
					"params": {
						"octaves": 3,
						"lacunarity": 1.8,
						"persistence": 0.35,
						"displacement": 0.15,
						"base_animation": Vector2(0.08, 0.08)
					}
				}
			]
		},

		# 03 - Hashing Matrix
		{
			"id": "hashing_matrix",
			"number": "03",
			"title": "GPU xxHash32 Matrix",
			"subtitle": "Jasper Flick: 04-Hashing",
			"description": "Massively parallel xxHash32 on the GPU. Demonstrates deterministic pseudo-random values generated per-fragment with 1D Grayscale, 2D Vector (RG), and 3D Color (RGB) projections plus fractal octaves.",
			"shader_path": "res://hashing/hashing.gdshader",
			"default_mesh": MeshType.PLANE,
			"default_params": {
				"hash_seed": 42,
				"visualization": 2,
				"staggered_animation": true,
				"base_frequency": 12.0,
				"octaves": 1,
				"lacunarity": 2.0,
				"persistence": 0.5,
				"base_animation": 1.5,
				"temporal_lacunarity": 2.0,
				"adaptive_fractal_scale": true
			},
			"controls": [
				{
					"name": "visualization",
					"label": "Visualization Mode",
					"type": "enum",
					"options": ["Grayscale (1D)", "RG Vectors (2D)", "RGB Colors (3D)"]
				},
				{
					"name": "base_frequency",
					"label": "Grid Density / Frequency",
					"type": "slider",
					"min": 2.0,
					"max": 48.0,
					"step": 1.0
				},
				{
					"name": "base_animation",
					"label": "Step Speed",
					"type": "slider",
					"min": 0.0,
					"max": 6.0,
					"step": 0.2
				},
				{
					"name": "octaves",
					"label": "Fractal Octaves",
					"type": "slider",
					"min": 1,
					"max": 4,
					"step": 1
				},
				{
					"name": "staggered_animation",
					"label": "Checkerboard Stagger",
					"type": "bool"
				},
				{
					"name": "hash_seed",
					"label": "Hash Seed",
					"type": "slider",
					"min": 0,
					"max": 500,
					"step": 1
				}
			],
			"presets": [
				{
					"name": "RGB Cyber Matrix",
					"params": {
						"visualization": 2,
						"base_frequency": 16.0,
						"octaves": 1,
						"base_animation": 2.5,
						"staggered_animation": true
					}
				},
				{
					"name": "Fractal White Noise",
					"params": {
						"visualization": 0,
						"base_frequency": 4.0,
						"octaves": 4,
						"lacunarity": 2.0,
						"persistence": 0.5,
						"base_animation": 1.0
					}
				},
				{
					"name": "2D Motion Vectors (RG)",
					"params": {
						"visualization": 1,
						"base_frequency": 10.0,
						"octaves": 1,
						"base_animation": 1.0,
						"staggered_animation": true
					}
				},
				{
					"name": "Coarse Voxel Quilt",
					"params": {
						"visualization": 2,
						"base_frequency": 4.0,
						"octaves": 1,
						"base_animation": 0.8,
						"staggered_animation": false
					}
				}
			]
		},

		# 04 - Value Noise & Interpolations
		{
			"id": "value_noise",
			"number": "04",
			"title": "Value Noise & Derivatives",
			"subtitle": "Jasper Flick: 07-Value Noise & 08-Value Noise Derivatives",
			"description": "Lattice value noise interpolated across coordinates. Toggle between Step (voxels), Linear (faceted), Smooth (Hermite curve), and Smoother (Perlin quintic) with real-time analytical derivatives for surface normals.",
			"shader_path": "res://value_noise/value_noise.gdshader",
			"default_mesh": MeshType.PLANE,
			"default_params": {
				"tiling": false,
				"animation": true,
				"slide_velocity": Vector2(0.15, 0.08),
				"colored": true,
				"color_min": Color(0.1, 0.25, 0.65, 1.0),
				"color_mid": Color(0.15, 0.55, 0.25, 1.0),
				"color_max": Color(0.95, 0.95, 0.9, 1.0),
				"smoothness": 3,
				"bumpiness": Vector2(0.5, 0.5),
				"displacement": 0.45,
				"vertex_displacement": true,
				"curl_strength": 0.0,
				"curl_frequency": Vector2(1.0, 1.0),
				"curl_octaves": 1,
				"curl_animation": 0.0,
				"pattern_seed": 0,
				"base_frequency": Vector2(5.0, 5.0),
				"octaves": 3,
				"lacunarity": 2.0,
				"persistence": 0.5,
				"base_animation": 0.5,
				"temporal_lacunarity": 2.0,
				"adaptive_fractal_scale": true
			},
			"controls": [
				{
					"name": "smoothness",
					"label": "Interpolation Mode",
					"type": "enum",
					"options": ["Step (Voxel/Blocky)", "Linear (Faceted)", "Smooth (Hermite)", "Smoother (Quintic)"]
				},
				{
					"name": "displacement",
					"label": "Terrain Displacement",
					"type": "slider",
					"min": 0.0,
					"max": 1.0,
					"step": 0.02
				},
				{
					"name": "bumpiness",
					"component": "xy",
					"label": "Normal Bumpiness",
					"type": "slider",
					"min": 0.0,
					"max": 1.5,
					"step": 0.05
				},
				{
					"name": "octaves",
					"label": "Octaves",
					"type": "slider",
					"min": 1,
					"max": 4,
					"step": 1
				},
				{
					"name": "slide_velocity",
					"component": "xy",
					"label": "Slide Drift Speed",
					"type": "slider",
					"min": 0.0,
					"max": 0.6,
					"step": 0.02
				},
				{
					"name": "colored",
					"label": "Color Gradient Ramp",
					"type": "bool"
				},
				{
					"name": "color_min",
					"label": "Valleys (Min Color)",
					"type": "color"
				},
				{
					"name": "color_mid",
					"label": "Slopes (Mid Color)",
					"type": "color"
				},
				{
					"name": "color_max",
					"label": "Peaks (Max Color)",
					"type": "color"
				}
			],
			"presets": [
				{
					"name": "Lush Alpine Terrain",
					"params": {
						"smoothness": 3,
						"displacement": 0.5,
						"octaves": 3,
						"colored": true,
						"color_min": Color(0.1, 0.3, 0.7),
						"color_mid": Color(0.2, 0.65, 0.25),
						"color_max": Color(0.95, 0.95, 1.0),
						"slide_velocity": Vector2(0.1, 0.05)
					}
				},
				{
					"name": "Voxel World (Step)",
					"params": {
						"smoothness": 0,
						"displacement": 0.45,
						"octaves": 2,
						"colored": true,
						"color_min": Color(0.3, 0.2, 0.1),
						"color_mid": Color(0.4, 0.75, 0.2),
						"color_max": Color(0.8, 0.85, 0.9),
						"slide_velocity": Vector2(0.08, 0.04)
					}
				},
				{
					"name": "Faceted Crystals (Linear)",
					"params": {
						"smoothness": 1,
						"displacement": 0.4,
						"octaves": 3,
						"colored": true,
						"color_min": Color(0.5, 0.1, 0.5),
						"color_mid": Color(0.1, 0.7, 0.8),
						"color_max": Color(1.0, 0.9, 0.95),
						"slide_velocity": Vector2(0.1, 0.05)
					}
				},
				{
					"name": "Volcanic Magma",
					"params": {
						"smoothness": 3,
						"displacement": 0.4,
						"octaves": 4,
						"colored": true,
						"color_min": Color(0.15, 0.02, 0.02),
						"color_mid": Color(0.9, 0.25, 0.0),
						"color_max": Color(1.0, 0.95, 0.3),
						"slide_velocity": Vector2(0.12, 0.06)
					}
				}
			]
		},

		# 05 - Tiling & Toroidal Wrap
		{
			"id": "tiling_noise",
			"number": "05",
			"title": "Seamless Tiling & Torus",
			"subtitle": "Jasper Flick: 09-Tiling Noise",
			"description": "Seamless periodic lattice modulo arithmetic. Eliminates edge boundary discontinuities so textures repeat infinitely and wrap seamlessly onto closed manifolds like Torus and Cylinders.",
			"shader_path": "res://value_noise/value_noise.gdshader",
			"default_mesh": MeshType.TORUS,
			"default_params": {
				"tiling": true,
				"animation": true,
				"slide_velocity": Vector2(0.1, 0.15),
				"colored": true,
				"color_min": Color(0.9, 0.1, 0.2, 1.0),
				"color_mid": Color(0.1, 0.1, 0.15, 1.0),
				"color_max": Color(0.2, 0.85, 0.95, 1.0),
				"smoothness": 3,
				"bumpiness": Vector2(0.4, 0.6),
				"displacement": 0.25,
				"vertex_displacement": true,
				"curl_strength": 0.0,
				"base_frequency": Vector2(6.0, 4.0),
				"octaves": 3,
				"lacunarity": 2.0,
				"persistence": 0.5,
				"base_animation": 0.25,
				"temporal_lacunarity": 2.0,
				"adaptive_fractal_scale": true
			},
			"controls": [
				{
					"name": "tiling",
					"label": "Seamless Periodic Tiling",
					"type": "bool"
				},
				{
					"name": "displacement",
					"label": "Displacement Height",
					"type": "slider",
					"min": 0.0,
					"max": 0.6,
					"step": 0.02
				},
				{
					"name": "base_frequency",
					"component": "x",
					"label": "Integer Frequency X",
					"type": "slider",
					"min": 2,
					"max": 12,
					"step": 2
				},
				{
					"name": "base_frequency",
					"component": "y",
					"label": "Integer Frequency Y",
					"type": "slider",
					"min": 2,
					"max": 12,
					"step": 2
				},
				{
					"name": "slide_velocity",
					"component": "y",
					"label": "Circulation Slide Speed",
					"type": "slider",
					"min": 0.0,
					"max": 0.5,
					"step": 0.02
				},
				{
					"name": "colored",
					"label": "Color Gradient",
					"type": "bool"
				}
			],
			"presets": [
				{
					"name": "Seamless Torus Ring",
					"params": {
						"tiling": true,
						"base_frequency": Vector2(6.0, 4.0),
						"displacement": 0.25,
						"slide_velocity": Vector2(0.08, 0.16)
					}
				},
				{
					"name": "Broken Seam (Tiling OFF)",
					"params": {
						"tiling": false,
						"base_frequency": Vector2(5.0, 3.0),
						"displacement": 0.25,
						"slide_velocity": Vector2(0.1, 0.1)
					}
				},
				{
					"name": "High Density Banding",
					"params": {
						"tiling": true,
						"base_frequency": Vector2(10.0, 6.0),
						"displacement": 0.2,
						"slide_velocity": Vector2(0.12, 0.2)
					}
				},
				{
					"name": "Calm Planetary Donut",
					"params": {
						"tiling": true,
						"base_frequency": Vector2(4.0, 2.0),
						"displacement": 0.12,
						"slide_velocity": Vector2(0.04, 0.08)
					}
				}
			]
		},

		# 06 - Curled Noise & Domain Warping
		{
			"id": "curled_noise",
			"number": "06",
			"title": "Curled Noise & Domain Warping",
			"subtitle": "Jasper Flick: 10-Curled Noise",
			"description": "Catlike Coding pinnacle tutorial: Curl Noise & Domain Warping! Uses analytical derivatives of an underlying noise field as tangential flow vectors to curl the coordinates of the main noise, simulating fluid vortices and cosmic swirls.",
			"shader_path": "res://value_noise/value_noise.gdshader",
			"default_mesh": MeshType.TORUS,
			"default_params": {
				"tiling": true,
				"animation": true,
				"slide_velocity": Vector2(0.05, 0.1),
				"colored": true,
				"color_min": Color(0.95, 0.15, 0.1, 1.0),
				"color_mid": Color(0.05, 0.05, 0.1, 1.0),
				"color_max": Color(0.2, 0.9, 0.95, 1.0),
				"smoothness": 3,
				"bumpiness": Vector2(0.3, 0.6),
				"displacement": 0.25,
				"vertex_displacement": true,
				"curl_strength": 0.35,
				"curl_frequency": Vector2(4.0, 2.0),
				"curl_octaves": 2,
				"curl_animation": 1.0,
				"pattern_seed": 0,
				"base_frequency": Vector2(6.0, 4.0),
				"octaves": 3,
				"lacunarity": 2.0,
				"persistence": 0.5,
				"base_animation": 0.25,
				"temporal_lacunarity": 2.0,
				"adaptive_fractal_scale": true
			},
			"controls": [
				{
					"name": "curl_strength",
					"label": "Curl Vortex Strength",
					"type": "slider",
					"min": -1.0,
					"max": 1.0,
					"step": 0.05
				},
				{
					"name": "curl_frequency",
					"component": "x",
					"label": "Curl Frequency X",
					"type": "slider",
					"min": 1.0,
					"max": 8.0,
					"step": 0.5
				},
				{
					"name": "curl_octaves",
					"label": "Curl Octaves",
					"type": "slider",
					"min": 1,
					"max": 3,
					"step": 1
				},
				{
					"name": "curl_animation",
					"label": "Vortex Spin Speed",
					"type": "slider",
					"min": 0.0,
					"max": 3.0,
					"step": 0.1
				},
				{
					"name": "displacement",
					"label": "Surface Displacement",
					"type": "slider",
					"min": 0.0,
					"max": 0.8,
					"step": 0.02
				},
				{
					"name": "bumpiness",
					"component": "xy",
					"label": "Normal Bumpiness",
					"type": "slider",
					"min": 0.0,
					"max": 1.5,
					"step": 0.05
				},
				{
					"name": "tiling",
					"label": "Periodic Tiling",
					"type": "bool"
				},
				{
					"name": "color_min",
					"label": "Core Color",
					"type": "color"
				},
				{
					"name": "color_mid",
					"label": "Medium Color",
					"type": "color"
				},
				{
					"name": "color_max",
					"label": "Highlight Color",
					"type": "color"
				}
			],
			"presets": [
				{
					"name": "Cosmic Nebular Swirls",
					"params": {
						"curl_strength": 0.45,
						"curl_frequency": Vector2(4.0, 2.0),
						"curl_octaves": 2,
						"curl_animation": 1.2,
						"displacement": 0.28,
						"color_min": Color(0.9, 0.1, 0.4),
						"color_mid": Color(0.05, 0.02, 0.15),
						"color_max": Color(0.3, 0.95, 1.0)
					}
				},
				{
					"name": "Jupiter Bands",
					"params": {
						"curl_strength": 0.35,
						"curl_frequency": Vector2(2.0, 6.0),
						"curl_octaves": 2,
						"curl_animation": 0.5,
						"displacement": 0.15,
						"color_min": Color(0.8, 0.4, 0.2),
						"color_mid": Color(0.4, 0.2, 0.1),
						"color_max": Color(0.95, 0.9, 0.7)
					}
				},
				{
					"name": "Violent Plasma Vortex",
					"params": {
						"curl_strength": -0.65,
						"curl_frequency": Vector2(5.0, 3.0),
						"curl_octaves": 3,
						"curl_animation": 2.0,
						"displacement": 0.35,
						"color_min": Color(0.1, 0.0, 0.3),
						"color_mid": Color(0.0, 0.8, 0.9),
						"color_max": Color(1.0, 1.0, 0.4)
					}
				},
				{
					"name": "Subtle Liquid Flow",
					"params": {
						"curl_strength": 0.15,
						"curl_frequency": Vector2(3.0, 2.0),
						"curl_octaves": 1,
						"curl_animation": 0.4,
						"displacement": 0.18,
						"color_min": Color(0.05, 0.2, 0.4),
						"color_mid": Color(0.1, 0.4, 0.6),
						"color_max": Color(0.7, 0.95, 1.0)
					}
				}
			]
		}
	]
