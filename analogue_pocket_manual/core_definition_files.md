Core Definition Files
A core is comprised of several files, which all must be placed into the core’s folder.

core.json: Required. Main core definition file.
audio.json: Required. Audio features. (upcoming feature)
data.json: Required. List of all data slots.
input.json: Required. Description of custom button mappings for the core. (remapping coming soon)
interact.json: Required. List of custom UI elements for the in-core menu, which can be used to interact with the core while running.
variants.json: Required. Variants list for supporting small variations of a base core. (upcoming feature)
video.json: Required. Video settings. Defines the video scaler settings used, namely resolution for each of the 8 scaler slots.
info.txt: Extra information that will be shown in the core’s Platform Detail view. Up to 32 lines can be displayed - no special characters. Bullet points can be shown by starting a line with an asterisk (* ).
icon.bin: Icon bitmap for use in the user interface.
Additionally, a core may allow users to select assets together in a predetermined group as an "instance". These instance JSON files are stored as assets themselves in the Assets folder and follow the same rules for their location.

<instance>.json: Instance definition file, stored as an asset.
Folder Naming Convention
The core folder name should follow this convention: AuthorName.CoreName where AuthorName and CoreName correspond to author and shortname in core.json respectively.

audio.json
Describes the audio parameters. (upcoming feature)

JSON Definition
magic: string
Must be APF_VER_1.

Sample File
{
  "audio": {
    "magic": "APF_VER_1"
  }
}

core.json
Describes the core in general terms, framework requirements, and a list of bitstreams.

JSON Definition
magic: string
Must be APF_VER_1.

metadata
platform_ids: array
Array of supported platform strings. Refer to platform list. If no platforms are specified (empty array) then core is standalone. This affects where assets and saves are stored in the filesystem.

Maximum 4 platforms.

shortname: string
Short name used for filesystem. Maximum length 31 characters.

description: string
Short description. Maximum length 63 characters.

author: string
Name of the core author. Maximum length 31 characters.

url: string
URL to more information about core. Maximum length 63 characters.

version: string
Version of the release. SemVer is highly encouraged. Maximum length 31 characters.

date_release: string
Date of the release in this format: 2022-12-31. The date the release was made. Maximum length 10 characters.

framework
target_product: string
Must be "Analogue Pocket".

version_required: string
Minimum firmware version required, in the format "1.1"

sleep_supported: boolean
If sleep is supported by the core. Additionally, a core can selectively allow or deny each individual save state creation request. The sleep/wake system uses the host commands [00A0 Savestate: Start/Query] and [00A4 Savestate: Load/Query].

chip32_vm: string
Filename of Chip32 program. If present, the program will take over all loading operations. File must be present in the root of the core’s folder. Maximum length 15 characters.

dock
supported: boolean
Whether Dock should be allowed. Must be true.

analog_output: boolean
Does core support analog output timing modes? Upcoming feature.

hardware
link_port: boolean
Whether link port is utilized.

cartridge_adapter: integer / hex string
Bit [31] set: Leave cart power off.

Bit [31] clear: Turn on cart power, if bit 24 is not set, or if it's set AND the user selects the 'Play Cartridge' option. (default).

Bit [30] set: Turn on cart power always.

Bit [24] set: Enable 'Play Cartridge' option in Asset browser when starting core. If user selects this option, data slot 0 and any other slots that derive their filenames from it will not be loaded.

Bit [17] set: Enforce strict adapter ID check. If the found adapter doesn't match the below ID code, core loading will fail.

Bit [16] set: Enforce soft adapter ID check. If user selects "Play Cartridge" option and adapter doesn't match, core loading will fail. However, if user does not pick "Play Cartridge", core loading will proceed despite whatever adapter may be inserted.

Bit [7:0]: cart adapter ID code.

The default value is simply 0, which will preserve backwards compatibility. A value of 0 will turn on cart power and bypass all other checks.

In all cases, a Host command will be sent informing the core if any cartridge adapter was found, if cartridge power was turned on, and whether the user wants to run the cartridge instead of an Asset. This Host command will be issued while the core is in reset.

