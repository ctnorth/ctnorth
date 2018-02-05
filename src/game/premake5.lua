project "Game"
    language "C++"
    kind "WindowedApp"
    targetname "ctnorth"

    vpaths
    {
        ["Headers/*"] = "**.hpp",
        ["Sources/*"] = "**.cpp",
        ["Resources/*"] = {"**.rc", "res/*.ico"},
        ["*"] = "premake5.lua"
    }

    files
    {
        "premake5.lua",
        "**.cpp",
        "**.hpp",
        "**.rc"
    }
