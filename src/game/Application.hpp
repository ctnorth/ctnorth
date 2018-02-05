// Copyright (c) 2013-2018 The CTNorth Authors. All Rights Reserved.
//
// Distributed under the GPLv3 license (See accompanying file LICENSE.md or copy at
// https://opensource.org/licenses/GPL-3.0)

#pragma once

#include <windows.h>

class Application
{
public:
    Application();
    ~Application();

    int Run(HINSTANCE instance, int cmdShow);
};
