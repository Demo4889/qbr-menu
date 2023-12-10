## Menu System for QBRCoreFramework 📄

## Screenshots
![Menu](https://cdn.discordapp.com/attachments/1021700112776437760/1183288337700769832/image.png?ex=6587ca24&is=65755524&hm=f9ee59a376ddda94f9e6e3f7e22aa914de5d48d89b14e21bdec40d66b1d46472&)
![Menu2](https://cdn.discordapp.com/attachments/1021700112776437760/1183289410226229338/image.png?ex=6587cb23&is=65755623&hm=aa95a9d46ebd56839cff7d00ce5451fb9933e2a6e9dcbc3592368fb694b15785&)

## Features
Ability to create a option menu

## Exanple
```
RegisterCommand("qbmenutest", function(source, args, raw)
    openMenu({
        {
            header = "Main Title",
            isMenuHeader = true,
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            params = {
                event = "qbr-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            disabled = true,
            params = {
                event = "qbr-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        },
    })
end)
```
```
RegisterNetEvent('qbr-menu:client:testMenu2', function(data)
    local number = data.number
    openMenu({
        {
            header = "< Go Back",
        },
        {
            header = "Number: "..number,
            txt = "Other",
            params = {
                event = "qbr-menu:client:testButton",
                args = {
                    message = "This was called by clicking this button"
                }
            }
        },
    })
end)
```
```
RegisterNetEvent('qbr-menu:client:testButton', function(data)
    TriggerEvent('QBCore:Notify', data.message)
end)
```

## Installation
Download the script and put it in the [qbr] directory.

## License
```
QBCore Framework
Copyright (C) 2021 Joshua Eger

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>
```
