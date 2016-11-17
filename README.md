# VirtualScenesAssets
Sample data and data access API for Virtual Scenes assets.

# Overview
VirtualScenesAssets is a set of utilities for accessing assets that we want to use for creating 3D virtual scenes.  These include 3D models, textures, reflectance spectra, illuiminant spectra, and related assets.

The VirtualScenesAssets repository iteself contains a small number of example assets and an API for finding and loading them.  It also establishes a convention for how the assets should be organized, allowing the same API to be use for assets across multiple locations.

# Installation
The best way to get VirtualScenesAssets is to use the [ToolboxToolbox](https://github.com/ToolboxHub/ToolboxToolbox).

If you have the ToolboxToolbox, then getting VirtualScenesAssets becomes a one-liner:
```
tbUse('VirtualScenesAssets');
```

## Preferences
The ToolboxToolbox will also create a configuration script which you can edit with local preferences.  This script will be named `VirtualScenesAssets.m`.  The default folder would be in your Matlab [userpath](https://www.mathworks.com/help/matlab/ref/userpath.html).  For example: 
```
~/Documents/MATLAB/VirtualScenesAssets.m
```

Here are some preferences you might wish to edit in this script:
 - where to look for locally stored assets -- edit [here](vsaMachineSetup.m#L10)
 - where to look for remotely stored assets, using [RemoteDataToolbox](https://github.com/isetbio/RemoteDataToolbox): edit [here](vsaMachineSetup.m#L18)

Next time you do `tbUse('VirtualScenesAssets')` your custom preferences will be set up.

# Organization and API
VirtualScenesAssets uses two levels of organization for assets: each asset has a "type" and a "name".

Each asset may contain several files, including:
  - an "info" file which is a mat-file that contains any data or metadata for the asset
  - zero or more data files of other types, like 3D models, textures, etc
  - zero or more "extra" files, like a readme, license notices, etc

## Listing types and names
The utility [vsaListTypes()](api/vsaListTypes.m) helps navigate the types.  It reports available asset types, and the location where each type was found.  See below for more about asset locations.
```
>> [types, locations] = vsaListTypes()
types = 
    'BaseScenes'    'Illuminants'    'IndicesOfRefraction'    'Objects'    'Reflectances'    'Textures'
locations = 
    'examples'    'examples'    'examples'    'examples'    'examples'    'examples'
```

The utility [vsaListAssets()](api/vsaListAssets.m) helps navigate the assets within each type.  It reports the names of available assets for a given type, and the location where each asset was found.  See below for more about asset locations.
```
>> [names, locations] = vsaListAssets('BaseScenes')
names = 
    'CheckerBoard'    'IndoorPlant'    'Library'    'Mill'    'TableChairs'    'Warehouse'
locations = 
    'examples'    'examples'    'examples'    'examples'    'examples'    'examples'
```

## Getting asset data
The utility [vsaGetInfo()](api/vsaGetInfo.m) finds and loads the "info" file for a particular asset.  This may contain any data or metadata for an asset.  For some assets, the info may be empty.  For each of the example `BaseScenes` assets, the info file contains 3D model annotations.
```
>> assetInfo = vsaGetInfo('BaseScenes', 'CheckerBoard')
assetInfo = 
        cameraSlots: [1x1 struct]
           lightBox: [3x2 double]
    lightExcludeBox: [3x2 double]
           lightIds: {'TopLeftLight-mesh'  'RightLight-mesh'  'BottomLight-mesh'}
        materialIds: {1x28 cell}
               name: 'CheckerBoard'
          objectBox: [3x2 double]
```

The utility [vsaGetFiles()](api/vsaGetFiles.m) locates any data files for an asset.  Each of the example `BaseScenes` assets comes with a Blender version and a Collada version of the same 3D model.
```
>> assetFiles = vsaGetFiles('BaseScenes', 'CheckerBoard')
assetFiles = 
    '.../VirtualScenesAssets/examples/BaseScenes/CheckerBoard/CheckerBoard.blend'
    '.../VirtualScenesAssets/examples/BaseScenes/CheckerBoard/CheckerBoard.dae'
```

## Creating and updating assets
The utility [vsaPut()](api/vsaPut.m) creates or updates an asset with a given type and name.  It accepts a list of data flies and "extras" files to save with the asset.  Additional name-value pairs will be saved in the asset's info file.

If an asset with the same name and type already exists at the target location, this conflict can be resolved in one of several ways, including "skip", "error", "merge" or "replace".  See below for more about asset locations.

Here is an example that creates or replaces one of the example assets that comes with this repository.
```
>> d65 = fullfile(rtbRoot(), 'RenderData', 'D65.spd');
vsaPut('Illuminants', 'D65', ...
    'location', 'examples', ...
    'files', {d65}, ...
    'ifConflict', 'replace');
```

# Asset Locations
The VirtualScenesAssets API is intented to work for assets stored in multiple locations.  These include:
  - "examples" -- the examples that come with this repository
  - "local" -- other assets stored on the local file system
  - "remote" -- assets stored on a remote server ([TODO](https://github.com/RenderToolbox/VirtualScenesAssets/issues/3))

By default, the listing and getting utilities search these three locations, in that order, to locate assets.  Each utility also accepts an optional list of locations to search, in case the default locations or search order needs to be overridden.

## Location strategies
Each asset location corresponds to an implementation of the abstract [VsaLocationStrategy](strategies/VsaLocationStrategy.m) class.  This class outlines the operations required for working with an asset location, like listing, reading, writing and deleting assets by type and name.


# Related Tools
VirtualScenesAssets has a small API and few required toolbox dependencies.  As such, it may be a useful component for many projects.  Two projects where we expect VirtualScenesAssets to be used are:
  - [VirtualScenesEngine](https://github.com/RenderToolbox/VirtualScenesEngine), which re-combines assets into myraiad scenes for rendering
  - [RenderToolbox4](https://github.com/RenderToolbox/RenderToolbox4), which deals with scenes and rendering in general
