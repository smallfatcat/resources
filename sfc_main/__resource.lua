resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	"@NativeUILua-Reloaded/Wrapper/Utility.lua",

    "@NativeUILua-Reloaded/UIElements/UIVisual.lua",
    "@NativeUILua-Reloaded/UIElements/UIResRectangle.lua",
    "@NativeUILua-Reloaded/UIElements/UIResText.lua",
    "@NativeUILua-Reloaded/UIElements/Sprite.lua",

    "@NativeUILua-Reloaded/UIMenu/elements/Badge.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/Colours.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/ColoursPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/StringMeasurer.lua",

    "@NativeUILua-Reloaded/UIMenu/items/UIMenuItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuCheckboxItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuListItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuSliderItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuSliderHeritageItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuColouredItem.lua",

    "@NativeUILua-Reloaded/UIMenu/items/UIMenuProgressItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuSliderProgressItem.lua",

    "@NativeUILua-Reloaded/UIMenu/windows/UIMenuHeritageWindow.lua",

    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuGridPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuHorizontalOneLineGridPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuVerticalOneLineGridPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuColourPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuPercentagePanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuStatisticsPanel.lua",

    "@NativeUILua-Reloaded/UIMenu/UIMenu.lua",
    "@NativeUILua-Reloaded/UIMenu/MenuPool.lua",

    "@NativeUILua-Reloaded/NativeUI.lua",
}

client_scripts {
    "@NativeUILua-Reloaded/UIProgressBar/UIProgressBarPool.lua",
    "@NativeUILua-Reloaded/UIProgressBar/items/UIProgressBarItem.lua",
}

client_scripts {
    "@Radiant_Animations/config.lua"
}

client_scripts {
    "sfc_config.lua",
    "test_functions.lua",
    "bank.lua",
    "menu.lua",
    "sfc_main_client.lua",
}

server_script "sfc_main_server.lua"