local wezterm = require('wezterm')  -- Pull API
local mycolors = require('oss_scripts.myColors')

local act = wezterm.action
local mux = wezterm.mux

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()

    pane:send_text('clear\r')
end)

-- * CONFIG!
config.default_cwd = 'C:/Users/Admin/__'
config.default_prog = {'pwsh', '-l'}

local colorScheme = 'Lavandula'
local fontName = 'CaskaydiaMono Nerd Font Mono'

-- VARS!!
local background = mycolors.window_background
local tab_color, status_bar = mycolors.tab, mycolors.bar

local _nerdfonts = wezterm.nerdfonts

-- Colors...
config.color_scheme = colorScheme
config.colors = {
    tab_bar =
    {
        background = background.color,

        -- The active tab is the one that has focus in the window
        active_tab = {
            bg_color = '#2b2042',  -- The color of the background area for the tab
            fg_color = '#c0c0c0',  -- The color of the text for the tab

            -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
            -- label shown for this tab. The default is "Normal"
            intensity = 'Normal',

            -- Specify whether you want "None", "Single" or "Double" underline for
            -- label shown for this tab. The default is "None"
            underline = 'None',

            -- Specify whether you want the text to be italic (true) or not (false)
            italic = true  -- for this tab. The default is false.
        },

        inactive_tab = {  -- Inactive tabs are the tabs that do not have focus
            bg_color = '#1b1032',
            fg_color = '#808080'
        },

        -- You can configure some alternate styling when the mouse pointer
        inactive_tab_hover = {  -- moves over inactive tabs.
            bg_color = '#3b3052',
            fg_color = '#909090',
            italic = true
        },

        -- The new tab button that let you create new tabs
        new_tab = {
            bg_color = '#1b1032',
            fg_color = '#808080'
        },

        -- You can configure some alternate styling when the mouse pointer
        new_tab_hover = {  -- moves over the new tab button
            bg_color = '#3b3052',
            fg_color = '#909090',
            italic = true
        }
    }
}

-- Fonts...
config.font_size = 16
config.font = wezterm.font(fontName)

-- Window...
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'AlwaysPrompt'
config.window_background_gradient = {
    orientation = 'Horizontal',  -- Can be "Vertical" or "Horizontal". Specifies the direction
    colors = {
        background.black,
        background.black_gray,

        background.black,
        background.black_gray,

        background.black,
        background.black_gray,

        background.black
    },

    -- Instead of specifying `colors`, you can use one of a number of
    -- predefined, preset gradients. A list of presets is shown in a section below.
    -- preset = "Warm",

    -- Specifies the interpolation style to be used.
    interpolation = 'CatmullRom',  -- "Linear", "Basis" and "CatmullRom" as supported.

    -- How the colors are blended in the gradient.
    blend = 'Rgb',  -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.

    segment_size = 16,
    segment_smoothness = 1.0
}

-- Keys!
leader = 'LEADER'
config.leader = {key = 'a', mods = 'CTRL', timeout_milliseconds = 1000}
config.keys = {
    {key = 'm', mods = 'SHIFT|CTRL', action = wezterm.action.ToggleFullScreen},
    -- Send C-a when pressing C-a twice
    {key = 'a',          mods = 'LEADER|CTRL', action = act.SendKey {key = 'a', mods = 'CTRL'}},
    {key = 'c',          mods = leader,      action = act.ActivateCopyMode},
    {key = 'phys:Space', mods = leader,      action = act.ActivateCommandPalette},

    -- Pane keybindings
    {key = 's', mods = leader, action = act.SplitVertical{domain = 'CurrentPaneDomain'}},
    {key = 'v', mods = leader, action = act.SplitHorizontal{domain = 'CurrentPaneDomain'}},
    {key = 'h', mods = leader, action = act.ActivatePaneDirection('Left')},
    {key = 'j', mods = leader, action = act.ActivatePaneDirection('Down')},
    {key = 'k', mods = leader, action = act.ActivatePaneDirection('Up')},
    {key = 'l', mods = leader, action = act.ActivatePaneDirection('Right')},
    {key = 'q', mods = leader, action = act.CloseCurrentPane{confirm = true}},
    {key = 'z', mods = leader, action = act.TogglePaneZoomState},
    {key = 'o', mods = leader, action = act.RotatePanes('Clockwise')},

    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    {key = 'r', mods = leader, action = act.ActivateKeyTable {name = 'resize_pane', one_shot = false}},

    -- Tab keybindings
    {key = 't', mods = leader, action = act.SpawnTab('CurrentPaneDomain')},
    {key = '[', mods = leader, action = act.ActivateTabRelative(-1)},
    {key = ']', mods = leader, action = act.ActivateTabRelative(1)},
    {key = 'n', mods = leader, action = act.ShowTabNavigator},
    {
        key = 'e', mods = leader,
        action = act.PromptInputLine{
        description = wezterm.format{
            {Attribute = {Intensity = 'Bold'}},
            {Foreground = {AnsiColor = 'Fuchsia'}},
            {Text = 'Renaming Tab Title...:'},
        },
        action = wezterm.action_callback(function(window, pane, line)
            if line then
                window:active_tab():set_title(line)
            end
        end)
        }
    },

    -- Key table for moving tabs around
    {key = 'm', mods = leader, action = act.ActivateKeyTable {name = 'move_tab', one_shot = false}},

    -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
    {key = '{', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1)},
    {key = '}', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1)},

    -- Lastly, workspace
    {key = 'w', mods = leader, action = act.ShowLauncherArgs {flags = 'FUZZY|WORKSPACES'}}
}

