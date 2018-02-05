// Copyright (c) 2013-2018 The CTNorth Authors. All Rights Reserved.
//
// Distributed under the MIT license (See accompanying file LICENSE.md or copy at
// https://opensource.org/licenses/MIT)

#include <windows.h>

#include "game/Application.hpp"

#ifdef _WIN32

int APIENTRY wWinMain(
    HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nShowCmd)
{
    Application app;
    return app.Run(hInstance, nShowCmd);
}

#else

int main(int argc, char** argv)
{
    Application app;
    return app.Run();
}

#endif
