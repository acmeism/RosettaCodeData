import bpy
import math
bpy.context.preferences.edit.keyframe_new_interpolation_type="LINEAR"
bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete()
bpy.ops.mesh.primitive_cube_add()
bpy.context.active_object.name="spinningcube"
spinningcube=bpy.data.objects["spinningcube"]
spinningcube.rotation_euler=(math.radians(45),math.radians(35.264),math.radians(0))
spinningcube.keyframe_insert(data_path="rotation_euler",frame=1)
spinningcube.rotation_euler=(math.radians(45),math.radians(35.264),math.radians(2700))
spinningcube.keyframe_insert(data_path="rotation_euler",frame=250)
bpy.context.scene.frame_set(1)
bpy.ops.screen.animation_play()
