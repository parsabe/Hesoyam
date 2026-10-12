#pragma once
#include <cstdint>
#include <cstring>

// GTA: San Andreas v1.0 US Core Memory Offsets & Address Table
// Specifically targeting HOODLUM 14,383,616 byte executable
namespace GTASA {

    // Global Engine Singletons and Data
    constexpr uintptr_t ADDR_CTIMER_MSECS          = 0x00B7CB84; // uint32_t ms
    constexpr uintptr_t ADDR_CTIMER_TIMESTEP       = 0x00B7CB5C; // float
    constexpr uintptr_t ADDR_FPS_LIMIT             = 0x00C1704C; // uint32_t limit
    constexpr uintptr_t ADDR_GAME_STATE            = 0x00C8D4C0; // uint32_t 9=playing
    constexpr uintptr_t ADDR_CAMERA                = 0x00B6F028; // CCamera instance

    // Player & World Functions
    constexpr uintptr_t ADDR_FUNC_FIND_PLAYER_PED  = 0x0056E210; // CPed* FindPlayerPed(int)
    constexpr uintptr_t ADDR_FUNC_FIND_PLAYER_VEH  = 0x0056E0D0; // CVehicle* FindPlayerVehicle(int, bool)
    
    // Core Render & Frame Loop Hook Locations
    constexpr uintptr_t ADDR_HOOK_GAME_PROCESS     = 0x0053BEE0; // CGame::Process()
    constexpr uintptr_t ADDR_HOOK_DRAWING          = 0x0053EAD0; // Main Render loop

    // Basic 3D Vector Representation
    struct CVector {
        float x, y, z;
    };

    // Helper memory patch routines
    inline void PatchMemory(uintptr_t address, const void* data, size_t size) {
        // Safe cross-platform memory copying helper
        std::memcpy(reinterpret_cast<void*>(address), data, size);
    }

    template<typename T>
    inline void WriteMemory(uintptr_t address, T value) {
        PatchMemory(address, &value, sizeof(T));
    }

    template<typename T>
    inline T ReadMemory(uintptr_t address) {
        T val;
        std::memcpy(&val, reinterpret_cast<const void*>(address), sizeof(T));
        return val;
    }
}