If Play Cartridge is selected, any data slots such as nonvolatile save files that derive their filenames from data slot 0 will not be loaded or saved.

For backwards compatibility, values of -1 will be automatically corrected 0x80000000 (Leave cart power off).

cores
A maximum of 8 cores is allowed.

name: string
Identifier for the bitstream used in debugging. Optional. For debugging purposes. Maximum length 15 characters.

id: integer / hex string
Identifier.

filename: string
Filename of the bitstream (bit-reversed). Maximum length 15 characters.

Sample File
{
  "core": {
    "magic": "APF_VER_1",
    "metadata": {
      "platform_ids": [],
      "/": "SampleCore",
      "description": "This is a sample core",
      "author": "developer",
      "url": "https://",
      "version": "1.0.0-preview",
      "date_release": "2022-04-20"
    },
    "framework": {
      "target_product": "Analogue Pocket",
      "version_required": "1.1",
      "sleep_supported": true,
      "dock": {
        "supported": true,
        "analog_output": false
      },
      "hardware": {
        "link_port": false,
        "cartridge_adapter": -1
      }
    },
    "cores": [
      {
        "name": "default",
        "id": 0,
        "filename": "bitstream.rbf_r"
      }
    ]
  }
}

data.json
Describes up to 32 possible data slots. Each slot can be loaded with an asset, loaded and saved to a nonvolatile save file, and contains a number of options.

JSON Definition
magic: string
Must be APF_VER_1.

data_slots (array)
A maximum of 32 data slots is allowed.

name: string
Name of the data slot. Maximum length of 15 characters.

id: integer / hex string
ID number. Limited to 16-bit unsigned.

required: boolean
If true, Pocket will check for a filename. If none is present, it will spawn a file browser in the location it expects the file to be in. If false, Pocket will try to load the file if it exists, otherwise it will be silently be skipped.

parameters: integer / hex string
Bitmap for the slot's configuration. See Parameters Bitmap below.

nonvolatile: boolean
If true, slot will be both loaded and unloaded on core exit. Related functionality with parameters above and Parameters Bitmap.

deferload: boolean
If true, slot will not be loaded, but its size and ID will still be communicated to the core, and the core may read/write it with Target commands. If a user reloads this slot, APF will send [008A Data slot update].

secondary: boolean
If true, slot will be ignored, and will only be loaded if referenced in a selected variant/instance.

filename: string
Expected filename for the slot. See Parameters Bitmap below. Maximum length of 31 characters.

extensions: string
Array of up to 4 supported file extensions. Each extension may be up to 7 characters. If a file browser is spawned, it will filter the files shown.
Example: "extensions": ["bin", "sav"].

size_exact: integer / hex string
If specified, or non-zero, the filesize will be checked and only loaded if the size matches. 32-bit unsigned.

size_maximum: integer / hex string
If specified, or non-zero, the file will not load unless it is equal or smaller in size than this value. 32-bit unsigned.

address: integer / hex string
Load address. 32-bit unsigned.

Parameters Bitmap
Bit Position	Description	Cleared	Set
0	User-reloadable		Slot is reloadable in Core UI
1	Core-specific file	File common to platform, not any core	File specific to this core only
2	Nonvolatile filename	Filename as written in the slot	Filename cloned from slot 0, with this slot's extension appended
3	Read-only	File may be modified	File is read-only
4	Instance JSON	Normal asset	Treat a JSON loaded into this slot as an instance description. Must also be flagged as "core-specific file", and only valid in first slot.
5	Initialize nonvolatile data on load	Data is loaded if it exists, otherwise nothing is written to this nonvolatile slot	Data is loaded if it exists, otherwise the slot's memory is overwritten with 0xFF's up to size_maximum
6	Reset core while loading	[0082 Data slot request write] command is sent before load, and [008F Data slot access all complete] sent after	[0010 Reset Enter] before executing the same data slot access/complete sequence, and additionally [0011 Reset Exit] after
7	Restart of core before/after loading	Same as above	Entire core is unloaded via the normal process, saving any nonvolatile slots. Then a full restart of the core is done, using the new data along with other already-defined assets
8	Full reload of core	Same as above	Same as above, but the bitstream is also reloaded before the restart process
9	Persist browsed filename	Normal behavior. File for slot may be chosen by user, at core boot (if required), or during runtime through Interact menu (if marked User-reloadable)	Filenames picked via the browser will be persisted, and the next time the core is loaded, the slot will be reloaded with the same file, overriding any definition or instance filename. The browser cache, which is saved per-core, is cleared when a user uses "Reset All to Defaults" in the core's Interact menu.
[25:24]	Index of platform to look for file in (usually platform 0)	When filename is specified for this slot, selects the platform from core.json's platform_ids array. This will be index 0 by default, or the first or only platform supported by the core.	This may be used to load a required asset from another platform’s Assets folder, so long as that platform is listed in the platform_ids array.

