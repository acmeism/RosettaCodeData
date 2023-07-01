import bpy

# select default cube
bpy.data.objects['Cube'].select_set(True)

# delete default cube
bpy.ops.object.delete(True)

# add text to Blender scene
bpy.data.curves.new(type="FONT", name="Font Curve").body = "Hello World"
font_obj = bpy.data.objects.new(name="Font Object", object_data=bpy.data.curves["Font Curve"])
bpy.context.scene.collection.objects.link(font_obj)

# camera center to text
bpy.context.scene.camera.location = (2.5,0.3,10)

# camera orient angle to text
bpy.context.scene.camera.rotation_euler = (0,0,0)

# change 3D scene to view from the camera
area = next(area for area in bpy.context.screen.areas if area.type == 'VIEW_3D')
area.spaces[0].region_3d.view_perspective = 'CAMERA'
