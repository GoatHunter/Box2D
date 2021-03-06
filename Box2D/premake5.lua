-- Box2D premake5 script.
-- https://premake.github.io/

workspace "Box2D"
	location ( "Build/%{_ACTION}" )
	architecture "x86_64"
	configurations { "Debug", "Release" }
	
	configuration "vs*"
		defines { "_CRT_SECURE_NO_WARNINGS" }	
		
	filter "configurations:Debug"
		targetdir ( "Build/%{_ACTION}/bin/Debug" )
	 	defines { "DEBUG" }
		symbols "On"

	filter "configurations:Release"
		targetdir ( "Build/%{_ACTION}/bin/Release" )
		defines { "NDEBUG" }
		optimize "On"

project "Box2D"
	kind "StaticLib"
	language "C++"
	files { "Box2D/**.h", "Box2D/**.cpp" }
	includedirs { "." }

if os.is("windows") then
project "GLEW"
	kind "StaticLib"
	language "C++"
	defines {"GLEW_STATIC"}
	files { "glew/*.h", "glew/*.c" }
	includedirs { "." }
end

local glfw_common = {
	"glfw/internal.h",
	"glfw/glfw_config.h",
	"glfw/glfw3.h",
	"glfw/glfw3native.h",
	"glfw/context.c",
	"glfw/init.c",
	"glfw/input.c",
	"glfw/monitor.c",
	"glfw/vulkan.c",
	"glfw/window.c" }

project "GLFW"
	kind "StaticLib"
	language "C"
	configuration { "windows" }
		local f = {
			"glfw/win32_platform.h",
			"glfw/win32_joystick.h",
			"glfw/wgl_context.h",
			"glfw/egl_context.h",
			"glfw/win32_init.c",
            "glfw/win32_joystick.c",
			"glfw/win32_monitor.c",
			"glfw/win32_time.c",
            "glfw/win32_tls.c",
            "glfw/win32_window.c",
        	"glfw/wgl_context.c",
        	"glfw/egl_context.c"
        }
   
        for i, v in ipairs(glfw_common) do
        	f[#f + 1] = glfw_common[i]
        end
    	files(f)

	configuration { "macosx" }
		local f = {
			"glfw/cocoa_platform.h",
			"glfw/iokit_joystick.h",
			"glfw/posix_tls.h",
			"glfw/nsgl_context.h",
			"glfw/egl_context.h",
			"glfw/cocoa_init.m",
			"glfw/cocoa_joystick.m",
			"glfw/cocoa_monitor.m",
			"glfw/cocoa_window.m",
            "glfw/cocoa_time.c",
            "glfw/posix_tls.c",
            "glfw/nsgl_context.m",
            "glfw/egl_context.c"
        }

        for i, v in ipairs(glfw_common) do
        	f[#f + 1] = glfw_common[i]
        end
    	files(f)

	configuration { "not windows", "not macosx" }
		local f = {
			"glfw/x11_platform.h",
			"glfw/xkb_unicode.h",
			"glfw/posix_time.h",
			"glfw/posix_tls.h",
			"glfw/glx_context.h",
			"glfw/egl_context.h",
			"glfw/x11_init.c",
			"glfw/x11_monitor.c",
			"glfw/x11_window.c",
            "glfw/xkb_unicode.c",
            "glfw/posix_time.c",
        	"glfw/posix_tls.c",
        	"glfw/glx_context.c",
        	"glfw/egl_context.c"
        }

        for i, v in ipairs(glfw_common) do
        	f[#f + 1] = glfw_common[i]
        end
    	files(f)

project "IMGUI"
	kind "StaticLib"
	language "C++"
	defines {"GLEW_STATIC"}
	files { "imgui/*.h", "imgui/*.cpp" }
	includedirs { "." }
	configuration { "macosx" }
    	defines{ "GLFW_INCLUDE_GLCOREARB" }

project "HelloWorld"
	kind "ConsoleApp"
	language "C++"
	files { "HelloWorld/HelloWorld.cpp" }
	includedirs { "." }
	links { "Box2D" }

project "Testbed"
	kind "ConsoleApp"
	language "C++"
	defines {"GLEW_STATIC"}
	files { "Testbed/**.h", "Testbed/**.cpp" }
	includedirs { "." }
	links { "Box2D", "GLFW", "IMGUI"}
	configuration { "windows" }
		links { "GLEW", "glu32", "opengl32", "winmm" }
	configuration { "macosx" }
    	defines{ "GLFW_INCLUDE_GLCOREARB" }
		links { "OpenGL.framework", "Cocoa.framework", "IOKit.framework", "CoreFoundation.framework", "CoreVideo.framework"}
	configuration { "not windows", "not macosx" }
		links { "X11", "GL", "GLU"}
