-- CTNorth build configuration script
-- Author(s):       iFarbod <ifarbod@outlook.com>
--
-- Copyright (c) 2013-2018 CTNorth Team
--
-- Distributed under the MIT license (See accompanying file LICENSE or copy at
-- https://opensource.org/licenses/MIT)

-- This is the root build file for Premake. Premake will start processing by loading this
-- file, and recursively load all dependencies until all dependencies are either
-- resolved or known not to exist (which will cause the build to fail). So if
-- you add a new build file, there must be some path of dependencies from this
-- file to your new one or Premake won't know about it.

-- Add build/premake to path
premake.path = premake.path .. ";build/premake"

--require "compose_files"
--require "install_cef"
--require "install_data"

dofile "buildoptions.lua"

-- The _ACTION variable can be nil, which will be annoying.
-- Let's make an action that won't be nil.
action = _ACTION or ""

newaction
{
    trigger = "cppcheck",
    description = "Run cppcheck over the source code and write to cppcheck[_errors].txt",
    execute = function ()
        if os.host() == "windows" then
            os.execute [[cppcheck --quiet --force --std=c++14 -x c++ --enable=all --platform=native -j 8 . >cppcheck.txt 2>cppcheck_errors.txt]]
        else
            os.execute [[cppcheck --force --std=c++14 --language=c++ | tee -a cppcheck.txt]]
        end
    end
}

---
-- Main workspace
---
workspace "CTNorth"
    location("../build/" .. action)
    configurations { "Debug", "Release" }
    platforms { "x86", "x64" }

    targetprefix ""

    if os.target() == "windows" then
        -- Use the latest experimental C++ features where avaialble on MSVC
        buildoptions "/std:c++latest"
    else
        -- Use GNU extensions where available
        cppdialect "gnu++17"
    end

    symbols "On"
    characterset "Unicode"
    pic "On"
    systemversion "10.0.16299.0"
    startproject "Game"

    -- So we won't hit address space limit so often during linkage.
    preferredtoolarchitecture "x86_64"
    --warnings "Extra"
    --exceptionhandling "Off"
    --rtti "Off"
    --linkoptions "/PDBALTPATH:%_PDB%"

    -- Preprocessor definitions
    defines
    {
        -- No windows.h min()/max() macros
        "NOMINMAX",
        -- Exclude rarely-used stuff from Windows headers
        "WIN32_LEAN_AND_MEAN"
    }

    if CI_BUILD then
        filter {}
            defines { "CI_BUILD=1" }
    end

    includedirs
    {
        "."
    }

    filter "platforms:x86"
        architecture "x86"
    filter "platforms:x64"
        architecture "x86_64"

    filter "configurations:Debug"
        defines { "CTN_DEBUG" }

    filter "configurations:Release"
        flags { "StaticRuntime" }
        optimize "Speed"

    -- Generate PDB files at /build/symbols
    filter {"system:windows", "configurations:Release", "kind:not StaticLib"}
        os.mkdir("../build/symbols")
        linkoptions "/PDB:\"..\\symbols\\$(ProjectName).pdb\""

    -- Enable visual styles
    -- TODO: Make this a function, per-project
    filter { "system:windows", "kind:not StaticLib" }
        linkoptions "/manifestdependency:\"type='Win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\""

    -- Disable deprecation warnings and errors
    filter "action:vs*"
        defines
        {
            "_CRT_SECURE_NO_WARNINGS",
            "_CRT_SECURE_NO_DEPRECATE",
            "_CRT_NONSTDC_NO_WARNINGS",
            "_CRT_NONSTDC_NO_DEPRECATE",
            "_SCL_SECURE_NO_WARNINGS",
            "_SCL_SECURE_NO_DEPRECATE"
        }

    -- Include the projects we are going to build
    group "Base"
    include "base"

    group "Game"
    include "engine"
    include "game"

    -- group "Components"
    -- include "components"

    --group "Net"
    --include "net"

    group "Tests"
    include "tests"

    group "Vendor"
    include "vendor/angelscript"

-- Cleanup
if _ACTION == "clean" then
    os.rmdir("../bin");
    os.rmdir("../build");
end