A core-specific file is distributed with the core itself, and does not share anything with its platform. The path would be: /Assets/<platform>/AuthorName.CoreName/examplefile.bin. It could also be a nonvolatile file, which would be located in /Saves/<platform>/AuthorName.CoreName/examplefile.bin.
A nonvolatile data slot, such as a save file, may be generated for every time the core is started based on the filename and path of the primary data slot, which is slot 0. Additionally, this file will take on the extension of the first extension in the nonvolatile data slot's extension list.
An instance JSON, if specified, will specify exact filenames for some or all other slots and select a variant to load. This can be useful if a core requires many different assets to be loaded.
Data slots can be optionally re-reloaded with a new file during runtime by the user, through the interact.json menu. Please see the Parameters Bitmap section with respect to bits 6, 7, and 8 to configure the behavior when a user reloads one of these slots. Some cores may be able to accept new data at any time, while others might need to be put into reset.
Slots marked as nonvolatile will be read out back onto the file they were loaded from on SD. The size of the file is determined by the Dataslot ID/Size Table BRAM in the core. This means the filesize will by default be the same as it was when loaded, unless the core has specifically modified the size to be bigger or smaller during runtime. The data flush happens whenever the core is shutdown - when a core is stopped with the root menu "Quit" option, Pocket is turned off, or Pocket is slept.
When using Chip32, the behavior of bits 6-7 are different. In either case, Chip32 will eventually be restarted with the selected slot ID to decide how to handle the load. Bit 6 has no effect. Bit 7 causes a soft reboot - the core is unloaded but FPGA not reset. Then, Chip32’s register state is reloaded and called again. In this case, a Chip32 program expecting to see a particular data slot with this bit set, must always call HOST 4002 to set APF back up and start running again. However, reloading the FPGA bitstream is not necessary.
A slot that is both nonvolatile/named from slot0 and read only would have the bitmap computed as follows:

(1 << bit2) + (1 << bit3) = 
4 + 8 = 
12
Sample File
{
  "data": {
    "magic": "APF_VER_1",
    "data_slots": [
      {
        "name": "Background Pic",
        "id": 1,
        "required": true,
        "parameters": 3,
        "extensions": [
          "bin"
        ],
        "size_exact": 0,
        "size_maximum": 8388608,
        "address": "0x00000000"
      },
      {
        "name": "Audio Sample",
        "id": "0xFC0",
        "required": true,
        "parameters": 3,
        "extensions": [
          "wav"
        ],
        "size_maximum": "0x4000000",
        "address": "0x00400000"
      },
      {
        "name": "Save Data",
        "id": 123,
        "required": true,
        "parameters": 7,
        "extensions": [
          "sav"
        ],
        "size_maximum": 8192,
        "address": "0x02000000"
      }
    ]
  }
}

input.json
Describes the button input mappings shown in the Core Settings > Controls menu. Currently read-only.

Per-Asset Functionality
Default
By default, the Controls menu is loaded from:
/Cores/AuthorName.CoreName/input.json

Per-Asset
It is possible to have completely unique Controls menus for every single primary asset loaded by the core. APF will check in a specific location, generated from the very first data slot 0. If it is found, it will override the core’s existing input.json.

