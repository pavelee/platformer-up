shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	UV.x += TIME * 0.3;
	UV.y += TIME * 0.3;
}