import bpy
import mathutils
from math import radians

if "Rotor" in bpy.data.objects:
    obj = bpy.data.objects["Rotor"] 
    obj.rotation_euler.z = obj.rotation_euler.z + radians(60.0)
    bpy.data.scenes[0].render.filepath = '/tmp/1'
    bpy.ops.render.render(animation=True)
    obj.rotation_euler.z = obj.rotation_euler.z + radians(90.0)        
    bpy.data.scenes[0].render.filepath = '/tmp/2'
    bpy.ops.render.render(animation=True)
    obj.rotation_euler.z = obj.rotation_euler.z + radians(120.0)   
    bpy.data.scenes[0].render.filepath = '/tmp/3'
    bpy.ops.render.render(animation=True)    
    obj.rotation_euler.z = obj.rotation_euler.z + radians(240.0)       
    bpy.data.scenes[0].render.filepath = '/tmp/4'
    bpy.ops.render.render(animation=True)   
    obj.rotation_euler.z = obj.rotation_euler.z + radians(270.0)       
    bpy.data.scenes[0].render.filepath = '/tmp/5'
    bpy.ops.render.render(animation=True)
    obj.rotation_euler.z = obj.rotation_euler.z + radians(300.0)       
    bpy.data.scenes[0].render.filepath = '/tmp/6'
    bpy.ops.render.render(animation=True)
    obj.rotation_euler.z = obj.rotation_euler.z + radians(0.0)       
    bpy.data.scenes[0].render.filepath = '/tmp/7'
    bpy.ops.render.render(animation=True)
    obj.rotation_euler.z = obj.rotation_euler.z + radians(180.0)       
    bpy.data.scenes[0].render.filepath = '/tmp/8'
    bpy.ops.render.render(animation=True)
    obj.rotation_euler.z = 0