A per-asset Controls menu, if it exists, is loaded from:
/Presets/AuthorName.CoreName/Input/<path_to_slot0_asset>.json

Example
For example, with an primary asset loaded into data slot 0 with current path and filename of:
/Assets/myplatform/common/subfolder1/asset.bin

APF will check for a JSON file mirroring the same folder structure, but in a different base folder:
/Presets/AuthorName.CoreName/Input/myplatform/common/subfolder1/asset.json

JSON Definition
magic: string
Must be APF_VER_1.

controllers (array)
A maximum of 4 controllers are allowed.

type: string
Type of the controller. Must be "default".

controllers.mappings (array)
A maximum of 8 mappings are allowed.

id: integer / hex string
Limited to 16-bit unsigned.

name: string
Name of the button shown in the menu. Maximum length of 19 chars.

key: string / keycode
See "Keycode list” below.

Keycode List
pad_btn_a: A button
pad_btn_b: B button
pad_btn_x: X button
pad_btn_y: Y button
pad_trig_l: L button
pad_trig_r: R button
pad_btn_start: Start button
pad_btn_select: Select button

Sample File
{
  "input": {
    "magic": "APF_VER_1",
    "controllers": [
      {
        "type": "default",
        "mappings": [
          {
            "id": 0,
            "name": "A",
            "key": "pad_btn_a"
          },
          {
            "id": 1,
            "name": "B",
            "key": "pad_btn_b"
          },
          {
            "id": 2,
            "name": "X",
            "key": "pad_btn_x"
          },
          {
            "id": 3,
            "name": "Y",
            "key": "pad_btn_y"
          },
          {
            "id": 4,
            "name": "L",
            "key": "pad_trig_l"
          },
          {
            "id": 5,
            "name": "R",
            "key": "pad_trig_r"
          },
          {
            "id": 6,
            "name": "Start",
            "key": "pad_btn_start"
          },
          {
            "id": 7,
            "name": "Select",
            "key": "pad_btn_select"
          }
        ]
      }
    ]
  }
}

<instance>.json
An instance file is stored in the same place that an asset would be - following platform path conventions (and core name, possibly). The location that a core will expect the instance JSON to be located from will be exactly the same as any other data slot. The Parameters Bitmap of a data slot determines if the data slot will be treated as common to a platform (in the “common” folder) or core-specific (in a subfolder named after the core itself).

To use an instance JSON, the data slot entry in data.json must have:

an extension list containing “json” so that the file browser filter will display JSON files
a Parameters Bitmap with the “Instance JSON” bit set
The filenames listed below should be located starting in the same folder as the instance JSON, but may be located in any number of subfolders.

JSON Definition
magic: string
Must be APF_VER_1.

data_path: string
Path to assets containing one or more subfolders, using forward slashes only. Maximum length of 255 characters.

core_select
id: integer / hex string
ID of core bitstream to select as part of the load process. Limited to 16-bit unsigned.

select: boolean
If true, the core bitstream matching ID will be loaded, otherwise the first/only bitstream will be selected.

data_slots (array)
A maximum of 32 data slots is allowed.

id: integer / hex string
ID of data_slot . Limited to 16-bit unsigned.

filename: string
Exact filename, including any subfolders. Relative paths are not supported. Maximum length of 255 characters.

memory_writes (array)
A maximum of 32 entries is allowed.

address: integer / hex string
Address to write to. 32-bit unsigned.

data: integer / hex string
Data to be written. 32-bit unsigned.

Sample File
{
  "instance": {
    "magic": "APF_VER_1",
    "core_select" : {
      "id" : 123,
      "select" : false
    },
    "data_path": "basefolder1/",
    "data_slots": [
      {
        "id": 1,
        "filename": "samplefolder/sample.bin"
      },
      {
        "id": 99,
        "filename": "samplefolder/sample.wav"
      }
    ],
    "memory_writes": [
      {
        "address": "0x00000004",
        "data": "0x12345678"
      }
    ]
  }
}

