// Copyright (c) 2013-2018 The CTNorth Authors. All Rights Reserved.
//
// Distributed under the GPLv3 license (See accompanying file LICENSE.md or copy at
// https://opensource.org/licenses/GPL-3.0)

#include "game/Application.hpp"

Application::Application() = default;

Application::~Application() = default;

// Main message handler for the sample.
LRESULT CALLBACK WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    // Handle destroy/shutdown messages.
    switch (message)
    {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
    }

    // Handle any messages the switch statement didn't.
    return DefWindowProc(hWnd, message, wParam, lParam);
}

int Application::Run(HINSTANCE instance, int cmdShow)
{
    // Initialize the window class.
    WNDCLASSEX windowClass = { 0 };
    windowClass.cbSize = sizeof(WNDCLASSEX);
    windowClass.style = CS_HREDRAW | CS_VREDRAW;
    windowClass.lpfnWndProc = WindowProc;
    windowClass.hInstance = instance;
    windowClass.hCursor = LoadCursor(nullptr, IDC_ARROW);
    windowClass.lpszClassName = L"CTNorth WindowClass";
    RegisterClassEx(&windowClass);

    RECT windowRect = { 0, 0, 1280, 600 };
    AdjustWindowRect(&windowRect, WS_OVERLAPPEDWINDOW, FALSE);

    // Create the window and store a handle to it.
    auto hwnd = CreateWindowEx(0, L"CTNorth WindowClass", L"CTNorth", WS_POPUPWINDOW, 30, 30,
        windowRect.right - windowRect.left, windowRect.bottom - windowRect.top,
        nullptr,  // We have no parent window, NULL.
        nullptr,  // We aren't using menus, NULL.
        instance,
        nullptr);  // We aren't using multiple windows, NULL.

    ShowWindow(hwnd, cmdShow);

    // Initialize the sample. OnInit is defined in each child-implementation of Application.
    // OnInit();

    // Main sample loop.
    MSG msg = { nullptr };
    while (true)
    {
        // Process any messages in the queue.
        if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);

            if (msg.message == WM_QUIT)
            {
                break;
            }

            // Pass events into our sample.
            // OnEvent(msg);
        }

        // OnUpdate();
        // OnRender();
    }

    // OnDestroy();

    // Return this part of the WM_QUIT message to Windows.
    return static_cast<char>(msg.wParam);
}