-- I can use the tab navigator (LDR t),
for i = 1, 9 do  -- but I also want to quickly navigate tabs with index
    table.insert(config.keys, {
        key = tostring(i), mods = leader,
        action = act.ActivateTab(i - 1)
    })
end

-- Dim inactive panes
config.inactive_pane_hsb = {saturation = 0.24, brightness = 0.5}

-- Tab bar
config.use_fancy_tab_bar, config.tab_bar_at_bottom = false, true
config.status_update_interval = 1000
config.tab_max_width = 11

-- The filled in variant of the < symbol | filled in variant of the > symbol
local SOLID_LEFT_ARROW = _nerdfonts.ple_flame_thick_mirrored
local SOLID_RIGHT_ARROW = _nerdfonts.ple_flame_thick

local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end

    -- Otherwise, use the title from the active pane
    return tab_info.active_pane.title  -- in that tab
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local color_tab = {tab_color.background, tab_color.foreground}

    local background = color_tab[1].default
    local foreground = color_tab[2].default

    if tab.is_active then
        background = color_tab[1].active
        foreground = color_tab[2].active
    elseif hover then
        background = color_tab[1].hover
        foreground = color_tab[2].hover
    end

    local edge_foreground = background
    local title = tab_title(tab)

    -- Ensure that the titles fit in the available space,
    title = wezterm.truncate_right(title, max_width - 4)  -- and that we have room for the edges.

    return {
        {Background = {Color = tab_color.edge_background}},
        {Foreground = {Color = edge_foreground}},
        {Text = SOLID_LEFT_ARROW},

        {Background = {Color = background}},
        {Foreground = {Color = foreground}},
        {Text = title},

        {Background = {Color = tab_color.edge_background}},
        {Foreground = {Color = edge_foreground}},
        {Text = SOLID_RIGHT_ARROW}
    }
end)

-- local function recompute_padding(window)
--     local window_dims = window:get_dimensions()
--     local overrides = window:get_config_overrides() or {}
--
--     if not window_dims.is_full_screen then
--         if not overrides.window_padding then
--             return  -- not changing anything
--         end overrides.window_padding = nil
--
--     else  -- Use only the middle 33%
--         local third = math.floor(window_dims.pixel_width / 6)
--         local new_padding = {
--             left = third,
--             right = third,
--             top = 40, bottom = 100
--         }
--         if overrides.window_padding and new_padding.left == overrides.window_padding.left
--         then  -- padding is same, avoid triggering further changes
--             return
--         end overrides.window_padding = new_padding
--     end
--
--     window:set_config_overrides(overrides)
-- end
--
-- wezterm.on('window-resized', function(window, pane)
--     recompute_padding(window)
-- end)
-- wezterm.on('window-config-reloaded', function(window)
--     recompute_padding(window)
-- end)

wezterm.on('update-status', function(window, pane)
    local status_color = status_bar.stat_color

    -- Workspace name
    local stat = window:active_workspace()
    local stat_color = status_color.default

    -- It's a little silly to have workspace name all the time
    -- Utilize this to display LDR or current key table name
    if window:active_key_table() then
        stat = window:active_key_table()
        stat_color = status_color.active_key
    end
    if window:leader_is_active() then
        stat = 'LDR'
        stat_color = status_color.leader_active
    end

    -- Current working directory
    local basename = function(s)
        return string.gsub(s, '(.*[/\\])(.*)', '%2')
    end

    -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l). Not a big deal, but check in case
    local cwd = pane:get_current_working_dir()
    local cmd = pane:get_foreground_process_name()

    cwd = cwd and basename(cwd) or ''
    cmd = cmd and basename(cmd):match('(.*)%.(.*)') or ''  -- Current command

    -- Time
    local time = wezterm.strftime('%H:%M')

    -- Left status (left of the tab line)
    window:set_left_status(wezterm.format({
        {Foreground = {Color = stat_color}},
        {Text = ' '},
        {Text = _nerdfonts.weather_small_craft_advisory .. ' ' .. stat},
        {Text = _nerdfonts.oct_chevron_right}
    }))

    window:set_right_status(wezterm.format({  -- Right status
        {Text = _nerdfonts.pom_away .. ' ( ͡o ͜ʖ ͡o)' .. cwd},
        {Text = '| '},
        {Foreground = {Color = status_bar.foreground_item}},
        {Text = _nerdfonts.md_zip_disk .. ' ' .. cmd}, 'ResetAttributes',
        {Text = ' | '},
        {Text = _nerdfonts.fa_clock_o .. ' ' .. time}
    }))
end)

-- Outhers...
config.default_workspace = 'Home'

return config