interact.json
Describes any custom UI elements to be displayed in the Core Settings menu.

The Core Settings menu is built up dynamically from the following sources:

Submenu for Display Modes (future use)
Submenu for Controls (from input.json)
Zero or more actions to reload data slots while the core is running (data.json, any data slot marked as “User-reloadable” in its Parameter Bitmap
Zero or more UI elements described in this interact.json file.
If at least one UI element was added, Pocket will provide “Reset all to defaults” action.
Limitations
Up to 16 UI entries from interact.json can be shown. However, if more than 4 reloadable data slots are also present, additional entries will be dropped to maintain a maximum of 20 combined interact+data menu entries.

It is recommended to use list items since each one can have up to 16 of its own possible options within itself, and does not count towards the overall limit.

Operation
See the data.json section for an explanation on what happens when a user reloads a data slot through this menu - the behavior can be customized.

The following UI elements are supported:

Check box - check
Radio box - radio
Slider adjustments - slider_u32
List options - list
Action buttons - action
Hexadecimal number readouts - number_u32
Each frame, all of the UI elements are read back from the core at a specified 32-bit BRIDGE address, updated with new user-adjusted values, and finally written back. This read-modify-write cycle requires the core to have both read and write support at each desired address, unless the element is flagged as writeonly .

Elements with a mask can be used to selectively modify any number of bits in a register. The readback value where the mask bits are set will be preserved when writing back.

If any persistent elements are found and loaded, they will be written into the core’s register space on boot immediately before the APF sends the [0011 Reset Exit] host command.

Per-Asset Functionality and Persistence
Persistent values will be saved out by their ID. If you update your core to add or remove some interact elements, APF will try to match up all the settings by their ID, so all IDs should be unique.

Default
By default, the interact menu is loaded from:
/Cores/AuthorName.CoreName/Interact/interact.json

By default, the interact menu’s persistent values are saved to:
/Settings/AuthorName.CoreName/Interact/interact_persist.json

Per-Asset
It is possible to have completely unique interact menus for every single primary asset loaded by the core. APF will check in a specific location, generated from the very first data slot 0. If it is found, it will override the core’s existing interact.json.

A per-asset interact menu, if it exists, is loaded from:
/Presets/AuthorName.CoreName/Interact/<path_to_slot0_asset>.json

A per-asset interact menu, if it exists, will save persistent values to:
/Settings/AuthorName.CoreName/Interact/<path_to_slot0_asset>.json

Example
For example, with an primary asset loaded into data slot 0 with current path and filename of
/Assets/myplatform/common/subfolder1/asset.bin

APF will check for a JSON file mirroring the same folder structure, but in a different base folder:
/Presets/AuthorName.CoreName/Interact/myplatform/common/subfolder1/asset.json

Similarly, any persistent values will be saved to:
/Settings/AuthorName.CoreName/Interact/myplatform/common/subfolder1/asset.json

JSON Definition
magic: string
Must be APF_VER_1.

variables
The following are common to all elements, regardless of type:

name: string
Name as displayed in UI. Maximum length of 23 chars.

id: integer / hex string
Id number. Limited to 16-bit unsigned.

type: string
Type of the UI element. Values: radio , check , slider_u32 , list, number_u32 , action

enabled: boolean
Whether or not the element can be interacted with.

address: integer / hex string
32-bit address into BRIDGE space for reading/write the value.

The following a specific to radio checkboxes:

group: integer / hex string
Group identifier. Radio boxes can be ganged up by assigning them all the same arbitrary group number.

persist: boolean
Retains the value set by the user after the core is shut own. Optional.

writeonly: boolean
If present and true, the value will only be stored in JSON and written to the core, but never read back from the core. Optional.

defaultval: integer / hex string
Initial value. May be 0 (unchecked) or 1 (checked). Restored when user selects Reset to Defaults.

value: integer / hex string
Value that is written when selecting the radio box, or compared against when reading the register.

value_off: integer / hex string
Value that is written when unchecked. Optional. Defaults to 0.

mask: integer / hex string
Mask. Bits set to ‘1’ will be left untouched in the register. Bits set to ‘0’ may be modified by the UI element. Optional.

The following are specific to check checkboxes.

persist: boolean
Retains the value set by the user after the core is shut own. Optional.

writeonly: boolean
If present and true, the value will only be stored in JSON and written to the core, but never read back from the core. Optional.

defaultval: integer / hex string
Initial value. May be 0 (unchecked) or 1 (checked). Also when user selects Reset to Defaults.

value: integer / hex string
Value that is written when selecting the check box, or compared against when reading the register.

value_off: integer / hex string
Value that is written when unchecked.

mask: integer / hex string
Mask. Bits set to ‘1’ will be left untouched in the register. Bits set to ‘0’ may be modified by the UI element. Optional.

The following are specific to slider_u32 sliders:

persist: boolean
Retains the value set by the user after the core is shut own. Optional.

writeonly: boolean
If present and true, the value will only be stored in JSON and written to the core, but never read back from the core. Optional.

defaultval: integer / hex string
Initial value used for the slider. Restored when user selects Reset to Defaults.

mask: integer / hex string
Mask. Bits set to ‘1’ will be left untouched in the register. Bits set to ‘0’ may be modified by the UI element. Optional.

graphical: object
object

signed: boolean
Displays ‘+’ when the value is positive. Optional.

min: integer / hex string
Minimum allowable value. (-2147483648 to 2147483647).

max: integer / hex string
Maximum allowable value. (-2147483648 to 2147483647).

adjust_small: integer / hex string
Adjustment step for fine adjustments. (-2147483648 to 2147483647).

adjust_large: integer / hex string
Adjustment step for coarse adjustments. (-2147483648 to 2147483647).

The following are specific to list menu items:
An array of up to 16 objects to comprise the list options, each of which contains the following:

value: integer / hex string
Value that is written when selecting the menu item.

name: string
Name as displayed in UI. Maximum length of 23 chars.

The following are specific to action menu items:

value: integer / hex string
Value that is written when selecting the menu item.

mask: integer / hex string
Mask. Bits set to ‘1’ will be left untouched in the register. Bits set to ‘0’ may be modified by value. Optional.

Sample File
{
  "interact": {
    "magic": "APF_VER_1",
    "variables": [
      {
        "name": "All RGB",
        "id": 2,
        "type": "radio",
        "group": 100,
        "enabled": true,
        "persist": true,
        "address": "0x00F0000C",
        "defaultval": 1,
        "value": 7
      },
      {
        "name": "Red only",
        "id": 3,
        "type": "radio",
        "group": 100,
        "enabled": true,
        "persist": true,
        "address": "0x00F0000C",
        "value": "0x4"
      },
      {
        "name": "Green only",
        "id": 4,
        "type": "radio",
        "group": 100,
        "enabled": true,
        "persist": true,
        "address": "0x00F0000C",
        "value": "0x2"
      },
      {
        "name": "Blue only",
        "id": 5,
        "type": "radio",
        "group": 100,
        "enabled": true,
        "persist": true,
        "address": "0x00F0000C",
        "value": "0x1",
        "mask": "0xFFFF0000"
      },
      {
        "name": "Difficulty",
        "id": 99,
        "type": "list",
        "enabled": true,
        "persist": true,
        "address": "0x00E00000",
        "writeonly": true,
        "defaultval": 2,
        "mask": "0xFFFF0000",
        "options": [
          {
            "value": "0x0000",
            "name": "Hard"
          },
          {
            "value": "0x0100",
            "name": "Normal"
          },
          {
            "value": "0x0200",
            "name": "Easy"
          },
          {
            "value": "0x0300",
            "name": "Very Easy"
          }
        ]
      },
      {
        "name": "Reset Square",
        "id": 6,
        "type": "action",
        "enabled": true,
        "address": "0x00F00010",
        "value": 64
      },
      {
        "name": "Square X",
        "id": 8,
        "type": "slider_u32",
        "enabled": true,
        "persist": true,
        "address": "0x00200000",
        "defaultval": 100,
        "graphical": {
          "signed": false,
          "min": 0,
          "max": 320,
          "adjust_small": 1,
          "adjust_large": "0x10"
        }
      },
      {
        "name": "Square Y",
        "id": 9,
        "type": "slider_u32",
        "enabled": true,
        "persist": true,
        "address": "0x00200004",
        "defaultval": 100,
        "graphical": {
          "signed": false,
          "min": 0,
          "max": 240,
          "adjust_small": 1,
          "adjust_large": "0x10"
        }
      },
      {
        "name": "Animation",
        "id": 1,
        "type": "check",
        "enabled": true,
        "address": "0x00100000",
        "defaultval": 1,
        "value": 1,
        "mask": "0xFFFF0000"
      },
      {
        "name": "Reset Frame",
        "id": 10,
        "type": "action",
        "enabled": true,
        "address": "0x00F00014",
        "value": 0
      },
      {
        "name": "Increment Frame",
        "id": 11,
        "type": "action",
        "enabled": true,
        "address": "0x00F00018",
        "value": 0
      },
      {
        "name": "Frame",
        "id": 12,
        "type": "number_u32",
        "enabled": false,
        "address": "0x20000000"
      },
      {
        "name": "Mask Write Debug",
        "id": 13,
        "type": "action",
        "enabled": true,
        "address": "0x00100004",
        "value": "0x00340000",
        "mask": "0xFF00FFFF"
      },
      {
        "name": "Debug",
        "id": 14,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00100004"
      },
      {
        "name": "Signed Value",
        "id": 15,
        "type": "slider_u32",
        "enabled": true,
        "address": "0x00300000",
        "defaultval": 5000,
        "graphical": {
          "signed": true,
          "min": -100000,
          "max": 100000,
          "adjust_small": 1,
          "adjust_large": 1000
        }
      }
    ]
  }
}

variants.json
Describes up to 8 core variations. These can be used to describe very similar hardware with just a few asset changes. This is an upcoming feature.

Each variant may select a particular bitstream and override data slots with alternate ones as well as write arbitrary data into the core’s address space.

JSON Definition
magic: string
Must be APF_VER_1.

variant_list (array)
Maximum of 8 variants.

name: string
Maximum length of 15 characters.

id: integer / hex string
ID number. Limited to 16-bit unsigned.

core_select: object
Contains a child integer object core_id which specifies the bitstream ID to load.

data_overridemagic: array
List of data slot overrides.

memory_writes: array
List of memory writes to tell the bitstream about the selected variant.

data_override (array)
Maximum of 8 variants.

data_id_to: integer / hex string
ID number of the data slot to be replaced. Limited to 16-bit unsigned.

data_id_from: integer / hex string
ID number of the data slot replacing the above. It may be flagged as secondary. Limited to 16-bit unsigned.

memory_writes (array)
Maximum of 16 variants.

address: integer / hex string
Address to write to. 32-bit unsigned.

data: integer / hex string
Data to be written. It may be flagged as secondary. 32-bit unsigned.

Sample File
{
  "variants": {
    "magic": "APF_VER_1",
    "variant_list": [
      {
        "name": "Variant1",
        "id": 0,
        "core_select": {
          "core_id": 0
        },
        "data_override": [
          {
            "data_id": 3,
            "data_id_override": 300
          }
        ],
        "memory_writes": [
          {
            "address": "0x00000004",
            "data": "0x12345678"
          },
          {
            "address": "0x02000200",
            "data": "0xabcdabcd"
          }
        ]
      },
      {
        "name": "Variant2",
        "id": 1,
        "core_select": {
          "core_id": 1
        },
        "data_override": [
          {
            "data_id": "0x100",
            "data_id_override": "0x103"
          }
        ]
      }
    ]
  }
}

video.json
Describes up to 8 video preset scaling configurations.

Cores may switch between any of these resolutions at runtime.

JSON Definition
magic: string
Must be APF_VER_1.

scaler_modes (array)
Maximum of 8 scaler modes.

width: integer
Active width in pixels.

height: integer
Active height in pixels.

aspect_w: integer
Aspect ratio width.

aspect_h: integer
Aspect ratio height.

dock_aspect_w: integer (optional)
Aspect ratio width when docked.

dock_aspect_h: integer (optional)
Aspect ratio height when docked

rotation: integer
Degrees to rotate the image. Valid values are 0, 90, 180, 270.

mirror: integer
Reflect the display direction. May be combined with rotation. Bit1: left/right mirror Bit0: up/down mirror.

display_modes (array)
Maximum of 16 display modes.

id: string/hex
ID of display mode that can be used with the core. Refer to the below Display Mode ID Table.

defaults
sharpness: integer (optional)
The default pixel sharpness when no display mode is used. 0 is the softest and is suitable for photos and video content. 3 is maximum sharpness.

Display Modes
Cores can use any of Pocket’s built-in display modes, plus a new customizable CRT Trinitron mode.

For cores wanting to use a LCD mode, it’s recommended to use the “generic” modes instead of the Original modes, for forward compatibility.

When using the CRT Trinitron mode, the display size will be quantized to the nearest integer multiple of the source image height in pixels. This is necessary to prevent artifacts. Next, the final width of the image will be calculated based on the specified aspect ratio. In all cases, the aspect ratio will be respected.

To work properly, the CRT mode requires that the core produce an image with no horizontal pixel duplication. While duplicated pixels won’t affect a simple scaler, they will negatively impact the functionality of the CRT mode.

When using the LCD modes, the display size will be integer scaled in the same way. However, both the width and height will be separately converted to integer multiples of the original resolution. The aspect ratio may not be possible to completely respect when using these modes. LCD modes are best suited for square pixels (when the aspect ratio matches the core’s video resolution).

When a Display Mode is selected, APF will send a Host command [00B8 OS Notify: Display Mode] to tell the core which one the user selected. Acknowledging this command is optional, as are the other OS Notify commands.

However, the non-color LCD modes (0x20 through 0x23) require the core to send pure grayscale video from RGB(0,0,0) to RGB(255,255,255). This command contains a parameter bit that needs to be respected by the core. Also, the core must provide the correct response for these particular display modes to function.

If there are multiple scaler slots used with different rotations, Aperture Grille with CRT Trinitron will only function for slot 0.

Display Mode ID Table
ID	Description	Notes
0x00	None	Not valid in JSON, only sent in the Host command [00B8 OS Notify: Display Mode]
0x10	CRT Trinitron	
0x20	Grayscale LCD	Generic, has no restriction on source content. Adjusted for better operation with denser image sources
0x21	Original GB DMG	Requires core response
0x22	Original GBP	Requires core response
0x23	Original GBP Light	Requires core response
0x30	Reflective Color LCD	Generic
0x31	Original GBC LCD	
0x32	Original GBC LCD+	
0x40	Backlit Color LCD	Generic
0x41	Original GBA LCD	
0x42	Original GBA SP 101	
0x51	Original GG	
0x52	Original GG+	
0x61	Original NGP	
0x62	Original NGPC	
0x63	Original NGPC+	
0x71	TurboExpress	
0x72	PC Engine LT	
0x81	Original Lynx	
0x82	Original Lynx+	
0xE0	Pinball Neon Matrix	
0xE1	Vacuum Fluorescent	
Sample File
{
  "video": {
    "magic": "APF_VER_1",
    "scaler_modes": [
      {
        "width": 320,
        "height": 240,
        "aspect_w": 4,
        "aspect_h": 3,
        "rotation": 0,
        "mirror": 0
      },
      {
        "width": 512,
        "height": 240,
        "aspect_w": 4,
        "aspect_h": 3,
        "rotation": 0,
        "mirror": 0
      },
      {
        "width": 480,
        "height": 270,
        "aspect_w": 16,
        "aspect_h": 9,
        "rotation": 0,
        "mirror": 0
      }
    ],
    "display_modes": [
      {
        "id": "0x10"
      },
      {
        "id": "0xE0"
      }
    ]
  }
}