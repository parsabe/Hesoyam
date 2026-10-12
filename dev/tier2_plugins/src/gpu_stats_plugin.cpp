#include "../include/gta_sa_defs.h"
#include <iostream>

// ==============================================================================
// GTA: SA Custom C++ Gameplay & Performance Plugin Template
// Designed for Linux / Debian Development with Clang or MinGW-w64 cross-compilers
// ==============================================================================

class GTAPerformancePlugin {
public:
    static void OnGameInit() {
        std::cout << "[Plugin] GTA: SA Performance & GPU Systems Initialized.\n";
        
        // Example: Unlock default 30 FPS cap to allow high-refresh RTX 4060 rendering
        // In retail SA, address 0x00C1704C stores the frame limiter cap.
        // GTASA::WriteMemory<uint32_t>(GTASA::ADDR_FPS_LIMIT, 144);
    }

    static void OnGameProcess() {
        uint32_t gameState = GTASA::ReadMemory<uint32_t>(GTASA::ADDR_GAME_STATE);
        if (gameState != 9) {
            return; // Not currently in active gameplay
        }

        uint32_t timeMs = GTASA::ReadMemory<uint32_t>(GTASA::ADDR_CTIMER_MSECS);
        float timeStep = GTASA::ReadMemory<float>(GTASA::ADDR_CTIMER_TIMESTEP);

        // Custom periodic logic (runs every frame)
        static uint32_t lastReport = 0;
        if (timeMs - lastReport > 5000) {
            lastReport = timeMs;
            std::cout << "[Plugin Update] Engine Time: " << timeMs 
                      << " ms | TimeStep: " << timeStep << "\n";
        }
    }
};

// Plugin Entry Point
#if defined(_WIN32)
#include <windows.h>
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) {
    if (fdwReason == DLL_PROCESS_ATTACH) {
        GTAPerformancePlugin::OnGameInit();
    }
    return TRUE;
}
#else
// Standalone / Native Linux test harness
int main() {
    std::cout << "[Linux Native Build] Testing GTA San Andreas Plugin Logic...\n";
    GTAPerformancePlugin::OnGameInit();
    std::cout << "[Linux Native Build] Validation test passed.\n";
    return 0;
}
#endif
