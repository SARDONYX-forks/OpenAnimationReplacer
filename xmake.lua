local PLUGIN_NAME<const> = "OpenAnimationReplacer"
local AUTHOR_NAME<const> = "ersh"
local DESCRIPTION<const> = ""

set_project(PLUGIN_NAME)
set_version("3.0.2")
set_languages("cxx23")
add_rules("mode.debug", "mode.release")

-- Dependencies
-- ref: https://xrepo.xmake.io/mirror/packages/windows.html
add_requires("boost 1.90.0", {configs = { container_hash = true, stl_interfaces = true }})
add_requires("cryptopp 8.9.0")
add_requires("effolkronium-random v1.5.0")
add_requires("fmt 12.1.0")
add_requires("imgui 1.89.6", {configs = {dx11 = true}}) -- https://github.com/xmake-io/xmake-repo/blob/master/packages/i/imgui/xmake.lua#L110
add_requires("rapidjson v1.1.0")
add_requires("rsm-binary-io 2.0.6")
add_requires("rsm-mmio 2.0.0")
add_requires("xxhash 0.8.3")

set_config("rex_ini", true) -- simpleini
set_config("rex_json", true) -- nlohmannjson
set_config("skse_xbyak", true) -- xbyak
set_config("skyrim_se", true)
set_config("skyrim_ae", true)
set_config("skyrim_vr", true)
includes("./extern/CommonLibSSE")

target("OpenAnimationReplacer", function ()
    set_kind("shared")
    add_packages(
        "boost",
        "commonlibsse-ng",
        "cryptopp",
        "effolkronium-random",
        "fmt",
        "imgui",
        "mergemapper",
        "rapidjson",
        "rsm-binary-io"    ,
        "rsm-mmio",
        "xxhash"
    )

    add_files("src/**.cpp")
    add_headerfiles("src/**.h")
    add_includedirs("src")
    set_pcxxheader("src/PCH.h")

    -- MergeMapper
    add_files("extern/MergeMapper/src/MergeMapperPluginAPI.cpp")
    add_includedirs("extern/MergeMapper/include", {public = true})

    if is_plat("windows") then
        add_cxflags("/EHsc", "/MP", "/W4", "/WX", {tools = "msvc"})
        add_defines("_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR")
    end
    if is_mode("release") then
        add_cxflags("/Ob3", {tools = "msvc"})
        add_ldflags("/OPT:REF", "/OPT:ICF", {tools = "msvc"})
    end
    if is_mode("debug") then
        add_ldflags("/INCREMENTAL", {tools = "msvc"})
    end

    -- This setting automatically creates `SKSE/Plugins/<target_NAME>.dll` during `xmake install`.
    add_rules("commonlibsse-ng.plugin", {
        name = PLUGIN_NAME,
        author = AUTHOR_NAME,
        description = DESCRIPTION,
    })
end)
